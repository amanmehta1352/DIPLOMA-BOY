// PWA basics: manifest valid, icons exist with right sizes, head links present. Run: node tests/pwa.test.js
const fs = require('fs'); const path = require('path'); const root = path.resolve(__dirname, '..');
const m = JSON.parse(fs.readFileSync(path.join(root, 'manifest.webmanifest'), 'utf8'));
const html = fs.readFileSync(path.join(root, 'index.html'), 'utf8');
const bad = [];
if (m.display !== 'standalone') bad.push('display');
if (!m.name || !m.short_name) bad.push('names');
if (!/^#[0-9A-Fa-f]{6}$/.test(m.theme_color)) bad.push('theme');
for (const ic of m.icons) {
  const f = path.join(root, ic.src); if (!fs.existsSync(f)) { bad.push('missing ' + ic.src); continue; }
  const b = fs.readFileSync(f); const w = b.readUInt32BE(16), h = b.readUInt32BE(20);
  if (ic.sizes !== `${w}x${h}`) bad.push('size ' + ic.src + ' ' + w + 'x' + h);
}
if (!m.icons.some(i => i.sizes === '512x512')) bad.push('no 512');
if (!m.icons.some(i => i.purpose === 'maskable')) bad.push('no maskable');
for (const s of ['rel="manifest"', 'rel="apple-touch-icon"', 'name="description"']) if (!html.includes(s)) bad.push('html ' + s);
console.log(JSON.stringify({ icons: m.icons.length, bad }));
process.exit(bad.length ? 1 : 0);
