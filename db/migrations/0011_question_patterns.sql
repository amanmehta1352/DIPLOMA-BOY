-- Same-type questions ("patterns"): questions that differ only in numbers/names share a pattern_id.
-- pattern_id = id of the lead question, pattern_n = how many questions share the pattern (all exams),
-- pattern_rep = true for the lead (and for every question that has no pattern), so lists can show one per pattern.
alter table mtb.questions add column if not exists pattern_id integer;
alter table mtb.questions add column if not exists pattern_n smallint;
alter table mtb.questions add column if not exists pattern_rep boolean not null default true;
create index if not exists questions_pattern_idx on mtb.questions(pattern_id) where pattern_id is not null;
