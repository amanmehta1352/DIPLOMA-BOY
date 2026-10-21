-- 0008: import robot. Hindi sheet link on the job; robot (service_role) may read/insert/update content tables. No DELETE, no DROP.
alter table mtb.import_jobs add column if not exists url_hi text;
alter table mtb.import_jobs add column if not exists source_id int;
grant select, insert, update on mtb.questions, mtb.sources, mtb.topics, mtb.subjects, mtb.exams, mtb.exam_branches, mtb.exam_sections, mtb.branches to service_role;
grant usage, select on all sequences in schema mtb to service_role;
