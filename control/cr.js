/* Diploma Boy Control Room (S4 skeleton). Read-only: draws status.json written by the Health Robot.
   Several apps: add an entry to apps.json. No secret in this page. */
'use strict';
const FALLBACK = { apps: [{ id: 'diploma-boy', name: 'Diploma Boy', icon: '🎓', repo: 'amanmehta1352/DIPLOMA-BOY',
  status_base: 'https://raw.githubusercontent.com/amanmehta1352/DIPLOMA-BOY/status/', site: 'https://amanmehta1352.github.io/DIPLOMA-BOY/', workflows: {} }] };
const S = { apps: [], app: null, status: null, hist: [], route: 'overview', err: '' };
const $ = id => document.getElementById(id);
const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const num = v => (v === null || v === undefined || v === '') ? '—' : (typeof v === 'number' ? v.toLocaleString('en-IN') : esc(v));
const DOT = { ok: '🟢', warn: '🟡', bad: '🔴' };
const HEAD = { ok: ['सब ठीक है', 'कोई लाल निशान नहीं'], warn: ['ध्यान दो', 'कुछ चीज़ें देखनी हैं'], bad: ['गड़बड़ है', 'लाल निशान वाली चीज़ पहले ठीक करो'] };
const RES = { success: ['ok', '✓ ठीक'], failure: ['bad', '✕ fail'], cancelled: ['none', 'रोका'], in_progress: ['warn', '⏳ चल रहा'], queued: ['warn', '⏳ कतार'] };
function ago(iso) { const m = Math.round((Date.now() - new Date(iso)) / 60000); if (isNaN(m)) return '—'; if (m < 1) return 'अभी'; if (m < 60) return m + ' मिनट पहले'; if (m < 1440) return Math.round(m / 60) + ' घंटे पहले'; return Math.round(m / 1440) + ' दिन पहले'; }
const safeUrl = u => /^https:\/\//.test(u || '') ? esc(u) : '#';

