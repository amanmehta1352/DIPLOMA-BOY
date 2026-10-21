-- 0012: standing import/publish/presentation rules (applied to live DB 21 Oct 2026; file added to repo afterwards)
create table if not exists mtb.pipeline_rules (
  id text primary key,
  title text not null,
  body text not null,
  applies_to text not null,
  updated_at timestamptz not null default now()
);
alter table mtb.pipeline_rules enable row level security;
revoke all on mtb.pipeline_rules from anon, authenticated;
grant select, insert, update on mtb.pipeline_rules to service_role;

insert into mtb.pipeline_rules (id, title, applies_to, body) values
('official-only','सिर्फ़ official सवाल','import','PYQ में सिर्फ़ official paper/answer key का text, options और answer। कोचिंग की solution/banner नहीं। Source URL sources.url में।'),
('publish-gate','publish से पहले जाँच','publish','Publish सिर्फ़ तब: answer है, 4 options हैं, English (text या picture) है, Hindi (text, picture या machine मार्क) है, और Hindi check में कोई flag नहीं। बाकी draft में रहेंगे।'),
('hindi-machine','Hindi मशीन अनुवाद','import','Official Hindi न मिले तो IndicTrans2 अनुवाद लगेगा और stem.hi_mt=true मार्क होगा। ऐप में "मशीन अनुवाद" नोट दिखता है।'),
('figure-picture','चित्र वाले सवाल','import','जिस सवाल में चित्र ज़रूरी है (Venn, आकृति, table), उसकी तस्वीर डाली जाती है। Text सिर्फ़ तब हटता है जब तस्वीर में पूरा सवाल हो (stem.dup / qpic)।'),
('pattern-group','एक जैसे सवालों का ग्रुप','publish','हर publish के बाद group.py चलता है: एक ही chapter के सवाल जो सिर्फ़ संख्या/नाम में अलग हैं (cosine ≥ 0.70, numbers masked) एक pattern बनते हैं। Threshold कम न करें।'),
('pattern-scope','Pattern किस मोड में','app','Pattern चिप सिर्फ़ chapter/subject practice में। PYQ-by-exam सूची में हर सवाल अलग दिखता है।'),
('hidden-not-deleted','Hidden, delete नहीं','data','Unverified या गलत सवाल status=hidden होते हैं, delete नहीं। Delete सिर्फ़ मालिक के साफ़ आदेश पर SQL से।'),
('backup-first','Server बदलने से पहले backup','data','हर migration/bulk update से पहले backup.take_nightly()।'),
('no-cache-tests','Release से पहले tests','app','हर app release से पहले सारे tests (flow, design, tree, cbt, home, clean, pattern) पास हों।'),
('paper-complete','पेपर पूरा होने पर ही publish','publish','किसी paper (जैसे 200 सवाल) का publish तभी जब उसके सारे सवाल पूरे और जाँचे हुए हों। अधूरा paper पूरा draft में रहेगा।')
on conflict (id) do update set title=excluded.title, body=excluded.body, applies_to=excluded.applies_to, updated_at=now();
