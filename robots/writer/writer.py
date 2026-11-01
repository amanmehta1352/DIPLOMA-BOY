"""Chapter Writer Robot: writes deep chapter content with a free AI (Gemini), checks it, saves it as a DRAFT.
Nothing it writes is shown in the app until the owner approves it.

   python3 robots/writer/writer.py --count 3 [--level govt_technical] [--dry-run]

Env: GEMINI_API_KEY (never printed), SUPABASE_SECRET_KEY (service role, never printed).
Checks before saving:
  1. structure: every section present, right counts, 4 options, answer index 0-3, no HTML / LaTeX
  2. second opinion: a second Gemini call solves the 10 practice questions without seeing the answers;
     more than 2 disagreements -> rejected
A chapter that fails is saved with status 'rejected' (and its reasons) so it is retried later, never shown.
"""
import argparse, json, os, random, re, sys, time, urllib.request, urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
SB_KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
GKEY = os.environ.get('GEMINI_API_KEY', '').strip()
WRITE_MODELS = ['gemini-3.5-flash', 'gemini-flash-latest', 'gemini-3.8-flash']
CHECK_MODELS = ['gemini-3.5-flash-lite', 'gemini-flash-lite-latest', 'gemini-3.5-flash']
LEVEL_ORDER = ['class_9_10', 'medical', 'govt_basic', 'upsc_civil', 'govt_technical', 'class_11_12_sci', 'class_6_8', 'banking', 'govt_defence',
               'engineering', 'state_psc', 'class_11_12_com', 'class_11_12_arts',
               'graduation_sci', 'graduation_com', 'graduation_arts', 'law_management', 'advanced_research']


FREE_KEYS = {
    'groq': os.environ.get('GROQ_API_KEY', '').strip(),
    'nvidia': os.environ.get('NVIDIA_API_KEY', '').strip(),
    'sambanova': os.environ.get('SAMBANOVA_API_KEY', '').strip(),
    'cloudflare': os.environ.get('CLOUDFLARE_API_TOKEN', '').strip(),
}
CF_ACCOUNT = os.environ.get('CLOUDFLARE_ACCOUNT_ID', '').strip()
# Backup writers, used only when every Gemini model fails. Each is OpenAI-compatible; model names can be overridden by env.
FREE_PROVIDERS = [
    ('groq', 'https://api.groq.com/openai/v1/chat/completions', os.environ.get('GROQ_WRITE_MODEL', 'openai/gpt-oss-120b')),
    ('nvidia', 'https://integrate.api.nvidia.com/v1/chat/completions', os.environ.get('NVIDIA_WRITE_MODEL', '')),   # no verified large model yet: set NVIDIA_WRITE_MODEL to enable
    ('sambanova', 'https://api.sambanova.ai/v1/chat/completions', os.environ.get('SAMBANOVA_WRITE_MODEL', 'Meta-Llama-3.3-70B-Instruct')),
    ('cloudflare', f'https://api.cloudflare.com/client/v4/accounts/{CF_ACCOUNT}/ai/v1/chat/completions', os.environ.get('CLOUDFLARE_WRITE_MODEL', '@cf/meta/llama-3.3-70b-instruct-fp8-fast')),
]


def hide(s):
    s = str(s)
    for k in (GKEY, SB_KEY, *FREE_KEYS.values()):
        if k: s = s.replace(k, '[hidden]')
    return s


def http(url, headers, body=None, method='POST', timeout=300):
    headers = {**headers, 'User-Agent': 'Mozilla/5.0 (diploma-boy)'}   # Groq answers 403 to the default Python agent
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()
    except (TimeoutError, urllib.error.URLError, OSError) as e:   # slow or dropped answer: treat like a busy server
        return 504, str(e).encode()


