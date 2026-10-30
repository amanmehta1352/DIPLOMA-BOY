-- Migration 0110: add 19 exams to mtb.exams (existing 7 rows untouched)
insert into mtb.exams (slug, name_en, name_hi, level, active, pattern, family_slug, family_en, family_hi, stage_hi, stage_en, stage_sort, content_level)
values
  ('neet-ug',        'NEET UG',        'नीट यूजी',              'diploma', true, '{}'::jsonb, 'neet-ug',        'NEET UG',        'नीट यूजी',              null, null, 1, 'medical'),
  ('jee-main',       'JEE Main',       'जेईई मेन',              'diploma', true, '{}'::jsonb, 'jee-main',       'JEE Main',       'जेईई मेन',              null, null, 1, 'engineering'),
  ('jee-advanced',   'JEE Advanced',   'जेईई एडवांस्ड',         'diploma', true, '{}'::jsonb, 'jee-advanced',   'JEE Advanced',   'जेईई एडवांस्ड',         null, null, 1, 'engineering'),
  ('upsc-cse',       'UPSC CSE',       'यूपीएससी सीएसई',        'diploma', true, '{}'::jsonb, 'upsc-cse',       'UPSC CSE',       'यूपीएससी सीएसई',        null, null, 1, 'upsc_civil'),
  ('class-6',        'Class 6',        'कक्षा 6',               'diploma', true, '{}'::jsonb, 'class-6',        'Class 6',        'कक्षा 6',               null, null, 1, 'class_6_8'),
  ('class-7',        'Class 7',        'कक्षा 7',               'diploma', true, '{}'::jsonb, 'class-7',        'Class 7',        'कक्षा 7',               null, null, 1, 'class_6_8'),
  ('class-8',        'Class 8',        'कक्षा 8',               'diploma', true, '{}'::jsonb, 'class-8',        'Class 8',        'कक्षा 8',               null, null, 1, 'class_6_8'),
  ('class-9',        'Class 9',        'कक्षा 9',               'diploma', true, '{}'::jsonb, 'class-9',        'Class 9',        'कक्षा 9',               null, null, 1, 'class_9_10'),
  ('class-10',       'Class 10',       'कक्षा 10',              'diploma', true, '{}'::jsonb, 'class-10',       'Class 10',       'कक्षा 10',              null, null, 1, 'class_9_10'),
  ('class-11-pcm',   'Class 11 PCM',   'कक्षा 11 PCM',          'diploma', true, '{}'::jsonb, 'class-11-pcm',   'Class 11 PCM',   'कक्षा 11 PCM',          null, null, 1, 'class_11_12_sci'),
  ('class-12-pcm',   'Class 12 PCM',   'कक्षा 12 PCM',          'diploma', true, '{}'::jsonb, 'class-12-pcm',   'Class 12 PCM',   'कक्षा 12 PCM',          null, null, 1, 'class_11_12_sci'),
  ('class-11-pcb',   'Class 11 PCB',   'कक्षा 11 PCB',          'diploma', true, '{}'::jsonb, 'class-11-pcb',   'Class 11 PCB',   'कक्षा 11 PCB',          null, null, 1, 'class_11_12_sci'),
  ('class-12-pcb',   'Class 12 PCB',   'कक्षा 12 PCB',          'diploma', true, '{}'::jsonb, 'class-12-pcb',   'Class 12 PCB',   'कक्षा 12 PCB',          null, null, 1, 'class_11_12_sci'),
  ('nda',            'NDA',            'एनडीए',                 'diploma', true, '{}'::jsonb, 'nda',            'NDA',            'एनडीए',                 null, null, 1, 'govt_defence'),
  ('cds',            'CDS',            'सीडीएस',                'diploma', true, '{}'::jsonb, 'cds',            'CDS',            'सीडीएस',                null, null, 1, 'govt_defence'),
  ('ibps-po',        'IBPS PO',        'आईबीपीएस पीओ',          'diploma', true, '{}'::jsonb, 'ibps-po',        'IBPS PO',        'आईबीपीएस पीओ',          null, null, 1, 'banking'),
  ('sbi-po',         'SBI PO',         'एसबीआई पीओ',            'diploma', true, '{}'::jsonb, 'sbi-po',         'SBI PO',         'एसबीआई पीओ',            null, null, 1, 'banking'),
  ('uppsc',          'UPPSC',          'यूपीपीएससी',            'diploma', true, '{}'::jsonb, 'uppsc',          'UPPSC',          'यूपीपीएससी',            null, null, 1, 'state_psc'),
  ('bpsc',           'BPSC',           'बीपीएससी',              'diploma', true, '{}'::jsonb, 'bpsc',           'BPSC',           'बीपीएससी',              null, null, 1, 'state_psc')
on conflict do nothing;
