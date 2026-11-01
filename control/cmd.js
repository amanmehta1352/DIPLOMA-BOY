/* Control Room · Command tab. Owner sends a command -> mtb.robot_commands -> Dispatcher robot starts it (within ~15 min).
   Needs the owner's review code (the same one used for draft review). The code stays on this phone only. No other secret here. */
'use strict';
window.CMD = (() => {
  const CODE_KEY = 'cr_owner_code';
  const ST = { queued: ['warn', '⏳ कतार में'], running: ['warn', '⚙️ चल रहा'], done: ['ok', '✓ पूरा'], failed: ['bad', '✕ fail'], cancelled: ['none', 'रद्द'] };
  const FALLBACK_ROBOTS = { health: { label_hi: '🩺 Health रिपोर्ट', inputs: {} } };
  const C = { robots: null, levels: [], list: null, msg: null, busy: false, robot: 'solver', err: '' };
  const store = {
    get() { try { return localStorage.getItem(CODE_KEY) || ''; } catch (_) { return C.mem || ''; } },
    set(v) { C.mem = v; try { v ? localStorage.setItem(CODE_KEY, v) : localStorage.removeItem(CODE_KEY); } catch (_) { /* memory only */ } },
  };
  const cfg = () => (S.app && S.app.commands) || null;

  async function rpc(fn, args) {
    const c = cfg(); if (!c) throw new Error('इस ऐप में Command चालू नहीं');
    const r = await fetch(c.rpc_base + fn, { method: 'POST', headers: { apikey: c.key, Authorization: 'Bearer ' + c.key, 'Content-Profile': c.schema, 'Accept-Profile': c.schema, 'Content-Type': 'application/json' }, body: JSON.stringify(args) });
    const t = await r.text(); let d = null; try { d = t ? JSON.parse(t) : null; } catch (_) { d = t; }
    if (!r.ok) { const m = (d && d.message) || ('HTTP ' + r.status); throw new Error(m === 'bad code' ? 'Code गलत है' : m === 'queue full' ? 'कतार भरी है (20) — पहले वाली commands पूरी होने दो' : m); }
    return d;
  }
  async function loadMeta() {
    if (C.robots) return;
    try { C.robots = (await getJson('../robots/dispatcher/robots.json')).robots; } catch (_) { C.robots = FALLBACK_ROBOTS; }
    try { C.levels = await getJson('../robots/writer/levels.json'); } catch (_) { C.levels = []; }
    if (!C.robots[C.robot]) C.robot = Object.keys(C.robots)[0];
  }
  async function loadList() {
    try { C.list = await rpc('cmd_list', { p_code: store.get(), p_limit: 30 }); C.err = ''; }
    catch (e) { C.list = []; C.err = e.message; if (/गलत/.test(e.message)) store.set(''); }
    try { const d = await rpc('draft_review_list', { p_code: store.get() }); C.drafts = Array.isArray(d) ? d : null; C.draftErr = Array.isArray(d) ? '' : 'review list का जवाब समझ नहीं आया'; } catch (e) { C.drafts = null; C.draftErr = e.message; }
  }
  function daySample(arr, n) {          // the same 5 approved chapters all day, new ones tomorrow
    const seed = Math.floor(Date.now() / 86400000);
    const h = d => (Math.imul((d.chapter_id * 31 + d.level_id.length) ^ seed, 2654435761) >>> 0);
    return [...arr].sort((a, b) => h(a) - h(b)).slice(0, n);
  }
  function reviewHtml() {
    if (!C.drafts) return C.draftErr ? `<h2>Review queue</h2><div class="msg bad">Review list नहीं खुली: ${esc(C.draftErr)}</div>` : '';
    const held = C.drafts.filter(d => d.status !== 'approved');
    const ok = C.drafts.filter(d => d.status === 'approved');
    const why = d => { const c = d.checks || {}; return (c.problems && c.problems.length ? c.problems.join('; ') : c.error || ''); };
    const row = (d, tag) => `<div class="card"><div class="row"><div><b>${esc(d.level_id)} · chapter ${esc(d.chapter_id)}</b><small>${esc(d.model || '')}${why(d) ? ' · ' + esc(why(d)) : ''}</small></div><span class="cnt"><span class="pill ${tag[0]}">${esc(tag[1])}</span></span></div></div>`;
    return `<h2>Review queue</h2><div class="card"><small>सिर्फ़ रुके हुए drafts और आज के 5 approved नमूने। approved ${ok.length} · रुके ${held.length}</small></div>
      ${held.length ? held.map(d => row(d, d.status === 'rejected' ? ['bad', 'रुका'] : ['warn', 'जाँच'])).join('') : '<p class="empty">कोई draft नहीं रुका</p>'}
      <h2>आज के 5 नमूने (approved)</h2>${daySample(ok, 5).map(d => row(d, ['ok', 'approved'])).join('') || '<p class="empty">अभी कोई approved नहीं</p>'}`;
  }

  function inputHtml(k, s) {
    const id = 'ci_' + k, lab = { count: 'कितने', level: 'Level', only: 'सिर्फ़ ये chapter id (comma से)', chapter: 'Chapter id (0 = सब)', redo: 'पुराने draft दोबारा लिखो', dry_run: 'सिर्फ़ अभ्यास (server पर कुछ नहीं लिखेगा)' }[k] || k;
    if (s.type === 'bool') return `<label class="check"><input type="checkbox" id="${id}" ${s.default ? 'checked' : ''}><span>${esc(lab)}</span></label>`;
    if (s.type === 'int') return `<label class="field"><span>${esc(lab)}${s.max ? ` (${s.min}–${s.max})` : ''}</span><input type="number" inputmode="numeric" id="${id}" value="${esc(s.default)}" min="${esc(s.min)}" max="${esc(s.max)}"></label>`;
    if (k === 'level' && C.levels.length) return `<label class="field"><span>${esc(lab)}</span><select id="${id}">${C.levels.map(l => `<option value="${esc(l.id)}" ${l.id === s.default ? 'selected' : ''}>${esc(l.hi)}</option>`).join('')}</select></label>`;
    return `<label class="field"><span>${esc(lab)}</span><input type="text" id="${id}" value="${esc(s.default)}" autocomplete="off"></label>`;
  }
  function readArgs(spec) {
    const a = {};
    for (const [k, s] of Object.entries(spec.inputs || {})) {
      const el = $('ci_' + k); if (!el) continue;
      a[k] = s.type === 'bool' ? el.checked : s.type === 'int' ? Number(el.value) : el.value.trim();
    }
    return a;
  }
  function cmdCard(c) {
    const p = ST[c.status] || ['none', c.status];
    const r = (C.robots && C.robots[c.robot]) || {};
    const args = Object.entries(c.args || {}).map(([k, v]) => `${k}=${v}`).join(' · ');
    const when = c.finished_at ? 'पूरा ' + ago(c.finished_at) : c.dispatched_at ? 'शुरू ' + ago(c.dispatched_at) : 'भेजा ' + ago(c.created_at);
    return `<div class="card"><div class="row"><div><b>#${esc(c.id)} ${esc(r.label_hi || c.robot)}</b><small>${esc(when)}${args ? ' · ' + esc(args) : ''}${c.note ? ' · ' + esc(c.note) : ''}</small>
      ${c.error ? `<small style="color:var(--bad)">${esc(c.error)}</small>` : ''}</div><span class="cnt"><span class="pill ${p[0]}">${esc(p[1])}</span></span></div>
      ${c.report ? `<details class="rep"><summary>📄 रिपोर्ट पढ़ो</summary><pre>${esc(c.report)}</pre></details>` : ''}
      <div class="btns">${c.run_url ? `<a class="btn line" href="${safeUrl(c.run_url)}" target="_blank" rel="noopener">GitHub पर देखो</a>` : ''}
      ${c.status === 'queued' ? `<button class="btn line" data-cancel="${esc(c.id)}">रद्द करो</button>` : ''}</div></div>`;
  }
  function draw(root) {
    if (!cfg()) { root.innerHTML = '<p class="empty">इस ऐप में Command चालू नहीं है</p>'; return; }
    const msg = C.msg ? `<div class="msg ${C.msg[0]}">${esc(C.msg[1])}</div>` : '';
    if (!store.get()) {
      root.innerHTML = `${msg}<div class="card"><b>🔐 Owner code डालो</b><small>वही code जो draft देखने में लगता है। यह सिर्फ़ इसी फ़ोन में रहेगा।</small>
        <label class="field" style="margin-top:10px"><span>Code</span><input type="password" id="cCode" autocomplete="current-password"></label>
        <button class="btn" id="cLogin">खोलो</button></div>`;
      $('cLogin').onclick = async () => { store.set($('cCode').value.trim()); C.msg = null; await loadMeta(); await loadList(); if (C.err) C.msg = ['bad', C.err]; draw(root); };
      return;
    }
    if (!C.robots || !C.list) { root.innerHTML = '<p class="empty">लोड हो रहा है…</p>'; return; }
    const spec = C.robots[C.robot] || { inputs: {} };
    root.innerHTML = `${msg}<div class="card"><b>📨 नई command</b><small>भेजने के ~15 मिनट में robot शुरू होगा। नतीजा नीचे दिखेगा।</small>
      <label class="field" style="margin-top:10px"><span>कौन सा robot</span><select id="cRobot">${Object.entries(C.robots).map(([k, r]) => `<option value="${esc(k)}" ${k === C.robot ? 'selected' : ''}>${esc(r.label_hi)}</option>`).join('')}</select></label>
      ${Object.entries(spec.inputs || {}).map(([k, s]) => inputHtml(k, s)).join('')}
      <label class="field"><span>नोट (अपने लिए, ज़रूरी नहीं)</span><textarea id="cNote" maxlength="500"></textarea></label>
      <div class="btns"><button class="btn" id="cSend" ${C.busy ? 'disabled' : ''}>भेजो</button><button class="btn line" id="cRefresh">⟳ ताज़ा</button><button class="btn line" id="cOut">Code हटाओ</button></div></div>
      <h2>हाल की commands</h2>${C.err ? `<div class="msg bad">${esc(C.err)}</div>` : ''}${C.list.length ? C.list.map(cmdCard).join('') : '<p class="empty">अभी कोई command नहीं</p>'}
      ${reviewHtml()}`;
    $('cRobot').onchange = e => { C.robot = e.target.value; C.msg = null; draw(root); };
    $('cRefresh').onclick = async () => { C.msg = null; await loadList(); draw(root); };
    $('cOut').onclick = () => { store.set(''); C.list = null; C.msg = null; draw(root); };
    $('cSend').onclick = async () => {
      const args = readArgs(spec), note = $('cNote') ? $('cNote').value.trim() || null : null;   // read before the form is redrawn
      C.busy = true; $('cSend').disabled = true;
      try {
        const id = await rpc('cmd_submit', { p_code: store.get(), p_robot: C.robot, p_args: args, p_note: note });
        C.msg = ['ok', `Command #${id} कतार में है — ~15 मिनट में शुरू होगी।`];
      } catch (e) { C.msg = ['bad', e.message]; }
      C.busy = false; await loadList(); draw(root);
    };
    root.querySelectorAll('[data-cancel]').forEach(b => b.onclick = async () => {
      try { await rpc('cmd_cancel', { p_code: store.get(), p_id: Number(b.dataset.cancel) }); C.msg = ['ok', 'रद्द कर दिया']; } catch (e) { C.msg = ['bad', e.message]; }
      await loadList(); draw(root);
    });
  }
  async function render(root) {
    draw(root);
    if (store.get() && (!C.robots || !C.list)) { await loadMeta(); await loadList(); if (S.route === 'command') draw(root); }
    else if (!C.robots) { loadMeta(); }
  }
  return { render };
})();
