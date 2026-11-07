# -*- coding: utf-8 -*-
"""Figures for Class 10 Chemistry ch 1 (Chemical reactions and equations). White card SVGs, hi + en."""
import json
B, O, G, R, K, M, P = "#2563eb", "#e8730c", "#15803d", "#dc2626", "#16202f", "#5f6b80", "#7c3aed"
def head(h): return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 {h}" font-family="Noto Sans Devanagari, system-ui, sans-serif"><rect x="0" y="0" width="340" height="{h}" rx="14" fill="#ffffff"/>'
def tx(x, y, s, c=K, sz=12, a="middle", w=600): return f'<text x="{x}" y="{y}" fill="{c}" font-size="{sz}" text-anchor="{a}" font-weight="{w}">{s}</text>'
def ln(a, b, c, d, col=K, w=2, ex=""): return f'<line x1="{a}" y1="{b}" x2="{c}" y2="{d}" stroke="{col}" stroke-width="{w}" stroke-linecap="round" {ex}/>'
def arrow(x1, y, x2, col=K): return ln(x1, y, x2 - 6, y, col, 2.5) + f'<path d="M{x2},{y} l-9,-5 l0,10 z" fill="{col}"/>'
def tube(x, y, h, fill="#ffffff", lvl=0.55, liq="#dbeafe", w=30):
    # test tube: open top at y, rounded bottom
    top = y; bot = y + h
    s = f'<path d="M{x},{top} L{x},{bot-w/2} A{w/2},{w/2} 0 0 0 {x+w},{bot-w/2} L{x+w},{top}" fill="{fill}" stroke="{K}" stroke-width="2"/>'
    ly = top + h * (1 - lvl)
    s += f'<path d="M{x+1.5},{ly} L{x+1.5},{bot-w/2} A{w/2-1.5},{w/2-1.5} 0 0 0 {x+w-1.5},{bot-w/2} L{x+w-1.5},{ly} Z" fill="{liq}"/>'
    return s
def flame(x, y): return f'<path d="M{x},{y} q-10,-14 0,-30 q10,16 0,30 z" fill="#fb923c"/><path d="M{x},{y} q-5,-8 0,-16 q5,8 0,16 z" fill="#fde047"/>'
def T(hi, en, lg): return hi if lg == "hi" else en

def f_mg(lg):
    s = head(190)
    s += f'<rect x="30" y="70" width="70" height="8" rx="2" fill="#cbd5e1" stroke="{K}"/>' + tx(65, 62, T("मैग्नीशियम फीता", "magnesium ribbon", lg), M, 11)
    s += f'<circle cx="104" cy="74" r="16" fill="#fff7cc"/><circle cx="104" cy="74" r="8" fill="#ffffff" stroke="#fde047" stroke-width="3"/>' + tx(104, 108, T("चकाचौंध सफ़ेद लौ", "dazzling white flame", lg), O, 11)
    s += flame(150, 150) + tx(150, 170, T("बर्नर", "burner", lg), M, 11)
    s += f'<ellipse cx="270" cy="120" rx="44" ry="12" fill="#f1f5f9" stroke="{K}"/><path d="M240,116 q30,-18 60,0" fill="#ffffff" stroke="#94a3b8"/>' + tx(270, 150, T("सफ़ेद चूर्ण: MgO", "white powder: MgO", lg), B, 12)
    s += tx(170, 30, "2Mg + O₂ → 2MgO", K, 15, "middle", 700)
    return s + "</svg>"

