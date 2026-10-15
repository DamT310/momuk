-- 모먹교실 학습 자료실: Supabase SQL Editor에서 한 번 실행하세요.
create extension if not exists pgcrypto;

create table if not exists public.learning_resources (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('ppt', 'sheet')),
  title text not null check (char_length(title) between 1 and 80),
  description text not null check (char_length(description) between 1 and 300),
  external_url text,
  storage_path text unique,
  file_name text,
  file_size bigint check (file_size is null or file_size <= 20971520),
  created_by uuid default auth.uid() references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  check (external_url is not null or storage_path is not null)
);

alter table public.learning_resources enable row level security;
revoke all on table public.learning_resources from anon, authenticated;
grant select, insert on table public.learning_resources to anon, authenticated;

drop policy if exists "Public can view learning resources" on public.learning_resources;
create policy "Public can view learning resources"
on public.learning_resources for select
to anon, authenticated
using (true);

drop policy if exists "Teachers can add learning resources" on public.learning_resources;
drop policy if exists "Teachers can update learning resources" on public.learning_resources;
drop policy if exists "Teachers can delete learning resources" on public.learning_resources;
drop policy if exists "Anyone can add learning resources" on public.learning_resources;
create policy "Anyone can add learning resources"
on public.learning_resources for insert
to anon, authenticated
with check (true);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'learning-materials',
  'learning-materials',
  true,
  20971520,
  array[
    'application/pdf',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/x-hwp',
    'application/haansofthwp',
    'application/vnd.hancom.hwp',
    'application/octet-stream'
  ]
)
on conflict (id) do update set
  public = true,
  file_size_limit = 20971520,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Public can read learning files" on storage.objects;
create policy "Public can read learning files"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'learning-materials');

drop policy if exists "Teachers can upload learning files" on storage.objects;
drop policy if exists "Teachers can update learning files" on storage.objects;
drop policy if exists "Teachers can delete learning files" on storage.objects;
drop policy if exists "Anyone can upload learning files" on storage.objects;
create policy "Anyone can upload learning files"
on storage.objects for insert
to anon, authenticated
with check (bucket_id = 'learning-materials');

