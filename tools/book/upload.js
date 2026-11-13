// Upload chapter cores as DRAFTS (owner must approve in Control Room → किताब).
// Usage (robots / CI, service key in env):  SUPABASE_URL=… SUPABASE_SERVICE_KEY=… node tools/book/upload.js <core.json>…
//        print SQL instead (owner runs it in the SQL editor):  node tools/book/upload.js --sql <core.json>
// Every file is checked first (tools/book/check.js); a file with errors is never uploaded.
import fs from 'node:fs';
import { checkCore } from './check.js';

const args = process.argv.slice(2), sql = args[0] === '--sql', files = sql ? args.slice(1) : args;
if (!files.length) { console.error('usage: node tools/book/upload.js [--sql] <core.json>…'); process.exit(2); }
const MODEL = process.env.CORE_MODEL || 'manual';
let bad = 0;
for (const f of files) {
  const core = JSON.parse(fs.readFileSync(f, 'utf8'));
  const r = checkCore(core);
  if (r.errs.length) { bad++; console.error(`SKIP ${f}: ${r.errs.length} error(s)`); r.errs.forEach(e => console.error('  ', e)); continue; }
  const checks = { code_checks: 'tools/book/check.js', stats: r.stats, warnings: r.warn, errors: [] };
  if (sql) {
    const q = s => `'${JSON.stringify(s).replace(/'/g, "''")}'`;
    console.log(`select set_config('request.jwt.claims', '{"role":"service_role"}', true);\nselect mtb.core_upsert(${q(core)}::jsonb, ${q(checks)}::jsonb, ${q(MODEL).replace(/^'"|"'$/g, "'")});`);
    continue;
  }
  const url = process.env.SUPABASE_URL, key = process.env.SUPABASE_SERVICE_KEY;
  if (!url || !key) { console.error('SUPABASE_URL / SUPABASE_SERVICE_KEY missing'); process.exit(2); }
  const res = await fetch(`${url}/rest/v1/rpc/core_upsert`, {
    method: 'POST',
    headers: { apikey: key, Authorization: `Bearer ${key}`, 'Content-Profile': 'mtb', 'Content-Type': 'application/json' },
    body: JSON.stringify({ p_data: core, p_checks: checks, p_model: MODEL })
  });
  const out = await res.text();
  console.log(f, res.status, out);
  if (!res.ok || !/ok|locked/.test(out)) bad++;
}
process.exit(bad ? 1 : 0);