# ---------- Gemini ----------
def gemini(prompt, models, json_out=True, temperature=0.4, deadline=None):
    """Returns (text, model). Tries each model; waits and retries on 429/500/503. Stops at the deadline (epoch seconds)."""
    last = ''
    for m in models:
        for attempt in range(4):
            if deadline and time.time() > deadline:
                raise RuntimeError('Gemini deadline passed: ' + last)
            cfg = {'temperature': temperature}
            if json_out: cfg['responseMimeType'] = 'application/json'
            body = json.dumps({'contents': [{'parts': [{'text': prompt}]}], 'generationConfig': cfg}).encode()
            left = int(deadline - time.time()) if deadline else 300
            s, b = http(f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                        {'x-goog-api-key': GKEY, 'Content-Type': 'application/json'}, body, timeout=max(10, min(300, left)))
            if s == 200:
                try:
                    d = json.loads(b)
                    cand = d['candidates'][0]
                    txt = ''.join(p.get('text', '') for p in cand['content']['parts'])
                except Exception as e:
                    last = f'{m}: bad response {e}'; break
                if not txt.strip() or cand.get('finishReason', 'STOP') != 'STOP':   # empty or cut off: next model
                    last = f'{m}: unusable output ({cand.get("finishReason")})'; break
                return txt, m
            last = f'{m}: HTTP {s} {hide(b[:200])}'
            if s in (429, 500, 502, 503, 504):
                time.sleep(min(60, 8 * (attempt + 1))); continue
            break   # 400/404 etc: try the next model
    raise RuntimeError('Gemini failed: ' + last)


def free_write(prompt):
    """Returns (text, model) from the first backup provider that answers. Raises if none does."""
    last = ''
    for name, url, model in FREE_PROVIDERS:
        key = FREE_KEYS[name]
        if not key or not model or (name == 'cloudflare' and not CF_ACCOUNT):
            last = f'{name}: key, model or account missing'; continue
        body = json.dumps({'model': model, 'messages': [{'role': 'user', 'content': prompt}],
                           'temperature': 0.4, 'max_tokens': 8192, 'response_format': {'type': 'json_object'}}).encode()
        s, b = http(url, {'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'}, body, timeout=240)
        if s == 200:
            try:
                d = json.loads(b)
                ch = d['choices'][0]
                txt = (ch.get('message') or {}).get('content') or ''
            except Exception as e:
                last = f'{name}: bad response {e}'; continue
            if not txt.strip() or ch.get('finish_reason') == 'length':   # empty or cut off: try the next provider
                last = f'{name}: unusable content (finish {ch.get("finish_reason")})'; continue
            return txt, f'{name}:{model}'
        last = f'{name}: HTTP {s} {hide(b[:160])}'
    raise RuntimeError('free providers failed: ' + last)


GEMINI_BUDGET = int(os.environ.get('GEMINI_BUDGET_SECONDS', '900'))   # total time for Gemini per chapter before backups start


def write_text(prompt):
    """Gemini first; backup free providers only if Gemini fails completely."""
    try:
        return gemini(prompt, WRITE_MODELS, deadline=time.time() + GEMINI_BUDGET)
    except RuntimeError as g_err:
        try:
            return free_write(prompt)
        except RuntimeError as f_err:
            raise RuntimeError(f'{g_err} | {f_err}')


def parse_json(text):
    t = text.strip()
    m = re.search(r'```(?:json)?\s*(.*?)```', t, re.S)
    if m: t = m.group(1)
    a, b = t.find('{'), t.rfind('}')
    return json.loads(t[a:b + 1])


# ---------- checks ----------
BAD = re.compile(r'<\s*/?\s*(div|span|p|br|b|i|sup|sub|table|tr|td|img|svg)\b|\\frac|\\sqrt|\$\$|\\\(|\\\[', re.I)


def strings(x):
    if isinstance(x, str): yield x
    elif isinstance(x, list):
        for y in x: yield from strings(y)
    elif isinstance(x, dict):
        for y in x.values(): yield from strings(y)


