"""AI providers for the chapter job. Every call returns the provider and the model that actually answered (attribution),
and every HTTP try is logged in .events (provider, model, http status, outcome kind, try number, seconds) for the job record.

Failure handling (bounded; nothing here ever picks a paid model):
  transient (HTTP 500/502/503/504, network error)  -> retried, at most TRIES per model, with BACKOFF waits
  timeout                                           -> same as transient, kind 'timeout'
  quota (HTTP 429)                                  -> not retried on that model; Gemini moves to its next free model
  permanent (HTTP 401/403/404)                      -> not retried; Gemini moves to its next model
  request error (HTTP 400/422, unreadable envelope) -> ProviderRequestError (a code/schema bug -> job 'failed')
  total provider time over TIME_BUDGET_S            -> ProviderUnavailable(kind='time_budget')
Every ProviderUnavailable makes the job 'blocked' (resume later), never 'failed'.

Real(): writer = OpenRouter ':free' model only (zero-price guard, no fallbacks); fact checks = Gemini (EN), OpenRouter (HI);
MCQ solver = Gemini, Groq backup only if the owner confirmed Groq's free tier; translator = Gemini.
"""
import json, os, re, sys, time
from common import ProviderUnavailable, ProviderRequestError, text_of, parse_json

ROUTE = os.environ.get('ROUTE_DIR', os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'diploma-boy', 'robots', 'route'))
TRIES = 3                 # per model, for transient/timeout only
BACKOFF = tuple(float(x) for x in os.environ.get('PROVIDER_BACKOFF_S', '5,15').split(','))   # seconds before try 2 and try 3
TIME_BUDGET_S = 1200      # total seconds this run may spend inside provider calls
MAX_CALLS = 40            # total HTTP requests this run may make to AI providers

FACT = ('Is this Class 10 study text correct? Check every claim: definitions, laws, formulas, cause-effect, units, numerical values. '
        'If any claim is wrong or misleading answer {"correct": false, "reason": "<which claim and why>"}, otherwise {"correct": true, "reason": ""}. '
        'Return only that JSON.\n\nTEXT:\n')


def kind_of(status, body=b''):
    if status == 200: return 'ok'
    if status == 429: return 'quota'
    if status in (401, 403, 404): return 'permanent'
    if status in (400, 422): return 'request_error'
    if status == 504 and (b'timed out' in body.lower() or b'timeout' in body.lower()): return 'timeout'
    if status >= 500: return 'transient'
    return 'permanent'


