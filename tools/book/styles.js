// Style layers: what a style shows, in which order and how much. Pure data, no AI.
// Same 5 codes as mtb.book_styles (db/migrations/0175_book_styles.sql). Pilot: saral + abhyas.
export const STYLES = {
  saral: {
    name: 'सरल पाठ्यपुस्तक', icon: '📗',
    explain: ['core'],            // which explain depths to print
    examples: 'first',            // one (easiest) worked example per section
    checks: true,                 // "स्वयं जाँचें" under each section
    ladder: false,                // no per-section question ladder
    activity: true, know: true,
    // end-of-chapter exercise: how many of each type, easiest first
    exercise: { mcq: 5, vshort: 4, short: 3, long: 2, numeric: 4 },
    answerKey: 'brief'            // MCQ letters + numeric solutions
  },
  abhyas: {
    name: 'अभ्यास-प्रधान', icon: '📙',
    explain: ['core'],
    examples: 'all',              // every worked example, easy → hard
    checks: false,
    ladder: ['mcq', 'vshort', 'numeric'],   // after each section, that section's questions by level
    activity: true, know: false,
    exercise: { short: 99, long: 99 },      // end: all written-answer questions ("मिश्रित अभ्यास")
    answerKey: 'full'             // every answer and every solution
  }
};

export const ACCENT = { basic: '#047857', board: '#1d4ed8', technical: '#b45309', higher: '#6d28d9' };
