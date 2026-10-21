-- 0010: public bucket for question pictures (figure questions). Upload only with the service key (robot).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('qimg', 'qimg', true, 2097152, array['image/png'])
on conflict (id) do nothing;
