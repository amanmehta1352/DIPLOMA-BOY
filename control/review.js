/* Control Room · Review tab (owner quality gate, migration 0173).
   Robots only write drafts. Here the owner reads each draft as colour-coded blocks and decides:
   ✅ approve (students see it) · ✏️ changes (note goes back to the Writer) · ❌ reject · ⏸ unpublish · ↩ roll back to an older copy.
   Uses the same owner review code as the Command tab (kept on this phone only). No other secret here. */
'use strict';
window.REV = (() => {
  const CODE_KEY = 'cr_owner_code';
  const R = { list: null, sols: null, names: null, filter: 'wait', open: null, doc: null, items: null, versions: null, msg: null, err: '', busy: false, arm: '' };
  const store = {
    get() { try { return localStorage.getItem(CODE_KEY) || ''; } catch (_) { return R.mem || ''; } },
    set(v) { R.mem = v; try { v ? localStorage.setItem(CODE_KEY, v) : localStorage.removeItem(CODE_KEY); } catch (_) { /* memory only */ } },
  };
  const cfg = () => (S.app && S.app.commands) || null;
  const br = s => esc(s).replace(/\n/g, '<br>');
  const key = d => d.level_id + '|' + d.chapter_id;
  const isAuto = d => d.status === 'approved' && d.checks && d.checks.auto_approved_at && !d.checks.owner;

  async function rpc(fn, args) {
    const c = cfg(); if (!c) throw new Error('इस ऐप में Review चालू नहीं');
    const r = await fetch(c.rpc_base + fn, { method: 'POST', headers: { apikey: c.key, Authorization: 'Bearer ' + c.key, 'Content-Profile': c.schema, 'Accept-Profile': c.schema, 'Content-Type': 'application/json' }, body: JSON.stringify(args) });
    const t = await r.text(); let d = null; try { d = t ? JSON.parse(t) : null; } catch (_) { d = t; }
    if (!r.ok) {
      const m = (d && d.message) || ('HTTP ' + r.status);
      const hi = { 'bad code': 'Code गलत है', 'note needed': 'बदलाव लिखो (कम से कम 5 अक्षर)', 'bad decision': 'फ़ैसला समझ नहीं आया' }[m];
      throw new Error(hi || (/Could not find the function/.test(m) ? 'Server पर migration 0173 अभी नहीं लगी' : m));
    }
    return d;
  }
  async function loadNames() {
    if (R.names) return;
    R.names = {};
    try { (await getJson('../robots/writer/chapters.json')).forEach(c => { R.names[c.l + '|' + c.c] = { h: c.h, s: c.s }; }); } catch (_) { /* titles optional */ }
  }
  async function loadList() {
    try { const d = await rpc('draft_review_list', { p_code: store.get() }); R.list = Array.isArray(d) ? d : []; R.err = ''; }
    catch (e) { R.list = []; R.err = e.message; if (/गलत/.test(e.message)) store.set(''); }
    try { const s = await rpc('solution_review_list', { p_code: store.get() }); R.sols = Array.isArray(s) ? s : []; } catch (_) { R.sols = null; }
  }
  async function openDoc(level, chapter) {
    R.open = { level_id: level, chapter_id: chapter }; R.doc = null; R.items = null; R.versions = null; R.msg = null; R.arm = '';
    try { R.doc = await rpc('draft_review_get', { p_level: level, p_chapter: chapter, p_code: store.get() }); } catch (e) { R.msg = ['bad', e.message]; }
    try { const it = await rpc('solution_review_get', { p_level: level, p_chapter: chapter, p_code: store.get() }); R.items = Array.isArray(it) ? it : []; } catch (_) { R.items = null; }
  }

  // ---------- list ----------
  const FILTERS = [
    ['wait', '🟡 जाँच बाकी', d => d.status === 'draft'],
    ['auto', '🟠 Auto से live', isAuto],
    ['live', '🟢 Live', d => d.status === 'approved'],
    ['stop', '🔴 रुके', d => d.status === 'rejected'],
  ];
  function checkChips(c) {
    c = c || {};
    const out = [];
    const p = c.problems || [];
    out.push(p.length ? `<span class="pill bad">✕ ${p.length} समस्या</span>` : (c.error ? '<span class="pill bad">✕ error</span>' : '<span class="pill ok">✓ code checks</span>'));
    const so = c.second_opinion;
    if (so && Array.isArray(so.disagree)) out.push(`<span class="pill ${so.disagree.length ? 'warn' : 'ok'}">दूसरी AI: ${so.disagree.length ? so.disagree.length + ' असहमत' : 'सहमत'}</span>`);
    if (typeof c.copyright_overlap === 'number') out.push(`<span class="pill ${c.copyright_overlap > 0.2 ? 'bad' : 'none'}">नकल ${(c.copyright_overlap * 100).toFixed(1)}%</span>`);
    if (c.owner) out.push(`<span class="pill none">आप: ${esc(c.owner.decision)}</span>`);
    return `<div class="chips">${out.join('')}</div>`;
  }
  function rowHtml(d) {
    const n = R.names[key(d)] || {};
    const pill = d.status === 'draft' ? ['warn', 'जाँच बाकी'] : isAuto(d) ? ['warn', 'auto live'] : d.status === 'approved' ? ['ok', 'live'] : ['bad', 'रुका'];
    return `<button class="card rv-row" data-open="${esc(key(d))}"><div class="row"><div><b>${esc(n.h || ('chapter ' + d.chapter_id))}</b>
      <small>${esc(n.s || '')} · ${esc(d.level_id)} · #${esc(d.chapter_id)} · ${esc(d.model || '')} · ${ago(d.updated_at)}</small></div>
      <span class="cnt"><span class="pill ${pill[0]}">${esc(pill[1])}</span></span></div>${checkChips(d.checks)}</button>`;
  }
  function listHtml() {
    const counts = Object.fromEntries(FILTERS.map(([k, , f]) => [k, R.list.filter(f).length]));
    const f = (FILTERS.find(x => x[0] === R.filter) || FILTERS[0])[2];
    const rows = R.list.filter(f).sort((a, b) => (a.checks && a.checks.problems && a.checks.problems.length ? 1 : 0) - (b.checks && b.checks.problems && b.checks.problems.length ? 1 : 0));
    const solWait = (R.sols || []).filter(s => s.draft > 0 || s.auto > 0);
    const sol = R.sols === null ? '' : `<h2>✍️ हल (Solver)</h2>${solWait.length ? solWait.map(s => { const n = R.names[key(s)] || {};
      return `<button class="card rv-row" data-open="${esc(key(s))}"><div class="row"><div><b>${esc(n.h || ('chapter ' + s.chapter_id))}</b><small>${esc(s.level_id)} · #${esc(s.chapter_id)}</small></div>
      <span class="cnt">${s.draft ? `<span class="pill warn">${esc(s.draft)} जाँच</span>` : ''}${s.auto ? ` <span class="pill warn">${esc(s.auto)} auto</span>` : ''}</span></div></button>`; }).join('') : '<p class="empty">कोई हल जाँच के लिए नहीं</p>'}`;
    return `<div class="card"><div class="row"><div><b>✅ Review · आपकी मंज़ूरी</b><small>Robot सिर्फ़ draft लिखते हैं। छात्र वही पढ़ते हैं जिसे आप ✅ करें।</small></div></div></div>
      <div class="seg" role="tablist">${FILTERS.map(([k, lab]) => `<button role="tab" data-filter="${k}" class="${k === R.filter ? 'on' : ''}" aria-selected="${k === R.filter}">${esc(lab)} <b>${counts[k]}</b></button>`).join('')}${window.BOOKS ? '<button role="tab" data-filter="books" aria-selected="false">📚 किताब</button>' : ''}</div>
      ${R.filter === 'auto' && counts.auto ? '<div class="stale">ये chapters पहले robot ने खुद live किए थे। हर एक खोलकर ✅ रखो या ⏸ हटाओ।</div>' : ''}
      ${rows.length ? rows.map(rowHtml).join('') : '<p class="empty">इस सूची में कुछ नहीं</p>'}${sol}`;
  }

  // ---------- one draft as colour-coded blocks ----------
  const blk = (kind, title, inner) => `<section class="blk ${kind}"><h3>${title}</h3>${inner}</section>`;
  const ul = arr => `<ul>${(arr || []).map(x => `<li>${br(x)}</li>`).join('')}</ul>`;
  function tableHtml(t) {
    if (!Array.isArray(t) || !t.length) return '';
    const [h, ...rows] = t;
    return `<div class="tw"><table><thead><tr>${(h || []).map(x => `<th>${esc(x)}</th>`).join('')}</tr></thead><tbody>${rows.map(r => `<tr>${(r || []).map(x => `<td>${esc(x)}</td>`).join('')}</tr>`).join('')}</tbody></table></div>`;
  }
  function docHtml(data) {
    if (!data || typeof data !== 'object') return '<p class="empty">इस draft में सामग्री नहीं</p>';
    const out = [];
    (data.notes || []).forEach(n => out.push(blk('blue', '📘 ' + esc(n.title || 'नोट'), ul(n.points) + tableHtml(n.table))));
    (data.teach || []).forEach(t => out.push(blk('purple', '🧑‍🏫 ' + esc(t.heading || 'पाठ'), `<p>${br(t.explain)}</p>${t.example ? `<p class="ex">${br(t.example)}</p>` : ''}`)));
    if ((data.formulas || []).length) out.push(blk('yellow', '✳️ सूत्र', (data.formulas || []).map(f => `<div class="fm"><b>${esc(f.title)}</b><code>${esc(f.formula)}</code><small>${esc(f.units || '')}${f.note ? ' · ' + esc(f.note) : ''}</small></div>`).join('')));
    (data.solved || []).forEach((s, i) => out.push(blk('orange', `⚙️ हल किया उदाहरण ${i + 1}`, `<p><b>${br(s.question)}</b></p><ol>${(s.steps || []).map(x => `<li>${br(x)}</li>`).join('')}</ol><p class="ans">उत्तर: ${esc(s.answer)}</p>`)));
    if ((data.practice || []).length) out.push(blk('red', '📝 अभ्यास (सही option हरा)', (data.practice || []).map((p, i) => `<div class="pq"><b>${i + 1}. ${br(p.q)}</b><ol type="a">${(p.options || []).map((o, j) => `<li class="${j === p.answer ? 'right' : ''}">${esc(o)}${j === p.answer ? ' ✓' : ''}</li>`).join('')}</ol>${p.explanation ? `<details><summary>हल</summary><p>${br(p.explanation)}</p></details>` : ''}</div>`).join('')));
    if ((data.mistakes || []).length) out.push(blk('red', '⚠️ आम गलतियाँ', ul(data.mistakes)));
    if ((data.revision || []).length) out.push(blk('green', '🔁 एक-लाइन revision', ul(data.revision)));
    return out.join('') || '<p class="empty">इस draft में पहचानी सामग्री नहीं</p>';
  }
  function problemsHtml(c) {
    c = c || {};
    const p = [...(c.problems || []), ...(c.error ? ['error: ' + c.error] : [])];
    const so = c.second_opinion;
    return `<div class="card"><b>🔍 जाँच</b>${checkChips(c)}
      ${p.length ? `<ul class="bad-list">${p.map(x => `<li>${esc(x)}</li>`).join('')}</ul>` : ''}
      ${so && so.model ? `<small>दूसरी AI: ${esc(so.model)}${Array.isArray(so.disagree) && so.disagree.length ? ' · असहमत सवाल: ' + so.disagree.map(i => i + 1).join(', ') : ''}</small>` : ''}
      ${c.held ? `<small>${esc(c.held)}</small>` : ''}${c.owner && c.owner.note ? `<small>आपकी पिछली टिप्पणी: ${esc(c.owner.note)}</small>` : ''}</div>`;
  }
  function actionsHtml(status, scope) {
    const b = (act, lab, cls) => {
      const armed = R.arm === scope + ':' + act;
      return `<button class="btn ${cls}${armed ? ' armed' : ''}" data-act="${act}" data-scope="${esc(scope)}">${armed ? 'पक्का? फिर दबाओ' : lab}</button>`;
    };
    const btns = status === 'draft' ? [b('approve', '✅ Approve', 'ok'), b('changes', '✏️ बदलाव माँगो', 'line'), b('reject', '❌ Reject', 'line bad')]
      : status === 'approved' ? [b('unpublish', '⏸ Live से हटाओ', 'line bad'), b('changes', '✏️ बदलाव माँगो', 'line')]
      : [b('changes', '✏️ दोबारा लिखवाओ (टिप्पणी के साथ)', 'line')];
    return `<label class="field"><span>टिप्पणी (बदलाव माँगने पर ज़रूरी — Writer इसे अगली बार मानेगा)</span><textarea id="rvNote-${esc(scope)}" maxlength="1500"></textarea></label><div class="btns">${btns.join('')}</div>`;
  }
  function itemsHtml() {
    if (R.items === null) return '';
    if (!R.items.length) return '';
    return `<h2>✍️ हल (Solver) · ${R.items.length}</h2>` + R.items.map(it => {
      const q = (it.data && it.data.q) || {}, m = ((it.data && it.data.methods) || [])[0] || {}, a = (m.answer && m.answer.value) ?? '';
      const so = (it.checks && it.checks.second_opinion) || {};
      const pill = it.status === 'draft' ? ['warn', 'जाँच बाकी'] : (it.checks && it.checks.auto_approved_at && !it.checks.owner) ? ['warn', 'auto live'] : ['ok', 'live'];
      return `<div class="card"><div class="row"><div><b>slot ${esc(it.slot)} · ${br(q.hi || q.en || '')}</b><small>उत्तर: ${esc(a)} · ${esc(it.model || '')}${so.model ? ' · दूसरी AI ' + (so.agree ? 'सहमत' : 'असहमत') : ''}</small></div>
        <span class="cnt"><span class="pill ${pill[0]}">${esc(pill[1])}</span></span></div>${actionsHtml(it.status, 'slot' + it.slot)}</div>`;
    }).join('');
  }
  function versionsHtml() {
    if (R.versions === null) return `<div class="btns"><button class="btn line" id="rvVers">🕘 पुराने versions देखो</button></div>`;
    if (!R.versions.length) return '<p class="empty">अभी कोई पुराना version नहीं (migration 0173 के बाद से बनते हैं)</p>';
    return `<h2>🕘 पुराने versions</h2>` + R.versions.map(v => `<div class="card"><div class="row"><div><b>#${esc(v.id)} · ${esc(v.status)}</b><small>${ago(v.saved_at)} बदला · ${esc(v.model || '')}${v.owner ? ' · आप: ' + esc(v.owner.decision) : ''}</small></div></div>
      <div class="btns"><button class="btn line${R.arm === 'v:' + v.id ? ' armed' : ''}" data-rollback="${esc(v.id)}">${R.arm === 'v:' + v.id ? 'पक्का? फिर दबाओ' : '↩ इसे वापस लाओ (draft बनकर)'}</button></div></div>`).join('');
  }
  function detailHtml() {
    const o = R.open, n = R.names[key(o)] || {};
    const msg = R.msg ? `<div class="msg ${R.msg[0]}">${esc(R.msg[1])}</div>` : '';
    const head = `<div class="btns" style="margin-top:0"><button class="btn line" id="rvBack">← सूची</button></div>
      <div class="card"><b>${esc(n.h || ('chapter ' + o.chapter_id))}</b><small>${esc(n.s || '')} · ${esc(o.level_id)} · #${esc(o.chapter_id)}</small></div>`;
    if (!R.doc) return head + msg + itemsHtml();
    const d = R.doc;
    const pill = d.status === 'draft' ? ['warn', 'जाँच बाकी'] : d.status === 'approved' ? ['ok', 'live'] : ['bad', 'रुका'];
    return `${head}${msg}<div class="card"><div class="row"><div><b>Chapter draft</b><small>${esc(d.model || '')} · ${ago(d.updated_at)}</small></div><span class="cnt"><span class="pill ${pill[0]}">${esc(pill[1])}</span></span></div>
      ${actionsHtml(d.status, 'ch')}</div>${problemsHtml(d.checks)}<div class="doc">${docHtml(d.data)}</div>
      <div class="card"><b>फ़ैसला</b>${actionsHtml(d.status, 'ch2')}</div>${itemsHtml()}${versionsHtml()}`;
  }

  // ---------- drawing + events ----------
  function draw(root) {
    if (!cfg()) { root.innerHTML = '<p class="empty">इस ऐप में Review चालू नहीं है</p>'; return; }
    if (!store.get()) {
      const msg = R.msg ? `<div class="msg ${R.msg[0]}">${esc(R.msg[1])}</div>` : '';
      root.innerHTML = `${msg}<div class="card"><b>🔐 Owner code डालो</b><small>वही code जो Command में लगता है। यह सिर्फ़ इसी फ़ोन में रहेगा।</small>
        <label class="field" style="margin-top:10px"><span>Code</span><input type="password" id="rvCode" autocomplete="current-password"></label>
        <button class="btn" id="rvLogin">खोलो</button></div>`;
      $('rvLogin').onclick = async () => { store.set($('rvCode').value.trim()); R.msg = null; root.innerHTML = '<p class="empty">लोड हो रहा है…</p>'; await loadNames(); await loadList(); if (R.err) R.msg = ['bad', R.err]; draw(root); };
      return;
    }
    if (R.filter === 'books' && window.BOOKS && !R.open) {   // chapter cores (control/books.js, migration 0176)
      window.BOOKS.render(root, { rpc, code: () => store.get(), back: () => { R.filter = 'wait'; draw(root); } });
      return;
    }
    if (!R.list) { root.innerHTML = '<p class="empty">लोड हो रहा है…</p>'; return; }
    if (R.err && !R.open) { root.innerHTML = `<div class="msg bad">${esc(R.err)}</div><div class="btns"><button class="btn line" id="rvRetry">⟳ फिर कोशिश</button></div>`; $('rvRetry').onclick = async () => { await loadList(); draw(root); }; return; }
    root.innerHTML = R.open ? detailHtml() : listHtml();
    bind(root);
  }
  function bind(root) {
    root.querySelectorAll('[data-filter]').forEach(b => b.onclick = () => { R.filter = b.dataset.filter; draw(root); });
    root.querySelectorAll('[data-open]').forEach(b => b.onclick = async () => {
      const [l, c] = b.dataset.open.split('|'); root.innerHTML = '<p class="empty">खुल रहा है…</p>'; await openDoc(l, Number(c)); draw(root); window.scrollTo(0, 0); });
    const back = $('rvBack'); if (back) back.onclick = async () => { R.open = null; R.msg = null; R.arm = ''; await loadList(); draw(root); };
    const vers = $('rvVers'); if (vers) vers.onclick = async () => {
      try { R.versions = await rpc('content_versions_list', { p_code: store.get(), p_kind: 'chapter', p_level: R.open.level_id, p_chapter: R.open.chapter_id, p_slot: null }) || []; }
      catch (e) { R.msg = ['bad', e.message]; } draw(root); };
    root.querySelectorAll('[data-rollback]').forEach(b => b.onclick = async () => {
      const id = b.dataset.rollback;
      if (R.arm !== 'v:' + id) { R.arm = 'v:' + id; draw(root); return; }
      R.arm = '';
      let m;
      try { const r = await rpc('content_rollback', { p_code: store.get(), p_version: Number(id) }); m = r === 'ok' ? ['ok', `Version #${id} वापस आया — अब यह draft है, ✅ करने पर live होगा`] : ['bad', 'नहीं हुआ: ' + r]; }
      catch (e) { m = ['bad', e.message]; }
      await openDoc(R.open.level_id, R.open.chapter_id); R.msg = m; draw(root); });
    root.querySelectorAll('[data-act]').forEach(b => b.onclick = async () => {
      const act = b.dataset.act, scope = b.dataset.scope, armKey = scope + ':' + act;
      const noteEl = $('rvNote-' + scope); const note = noteEl ? noteEl.value.trim() : '';
      if (act === 'changes' && note.length < 5) { R.msg = ['bad', 'बदलाव लिखो (कम से कम 5 अक्षर) — Writer इसी टिप्पणी से दोबारा लिखेगा']; draw(root); return; }
      if (act !== 'approve' && act !== 'changes' && R.arm !== armKey) { R.arm = armKey; draw(root); const n2 = $('rvNote-' + scope); if (n2) n2.value = note; return; }
      R.arm = ''; if (R.busy) return; R.busy = true;
      const o = R.open;
      try {
        const r = scope.startsWith('slot')
          ? await rpc('solution_decide', { p_code: store.get(), p_level: o.level_id, p_chapter: o.chapter_id, p_slot: Number(scope.slice(4)), p_decision: act, p_note: note || null })
          : await rpc('draft_decide', { p_code: store.get(), p_level: o.level_id, p_chapter: o.chapter_id, p_decision: act, p_note: note || null });
        const done = { approve: '✅ Approved — अब छात्र इसे देखेंगे', changes: '✏️ वापस भेजा — Writer अगली बार आपकी टिप्पणी के साथ लिखेगा', reject: '❌ Rejected — दोबारा अपने-आप नहीं लिखा जाएगा', unpublish: '⏸ Live से हटाया — फिर से जाँच सूची में' }[act];
        R.msg = r === 'ok' ? ['ok', done] : ['bad', 'नहीं हुआ: ' + r];
      } catch (e) { R.msg = ['bad', e.message]; }
      R.busy = false; const m = R.msg; await openDoc(o.level_id, o.chapter_id); R.msg = m; draw(root);
    });
  }
  async function render(root) {
    draw(root);
    if (store.get() && !R.list) { await loadNames(); await loadList(); if (S.route === 'review') draw(root); }
  }
  return { render };
})();
