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
        self.budget = float(os.environ.get('PROVIDER_TIME_BUDGET_S', TIME_BUDGET_S))
        self.spent = 0.0
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
            t0 = self.clock()
            s, b = self.R.http(url, headers, body, timeout)
            dt = self.clock() - t0; self.spent += dt
            k = kind_of(s, b if isinstance(b, bytes) else str(b).encode())
            self.events.append({'provider': provider, 'model': model, 'http': s, 'kind': k, 'try': t, 'secs': round(dt, 2)})
            if k == 'ok': return b
            if k == 'request_error': raise ProviderRequestError(f'{provider} {model}: HTTP {s} (our request was rejected)')
            last = k
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

    def _chat(self, url, key, model, prompt, provider, timeout=240):
        if not key: raise ProviderUnavailable(provider, 'not_configured', 'key missing or free tier not confirmed by owner')
        req = {'model': model, 'messages': [{'role': 'user', 'content': prompt}], 'temperature': 0.3, 'max_tokens': 4000}
        if provider == 'openrouter':
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

    def _gemini(self, prompt, json_mode=True):
        if not self.g_key: raise ProviderUnavailable('gemini', 'not_configured', 'key missing or free tier not confirmed by owner')
        kinds = []
        for m in self.R.G_MODELS:
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

    def write(self, prompt):
        return self._chat('https://openrouter.ai/api/v1/chat/completions', self.or_key, self.or_model, prompt, 'openrouter')

    def fact_check(self, content, lang):
        p = FACT + text_of(content)
        raw, prov, model = self._gemini(p) if lang == 'en' else self._chat('https://openrouter.ai/api/v1/chat/completions', self.or_key, self.or_model, p, 'openrouter', 180)
        j = parse_json(raw)
        return bool(j.get('correct')) is True, str(j.get('reason', ''))[:400], prov, model

    def solve(self, q):
        opts = '\n'.join(f'{i}) {o}' for i, o in enumerate(q['options']))
        p = ('Solve this question carefully. Show the arithmetic step by step and double-check it. Then end with one final line exactly like '
             '{"answer_index": N} where N is 0, 1, 2 or 3; if no option equals your result use {"answer_index": -1}.\n\n' + q['question'] + '\n' + opts)
        try:
            txt, prov, model = self._gemini(p, json_mode=False)
        except ProviderUnavailable as e:
            if e.kind == 'time_budget' or not self.groq_key: raise          # Groq only when the owner confirmed it is free
            txt, prov, model = self._chat('https://api.groq.com/openai/v1/chat/completions', self.groq_key,
                                          os.environ.get('GROQ_WRITE_MODEL', 'openai/gpt-oss-120b'), p, 'groq', 180)
        hit = re.findall(r'"answer_index"\s*:\s*(-?[0-3])', txt)
        return (int(hit[-1]) if hit else -1), prov, model

    def translate(self, prompt):
        return self._gemini(prompt)


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