class Real:
    def __init__(self, sleep=time.sleep, clock=time.monotonic):
        sys.path.insert(0, ROUTE)
        import run_chapter as R
        self.R, self.sleep, self.clock = R, sleep, clock
        self.or_key = os.environ.get('OPENROUTER_API_KEY', '').strip()
        self.or_model = os.environ.get('OPENROUTER_MODEL', '').strip()
        # owner-confirmed no-charge providers only; anything not listed is never called
        self.free_ok = {x.strip() for x in os.environ.get('FREE_TIER_CONFIRMED', '').split(',') if x.strip()}
        self.g_key = os.environ.get('GEMINI_API_KEY', '').strip() if 'gemini' in self.free_ok else ''
        self.groq_key = os.environ.get('GROQ_API_KEY', '').strip() if 'groq' in self.free_ok else ''
        acct = os.environ.get('CLOUDFLARE_ACCOUNT_ID', '').strip()
        ok = lambda name, var: os.environ.get(var, '').strip() if name in self.free_ok else ''
        # free backup writers, in the owner's order: after Gemini -> Groq -> NVIDIA -> SambaNova -> Cloudflare.
        # A provider is used only if the owner listed it in FREE_TIER_CONFIRMED, its key exists and a model is set.
        self.chain = [p for p in [
            ('groq', 'https://api.groq.com/openai/v1/chat/completions', os.environ.get('GROQ_WRITE_MODEL') or 'openai/gpt-oss-120b', ok('groq', 'GROQ_API_KEY')),
            ('nvidia', 'https://integrate.api.nvidia.com/v1/chat/completions', os.environ.get('NVIDIA_WRITE_MODEL', ''), ok('nvidia', 'NVIDIA_API_KEY')),
            ('sambanova', 'https://api.sambanova.ai/v1/chat/completions', os.environ.get('SAMBANOVA_WRITE_MODEL') or 'Meta-Llama-3.3-70B-Instruct', ok('sambanova', 'SAMBANOVA_API_KEY')),
            ('cloudflare', f'https://api.cloudflare.com/client/v4/accounts/{acct}/ai/v1/chat/completions',
             os.environ.get('CLOUDFLARE_WRITE_MODEL') or '@cf/meta/llama-3.3-70b-instruct-fp8-fast', ok('cloudflare', 'CLOUDFLARE_API_TOKEN') if acct else ''),
        ] if p[2] and p[3]]
        self.budget = float(os.environ.get('PROVIDER_TIME_BUDGET_S', TIME_BUDGET_S))
        self.spent = 0.0
        self.max_calls = int(os.environ.get('PROVIDER_MAX_CALLS', MAX_CALLS)); self.n_calls = 0
        # roles: WRITER_PROVIDER=openrouter (default) | gemini. With a Gemini writer, the English checks (fact check, MCQ solve)
        # go to the OpenRouter free model so that the checker is a different company from the writer.
        self.writer = os.environ.get('WRITER_PROVIDER', 'openrouter').strip()
        self.g_writer_model = os.environ.get('GEMINI_WRITER_MODEL', '').strip()
        self.events = []
        self._or_checked = False

    def drain_events(self):
        e, self.events = self.events, []
        return e

    # ---- one HTTP exchange with bounded retries ----
    def _post(self, provider, model, url, headers, body, timeout):
        last = None
        for t in range(1, TRIES + 1):
            if self.spent >= self.budget:
                raise ProviderUnavailable(provider, 'time_budget', f'{self.spent:.0f}s spent of {self.budget:.0f}s')
            if self.n_calls >= self.max_calls:
                raise ProviderUnavailable(provider, 'call_budget', f'{self.n_calls} requests made of {self.max_calls}')
            self.n_calls += 1
            t0 = self.clock()
            s, b = self.R.http(url, dict(headers, **{'User-Agent': 'diploma-boy-chapter-robot/1.0'}), body, timeout)   # some providers (Groq) block the default urllib agent
            dt = self.clock() - t0; self.spent += dt
            k = kind_of(s, b if isinstance(b, bytes) else str(b).encode())
            ev = {'provider': provider, 'model': model, 'http': s, 'kind': k, 'try': t, 'secs': round(dt, 2)}
            if k != 'ok':   # short provider error text (keys are never in a provider's error body; still masked)
                msg = (b if isinstance(b, bytes) else str(b).encode())[:300].decode('utf-8', 'replace')
                for key in (self.or_key, self.g_key, self.groq_key):
                    if key: msg = msg.replace(key, '[hidden]')
                ev['error'] = msg
            self.events.append(ev)
            if k == 'ok': return b
            if k == 'request_error': raise ProviderRequestError(f'{provider} {model}: HTTP {s} (our request was rejected)')
            last = k
            if k == 'quota' and t < TRIES:   # a per-minute limit that says when to come back: wait (bounded) and retry the same model
                m = re.search(r'try again in\s*(?:(\d+)m)?\s*(\d+(?:\.\d+)?)?(ms|s)?', ev.get('error', ''), re.I)
                if m and (m.group(1) or m.group(2)):
                    wait = int(m.group(1) or 0) * 60 + (float(m.group(2) or 0) / (1000 if m.group(3) == 'ms' else 1))
                    if wait <= 90 and self.spent + wait < self.budget:
                        self.sleep(wait + 1); self.spent += wait + 1; continue
            if k in ('quota', 'permanent'): raise ProviderUnavailable(provider, k, f'{model} HTTP {s}')
            if t < TRIES:
                wait = BACKOFF[min(t - 1, len(BACKOFF) - 1)]
                self.sleep(wait); self.spent += wait
        raise ProviderUnavailable(provider, last, f'{model} still failing after {TRIES} tries')

    def _get_models(self):
        get = getattr(self.R, 'http_get', None)
        if get: return get('https://openrouter.ai/api/v1/models', 60)
        import urllib.request
        try:
            with urllib.request.urlopen(urllib.request.Request('https://openrouter.ai/api/v1/models', method='GET'), timeout=60) as r:
                return r.status, r.read()
        except Exception as e:
            return 504, str(e).encode()

    def _openrouter_free_guard(self):
        """Blocks before any OpenRouter call unless the model is a ':free' id that OpenRouter currently prices at 0."""
        if self._or_checked: return
        if not self.or_model.endswith(':free'):
            raise ProviderUnavailable('openrouter', 'not_free', f'model {self.or_model!r} is not a :free id')
        s, b = self._get_models()
        if s != 200: raise ProviderUnavailable('openrouter', 'transient', f'price check HTTP {s}')
        m = {x['id']: x for x in json.loads(b)['data']}.get(self.or_model)
        if not m: raise ProviderUnavailable('openrouter', 'permanent', f'{self.or_model} not listed')
        pr = m.get('pricing', {})
        if any(float(pr.get(k) or 0) != 0 for k in ('prompt', 'completion', 'request', 'image')):
            raise ProviderUnavailable('openrouter', 'not_free', f'{self.or_model} is not priced at 0')
        self._or_checked = True

    def _chat(self, url, key, model, prompt, provider, timeout=240, max_tokens=4000):
        if not key: raise ProviderUnavailable(provider, 'not_configured', 'key missing or free tier not confirmed by owner')
        req = {'model': model, 'messages': [{'role': 'user', 'content': prompt}], 'temperature': 0.3, 'max_tokens': max_tokens}
        if provider == 'openrouter':
            req['reasoning'] = {'effort': 'none', 'exclude': True}     # reasoning models otherwise spend the budget and reply empty
            self._openrouter_free_guard()
            req['provider'] = {'allow_fallbacks': False, 'max_price': {'prompt': 0, 'completion': 0}}   # no paid routing, no fallback list
        b = self._post(provider, model, url, {'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'}, json.dumps(req).encode(), timeout)
        try:
            j = json.loads(b); txt = j['choices'][0]['message']['content'] or ''
        except Exception as e:
            raise ProviderRequestError(f'{provider}: unreadable reply envelope ({type(e).__name__})')
        got = j.get('model') or model
        if provider == 'openrouter' and got.split(':')[0] != model.split(':')[0]:
            raise ProviderUnavailable('openrouter', 'not_free', f'answered by {got}, not the requested free model')
        return txt, provider, got

    def research(self, prompt, queries=None):
        """Web research. 1) Gemini with Google Search grounding. 2) if Gemini is out: free web search (DuckDuckGo) -> the robot reads
        the top pages' headings only -> a free AI turns them into the outline. 3) Groq compound. Returns (text, sources, provider, model)."""
        kinds = [] if self.g_key else ['not_configured']
        for m in (self.R.G_MODELS if self.g_key else []):
            for tools in (True, False):
                body = {'contents': [{'parts': [{'text': prompt}]}], 'generationConfig': {'temperature': 0.2}}
                if tools: body['tools'] = [{'google_search': {}}]
                try:
                    b = self._post('gemini', m, f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                                   {'x-goog-api-key': self.g_key, 'Content-Type': 'application/json'}, json.dumps(body).encode(), 240)
                except ProviderRequestError:
                    if tools: continue                      # grounding not allowed: try once without it
                    raise
                except ProviderUnavailable as e:
                    if e.kind == 'time_budget': raise
                    kinds.append(e.kind); break
                d = json.loads(b); cand = d['candidates'][0]
                txt = ''.join(p.get('text', '') for p in cand['content']['parts'])
                src = [{'title': c.get('web', {}).get('title', ''), 'uri': c.get('web', {}).get('uri', '')}
                       for c in (cand.get('groundingMetadata') or {}).get('groundingChunks', []) if c.get('web')]
                return txt, src, 'gemini', d.get('modelVersion') or m
        if queries:
            try:
                return self._research_web(prompt, queries)
            except ProviderUnavailable as e:
                if e.kind in ('time_budget', 'call_budget'): raise
                kinds.append(f'web:{e.kind}')
        return self._research_groq(prompt, kinds)

    def _research_web(self, prompt, queries):
        import websearch
        sources, material = websearch.research(queries, getattr(self, 'web_fetch', websearch.fetch))
        self.events.append({'provider': 'web', 'model': 'search', 'http': 200 if sources else 0, 'kind': 'ok' if sources else 'no_results',
                            'try': 1, 'secs': 0, 'pages': len(sources), 'error': json.dumps(websearch.LOG[-12:])})
        if not sources: raise ProviderUnavailable('web', 'no_results', 'no readable pages found')
        p = (prompt + '\n\nBelow are ONLY the section headings and list items of web pages that teach this chapter (no page text). '
             'Build the outline from them and from your own knowledge of this level. Do not copy wording.\n' + json.dumps(material, ensure_ascii=False)[:24000])
        txt, prov, model = self._free_chain_or(p)
        return txt, sources, prov, model

    def _free_chain_or(self, prompt, max_tokens=4000):
        tried = []
        try:
            return self._free_chain(prompt, max_tokens, tried)
        except ProviderUnavailable as e:
            if e.kind in ('time_budget', 'call_budget'): raise
        return self._or(prompt, 240)

    def _research_groq(self, prompt, kinds):
        """Fallback web research: Groq 'compound' model has a built-in web search; source links are taken from its tool results."""
        if not self.groq_key:
            raise ProviderUnavailable('gemini', 'quota' if 'quota' in kinds else 'transient', 'research: ' + ','.join(kinds) + '; groq not confirmed')
        b = None
        for model in [m for m in os.environ.get('GROQ_RESEARCH_MODELS', 'groq/compound,compound-beta,groq/compound-mini,compound-beta-mini').split(',') if m]:
            req = {'model': model, 'messages': [{'role': 'user', 'content': prompt}], 'temperature': 0.2, 'max_tokens': 4000}
            try:
                b = self._post('groq', model, 'https://api.groq.com/openai/v1/chat/completions',
                               {'Authorization': 'Bearer ' + self.groq_key, 'Content-Type': 'application/json'}, json.dumps(req).encode(), 300)
                break
            except (ProviderUnavailable, ProviderRequestError) as e:
                if isinstance(e, ProviderUnavailable) and e.kind in ('time_budget', 'call_budget'): raise
                kinds.append(f'groq:{model}')
        if b is None: raise ProviderUnavailable('groq', 'permanent', 'research: ' + ','.join(kinds))
        try:
            j = json.loads(b); msg = j['choices'][0]['message']
        except Exception as e:
            raise ProviderRequestError(f'groq research: unreadable reply ({type(e).__name__})')
        src, seen = [], set()
        for u, t in re.findall(r'"url"\s*:\s*"(https?://[^"]+)"(?:[^{}]*?"title"\s*:\s*"([^"]*)")?', json.dumps(msg.get('executed_tools') or [])):
            if u not in seen: seen.add(u); src.append({'title': t, 'uri': u})
        return msg.get('content') or '', src, 'groq', j.get('model') or model

    def fact_check_app(self, d):
        flat = []
        def walk(x):
            if isinstance(x, str): flat.append(x)
            elif isinstance(x, list): [walk(y) for y in x]
            elif isinstance(x, dict): [walk(v) for k, v in x.items() if k != 'id']
        walk(d)
        raw, prov, model = self._or(FACT + ' '.join(flat), 240)
        try:
            j = parse_json(raw)
        except ValueError:
            return None, 'inconclusive: checker reply not parseable: ' + (raw or '')[:300].replace('\n', ' '), prov, model
        return bool(j.get('correct')) is True, str(j.get('reason', ''))[:400], prov, model

    def solve_all(self, practice):
        qs = [{'n': i, 'q': x['q'], 'options': x['options']} for i, x in enumerate(practice)]
        p = ('Solve each multiple-choice question carefully, step by step in your head. Reply only with JSON: {"answers": [index, ...]} '
             'where each index is 0, 1, 2 or 3, in the same order as the questions.\n\n' + json.dumps(qs, ensure_ascii=False))
        raw, prov, model = self._or(p, 240)
        try:
            got = parse_json(raw).get('answers', [])
        except ValueError:
            got = []
        return [g if isinstance(g, int) else -1 for g in got], prov, model

    def _gemini(self, prompt, json_mode=True, models=None):
        if not self.g_key: raise ProviderUnavailable('gemini', 'not_configured', 'key missing or free tier not confirmed by owner')
        kinds = []
        for m in (models or self.R.G_MODELS):
            cfg = {'temperature': 0.2}
            if json_mode: cfg['responseMimeType'] = 'application/json'
            body = json.dumps({'contents': [{'parts': [{'text': prompt}]}], 'generationConfig': cfg}).encode()
            try:
                b = self._post('gemini', m, f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                               {'x-goog-api-key': self.g_key, 'Content-Type': 'application/json'}, body, 240)
            except ProviderUnavailable as e:
                if e.kind == 'time_budget': raise
                kinds.append(e.kind); continue          # next free Gemini model
            try:
                d = json.loads(b)
                return ''.join(p.get('text', '') for p in d['candidates'][0]['content']['parts']), 'gemini', d.get('modelVersion') or m
            except Exception as e:
                raise ProviderRequestError(f'gemini: unreadable reply envelope ({type(e).__name__})')
        worst = 'quota' if 'quota' in kinds else ('transient' if 'transient' in kinds or 'timeout' in kinds else (kinds[-1] if kinds else 'permanent'))
        raise ProviderUnavailable('gemini', worst, 'all models: ' + ','.join(kinds))

    def _or(self, prompt, timeout=240):
        return self._chat('https://openrouter.ai/api/v1/chat/completions', self.or_key, self.or_model, prompt, 'openrouter', timeout)

    def _free_chain(self, prompt, max_tokens, tried):
        """Next free provider in the owner's order; each one that is out of quota / down is skipped. Never a paid model."""
        for name, url, model, key in self.chain:
            try:
                return self._chat(url, key, model, prompt, name, 300, max_tokens)
            except ProviderUnavailable as e:
                if e.kind in ('time_budget', 'call_budget'): raise
                tried.append(f'{name}:{e.kind}')
            except ProviderRequestError:     # this backup rejects the request size/shape: try the next one
                tried.append(f'{name}:request_error')
        raise ProviderUnavailable('all_free_providers', 'quota' if any(':quota' in t for t in tried) else 'transient', ','.join(tried))

    def _gemini_then_chain(self, prompt, first=None, max_tokens=16000):
        tried = []
        try:
            models = ([first] if first else []) + [m for m in self.R.G_MODELS if m != first]
            return self._gemini(prompt, models=models)
        except ProviderUnavailable as e:
            if e.kind in ('time_budget', 'call_budget'): raise
            tried.append(f'gemini:{e.kind}')
        return self._free_chain(prompt, max_tokens, tried)

    def write(self, prompt):
        if self.writer == 'gemini':
            return self._gemini_then_chain(prompt, self.g_writer_model or None)
        return self._or(prompt)

    def fact_check(self, content, lang):
        p = FACT + text_of(content)
        en_on_gemini = lang == 'en' and self.writer != 'gemini'
        raw, prov, model = self._gemini(p) if en_on_gemini else self._or(p, 180)
        try:
            j = parse_json(raw)
        except ValueError:
            # checker answered, but not in the requested shape: INCONCLUSIVE (None), never a pass; the raw text is kept in the reason
            return None, 'inconclusive: checker reply not parseable: ' + (raw or '')[:300].replace('\n', ' '), prov, model
        return bool(j.get('correct')) is True, str(j.get('reason', ''))[:400], prov, model

    def solve(self, q):
        opts = '\n'.join(f'{i}) {o}' for i, o in enumerate(q['options']))
        p = ('Solve this question carefully. Show the arithmetic step by step and double-check it. Then end with one final line exactly like '
             '{"answer_index": N} where N is 0, 1, 2 or 3; if no option equals your result use {"answer_index": -1}.\n\n' + q['question'] + '\n' + opts)
        if self.writer == 'gemini':
            txt, prov, model = self._or(p, 180)                               # checker from a different company than the writer
            hit = re.findall(r'"answer_index"\s*:\s*(-?[0-3])', txt)
            return (int(hit[-1]) if hit else -1), prov, model
        try:
            txt, prov, model = self._gemini(p, json_mode=False)
        except ProviderUnavailable as e:
            if e.kind == 'time_budget' or not self.groq_key: raise          # Groq only when the owner confirmed it is free
            txt, prov, model = self._chat('https://api.groq.com/openai/v1/chat/completions', self.groq_key,
                                          os.environ.get('GROQ_WRITE_MODEL', 'openai/gpt-oss-120b'), p, 'groq', 180)
        hit = re.findall(r'"answer_index"\s*:\s*(-?[0-3])', txt)
        return (int(hit[-1]) if hit else -1), prov, model

    def extract(self, prompt):
        """Structured extraction (syllabus lines). Any free AI; a wrong line is dropped later by the PDF grounding check."""
        try:
            return self._gemini_then_chain(prompt, max_tokens=8000)
        except ProviderUnavailable as e:
            if e.kind in ('time_budget', 'call_budget'): raise
            return self._chat('https://openrouter.ai/api/v1/chat/completions', self.or_key, self.or_model, prompt, 'openrouter', 300, 8000)

    def translate(self, prompt):
        try:
            return self._gemini_then_chain(prompt)
        except ProviderUnavailable as e:        # every writer-chain AI is out: the free OpenRouter model translates
            if e.kind in ('time_budget', 'call_budget'): raise
            return self._chat('https://openrouter.ai/api/v1/chat/completions', self.or_key, self.or_model, prompt, 'openrouter', 300, 16000)


