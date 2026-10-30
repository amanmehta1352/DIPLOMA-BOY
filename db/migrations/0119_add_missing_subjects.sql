-- Migration 0119: add 19 subjects for levels that had no subject (commerce, arts, law)
-- Explicit IDs 16-34 (existing max id = 15). Slugs were checked: none existed before.
insert into mtb.subjects (id, slug, name_en, name_hi, branch_id) values
  (16, 'accountancy', 'Accountancy', 'अकाउंटेंसी', null),
  (17, 'business-studies', 'Business Studies', 'व्यवसाय अध्ययन', null),
  (18, 'economics-com', 'Economics (Commerce)', 'अर्थशास्त्र (कॉमर्स)', null),
  (19, 'maths-com', 'Mathematics (Commerce)', 'गणित (कॉमर्स)', null),
  (20, 'advanced-accountancy', 'Advanced Accountancy', 'उच्च अकाउंटेंसी', null),
  (21, 'business-law', 'Business Law', 'व्यवसाय कानून', null),
  (22, 'cost-accounting', 'Cost Accounting', 'लागत लेखांकन', null),
  (23, 'history', 'History', 'इतिहास', null),
  (24, 'political-science', 'Political Science', 'राजनीति विज्ञान', null),
  (25, 'geography-arts', 'Geography', 'भूगोल', null),
  (26, 'sociology', 'Sociology', 'समाजशास्त्र', null),
  (27, 'psychology', 'Psychology', 'मनोविज्ञान', null),
  (28, 'advanced-history', 'Advanced History', 'उच्च इतिहास', null),
  (29, 'advanced-polity', 'Advanced Political Science', 'उच्च राजनीति विज्ञान', null),
  (30, 'advanced-geography', 'Advanced Geography', 'उच्च भूगोल', null),
  (31, 'legal-reasoning', 'Legal Reasoning', 'विधिक तर्क', null),
  (32, 'legal-aptitude', 'Legal Aptitude', 'विधिक योग्यता', null),
  (33, 'english-law', 'English (Law)', 'अंग्रेज़ी (कानून)', null),
  (34, 'quant-law', 'Quantitative Aptitude (Law)', 'मात्रात्मक योग्यता', null)
on conflict do nothing;