async function getJson(url) { const r = await fetch(url, { cache: 'no-store' }); if (!r.ok) throw new Error(r.status); return r.json(); }
async function loadApps() {
  try { S.apps = (await getJson('apps.json')).apps; } catch (_) { S.apps = FALLBACK.apps; }
  const want = (location.hash.match(/app=([\w-]+)/) || [])[1];
  S.app = S.apps.find(a => a.id === want) || S.apps[0];
  const sel = $('appSel'); sel.innerHTML = S.apps.map(a => `<option value="${esc(a.id)}">${esc(a.icon)} ${esc(a.name)}</option>`).join(''); sel.value = S.app.id; sel.hidden = S.apps.length < 2;
  sel.onchange = () => { S.app = S.apps.find(a => a.id === sel.value); load(); };
}
async function load() {
  $('appName').textContent = S.app.name; $('appIcon').textContent = S.app.icon; $('age').textContent = 'लोड हो रहा है…';
  const t = '?t=' + Math.floor(Date.now() / 60000);
  try {
    const [st, h] = await Promise.all([getJson(S.app.status_base + 'status.json' + t), getJson(S.app.status_base + 'history.json' + t).catch(() => [])]);
    S.status = st; S.hist = Array.isArray(h) ? h : []; S.err = '';
  } catch (e) { S.status = null; S.err = String(e.message || e); }
  render();
}
function checkRow(c) {
  const cnt = c.count === null || c.count === undefined ? '' : `<span class="cnt ${esc(c.state)}">${num(c.count)}</span>`;
  const inner = `<div class="row"><span class="dot">${DOT[c.state] || '⚪'}</span><div><b>${esc(c.label_hi)}</b><small>${esc(c.detail)}</small></div>${cnt}</div>`;
  return `<div class="card">${c.link ? `<a href="${safeUrl(c.link)}" target="_blank" rel="noopener" style="color:inherit;text-decoration:none;display:block">${inner}</a>` : inner}</div>`;
}
function vOverview(st) {
  const h = HEAD[st.overall] || HEAD.warn;
  const order = { bad: 0, warn: 1, ok: 2 };
  const list = [...st.checks].sort((a, b) => order[a.state] - order[b.state]);
  return `<div class="banner ${esc(st.overall)}"><span class="big">${DOT[st.overall] || '⚪'}</span><div><b>${h[0]}</b><small>${h[1]}</small></div></div>${list.map(checkRow).join('')}`;
}
function spark(vals) {
  if (vals.length < 2) return '<p class="empty">अभी इतिहास कम है</p>';
  const W = 300, H = 60, max = Math.max(...vals), min = Math.min(...vals), r = Math.max(1, max - min);
  const pts = vals.map((v, i) => `${(i * W / (vals.length - 1)).toFixed(1)},${(H - 4 - (v - min) / r * (H - 8)).toFixed(1)}`).join(' ');
  return `<svg class="spark" viewBox="0 0 ${W} ${H}" preserveAspectRatio="none" role="img" aria-label="live सवालों का इतिहास"><polyline fill="none" stroke="var(--pri)" stroke-width="2" points="${pts}"/></svg>`;
}
function vQuestions(st) {
  const n = st.numbers || {}, by = n.by_exam || {};
  const rows = Object.keys(by).sort().map(k => `<tr><td>${esc(k)}</td><td>${num(by[k].published)}</td><td>${num(by[k].draft)}</td><td>${num(by[k].hidden)}</td></tr>`).join('');
  return `<div class="card"><div class="row"><div><b>कुल सवाल ${num(n.total)}</b><small>live ${num(n.published)} · draft ${num(n.draft)} · hidden ${num(n.hidden)}</small></div></div></div>
  <h2>Live सवाल (समय के साथ)</h2><div class="card">${spark(S.hist.map(x => x.published).filter(v => typeof v === 'number'))}</div>
  <h2>Exam के हिसाब से</h2><div class="card"><table><thead><tr><th>Exam</th><th>live</th><th>draft</th><th>hidden</th></tr></thead><tbody>${rows}</tbody></table></div>`;
}
function vRobots(st) {
  const wf = S.app.workflows || {}, repo = S.app.repo;
  if (!(st.robots || []).length) return '<p class="empty">अभी किसी robot का रिकॉर्ड नहीं</p>';
  return st.robots.map(r => {
    const p = RES[r.result] || ['none', r.result || 'कभी नहीं'];
    const link = wf[r.id] ? `https://github.com/${repo}/actions/workflows/${wf[r.id]}` : `https://github.com/${repo}/actions`;
    return `<div class="card"><div class="row"><div><b>${esc(r.label_hi)}</b><small>${esc(r.what_hi || '')} · ${ago(r.last_run)}</small></div><span class="cnt"><span class="pill ${p[0]}">${esc(p[1])}</span></span></div>
      <div style="margin-top:10px"><a class="btn line" href="${safeUrl(link)}" target="_blank" rel="noopener">खोलो / चलाओ</a></div></div>`;
  }).join('');
}
function vBackup(st) {
  const b = (st.checks || []).find(c => c.id === 'backup'), r = (st.checks || []).find(c => c.id === 'restore'), v = st.backup_verify;
  return `${b ? checkRow(b) : ''}${r ? checkRow(r) : '<p class="empty">Backup की वापसी-जाँच अभी नहीं हुई</p>'}
  ${v ? `<div class="card"><small>जाँच: slot ${num(v.slot)} · backup में ${num(v.backup_rows)} सवाल · live में गायब ${num(v.missing_in_live)} · backup के बाद बदले ${num(v.changed_since)}</small></div>` : ''}`;
}
const VIEWS = { overview: vOverview, questions: vQuestions, robots: vRobots, backup: vBackup };
function render() {
  document.querySelectorAll('#dock button').forEach(b => b.classList.toggle('on', b.dataset.go === S.route));
  const root = $('view');
  if (!S.status) { $('age').textContent = 'रिपोर्ट नहीं मिली'; root.innerHTML = `<div class="card"><b>⚠️ रिपोर्ट नहीं मिली</b><small>${esc(S.err)} — Health Robot एक बार चलना चाहिए (Actions → Health Robot → Run workflow)।</small></div>`; return; }
  const st = S.status, mins = (Date.now() - new Date(st.at)) / 60000;
  $('age').textContent = 'रिपोर्ट ' + ago(st.at);
  const stale = mins > 180 ? `<div class="stale">⏳ यह रिपोर्ट ${ago(st.at)} की है — पुरानी जानकारी को अभी की हालत न समझें।</div>` : '';
  try { root.innerHTML = stale + (VIEWS[S.route] || vOverview)(st); } catch (e) { root.innerHTML = `<div class="card"><b>यह हिस्सा नहीं खुला</b><small>${esc(e.message)}</small></div>`; }
}
document.getElementById('dock').addEventListener('click', e => { const b = e.target.closest('button[data-go]'); if (!b) return; S.route = b.dataset.go; render(); window.scrollTo(0, 0); });
$('reload').addEventListener('click', load);
loadApps().then(load);