def f_zn(lg):
    s = head(210)
    s += f'<path d="M60,70 L60,110 L30,175 Q28,185 40,185 L120,185 Q132,185 130,175 L100,110 L100,70 Z" fill="#ffffff" stroke="{K}" stroke-width="2"/>'
    s += f'<path d="M45,150 L115,150 L127,178 Q128,183 120,183 L40,183 Q32,183 34,178 Z" fill="#dbeafe"/>'
    for x, y in ((60, 172), (75, 168), (95, 174)): s += f'<rect x="{x}" y="{y}" width="12" height="7" fill="#94a3b8"/>'
    for x, y in ((66, 160), (82, 155), (100, 162), (90, 140)): s += f'<circle cx="{x}" cy="{y}" r="3" fill="none" stroke="{B}"/>'
    s += ln(80, 70, 80, 40, K, 3) + ln(80, 40, 210, 40, K, 3) + ln(210, 40, 210, 70, K, 3)
    s += f'<rect x="190" y="70" width="40" height="70" fill="#f1f5f9" stroke="{K}"/>' + tx(210, 110, "H₂", B, 15, "middle", 700)
    s += tx(80, 202, T("तनु H₂SO₄ + जिंक", "dilute H₂SO₄ + zinc", lg), M, 11) + tx(270, 98, T("जलती तीली से", "pops with a", lg), M, 11) + tx(270, 113, T("'पॉप' ध्वनि", "burning splint", lg), M, 11)
    s += tx(210, 175, "Zn + H₂SO₄ → ZnSO₄ + H₂", K, 12, "middle", 700)
    return s + "</svg>"

def f_balance(lg):
    s = head(220) + tx(170, 24, "3Fe + 4H₂O → Fe₃O₄ + 4H₂", K, 15, "middle", 700)
    rows = [("Fe", "3", "3"), ("H", "8", "8"), ("O", "4", "4")]
    s += f'<rect x="40" y="40" width="260" height="30" rx="6" fill="#eff6ff"/>' + tx(80, 60, T("परमाणु", "Atom", lg), B, 13) + tx(170, 60, T("बाएँ (अभिकारक)", "Left (reactants)", lg), B, 12) + tx(260, 60, T("दाएँ (उत्पाद)", "Right (products)", lg), B, 12)
    for i, (a, l, r) in enumerate(rows):
        y = 92 + i * 30
        s += tx(80, y, a, K, 15, "middle", 700) + tx(170, y, l, K, 15) + tx(260, y, r, K, 15) + tx(305, y, "✓", G, 15, "middle", 700)
    s += f'<rect x="40" y="172" width="260" height="34" rx="8" fill="#ecfdf5"/>' + tx(170, 194, T("हर परमाणु दोनों ओर बराबर → संतुलित", "Every atom equal on both sides → balanced", lg), G, 12, "middle", 700)
    return s + "</svg>"

def f_types(lg):
    s = head(250)
    def blk(x, y, t, c): return f'<rect x="{x}" y="{y}" width="26" height="22" rx="5" fill="{c}"/>' + tx(x + 13, y + 16, t, "#fff", 12, "middle", 700)
    rows = [(T("संयोजन", "Combination", lg), [("A", B), "+", ("B", O)], [("A", B), ("B", O)]),
            (T("वियोजन", "Decomposition", lg), [("A", B), ("B", O)], [("A", B), "+", ("B", O)]),
            (T("विस्थापन", "Displacement", lg), [("A", B), "+", ("B", O), ("C", G)], [("A", B), ("C", G), "+", ("B", O)]),
            (T("द्विविस्थापन", "Double displacement", lg), [("A", B), ("B", O), "+", ("C", G), ("D", P)], [("A", B), ("D", P), "+", ("C", G), ("B", O)])]
    for i, (name, l, r) in enumerate(rows):
        y = 24 + i * 56
        s += tx(10, y + 4, name, K, 12, "start", 700)
        x = 14
        for it in l:
            if it == "+": s += tx(x + 6, y + 30, "+", K, 15); x += 14
            else: s += blk(x, y + 14, it[0], it[1]); x += 28
        s += arrow(x + 4, y + 25, x + 30, M); x += 38
        for it in r:
            if it == "+": s += tx(x + 6, y + 30, "+", K, 15); x += 14
            else: s += blk(x, y + 14, it[0], it[1]); x += 28
    return s + "</svg>"

