# Electricity: design brief (for the writer robot)

Scope: Class 10 Science, Electricity (topic 880). Level row: class_9_10 (10 atoms: 3 concept, 2 formula, 2 example, 3 MCQ). Primary language English, secondary Hindi (bilingual-scope.md). Use this brief together with "Diploma Boy Content Standard v1". Where they disagree, the Standard decides.

## 0. Rules (no exceptions)
- Write every sentence yourself. Do not copy or closely paraphrase any book, including NCERT. Use your own examples and numbers.
- Every numerical value must be consistent. Every answer must be recomputed in code before release.
- No filler lines ("समझो ऐसे", "क्लास में आपका स्वागत है"). Each line must teach something or show a step.
- Hindi is a translation of the English meaning, not a loose rewrite. Units and symbols stay identical.

## 1. Student journey (order of presentation)
1. **Hook (one line, real life):** "Why does a 5 A fuse blow when you run an iron and a heater together?" Use a question the student can answer from daily life.
2. **Outcome:** 2 to 4 things the student will be able to do (for example: "Apply V = IR to a circuit with two resistors").
3. **Concept:** one idea per atom. Charge, current, potential difference, resistance, Ohm's law, series and parallel, power and energy, heating effect, fuse, safety.
4. **Visual:** an SVG diagram for each key concept (see section 2).
5. **Formula / rule:** the formula, every symbol with unit, and a line on when it applies.
6. **Example (solved, step-by-step):** a student sees the question first, then taps "next" to reveal each step. Each step has a "why" line. One "trap" box: the most common mistake (for example: using 500 mA as 500 A).
7. **Practice:** the 3 MCQs. Options come from common mistakes, not random numbers.
8. **Assessment:** the same MCQs, marked by answer index. No extra atoms.
9. **Revision:** a 3-line Notes card per chapter (key formula, one trap, one fact).

## 2. Diagrams (SVG), at least 4 per chapter
Each diagram has a title, labels, and one sentence explaining what the student should see.
- D1: Simple circuit (cell, switch, bulb, ammeter in series, voltmeter across the bulb). Arrows show conventional current.
- D2: Electron movement in a conductor versus conventional current direction. Keep this clearly labelled to avoid confusion.
- D3: V-I graph for an ohmic resistor (straight line through origin) and a non-ohmic device (curved line). Axes labelled with units.
- D4: Series and parallel combinations side by side, with the same two resistors, so the difference is visible.
- D5: Heating effect: a heater coil, with a note that heat = I²Rt.
- D6: Home wiring: live, neutral, earth, fuse, MCB, and the switch in the live wire.
Colours: one colour per quantity across all diagrams (current in one colour, voltage in another). Do not use colour alone to carry meaning; also use a label.

## 3. Solved examples: the masterclass style
- Each example has 2 methods where possible: (a) direct formula, (b) unit or ratio method (for example: "double the voltage, halve the resistance: current becomes 4 times").
- Both methods end on the same answer. The last step circles the answer.
- Steps: 2 to 8 lines, each one notebook line, at least 60% of lines show real numbers.
- "Why" line on each step; one "trap" box per example.

## 4. Atom plan for Electricity (class 9-10 row)
| Atom | Count | Content |
|---|---|---|
| concept | 3 | (1) charge and current, (2) potential difference and resistance, (3) Ohm's law and its graph |
| formula | 2 | V = IR and Q = It, with symbols, units, and when to use each |
| example | 2 | (1) current through a bulb from voltage and resistance, (2) two resistors in series and parallel |
| mcq | 3 | (1) easy: unit of current, (2) medium: effect of doubling resistance on current, (3) medium: power of a heater from V and I |

Each MCQ has 4 options. The answer index is stored, and a code check recomputes numerical answers.

## 5. Writing checks the writer must pass before handing over
- Counts match the table above.
- Every example has 2 methods and both give the same value.
- No line of Hindi is only transliteration of English words without meaning.
- No sentence longer than 25 words in English, except formulas.
- Diagrams are present (at least 4, from section 2).
- No copied text from any book.

## 6. Output
Produce the chapter as structured JSON: concept, formula, example, mcq, svg atoms, plus Notes card and Hindi translation. No prose outside the JSON.