def check_structure(d, want_id):
    p = []
    def n(key, lo, hi):
        v = d.get(key)
        if not isinstance(v, list): p.append(f'{key}: missing'); return []
        if not (lo <= len(v) <= hi): p.append(f'{key}: {len(v)} (want {lo}-{hi})')
        return v
    if d.get('id') != want_id: p.append(f'id: {d.get("id")!r} != {want_id}')
    for i, x in enumerate(n('notes', 5, 8)):
        if not isinstance(x, dict) or not x.get('title') or not isinstance(x.get('points'), list) or len(x['points']) < 2:
            p.append(f'notes[{i}]: needs title + points')
    for i, x in enumerate(n('teach', 4, 6)):
        if not isinstance(x, dict) or not x.get('heading') or not x.get('explain'): p.append(f'teach[{i}]: needs heading + explain')
    for i, x in enumerate(n('formulas', 6, 12)):
        if not isinstance(x, dict) or not x.get('title') or not x.get('formula'): p.append(f'formulas[{i}]: needs title + formula')
    for i, x in enumerate(n('solved', 3, 5)):
        if not isinstance(x, dict) or not x.get('question') or not isinstance(x.get('steps'), list) or not x.get('answer'):
            p.append(f'solved[{i}]: needs question + steps + answer')
    for i, x in enumerate(n('practice', 10, 10)):
        ok = isinstance(x, dict) and x.get('q') and isinstance(x.get('options'), list) and len(x['options']) == 4 \
            and all(isinstance(o, str) and o.strip() for o in x['options']) and isinstance(x.get('answer'), int) and 0 <= x['answer'] <= 3
        if not ok: p.append(f'practice[{i}]: needs q, 4 options, answer 0-3')
        elif len({o.strip() for o in x['options']}) < 4: p.append(f'practice[{i}]: duplicate options')
        else:   # the worked answer must end at the same answer as the right option (symmetric with the solved examples)
            right = x['options'][x['answer']]; nums = re.findall(r'\d+(?:\.\d+)?', right.replace(',', ''))
            exp = str(x.get('explanation') or '').replace(',', '')
            if not exp.strip(): p.append(f'practice[{i}]: explanation missing')
            elif nums and not all(n in exp for n in nums): p.append(f'practice[{i}]: explanation does not reach the right option ({right})')
            if re.search(r'\*', exp): p.append(f'practice[{i}]: use × not *')
    n('mistakes', 3, 5); n('revision', 6, 10)
    bad = [s for s in strings(d) if BAD.search(s)]
    if bad: p.append(f'HTML/LaTeX found ({len(bad)}): {bad[0][:60]}')
    if sum(len(s) for s in strings(d)) < 6000: p.append('too short')
    return p


def shuffle_options(d, seed):
    """AI models tend to put the right answer in the same place; mix option order (same order every rerun)."""
    rnd = random.Random(seed)
    for x in d.get('practice', []):
        if isinstance(x, dict) and isinstance(x.get('options'), list) and len(x['options']) == 4 and isinstance(x.get('answer'), int) and 0 <= x['answer'] <= 3:
            right = x['options'][x['answer']]; order = list(range(4)); rnd.shuffle(order)
            x['options'] = [x['options'][i] for i in order]; x['answer'] = x['options'].index(right)
    return d


def tidy_explanations(d):
    """The circled right option is shown under every worked answer, so a closing 'अतः उत्तर = …' line is dropped
    (AI writers often put an option number there, which is wrong after the options are mixed)."""
    for x in d.get('practice', []):
        if isinstance(x, dict) and isinstance(x.get('explanation'), str):
            lines = [l for l in x['explanation'].split('\n') if l.strip()]
            while lines and re.match(r'^\s*(अतः\s*)?(सही\s*)?उत्तर\s*[=:]', lines[-1]): lines.pop()
            x['explanation'] = '\n'.join(lines)
    return d


ORKEY = os.environ.get('OPENROUTER_API_KEY', '').strip()
OR_MODEL = os.environ.get('OPENROUTER_MODEL', 'deepseek/deepseek-chat')


def openrouter(prompt, model=None, provider=None):
    """Second AI from a different company (OpenRouter). Reasoning off so the reply is not empty."""
    req = {'model': model or OR_MODEL, 'messages': [{'role': 'user', 'content': prompt}], 'temperature': 0,
           'max_tokens': 400, 'reasoning': {'effort': 'none', 'exclude': True}}
    if provider: req['provider'] = provider
    body = json.dumps(req).encode()
    s, b = http('https://openrouter.ai/api/v1/chat/completions', {'Authorization': 'Bearer ' + ORKEY, 'Content-Type': 'application/json'}, body, timeout=120)
    if s != 200: raise RuntimeError(f'openrouter HTTP {s} {hide(b[:160])}')
    d = json.loads(b)
    return d['choices'][0]['message'].get('content') or '', d.get('model', model or OR_MODEL)


DEVA = re.compile(r'[\u0900-\u097F]')
LATIN = re.compile(r'[A-Za-z]')


def _hindi_major(text):
    """Maths and units are not language: drop bracketed English terms, symbol-like tokens (v, m/s, sqrt, x^2) and short Latin words."""
    t = re.sub(r'\([^()]*\)', ' ', text)
    units = r'(m|s|kg|g|km|cm|mm|N|J|W|V|A|K|Pa|Hz|C|mol|L|ml|h|min|rad)'
    t = re.sub(r'\b[A-Za-z]\b'                                   # single-letter variables: v, t, m
               r'|\b(sqrt|sin|cos|tan|log|ln|KE|PE)\b'             # functions and standard symbols
               r'|\b' + units + r'(/' + units + r')*(\^\d+)?\b'       # units: m/s, kg, m^2
               r'|[A-Za-z]+\^\d+|[A-Za-z]*\d+[A-Za-z]*', ' ', t)
    dv, la = len(DEVA.findall(t)), len(LATIN.findall(t))
    return dv > 0 and dv >= la