class Mock:
    """Scripted providers for tests. Each queue holds answers; an Exception instance in a queue is raised.
    fact/solve may be functions or lists (consumed in order). Records every call so tests can prove what ran."""
    def __init__(self, write=(), fact=None, solve=None, translate=()):
        self.q = {'write': list(write), 'translate': list(translate)}
        self.fact = fact or (lambda content, lang: (True, ''))
        self.solve_fn = solve or (lambda q: q['answer_index'])
        self.calls = []
        self.events = []

    def drain_events(self):
        e, self.events = self.events, []
        return e

    def _next(self, k):
        self.calls.append(k)
        x = self.q[k].pop(0)
        if isinstance(x, Exception): raise x
        return x

    def _fn(self, f, *a):
        r = f.pop(0) if isinstance(f, list) else f(*a)
        if isinstance(r, Exception): raise r
        return r

    def write(self, prompt):
        self.last_prompt = prompt
        return json.dumps(self._next('write'), ensure_ascii=False), 'mock-writer', 'mock-writer-1'

    def fact_check(self, content, lang):
        self.calls.append('fact_' + lang)
        r = self._fn(self.fact, content, lang)
        return r[0], r[1], 'mock-checker', 'mock-checker-1'

    def solve(self, q):
        self.calls.append('solve')
        return self._fn(self.solve_fn, q), 'mock-solver', 'mock-solver-1'

    def translate(self, prompt):
        return json.dumps(self._next('translate'), ensure_ascii=False), 'mock-translator', 'mock-translator-1'

    def research(self, prompt, queries=None):
        self.calls.append('research'); r = self._fn(self.research_fn, prompt) if hasattr(self, 'research_fn') else ({'subtopics': []}, [{'title': 't', 'uri': 'https://x'}])
        return json.dumps(r[0]), r[1], 'mock-research', 'mock-research-1'

    def extract(self, prompt):
        self.calls.append('extract'); self.last_extract = prompt
        return json.dumps(self._fn(self.extract_fn, prompt), ensure_ascii=False), 'mock-extractor', 'mock-extractor-1'

    def fact_check_app(self, d):
        self.calls.append('fact_app'); r = self._fn(self.fact, d, 'hi'); return r[0], r[1], 'mock-checker', 'mock-checker-1'

    def solve_all(self, practice):
        self.calls.append('solve_all'); r = self._fn(self.solve_all_fn, practice) if hasattr(self, 'solve_all_fn') else [x['answer'] for x in practice]
        return r, 'mock-solver', 'mock-solver-1'
