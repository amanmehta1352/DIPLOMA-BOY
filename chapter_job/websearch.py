"""Free web research without any AI search product: DuckDuckGo HTML results -> fetch top pages -> keep only their
headings and short list items (topic names). No paragraph text is kept, so nothing can be copied into content.
fetch(url) -> (status, bytes) is injectable for tests."""
import html, re, urllib.parse, urllib.request

UA = {'User-Agent': 'Mozilla/5.0 (compatible; diploma-boy-research/1.0)'}
SKIP = ('duckduckgo.com', 'youtube.com', 'facebook.com', 'instagram.com', 'twitter.com', 'x.com', 'pinterest.')


def fetch(url, timeout=20, cap=600_000):
    try:
        with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=timeout) as r:
            return r.status, r.read(cap)
    except Exception as e:
        return 0, str(e).encode()


LOG = []   # (engine, http status, results) for the job record


ENGINES = [
    ('duckduckgo', 'https://html.duckduckgo.com/html/?q={q}', r'<a[^>]+class="result__a"[^>]+href="([^"]+)"[^>]*>(.*?)</a>'),
    ('duckduckgo-lite', 'https://lite.duckduckgo.com/lite/?q={q}', r'<a[^>]+href="([^"]+)"[^>]*class=.result-link.[^>]*>(.*?)</a>'),
    ('mojeek', 'https://www.mojeek.com/search?q={q}', r'<a[^>]+class="ob"[^>]+href="([^"]+)"[^>]*>(.*?)</a>'),
    ('bing', 'https://www.bing.com/search?q={q}', r'<h2[^>]*><a[^>]+href="(https?://[^"]+)"[^>]*>(.*?)</a>'),
]


def search(query, fetch=fetch, n=6):
    for name, url, pat in ENGINES:
        s, b = fetch(url.format(q=urllib.parse.quote(query)))
        res = _parse(b, pat, n) if s == 200 else []
        LOG.append((name, s, len(res)))
        if res: return res
    return []


def _parse(b, pat, n):
    out, seen = [], set()
    for m in re.finditer(pat, b.decode('utf-8', 'replace'), re.S):
        href = html.unescape(m.group(1))
        q = urllib.parse.parse_qs(urllib.parse.urlparse(href).query).get('uddg')
        url = q[0] if q else href
        if not url.startswith('http') or any(x in url for x in SKIP) or url in seen: continue
        seen.add(url); out.append({'title': re.sub(r'<[^>]+>', '', html.unescape(m.group(2))).strip(), 'uri': url})
        if len(out) >= n: break
    return out


def headings(page_bytes, limit=60):
    t = page_bytes.decode('utf-8', 'replace')
    t = re.sub(r'(?is)<(script|style|nav|footer|header)[^>]*>.*?</\1>', ' ', t)
    items = []
    for tag, inner in re.findall(r'(?is)<(h[1-4]|li)[^>]*>(.*?)</\1>', t):
        x = re.sub(r'\s+', ' ', html.unescape(re.sub(r'<[^>]+>', ' ', inner))).strip()
        if 3 <= len(x) <= 120 and x not in items: items.append(x)
        if len(items) >= limit: break
    return items


def research(queries, fetch=fetch, pages=5):
    """Returns (sources, outline_material): sources = pages actually read; material = their headings only."""
    found = []
    for q in queries:
        for r in search(q, fetch):
            if r['uri'] not in [x['uri'] for x in found]: found.append(r)
    sources, material = [], []
    for r in found:
        if len(sources) >= pages: break
        s, b = fetch(r['uri'])
        if s != 200: continue
        h = headings(b)
        if len(h) >= 5:
            sources.append(r); material.append({'source': r['uri'], 'headings': h})
    return sources, material