def hindi_ok(d):
    """Pure: every teaching section is in Hindi (Devanagari is the majority in each; English terms in brackets are allowed).
    Formulas are not checked (they are symbols). A missing section is left to the structure check."""
    sections = {k: ' '.join(strings(d.get(k))) for k in ('notes', 'teach', 'solved', 'mistakes', 'revision') if d.get(k)}
    prac = [x for x in d.get('practice', []) if isinstance(x, dict)]
    if prac: sections['practice'] = ' '.join(str(x.get('q', '')) + ' ' + str(x.get('explanation', '')) for x in prac)
    return bool(sections) and all(_hindi_major(t) for t in sections.values())


COPY_THRESHOLD = 0.20
_FP = None


def copyright_score(d):
    """Share of the chapter's 3-word sequences (counted with repeats) found in the hashed NCERT fingerprints.
    None when the fingerprints for Hindi and English are not both loaded, so the gate cannot judge."""
    global _FP
    try:
        sys.path.insert(0, os.path.join(HERE, '..', 'copyright'))
        import ngram as NG
        if _FP is None:
            hs, langs = NG.load_fingerprint_files()
            _FP = hs if (langs.get('hi') and langs.get('en')) else set()
        if not _FP: return None
        words = NG.words(' '.join(strings(d)))
        grams = [NG.fp(tuple(words[i:i + 3])) for i in range(len(words) - 2)]
        if not grams: return 0.0
        return sum(1 for g in grams if g in _FP) / len(grams)
    except Exception:
        return None


def second_opinion(d):
    qs = [{'n': i, 'q': x['q'], 'options': x['options']} for i, x in enumerate(d.get('practice', []))]
    prompt = ('Solve each multiple-choice question carefully. Reply only with JSON: {"answers": [index, ...]} '
              'where each index is 0, 1, 2 or 3 in the same order as the questions.\n\n' + json.dumps(qs, ensure_ascii=False))
    if ORKEY:
        txt, m = openrouter(prompt)          # a different company checks the answers
    else:
        try:
            txt, m = gemini(prompt, CHECK_MODELS, temperature=0, deadline=time.time() + 300)
        except RuntimeError:                 # Gemini down: a free provider still checks, so the chapter is not rejected
            txt, m = free_write(prompt)
    got = parse_json(txt).get('answers', [])
    diff = [i for i, x in enumerate(d['practice']) if i >= len(got) or got[i] != x['answer']]
    return diff, m


