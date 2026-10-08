-- MELO PRIVATE VAULT / Supabase SQL Editor
-- Run in the Supabase project used exclusively for Melo Player.
-- Files are private: never make bucket public or expose a service_role key to the website.

create table if not exists public.melo_tracks (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 500),
  artist text not null default '',
  album text not null default '',
  genre text not null default '',
  release_year text not null default '',
  format text not null default '',
  original_name text not null default '',
  file_path text not null,
  file_size bigint not null default 0 check (file_size >= 0),
  duration double precision not null default 0 check (duration >= 0),
  cover_path text,
  lyrics text not null default '',
  is_favorite boolean not null default false,
  play_count integer not null default 0 check (play_count >= 0),
  listen_seconds double precision not null default 0 check (listen_seconds >= 0),
  played_at timestamptz,
  created_at timestamptz not null default now(),
  unique (owner_id, file_path),
  constraint melo_path_scoped_to_owner check (
     split_part(file_path, '/', 1) = owner_id::text
     and (cover_path is null or split_part(cover_path, '/', 1) = owner_id::text)
  )
);
create index if not exists melo_tracks_owner_created_idx on public.melo_tracks(owner_id,created_at desc);
alter table public.melo_tracks enable row level security;

-- Ensure only signed-in users can call this table. RLS below enforces identity.
revoke all on public.melo_tracks from anon;
grant select, insert, update, delete on public.melo_tracks to authenticated;

-- These names are safe to re-run in a Melo-only Supabase project.
drop policy if exists "melo_tracks_select_own" on public.melo_tracks;
create policy "melo_tracks_select_own" on public.melo_tracks
  for select to authenticated using ((select auth.uid()) = owner_id);
drop policy if exists "melo_tracks_insert_own" on public.melo_tracks;
create policy "melo_tracks_insert_own" on public.melo_tracks
  for insert to authenticated with check ((select auth.uid()) = owner_id);
drop policy if exists "melo_tracks_update_own" on public.melo_tracks;
create policy "melo_tracks_update_own" on public.melo_tracks
  for update to authenticated using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);
drop policy if exists "melo_tracks_delete_own" on public.melo_tracks;
create policy "melo_tracks_delete_own" on public.melo_tracks
  for delete to authenticated using ((select auth.uid()) = owner_id);

insert into storage.buckets (id,name,public,file_size_limit)
values ('melo-private','melo-private',false,52428800)
on conflict (id) do update set public=false,file_size_limit=52428800;

-- These policies apply *only* to storage objects under the UUID folder of a signed-in user.
-- File names are generated as UUIDs; nobody else can list, sign, or delete them.
drop policy if exists "melo_storage_select_own" on storage.objects;
create policy "melo_storage_select_own" on storage.objects
  for select to authenticated using (
    bucket_id = 'melo-private' and (storage.foldername(name))[1] = (select auth.uid())::text
  );
drop policy if exists "melo_storage_insert_own" on storage.objects;
create policy "melo_storage_insert_own" on storage.objects
  for insert to authenticated with check (
    bucket_id = 'melo-private'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and lower(storage.extension(name)) in ('mp3','flac','m4a','wav','ogg','oga','opus','aac','jpg','jpeg','png','webp')
  );
drop policy if exists "melo_storage_delete_own" on storage.objects;
create policy "melo_storage_delete_own" on storage.objects
  for delete to authenticated using (
    bucket_id = 'melo-private' and (storage.foldername(name))[1] = (select auth.uid())::text
  );
