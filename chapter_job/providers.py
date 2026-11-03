"""AI providers for the chapter job. Every call returns the provider and the model that actually answered (attribution).
Quota, rate limits, outages, missing keys and timeouts raise ProviderUnavailable, so the job ends 'blocked' and resumes later.

Real(): the same free providers the route robot already uses (robots/route/run_chapter.py http helper):
  writer      = OpenRouter (OPENROUTER_MODEL, default deepseek/deepseek-chat)
  fact checks = Gemini for English, OpenRouter for Hindi (a different company from the translator)
  MCQ solver  = Gemini with written working; Groq as backup
  translator  = Gemini
"""
import json, os, re, sys, time
from job import ProviderUnavailable, text_of, parse_json

ROUTE = os.environ.get('ROUTE_DIR', os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'diploma-boy', 'robots', 'route'))

FACT = ('Is this Class 10 study text correct? Check every claim: definitions, laws, formulas, cause-effect, units, numerical values. '
        'If any claim is wrong or misleading answer {"correct": false, "reason": "<which claim and why>"}, otherwise {"correct": true, "reason": ""}. '
        'Return only that JSON.\n\nTEXT:\n')


class Real:
    def __init__(self):
        sys.path.insert(0, ROUTE)
        import run_chapter as R
        self.R = R
        self.or_key = os.environ.get('OPENROUTER_API_KEY', '').strip()
        self.or_model = os.environ.get('OPENROUTER_MODEL', '').strip()
        # owner-confirmed no-charge providers only; anything not listed is never called
        self.free_ok = {x.strip() for x in os.environ.get('FREE_TIER_CONFIRMED', '').split(',') if x.strip()}
        self.g_key = os.environ.get('GEMINI_API_KEY', '').strip() if 'gemini' in self.free_ok else ''
        self.groq_key = os.environ.get('GROQ_API_KEY', '').strip() if 'groq' in self.free_ok else ''
        self._or_checked = False

    def _openrouter_free_guard(self):
        """Blocks before any OpenRouter call unless the model is a ':free' id that OpenRouter currently prices at 0/0."""
        if self._or_checked: return
        if not self.or_model.endswith(':free'):
            raise ProviderUnavailable(f'openrouter: model {self.or_model!r} is not a :free id; paid models are not allowed')
        import urllib.request
        try:
            with urllib.request.urlopen(urllib.request.Request('https://openrouter.ai/api/v1/models', method='GET'), timeout=60) as r: b = r.read()
        except Exception as e:
            raise ProviderUnavailable(f'openrouter: price check failed ({type(e).__name__})')
        m = {x['id']: x for x in json.loads(b)['data']}.get(self.or_model)
        if not m: raise ProviderUnavailable(f'openrouter: {self.or_model} not listed')
        pr = m.get('pricing', {})
        if any(float(pr.get(k) or 0) != 0 for k in ('prompt', 'completion', 'request', 'image')):
            raise ProviderUnavailable(f'openrouter: {self.or_model} is not priced at 0 ({pr})')
        self._or_checked = True

    def _chat(self, url, key, model, prompt, provider, timeout=240):
        if not key: raise ProviderUnavailable(f'{provider}: key missing or free tier not confirmed by owner')
        req = {'model': model, 'messages': [{'role': 'user', 'content': prompt}], 'temperature': 0.3, 'max_tokens': 4000}
        if provider == 'openrouter':
            self._openrouter_free_guard()
            req['provider'] = {'allow_fallbacks': False, 'max_price': {'prompt': 0, 'completion': 0}}   # no paid routing; no 'models' fallback list
        body = json.dumps(req).encode()
        s, b = self.R.http(url, {'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'}, body, timeout)
        if s == 429 or s >= 500: raise ProviderUnavailable(f'{provider}: HTTP {s}')
        if s != 200: raise RuntimeError(f'{provider}: HTTP {s}')
        j = json.loads(b)
        got = j.get('model') or model
        if provider == 'openrouter' and got.split(':')[0] != model.split(':')[0]:
            raise ProviderUnavailable(f'openrouter: answered by {got}, not the requested free model {model}')
        return j['choices'][0]['message']['content'] or '', provider, got

    def _gemini(self, prompt, json_mode=True):
        if not self.g_key: raise ProviderUnavailable('gemini: key missing or free tier not confirmed by owner')
        last = ''
        for m in self.R.G_MODELS:
            cfg = {'temperature': 0.2}
            if json_mode: cfg['responseMimeType'] = 'application/json'
            body = json.dumps({'contents': [{'parts': [{'text': prompt}]}], 'generationConfig': cfg}).encode()
            s, b = self.R.http(f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                               {'x-goog-api-key': self.g_key, 'Content-Type': 'application/json'}, body)
            if s == 200:
                d = json.loads(b)
                return ''.join(p.get('text', '') for p in d['candidates'][0]['content']['parts']), 'gemini', d.get('modelVersion') or m
            last = f'{m}: HTTP {s}'; time.sleep(3)
        raise ProviderUnavailable('gemini: ' + last)

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
        except ProviderUnavailable:
            txt, prov, model = self._chat('https://api.groq.com/openai/v1/chat/completions', self.groq_key,
                                          os.environ.get('GROQ_WRITE_MODEL', 'openai/gpt-oss-120b'), p, 'groq', 180)
        hit = re.findall(r'"answer_index"\s*:\s*(-?[0-3])', txt)
        return (int(hit[-1]) if hit else -1), prov, model

    def translate(self, prompt):
        return self._gemini(prompt)


class Mock:
    """Scripted providers for tests. Each queue holds answers; an Exception instance in a queue is raised.
    Records every call so tests can prove what ran (and what did not)."""
    def __init__(self, write=(), fact=None, solve=None, translate=()):
        self.q = {'write': list(write), 'translate': list(translate)}
        self.fact = fact or (lambda content, lang: (True, ''))
        self.solve_fn = solve or (lambda q: q['answer_index'])
        self.calls = []

    def _next(self, k):
        self.calls.append(k)
        x = self.q[k].pop(0)
        if isinstance(x, Exception): raise x
        return x

    def write(self, prompt):
        self.last_prompt = prompt
        return json.dumps(self._next('write'), ensure_ascii=False), 'mock-writer', 'mock-writer-1'

    def fact_check(self, content, lang):
        self.calls.append('fact_' + lang)
        r = self.fact(content, lang)
        if isinstance(r, Exception): raise r
        return r[0], r[1], 'mock-checker', 'mock-checker-1'

    def solve(self, q):
        self.calls.append('solve')
        r = self.solve_fn(q)
        if isinstance(r, Exception): raise r
        return r, 'mock-solver', 'mock-solver-1'

    def translate(self, prompt):
        return json.dumps(self._next('translate'), ensure_ascii=False), 'mock-translator', 'mock-translator-1'