# ---------- server ----------
def rpc(name, args=None):
    h = {'apikey': SB_KEY, 'Authorization': 'Bearer ' + SB_KEY, 'Content-Profile': 'mtb', 'Accept-Profile': 'mtb',
         'Content-Type': 'application/json', 'x-actor': 'writer-robot'}
    s, b = http(f'{SB}/rest/v1/rpc/{name}', h, json.dumps(args or {}).encode(), timeout=60)
    if s >= 300: raise RuntimeError(f'{name}: HTTP {s} {hide(b[:200])}')
    return json.loads(b) if b else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--count', type=int, default=3)
    ap.add_argument('--level', default='')
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--only', default='', help='chapter ids (comma separated) to (re)write even if a draft exists; approved drafts are never overwritten')
    ap.add_argument('--report', default='writer-report.md')
    a = ap.parse_args()
    if not GKEY: sys.exit('GEMINI_API_KEY missing')
    if not SB_KEY and not a.dry_run: sys.exit('SUPABASE_SECRET_KEY missing')

    chapters = json.load(open(os.path.join(HERE, 'chapters.json'), encoding='utf-8'))
    levels = {l['id']: l for l in json.load(open(os.path.join(HERE, 'levels.json'), encoding='utf-8'))}
    tpl = open(os.path.join(HERE, 'prompt.txt'), encoding='utf-8').read()
    done = {}
    if SB_KEY:
        done = {(r['level_id'], r['chapter_id']): r for r in rpc('draft_status')}
    # queue: not done yet, or rejected fewer than 3 times; levels in priority order
    order = {l: i for i, l in enumerate(LEVEL_ORDER)}
    queue = [c for c in chapters if (not a.level or c['l'] == a.level)
             and ((c['l'], c['c']) not in done or (done[(c['l'], c['c'])]['status'] == 'rejected' and done[(c['l'], c['c'])]['attempts'] < 3))]
    queue.sort(key=lambda c: (order.get(c['l'], 99), c['c']))
    if a.only:
        ids = {int(x) for x in a.only.split(',') if x.strip()}
        queue = sorted([c for c in chapters if (not a.level or c['l'] == a.level) and c['c'] in ids
                        and done.get((c['l'], c['c']), {}).get('status') != 'approved'], key=lambda c: (order.get(c['l'], 99), c['c']))
    cfg = json.load(open(os.path.join(HERE, '..', 'ecosystem', 'config.json'), encoding='utf-8'))
    AUTO_OK, AUTO_MAX, approved_now = bool(cfg.get('auto_approve')), int(cfg.get('auto_approve_max_per_run', 5)), 0
    lines = [f'# Writer robot report', f'queue left before this run: {len(queue)}', f'auto-approve: {"on" if AUTO_OK else "off"}', '']
    for c in queue[:a.count]:
        L = levels[c['l']]
        want = f"DB|{c['l']}|{c['c']}"
        prompt = tpl
        for k, v in {'{l}': c['l'], '{c}': str(c['c']), '{lhi}': L['hi'], '{len}': L['en'], '{depth}': L['depth'],
                     '{s}': c['s'], '{se}': c['se'], '{h}': c['h'], '{e}': c['e']}.items():
            prompt = prompt.replace(k, v)
        for attempt in range(2):
          status, checks, model, data = 'rejected', {}, None, None
          try:
              txt, model = write_text(prompt)
              data = tidy_explanations(shuffle_options(parse_json(txt), want))
              prob = check_structure(data, want)
              checks['structure'] = prob
              if not prob:
                  diff, cm = second_opinion(data)
                  checks['second_opinion'] = {'model': cm, 'disagree': diff}
                  if len(diff) > 2: prob.append(f'second opinion disagrees on {len(diff)} of 10 answers')
                  if not hindi_ok(data): prob.append('not Hindi (Devanagari is not the majority)')
                  cs = copyright_score(data)          # automatic gate: the draft must not copy the NCERT text we hold
                  checks['copyright_overlap'] = None if cs is None else round(cs, 3)
                  if cs is None: prob.append('copyright check unavailable (no fingerprints loaded)')
                  elif cs > COPY_THRESHOLD: prob.append(f'copyright overlap {cs:.0%} is above {COPY_THRESHOLD:.0%}')
              status = 'draft' if not prob else 'rejected'
              checks['problems'] = prob
          except Exception as e:
              checks['error'] = hide(e)[:300]
          if status == 'draft': break
          time.sleep(10)
        size = sum(len(s) for s in strings(data)) if data else 0
        cs_txt = 'copy n/a' if checks.get('copyright_overlap') is None else f"copy {checks['copyright_overlap']:.1%}"
        lines.append(f"- {want} {c['h']} ({c['s']}): **{status}** · {model} · {size} chars · {cs_txt} · {'; '.join(checks.get('problems', [])) or checks.get('error', '') or 'all checks passed'}")
        print(lines[-1], flush=True)
        if data is not None and not a.dry_run and not checks.get('error'):   # infrastructure errors never count as rejections
            rpc('draft_save', {'p': {'level_id': c['l'], 'chapter_id': c['c'], 'status': status, 'data': data,
                                     'provider': 'gemini', 'model': model, 'checks': checks}})
            # Auto-approve only when the second opinion came from a different company (OpenRouter); a Gemini fallback never publishes.
            if status == 'draft' and AUTO_OK and ORKEY and approved_now < AUTO_MAX:
                # Automatic approval: the database re-checks the same rules (no problems, second AI agreed on all answers).
                r = rpc('auto_approve_draft', {'p_level': c['l'], 'p_chapter': c['c']})
                if r == 'approved': approved_now += 1
                lines[-1] += f' · auto: {r}'
                print(lines[-1], flush=True)
        if a.dry_run and data is not None:
            os.makedirs('writer-out', exist_ok=True)
            json.dump(data, open(f"writer-out/{c['l']}_{c['c']}.json", 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        time.sleep(6)   # stay under the free per-minute limit
    open(a.report, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')


if __name__ == '__main__':
    main()
