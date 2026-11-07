# Hand-drawn static figures that the demos did not cover (F1 static, F10 ampere, F12 resistivity chart, F13 fuse/filament, F14 P-V-I-R wheel).
B, O, G, R, K, M = "#2563eb", "#e8730c", "#15803d", "#dc2626", "#16202f", "#5f6b80"
HEAD = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 {h}" font-family="Noto Sans Devanagari, system-ui, sans-serif"><rect x="0" y="0" width="340" height="{h}" rx="14" fill="#ffffff"/>'
def tx(x, y, s, c=K, sz=13, a="middle", w=600): return f'<text x="{x}" y="{y}" fill="{c}" font-size="{sz}" text-anchor="{a}" font-weight="{w}">{s}</text>'
def ln(a, b, c, d, col=K, w=2.5, ex=""): return f'<line x1="{a}" y1="{b}" x2="{c}" y2="{d}" stroke="{col}" stroke-width="{w}" stroke-linecap="round" {ex}/>'
def arrow(x, y, ang, c): return f'<path d="M-8,-6 L8,0 L-8,6 Z" fill="{c}" transform="translate({x},{y}) rotate({ang})"/>'

def f1(lang):
    hi = lang == "hi"
    s = HEAD.format(h=200)
    s += ln(40, 50, 300, 50) + ln(300, 50, 300, 150) + ln(300, 150, 40, 150) + ln(40, 50, 40, 82) + ln(40, 118, 40, 150)
    s += f'<rect x="30" y="80" width="22" height="40" fill="#fff"/>' + ln(36, 86, 36, 114) + ln(46, 92, 46, 108, K, 5)
    s += tx(26, 90, "+", R, 14) + tx(26, 118, "−", K, 16)
    # conventional current: clockwise from + (top) -> along top to right
    for x in (110, 220): s += arrow(x, 50, 0, O)
    s += arrow(300, 100, 90, O)
    s += tx(170, 38, ("परम्परागत धारा: + से −" if hi else "Conventional current: + to −"), O, 13)
    # electrons along bottom moving right-to-left? electrons go counter-clockwise: from − (bottom) along bottom to the right
    for x in (90, 140, 190, 240): s += f'<circle cx="{x}" cy="150" r="5" fill="{B}"/>'
    s += arrow(265, 150, 0, B)
    s += tx(170, 178, ("इलेक्ट्रॉन: − से + (उल्टी दिशा)" if hi else "Electrons: − to + (opposite way)"), B, 13)
    return s + "</svg>"

def f10(lang):
    hi = lang == "hi"
    s = HEAD.format(h=190)
    s += '<rect x="20" y="60" width="300" height="50" rx="25" fill="#eef3fd" stroke="#c9d6f2" stroke-width="2"/>'
    s += '<ellipse cx="170" cy="85" rx="12" ry="25" fill="none" stroke="#e8730c" stroke-width="3" stroke-dasharray="5 4"/>'
    for i, x in enumerate((50, 80, 110, 140, 200, 230, 260, 290)): s += f'<circle cx="{x}" cy="{75 + (i % 2) * 20}" r="5" fill="{B}"/>'
    s += arrow(300, 40, 180, B) + ln(220, 40, 296, 40, B, 2)
    s += tx(250, 32, ("इलेक्ट्रॉन" if hi else "electrons"), B, 12)
    s += tx(170, 135, ("अनुप्रस्थ काट (cross-section)" if hi else "cross-section"), O, 12)
    s += tx(170, 162, ("1 सेकंड में 1 C आवेश पार करे = 1 A" if hi else "1 C of charge crossing in 1 s = 1 A"), K, 14, "middle", 700)
    s += tx(170, 182, "I = Q / t", G, 14, "middle", 700)
    return s + "</svg>"

