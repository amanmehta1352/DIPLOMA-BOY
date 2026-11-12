-- 0170 degrees added in 0169 also get the graduate-level exams that 0167 gave to the earlier degrees. Additive.
insert into mtb.qualification_exams (qual_slug, target, status, why, sort)
select q.slug, b.t, 'any', b.why, b.s
from mtb.qualifications q cross join (values
  ('rrb-ntpc','graduate posts: any degree',10), ('ibps-po','any graduate',11), ('sbi-po','any graduate (final year allowed)',12),
  ('cds','graduate (stream rules per academy)',13), ('uppsc','any graduate',14), ('bpsc','any graduate',15), ('upsc-cse','any graduate',16)) b(t, why, s)
where q.cat in ('graduation','postgrad')
on conflict (qual_slug, target) do nothing;
