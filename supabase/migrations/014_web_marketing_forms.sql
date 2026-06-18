-- =========================================================
-- Phase 16: Public Web Landing Page Forms
-- =========================================================
create extension if not exists "pgcrypto";

create table if not exists public.waitlist_subscribers (
  id uuid primary key default gen_random_uuid(),
  email text not null,
  source text not null default 'website',
  created_at timestamptz not null default now(),
  constraint waitlist_subscribers_email_check check (email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$')
);

create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  subject text,
  message text not null,
  created_at timestamptz not null default now(),
  constraint contact_messages_email_check check (email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$')
);

create unique index if not exists waitlist_subscribers_email_source_idx on public.waitlist_subscribers(lower(email), source);
create index if not exists waitlist_subscribers_created_at_idx on public.waitlist_subscribers(created_at desc);
create index if not exists contact_messages_created_at_idx on public.contact_messages(created_at desc);

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin');
$$;

alter table public.waitlist_subscribers enable row level security;
alter table public.contact_messages enable row level security;

drop policy if exists "Anyone can join waitlist" on public.waitlist_subscribers;
drop policy if exists "Admins can read waitlist" on public.waitlist_subscribers;
create policy "Anyone can join waitlist" on public.waitlist_subscribers
  for insert to anon, authenticated
  with check (email is not null and source is not null);
create policy "Admins can read waitlist" on public.waitlist_subscribers
  for select to authenticated
  using (public.is_admin());

drop policy if exists "Anyone can submit contact messages" on public.contact_messages;
drop policy if exists "Admins can read contact messages" on public.contact_messages;
create policy "Anyone can submit contact messages" on public.contact_messages
  for insert to anon, authenticated
  with check (name is not null and email is not null and message is not null);
create policy "Admins can read contact messages" on public.contact_messages
  for select to authenticated
  using (public.is_admin());
