/* Diploma Boy service worker — db-v26.
   App shell + Supabase content: stale-while-revalidate.
   First open after a level is picked downloads that level once (see
   warmOfflinePack() in index.html / next.html); later opens show the
   phone's saved copy instantly, even offline, and refresh in the
   background when the net is there. POSTs are never cached.
   Bump VERSION on every release so old caches are dropped. */
const VERSION = 'db-v26';
const SHELL = 'shell-' + VERSION, DATA = 'data-' + VERSION;
const SHELL_FILES = ['./', './index.html', './next.html', './book.html', './level-book.html', './edition.html', './solve.html', './manifest.webmanifest', './privacy.html', './terms.html', './delete-data.html',
  './icons/icon.svg', './icons/icon-192.png', './icons/icon-512.png', './icons/icon-512-maskable.png', './icons/apple-touch-icon.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(SHELL).then(c => c.addAll(SHELL_FILES)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(k => k !== SHELL && k !== DATA).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

async function staleWhileRevalidate(req, cacheName, fallbackUrl) {
  const cache = await caches.open(cacheName);
  const cached = await cache.match(req, { ignoreVary: true });
  const network = fetch(req).then(res => {
    if (res && res.ok) cache.put(req, res.clone());
    return res;
  }).catch(() => null);
  if (cached) { network.catch(() => {}); return cached; }
  const res = await network;
  if (res) return res;
  const fb = fallbackUrl && await cache.match(fallbackUrl);
  if (fb) return fb;
  throw new Error('offline and nothing cached');
}

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.hostname.endsWith('.supabase.co') && url.pathname.startsWith('/rest/v1/')) {
    e.respondWith(staleWhileRevalidate(req, DATA));
    return;
  }
  if (url.hostname.endsWith('.supabase.co') && url.pathname.startsWith('/storage/v1/object/public/')) {
    e.respondWith(staleWhileRevalidate(req, DATA));
    return;
  }
  if (url.origin === self.location.origin) {
    e.respondWith(staleWhileRevalidate(req, SHELL, req.mode === 'navigate' ? './index.html' : null));
    return;
  }
  if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    e.respondWith(staleWhileRevalidate(req, SHELL));
  }
});