def f12(lang):
    hi = lang == "hi"
    # log scale bar chart of resistivity (Ω m)
    import math
    rows = [("चाँदी", "Silver", 1.6e-8, B), ("ताँबा", "Copper", 1.7e-8, B), ("एल्युमिनियम", "Aluminium", 2.6e-8, B), ("टंगस्टन", "Tungsten", 5.2e-8, B),
            ("नाइक्रोम", "Nichrome", 1.1e-6, O), ("काँच", "Glass", 1e10, R), ("रबर", "Rubber", 1e13, R)]
    s = HEAD.format(h=250)
    s += tx(170, 24, ("प्रतिरोधकता ρ (Ω m), लघुगणक पैमाना" if hi else "Resistivity ρ (Ω m), log scale"), K, 13, "middle", 700)
    lo, hi_ = -8.5, 13.5
    for i, (h, e, v, c) in enumerate(rows):
        y = 44 + i * 28
        w = 20 + (math.log10(v) - lo) / (hi_ - lo) * 170
        s += tx(92, y + 15, (h if hi else e), K, 12, "end")
        s += f'<rect x="100" y="{y}" width="{w:.0f}" height="18" rx="4" fill="{c}" opacity=".85"/>'
        m, ex = f"{v:.1e}".split("e"); s += tx(106 + w, y + 14, f"{m} × 10^{int(ex)}".replace("^", "") if False else f"{m}×10{''.join('⁰¹²³⁴⁵⁶⁷⁸⁹⁻'['0123456789-'.index(ch)] for ch in str(int(ex)))}", M, 11, "start", 500)
    s += tx(170, 244, ("नीला: चालक · नारंगी: मिश्रधातु · लाल: विद्युतरोधी" if hi else "blue: conductors · orange: alloy · red: insulators"), M, 11)
    return s + "</svg>"

def f13(lang):
    hi = lang == "hi"
    s = HEAD.format(h=200)
    # filament bulb (left)
    s += '<circle cx="85" cy="80" r="45" fill="#fff7e0" stroke="#16202f" stroke-width="2.5"/>'
    s += '<path d="M65,110 L65,85 q5,-12 10,0 q5,12 10,0 q5,-12 10,0 q5,12 10,0 L105,110" fill="none" stroke="#e8730c" stroke-width="3"/>'
    s += '<rect x="65" y="122" width="40" height="18" rx="3" fill="#cbd5e1"/>'
    s += tx(85, 162, ("टंगस्टन तंतु" if hi else "tungsten filament"), O, 12) + tx(85, 180, ("गलनांक ≈ 3380 °C" if hi else "melting point ≈ 3380 °C"), M, 11)
    # fuse (right)
    s += '<rect x="190" y="60" width="120" height="40" rx="8" fill="#f8fafc" stroke="#16202f" stroke-width="2.5"/>'
    s += ln(160, 80, 190, 80) + ln(310, 80, 330, 80)
    s += '<path d="M190,80 C220,70 250,90 280,80 S305,78 310,80" fill="none" stroke="#dc2626" stroke-width="2"/>'
    s += tx(250, 50, ("फ्यूज़ (श्रेणी में)" if hi else "fuse (in series)"), R, 12)
    s += tx(250, 124, ("कम गलनांक वाला पतला तार" if hi else "thin wire, low melting point"), M, 11)
    s += tx(250, 146, ("धारा > रेटिंग → तार पिघले" if hi else "current > rating → wire melts"), R, 12, "middle", 700)
    s += tx(250, 166, ("→ परिपथ टूटे, उपकरण बचे" if hi else "→ circuit breaks, devices safe"), G, 12, "middle", 700)
    return s + "</svg>"

def f14(lang):
    hi = lang == "hi"
    s = HEAD.format(h=250)
    cx, cy = 170, 120
    s += f'<circle cx="{cx}" cy="{cy}" r="95" fill="#f8fafc" stroke="#dde3ec" stroke-width="2"/>'
    s += ln(cx - 95, cy, cx + 95, cy, "#dde3ec", 2) + ln(cx, cy - 95, cx, cy + 95, "#dde3ec", 2)
    s += f'<circle cx="{cx}" cy="{cy}" r="26" fill="{O}"/>' + tx(cx, cy + 7, "P", "#fff", 22, "middle", 800)
    quads = [("P = V × I", -48, -45), ("P = I² R", 48, -45), ("P = V² / R", -48, 55), ("I = P / V", 48, 55)]
    for t_, dx, dy in quads: s += tx(cx + dx, cy + dy, t_, B, 14, "middle", 700)
    s += tx(170, 236, ("जो दो राशियाँ पता हों, वही सूत्र चुनो" if hi else "pick the formula that uses the two values you know"), M, 12)
    return s + "</svg>"

FIG = {}
for lang in ("hi", "en"):
    FIG[lang] = {"F1_current": f1(lang), "F10_ampere": f10(lang), "F12_resistivity_chart": f12(lang), "F13_fuse_filament": f13(lang), "F14_power_wheel": f14(lang)}
