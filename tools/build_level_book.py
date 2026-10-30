#!/usr/bin/env python3
"""Build level-book.html: the same book reader look as book.html (Physics), for every level and subject.

The style block and the stacked-fraction code are copied verbatim from book.html, so every chapter of
every level looks like the Physics book (Book / Notes / Teach / Formula / Diagram tabs, stacked fractions).
Content comes from the server: mtb.get_level_catalog (chapters) and mtb.get_chapter_atoms (one chapter).
Run from the repo root:  python3 tools/build_level_book.py
"""
import re, pathlib
root = pathlib.Path(__file__).resolve().parent.parent
src = (root / 'book.html').read_text(encoding='utf-8')
style = src[src.index('<style>'):src.index('</style>') + len('</style>')]
a = src.index('/* ===== Stacked fractions'); b = src.index('function switchTab(tab)')
frac = src[a:b].rstrip()
assert 'function fracify(root)' in frac and 'function splitFormulaBars' in frac
body = (root / 'tools' / 'level_book_body.html').read_text(encoding='utf-8')
out = body.replace('/*__STYLE__*/', style).replace('/*__FRACIFY__*/', frac)
(root / 'level-book.html').write_text(out, encoding='utf-8')
print('level-book.html', len(out), 'bytes')