def f_heat_feso4(lg):
    s = head(210)
    s += f'<g transform="rotate(-25 120 110)">{tube(100, 50, 110, lvl=0.18, liq="#bbf7d0")}</g>'
    s += flame(120, 190) + tx(120, 205, T("गर्म करो", "heat", lg), M, 11)
    s += f'<path d="M110,48 q-6,-18 4,-30 q8,-10 0,-22" fill="none" stroke="#94a3b8" stroke-width="2" stroke-dasharray="3 3"/>' + tx(60, 24, T("जलते सल्फ़र जैसी गंध", "smell of burning sulphur", lg), M, 11, "start")
    s += tx(250, 70, T("हरा FeSO₄", "green FeSO₄", lg), G, 12) + arrow(220, 92, 280, M) + tx(250, 120, T("भूरा-लाल Fe₂O₃", "reddish-brown Fe₂O₃", lg), R, 12)
    s += tx(250, 160, "2FeSO₄ → Fe₂O₃", K, 12, "middle", 700) + tx(250, 178, "+ SO₂ + SO₃", K, 12, "middle", 700)
    return s + "</svg>"

def f_electrolysis(lg):
    s = head(220)
    s += f'<rect x="60" y="110" width="220" height="80" rx="6" fill="#dbeafe" stroke="{K}" stroke-width="2"/>'
    s += f'<rect x="95" y="50" width="34" height="120" fill="#f8fafc" stroke="{K}"/><rect x="211" y="50" width="34" height="120" fill="#f8fafc" stroke="{K}"/>'
    s += f'<rect x="96" y="51" width="32" height="60" fill="#ffffff"/><rect x="212" y="51" width="32" height="30" fill="#ffffff"/>'
    s += f'<rect x="96" y="111" width="32" height="58" fill="#dbeafe"/><rect x="212" y="81" width="32" height="88" fill="#dbeafe"/>'
    s += tx(112, 86, "H₂", B, 14, "middle", 700) + tx(228, 70, "O₂", R, 13, "middle", 700)
    s += tx(112, 40, T("2 भाग", "2 parts", lg), B, 12) + tx(228, 40, T("1 भाग", "1 part", lg), R, 12)
    s += ln(112, 190, 112, 205, K) + ln(228, 190, 228, 205, K) + ln(112, 205, 150, 205) + ln(190, 205, 228, 205)
    s += f'<rect x="150" y="196" width="40" height="18" rx="3" fill="#ffffff" stroke="{K}"/>' + tx(170, 209, "6 V", K, 11)
    s += tx(170, 22, "2H₂O → 2H₂ + O₂", K, 14, "middle", 700)
    return s + "</svg>"

def f_nail(lg):
    s = head(210)
    for i, (liq, lab, nail) in enumerate((("#93c5fd", T("शुरू में: नीला CuSO₄", "start: blue CuSO₄", lg), "#94a3b8"), ("#bbf7d0", T("20 मिनट बाद: हल्का हरा", "after 20 min: light green", lg), "#b45309"))):
        x = 60 + i * 150
        s += tube(x, 40, 120, lvl=0.62, liq=liq, w=40)
        s += f'<rect x="{x+16}" y="20" width="8" height="120" rx="2" fill="{nail}"/>'
        s += tx(x + 20, 182, lab, K, 11)
    s += arrow(120, 100, 200, M)
    s += tx(170, 202, "Fe + CuSO₄ → FeSO₄ + Cu", K, 13, "middle", 700)
    s += tx(258, 120, T("भूरी परत: Cu", "brown coat: Cu", lg), O, 11, "start")
    return s + "</svg>"

def f_ppt(lg):
    s = head(200)
    s += tube(50, 40, 110, lvl=0.5, liq="#f1f5f9", w=34) + tx(67, 170, "Na₂SO₄", M, 11)
    s += tube(130, 40, 110, lvl=0.5, liq="#f1f5f9", w=34) + tx(147, 170, "BaCl₂", M, 11)
    s += arrow(180, 100, 225, M)
    s += tube(240, 40, 110, lvl=0.6, liq="#f8fafc", w=40)
    s += f'<ellipse cx="260" cy="136" rx="16" ry="9" fill="#e2e8f0" stroke="#94a3b8"/>' + tx(260, 170, T("सफ़ेद अवक्षेप BaSO₄", "white precipitate BaSO₄", lg), B, 11)
    s += tx(170, 22, "Na₂SO₄ + BaCl₂ → BaSO₄↓ + 2NaCl", K, 12, "middle", 700)
    return s + "</svg>"

