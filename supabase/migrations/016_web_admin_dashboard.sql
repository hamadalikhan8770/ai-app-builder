-- =========================================================
-- Phase 18: Full Web Admin Dashboard Compatibility
-- =========================================================
create extension if not exists "pgcrypto";

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_user_id uuid,
  target_user_id uuid,
  action text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.admin_announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  message text not null,
  target_plan text not null default 'all',
  channels text[] not null default '{in_app}',
  status text not null default 'queued',
  created_by uuid,
  created_at timestamptz not null default now()
);

alter table if exists public.profiles add column if not exists disabled boolean not null default false;
alter table if exists public.usage_limits add column if not exists generation_limit int;
alter table if exists public.usage_limits add column if not exists monthly_generation_limit int;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and coalesce(p.disabled,false) = false);
$$;

alter table public.audit_logs enable row level security;
alter table public.admin_announcements enable row level security;

drop policy if exists "Admins read audit logs" on public.audit_logs;
drop policy if exists "Admins insert audit logs" on public.audit_logs;
create policy "Admins read audit logs" on public.audit_logs for select to authenticated using (public.is_admin());
create policy "Admins insert audit logs" on public.audit_logs for insert to authenticated with check (public.is_admin());

drop policy if exists "Admins manage announcements" on public.admin_announcements;
create policy "Admins manage announcements" on public.admin_announcements for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Admin read policies for dashboard tables. Existing user-scoped policies remain active.
do $$ begin
  if to_regclass('public.app_projects') is not null then execute 'drop policy if exists "Admins read all projects" on public.app_projects'; execute 'create policy "Admins read all projects" on public.app_projects for select to authenticated using (public.is_admin())'; end if;
  if to_regclass('public.generated_outputs') is not null then execute 'drop policy if exists "Admins read all generated outputs" on public.generated_outputs'; execute 'create policy "Admins read all generated outputs" on public.generated_outputs for select to authenticated using (public.is_admin())'; end if;
  if to_regclass('public.usage_limits') is not null then execute 'drop policy if exists "Admins manage usage limits" on public.usage_limits'; execute 'create policy "Admins manage usage limits" on public.usage_limits for all to authenticated using (public.is_admin()) with check (public.is_admin())'; end if;
  if to_regclass('public.subscriptions') is not null then execute 'drop policy if exists "Admins read subscriptions" on public.subscriptions'; execute 'create policy "Admins read subscriptions" on public.subscriptions for select to authenticated using (public.is_admin())'; end if;
  if to_regclass('public.team_members') is not null then execute 'drop policy if exists "Admins read team members" on public.team_members'; execute 'create policy "Admins read team members" on public.team_members for select to authenticated using (public.is_admin())'; end if;
end $$;

create index if not exists audit_logs_created_at_idx on public.audit_logs(created_at desc);
create index if not exists admin_announcements_created_at_idx on public.admin_announcements(created_at desc);
