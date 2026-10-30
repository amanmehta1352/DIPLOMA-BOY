-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261022101511  name: ntpc_mixed_subject_and_aliases
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 9e2edc92475b36b5ebb2714bcf8ed454

insert into mtb.subjects(slug,name_en,name_hi,branch_id) values ('ntpc-mixed','NTPC (subject to be tagged)','NTPC (विषय टैग बाकी)',null) on conflict (slug) do nothing;
insert into mtb.subject_aliases(alias,subject_slug) values
 ('rrb ntpc graduate level i','ntpc-mixed'),('rrb ntpc graduate cbt 1','ntpc-mixed'),('ntpc','ntpc-mixed'),
 ('rrb ntpc graduate level ii','ntpc-mixed'),('rrb ntpc under graduate cbt 2','ntpc-mixed'),('rrb ntpc graduate cbt 2','ntpc-mixed'),
 ('rrb ntpc under graduate cbt i','ntpc-mixed'),('rrb ntpc undergraduate cbt i','ntpc-mixed'),('rrb ntpc undergraduate cbt ii','ntpc-mixed')
on conflict (alias) do nothing;
select 1;
