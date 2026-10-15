-- 모먹교실 학습 자료실: Supabase SQL Editor에서 한 번 실행하세요.
create extension if not exists pgcrypto;

create table if not exists public.teacher_accounts (
  email text primary key check (email = lower(email)),
  created_at timestamptz not null default now()
);

alter table public.teacher_accounts enable row level security;
revoke all on table public.teacher_accounts from anon, authenticated;

create or replace function public.is_momuk_teacher()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.teacher_accounts
    where email = lower(coalesce(auth.jwt()->>'email', ''))
  );
$$;

revoke all on function public.is_momuk_teacher() from public;
grant execute on function public.is_momuk_teacher() to authenticated;

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
grant select on table public.learning_resources to anon, authenticated;
grant insert, update, delete on table public.learning_resources to authenticated;

drop policy if exists "Public can view learning resources" on public.learning_resources;
create policy "Public can view learning resources"
on public.learning_resources for select
to anon, authenticated
using (true);

drop policy if exists "Teachers can add learning resources" on public.learning_resources;
create policy "Teachers can add learning resources"
on public.learning_resources for insert
to authenticated
with check (public.is_momuk_teacher() and created_by = auth.uid());

drop policy if exists "Teachers can update learning resources" on public.learning_resources;
create policy "Teachers can update learning resources"
on public.learning_resources for update
to authenticated
using (public.is_momuk_teacher())
with check (public.is_momuk_teacher());

drop policy if exists "Teachers can delete learning resources" on public.learning_resources;
create policy "Teachers can delete learning resources"
on public.learning_resources for delete
to authenticated
using (public.is_momuk_teacher());

insert into storage.buckets (id, name, public, file_size_limit)
values ('learning-materials', 'learning-materials', true, 20971520)
on conflict (id) do update set public = true, file_size_limit = 20971520;

drop policy if exists "Public can read learning files" on storage.objects;
create policy "Public can read learning files"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'learning-materials');

drop policy if exists "Teachers can upload learning files" on storage.objects;
create policy "Teachers can upload learning files"
on storage.objects for insert
to authenticated
with check (bucket_id = 'learning-materials' and public.is_momuk_teacher());

drop policy if exists "Teachers can update learning files" on storage.objects;
create policy "Teachers can update learning files"
on storage.objects for update
to authenticated
using (bucket_id = 'learning-materials' and public.is_momuk_teacher())
with check (bucket_id = 'learning-materials' and public.is_momuk_teacher());

drop policy if exists "Teachers can delete learning files" on storage.objects;
create policy "Teachers can delete learning files"
on storage.objects for delete
to authenticated
using (bucket_id = 'learning-materials' and public.is_momuk_teacher());

insert into public.teacher_accounts (email)
values ('daamt10@gmail.com')
on conflict (email) do nothing;
