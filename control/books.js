/* Control Room · Review → 📚 किताब: owner gate for chapter cores (migration 0176).
   The owner reads the core exactly as students will (rendered by tools/book/render.js, switchable between styles),
   sees code checks re-run right here in the browser, then decides: ✅ approve · ✏️ changes · ❌ reject · ⏸ unpublish · ↩ roll back.
   Opened from review.js (Review tab, "📚 किताब" button); uses its rpc() and the same owner code. */
'use strict';
window.BOOKS = (() => {
  const B = { list: null, open: null, doc: null, style: 'saral', html: '', recheck: null, versions: null, msg: null, err: '', arm: '', busy: false, lib: null };
  let X = null;   // { rpc, code, back } from review.js

  async function lib() {
    if (!B.lib) {
      const [r, c, s] = await Promise.all([import('../tools/book/render.js'), import('../tools/book/check.js'), import('../tools/book/styles.js')]);
      B.lib = { render: r.render, checkCore: c.checkCore, STYLES: s.STYLES };
    }
    return B.lib;
  }
  async function loadList() {
    try { const d = await X.rpc('core_review_list', { p_code: X.code() }); B.list = Array.isArray(d) ? d : []; B.err = ''; }
    catch (e) { B.list = []; B.err = /migration/.test(e.message) ? 'Server पर migration 0176 अभी नहीं लगी' : e.message; }
  }
  async function openCore(id) {
    B.open = id; B.doc = null; B.versions = null; B.msg = null; B.arm = ''; B.html = ''; B.recheck = null;
    try { B.doc = await X.rpc('core_review_get', { p_code: X.code(), p_core: id }); } catch (e) { B.msg = ['bad', e.message]; }
    await paint();
  }
  async function paint() {
    if (!B.doc || !B.doc.data) return;
    try {
      const L = await lib();
      B.recheck = L.checkCore(B.doc.data);
      B.html = B.recheck.errs.length ? '' : L.render(B.doc.data, B.style);
    } catch (e) { B.msg = ['bad', 'पन्ना नहीं बना: ' + e.message]; }
  }

  const statusPill = s => s === 'draft' ? ['warn', 'जाँच बाकी'] : s === 'approved' ? ['ok', 'live'] : ['bad', 'रुका'];
  function chips(c, re) {
    c = c || {}; const out = [], st = c.stats || {};
    if (re) out.push(re.errs.length ? `<span class="pill bad">✕ ${re.errs.length} गलती</span>` : '<span class="pill ok">✓ उत्तर दोबारा गणना से सही</span>');
    else if ((c.errors || []).length) out.push(`<span class="pill bad">✕ ${c.errors.length} गलती</span>`);
    if (st.sections) out.push(`<span class="pill none">${esc(st.sections)} खंड · ${esc(st.examples)} उदाहरण · ${esc(st.figures)} चित्र</span>`);
    const w = re ? re.warn : (c.warnings || []);
    if (w.length) out.push(`<span class="pill warn">${w.length} चेतावनी</span>`);
    if (c.owner) out.push(`<span class="pill none">आप: ${esc(c.owner.decision)}</span>`);
    return `<div class="chips">${out.join('')}</div>`;
  }
  function listHtml() {
    const head = `<div class="btns" style="margin-top:0"><button class="btn line" id="bkBack">← Review</button></div>
      <div class="card"><b>📚 किताब · अध्याय-core</b><small>एक core से सारी शैलियाँ बनती हैं। ✅ करने पर ही छात्र इसे पढ़ेंगे।</small></div>`;
    if (B.err) return head + `<div class="msg bad">${esc(B.err)}</div>`;
    if (!B.list.length) return head + '<p class="empty">अभी कोई core नहीं</p>';
    const order = { draft: 0, rejected: 1, approved: 2 };
    return head + [...B.list].sort((a, b) => order[a.status] - order[b.status]).map(c => {
      const p = statusPill(c.status);
      return `<button class="card rv-row" data-core="${esc(c.core_id)}"><div class="row"><div><b>अध्याय ${esc(c.no)} · ${esc(c.title_hi)}</b>
        <small>${esc(c.qual)} · ${esc(c.subject)} · ${esc(c.model || '')} · ${ago(c.updated_at)}</small></div>
        <span class="cnt"><span class="pill ${p[0]}">${esc(p[1])}</span></span></div>${chips(c.checks)}</button>`;
    }).join('');
  }
  function actionsHtml(status, scope) {
    const b = (act, lab, cls) => {
      const armed = B.arm === scope + ':' + act;
      return `<button class="btn ${cls}${armed ? ' armed' : ''}" data-bact="${act}" data-scope="${scope}">${armed ? 'पक्का? फिर दबाओ' : lab}</button>`;
    };
    const ok = !(B.recheck && B.recheck.errs.length);
    const btns = status === 'draft' ? [ok ? b('approve', '✅ Approve', 'ok') : '', b('changes', '✏️ बदलाव माँगो', 'line'), b('reject', '❌ Reject', 'line bad')]
      : status === 'approved' ? [b('unpublish', '⏸ Live से हटाओ', 'line bad'), b('changes', '✏️ बदलाव माँगो', 'line')]
      : [b('changes', '✏️ दोबारा लिखवाओ (टिप्पणी के साथ)', 'line')];
    return `<label class="field"><span>टिप्पणी (बदलाव माँगने पर ज़रूरी)</span><textarea id="bkNote-${scope}" maxlength="1500"></textarea></label><div class="btns">${btns.join('')}</div>`;
  }
  function versionsHtml() {
    if (B.versions === null) return `<div class="btns"><button class="btn line" id="bkVers">🕘 पुराने versions देखो</button></div>`;
    if (!B.versions.length) return '<p class="empty">अभी कोई पुराना version नहीं</p>';
    return `<h2>🕘 पुराने versions</h2>` + B.versions.map(v => `<div class="card"><div class="row"><div><b>#${esc(v.id)} · ${esc(v.status)}</b><small>${ago(v.saved_at)} बदला · ${esc(v.model || '')}${v.owner ? ' · आप: ' + esc(v.owner.decision) : ''}</small></div></div>
      <div class="btns"><button class="btn line${B.arm === 'v:' + v.id ? ' armed' : ''}" data-broll="${esc(v.id)}">${B.arm === 'v:' + v.id ? 'पक्का? फिर दबाओ' : '↩ इसे वापस लाओ (draft बनकर)'}</button></div></div>`).join('');
  }
  function detailHtml() {
    const msg = B.msg ? `<div class="msg ${B.msg[0]}">${esc(B.msg[1])}</div>` : '';
    const head = `<div class="btns" style="margin-top:0"><button class="btn line" id="bkList">← किताब सूची</button></div>`;
    if (!B.doc) return head + msg;
    const d = B.doc, data = d.data || {}, p = statusPill(d.status), re = B.recheck;
    const styles = B.lib ? Object.entries(B.lib.STYLES) : [];
    const errs = re && (re.errs.length || re.warn.length)
      ? `<ul class="bad-list">${re.errs.map(x => `<li>✕ ${esc(x)}</li>`).join('')}${re.warn.map(x => `<li>⚠ ${esc(x)}</li>`).join('')}</ul>` : '';
    return `${head}${msg}<div class="card"><div class="row"><div><b>अध्याय ${esc(data.no)} · ${esc(data.title_hi)}</b><small>${esc(d.core_id)} · ${esc(d.model || '')} · ${ago(d.updated_at)}</small></div>
      <span class="cnt"><span class="pill ${p[0]}">${esc(p[1])}</span></span></div>${chips(d.checks, re)}${errs}
      <small>जाँच अभी इसी फ़ोन पर दोबारा चली: हर उदाहरण और आंकिक का उत्तर फिर से गणना करके मिलाया।</small></div>
      <div class="seg" role="tablist">${styles.map(([k, s]) => `<button role="tab" data-bstyle="${k}" class="${k === B.style ? 'on' : ''}" aria-selected="${k === B.style}">${esc(s.icon + ' ' + s.name)}</button>`).join('')}</div>
      ${B.html ? `<iframe id="bkFrame" class="bk-frame" title="अध्याय का पन्ना" sandbox="allow-same-origin"></iframe>` : '<p class="empty">गलतियाँ ठीक होने तक पन्ना नहीं बनेगा</p>'}
      <div class="card"><b>फ़ैसला</b><small>✅ एक core approve करने पर उसकी सारी शैलियाँ छात्रों को दिखेंगी।</small>${actionsHtml(d.status, 'core')}</div>${versionsHtml()}`;
  }

  function draw(root) {
    if (B.open) root.innerHTML = detailHtml();
    else if (!B.list) root.innerHTML = '<p class="empty">लोड हो रहा है…</p>';
    else root.innerHTML = listHtml();
    bind(root);
  }
  function bind(root) {
    const f = $('bkFrame');
    if (f) {
      f.srcdoc = B.html;
      f.onload = () => { try { f.style.height = f.contentDocument.documentElement.scrollHeight + 'px'; } catch (_) { f.style.height = '80vh'; } };
    }
    const back = $('bkBack'); if (back) back.onclick = () => { B.open = null; X.back(); };
    const toList = $('bkList'); if (toList) toList.onclick = async () => { B.open = null; B.msg = null; B.arm = ''; root.innerHTML = '<p class="empty">लोड हो रहा है…</p>'; await loadList(); draw(root); };
    root.querySelectorAll('[data-core]').forEach(b => b.onclick = async () => { root.innerHTML = '<p class="empty">खुल रहा है…</p>'; await openCore(b.dataset.core); draw(root); window.scrollTo(0, 0); });
    root.querySelectorAll('[data-bstyle]').forEach(b => b.onclick = async () => { B.style = b.dataset.bstyle; await paint(); draw(root); });
    const vers = $('bkVers'); if (vers) vers.onclick = async () => {
      try { B.versions = await X.rpc('core_versions_list', { p_code: X.code(), p_core: B.open }) || []; } catch (e) { B.msg = ['bad', e.message]; } draw(root); };
    root.querySelectorAll('[data-broll]').forEach(b => b.onclick = async () => {
      const id = b.dataset.broll;
      if (B.arm !== 'v:' + id) { B.arm = 'v:' + id; draw(root); return; }
      B.arm = ''; let m;
      try { const r = await X.rpc('core_rollback', { p_code: X.code(), p_version: Number(id) }); m = r === 'ok' ? ['ok', `Version #${id} वापस आया — अब यह draft है`] : ['bad', 'नहीं हुआ: ' + r]; }
      catch (e) { m = ['bad', e.message]; }
      await openCore(B.open); B.msg = m; draw(root); });
    root.querySelectorAll('[data-bact]').forEach(b => b.onclick = async () => {
      const act = b.dataset.bact, scope = b.dataset.scope, armKey = scope + ':' + act;
      const noteEl = $('bkNote-' + scope); const note = noteEl ? noteEl.value.trim() : '';
      if (act === 'changes' && note.length < 5) { B.msg = ['bad', 'बदलाव लिखो (कम से कम 5 अक्षर)']; draw(root); return; }
      if (act !== 'approve' && act !== 'changes' && B.arm !== armKey) { B.arm = armKey; draw(root); const n2 = $('bkNote-' + scope); if (n2) n2.value = note; return; }
      B.arm = ''; if (B.busy) return; B.busy = true;
      try {
        const r = await X.rpc('core_decide', { p_code: X.code(), p_core: B.open, p_decision: act, p_note: note || null });
        const done = { approve: '✅ Approved — अब छात्र यह अध्याय सारी शैलियों में पढ़ेंगे', changes: '✏️ वापस भेजा — अगली बार आपकी टिप्पणी के साथ लिखा जाएगा', reject: '❌ Rejected', unpublish: '⏸ Live से हटाया — फिर से जाँच सूची में' }[act];
        B.msg = r === 'ok' ? ['ok', done] : ['bad', 'नहीं हुआ: ' + ({ has_errors: 'जाँच में गलतियाँ हैं', not_draft: 'यह draft नहीं है' }[r] || r)];
      } catch (e) { B.msg = ['bad', e.message]; }
      B.busy = false; const m = B.msg; await openCore(B.open); B.msg = m; draw(root);
    });
  }
  async function render(root, ctx) {
    X = ctx;
    draw(root);
    if (!B.list) { await loadList(); draw(root); }
  }
  return { render };
})();