def f_redox(lg):
    s = head(220) + tx(170, 92, "CuO + H₂ → Cu + H₂O", K, 18, "middle", 700)
    s += f'<path d="M128,72 C128,40 290,40 290,72" fill="none" stroke="{G}" stroke-width="2.5" stroke-dasharray="6 4"/>'
    s += tx(210, 28, T("H₂ ऑक्सीजन पाता है → ऑक्सीकरण", "H₂ gains oxygen → oxidation", lg), G, 12, "middle", 700)
    s += f'<path d="M70,104 C70,150 250,150 250,104" fill="none" stroke="{R}" stroke-width="2.5" stroke-dasharray="6 4"/>'
    s += tx(160, 160, T("CuO ऑक्सीजन खोता है → अपचयन", "CuO loses oxygen → reduction", lg), R, 12, "middle", 700)
    s += f'<rect x="30" y="174" width="280" height="36" rx="8" fill="#f5f3ff"/>' + tx(170, 197, T("दोनों साथ-साथ = रेडॉक्स अभिक्रिया", "both together = redox reaction", lg), P, 13, "middle", 700)
    return s + "</svg>"

def f_rust(lg):
    s = head(200)
    labs = [(T("हवा + पानी", "air + water", lg), "#bfdbfe", True), (T("सिर्फ़ सूखी हवा", "dry air only", lg), "#ffffff", False), (T("उबला पानी + तेल", "boiled water + oil", lg), "#e0f2fe", False)]
    for i, (lab, liq, rust) in enumerate(labs):
        x = 30 + i * 105
        s += tube(x, 30, 120, lvl=0.45 if liq != "#ffffff" else 0.02, liq=liq, w=40)
        if i == 2: s += f'<rect x="{x+2}" y="92" width="36" height="8" fill="#fde68a"/>'
        s += f'<rect x="{x+16}" y="40" width="8" height="100" rx="2" fill="{"#b45309" if rust else "#94a3b8"}"/>'
        s += tx(x + 20, 172, lab, K, 11) + tx(x + 20, 190, T("जंग ✓", "rust ✓", lg) if rust else T("जंग नहीं", "no rust", lg), R if rust else G, 11, "middle", 700)
    return s + "</svg>"

def f_energy(lg):
    s = head(200)
    for i, (title, up, col) in enumerate(((T("ऊष्माक्षेपी", "Exothermic", lg), False, O), (T("ऊष्माशोषी", "Endothermic", lg), True, B))):
        x = 20 + i * 165
        s += tx(x + 75, 22, title, col, 13, "middle", 700)
        s += ln(x + 10, 170, x + 10, 40, M, 1.5) + tx(x + 4, 50, "E", M, 11, "end")
        y1, y2 = (130, 70) if up else (70, 130)
        s += ln(x + 18, y1, x + 60, y1, K, 3) + ln(x + 95, y2, x + 140, y2, K, 3)
        s += f'<path d="M{x+60},{y1} C{x+75},{min(y1,y2)-30} {x+85},{min(y1,y2)-30} {x+95},{y2}" fill="none" stroke="{col}" stroke-width="2" stroke-dasharray="4 3"/>'
        s += tx(x + 38, y1 + 18, T("अभिकारक", "reactants", lg), M, 10) + tx(x + 118, y2 + 18, T("उत्पाद", "products", lg), M, 10)
        s += tx(x + 75, 190, T("ऊर्जा बाहर", "energy out", lg) if not up else T("ऊर्जा अंदर", "energy in", lg), col, 12, "middle", 700)
    return s + "</svg>"

FIGS = {lg: {"mg": f_mg(lg), "zn": f_zn(lg), "balance": f_balance(lg), "types": f_types(lg), "feso4": f_heat_feso4(lg),
             "electrolysis": f_electrolysis(lg), "nail": f_nail(lg), "ppt": f_ppt(lg), "redox": f_redox(lg), "rust": f_rust(lg), "energy": f_energy(lg)} for lg in ("hi", "en")}
if __name__ == "__main__":
    json.dump(FIGS, open("figs.json", "w"), ensure_ascii=False)
    html = "<html><body style='background:#ccc;margin:0'>" + "".join(f"<div style='width:340px;display:inline-block;margin:4px'>{v}</div>" for v in FIGS["hi"].values()) + "</body></html>"
    open("figs_preview.html", "w").write(html); print(len(FIGS["hi"]), "figures")
