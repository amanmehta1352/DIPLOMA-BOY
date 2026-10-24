-- 0025 Books (B1): किताबें filter से बनती हैं (live सवाल, set-wise, hide हुए सवाल नहीं)
-- Live: applied 2026-10-24. Note: mtb.filter_questions has a 2000-id cap, so build books per subject/chapter (each < 2000).

create table if not exists mtb.books (
  id bigint generated always as identity primary key,
  title text not null,
  filter jsonb not null default '{}'::jsonb,
  version int not null default 1,
  built_at timestamptz not null default now(),
  question_count int not null default 0,
  unique (title, version)
);

create table if not exists mtb.book_items (
  book_id bigint not null references mtb.books(id) on delete cascade,
  position int not null,
  question_id bigint not null,
  chapter_id bigint,
  set_no int not null default 0,
  source_id bigint,
  primary key (book_id, position),
  unique (book_id, question_id)
);

-- Each book item must point at a real question; a question with a book entry cannot be deleted (RESTRICT).
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'book_items_question_fk') then
    alter table mtb.book_items add constraint book_items_question_fk
      foreign key (question_id) references mtb.questions(id) on delete restrict;
  end if;
end $$;

alter table mtb.books enable row level security;
alter table mtb.book_items enable row level security;
revoke all on mtb.books, mtb.book_items from anon, authenticated;
grant select, insert, update, delete on mtb.books, mtb.book_items to service_role;

create or replace function mtb.build_book(p_title text, p_filter jsonb)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare
  f jsonb; bid bigint; ver int; n int; run_no bigint;
begin
  f := mtb.filter_questions(coalesce(p_filter,'{}'::jsonb), 100000);
  -- Serialize builds of the same title so two runs cannot pick the same version.
  perform pg_advisory_xact_lock(hashtext('build_book:' || p_title));
  select coalesce(max(version),0)+1 into ver from mtb.books where title = p_title;
  insert into mtb.books(title, filter, version, built_at, question_count)
    values (p_title, coalesce(p_filter,'{}'::jsonb), ver, now(), 0) returning id into bid;
  select max(run_id) into run_no from mtb.question_sets;
  insert into mtb.book_items(book_id, position, question_id, chapter_id, set_no, source_id)
  select bid, row_number() over (order by q.chapter_id, coalesce(qs.set_no,0), q.id),
         q.id, q.chapter_id, coalesce(qs.set_no,0), q.source_id
  from mtb.questions q
  join (select jsonb_array_elements_text(f->'ids') as id) x on x.id = q.id::text
  left join mtb.question_sets qs on qs.question_id = q.id and qs.run_id = run_no
  where q.status = 'published'
    and (not (q.stem ? 'img') or coalesce(q.stem->'checks'->>'fig_ok','') = 'true');
  get diagnostics n = row_count;
  update mtb.books set question_count = n where id = bid;
  return jsonb_build_object('ok', true, 'book_id', bid, 'title', p_title, 'version', ver, 'questions', n);
end $$;

revoke all on function mtb.build_book(text,jsonb) from public, anon, authenticated;
grant execute on function mtb.build_book(text,jsonb) to service_role;
