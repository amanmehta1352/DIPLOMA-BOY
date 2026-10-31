# Diploma Boy content style (template for every robot)

Written once, followed by every robot (Writer, Solver) and checked by code.

## What each mode is for
| Mode | Purpose | Content |
|---|---|---|
| Book (किताब) | the chapter as a printed textbook | numbered sections (1.1, 1.2 …): definition → rules → small example; key formulas in boxes; worked examples with full solution; exercise at the end (each question shows its worked solution after answering) |
| Notes (नोट्स) | quick revision | short points, tables, formulas at a glance, common mistakes, one-line revision |
| Teach (क्लास) | teacher in class | spoken explanation with daily-life example → solve together step by step (✍️ reveal) → "your turn" (3 questions) |
| Formula (सूत्र) | formulas only | title, formula, unit, note |
| Diagram / 3D (चित्र) | pictures only | diagrams (3D only where a real model exists, e.g. Physics) |
| ✍️ Masterclass | one question, every method | owner's masterclass page: Base-100, Fraction, Bar, Table, Venn, Formula, Ratio, Shortcut, Unit analysis |

## Maths is typeset like a printed book
Write plain notation; the app draws it:
`a/b` and `(a + b)/(c - d)` → stacked fraction · `×` for multiply (never `*`) · `x^2`, `(1 + R/100)^n` → superscript · `sqrt(x)` → √x.
Units stay inline (`m/s`, `km/h`).

## Every solution looks the same everywhere
A solution is a list of notebook steps, one line each, with the real numbers ("माना मूलधन = 100", "SI = 5200 - 4000 = 1200").
The last step reaches the answer, and the answer is circled. Worked examples, Teach walkthroughs, exercise solutions and the
masterclass page all use this one format, so what a student is taught and what the test shows always match.

## Checks (code, no AI)
- structure and counts; no HTML/LaTeX; `×` not `*`
- exercise: the worked solution must reach the same answer as the right option
- masterclass: every method reaches the same answer; at least 3 methods; steps show numbers; units bold in Physics/Chemistry
- a second AI solves the questions without seeing the answers
