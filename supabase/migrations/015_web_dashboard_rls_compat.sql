-- =========================================================
-- Phase 17: Web Dashboard MVP RLS Compatibility
-- Safe compatibility migration for browser dashboard access.
-- =========================================================

create extension if not exists "pgcrypto";

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin');
$$;

-- Profiles: own profile read/update full_name; admins read all.
do $$ begin
  if to_regclass('public.profiles') is not null then
    execute 'alter table public.profiles enable row level security';
    execute 'drop policy if exists "Web users read own profile" on public.profiles';
    execute 'drop policy if exists "Web users update own profile" on public.profiles';
    execute 'drop policy if exists "Admins read profiles" on public.profiles';
    execute 'create policy "Web users read own profile" on public.profiles for select to authenticated using (id = auth.uid())';
    execute 'create policy "Web users update own profile" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid())';
    execute 'create policy "Admins read profiles" on public.profiles for select to authenticated using (public.is_admin())';
  end if;
end $$;

-- App projects: add web MVP columns and own-project policies without breaking mobile/team policies.
do $$ begin
  if to_regclass('public.app_projects') is not null then
    execute 'alter table public.app_projects add column if not exists title text';
    execute 'alter table public.app_projects add column if not exists name text';
    execute 'alter table public.app_projects add column if not exists user_id uuid';
    execute 'alter table public.app_projects add column if not exists owner_user_id uuid';
    execute 'alter table public.app_projects add column if not exists created_by_user_id uuid';
    execute 'alter table public.app_projects add column if not exists visibility text not null default ''private''';
    execute 'alter table public.app_projects add column if not exists target_platform text';
    execute 'alter table public.app_projects add column if not exists selected_stack text';
    execute 'alter table public.app_projects add column if not exists main_features text[] not null default ''{}''';
    execute 'alter table public.app_projects add column if not exists status text not null default ''draft''';
    execute 'alter table public.app_projects enable row level security';
    execute 'drop policy if exists "Web users read own projects" on public.app_projects';
    execute 'drop policy if exists "Web users create own projects" on public.app_projects';
    execute 'drop policy if exists "Web users update own projects" on public.app_projects';
    execute 'create policy "Web users read own projects" on public.app_projects for select to authenticated using (coalesce(owner_user_id, user_id, created_by_user_id) = auth.uid() or public.is_admin())';
    execute 'create policy "Web users create own projects" on public.app_projects for insert to authenticated with check (coalesce(owner_user_id, user_id, created_by_user_id) = auth.uid())';
    execute 'create policy "Web users update own projects" on public.app_projects for update to authenticated using (coalesce(owner_user_id, user_id, created_by_user_id) = auth.uid()) with check (coalesce(owner_user_id, user_id, created_by_user_id) = auth.uid())';
  end if;
end $$;

-- Generated outputs: own outputs through project ownership, admins all.
do $$ begin
  if to_regclass('public.generated_outputs') is not null then
    execute 'alter table public.generated_outputs enable row level security';
    execute 'drop policy if exists "Web users read own generated outputs" on public.generated_outputs';
    execute 'create policy "Web users read own generated outputs" on public.generated_outputs for select to authenticated using (public.is_admin() or exists (select 1 from public.app_projects p where p.id = generated_outputs.project_id and coalesce(p.owner_user_id, p.user_id, p.created_by_user_id) = auth.uid()))';
  end if;
end $$;

-- Usage/subscription rows: own rows read, admin all if tables exist.
do $$ begin
  if to_regclass('public.usage_limits') is not null then
    execute 'alter table public.usage_limits enable row level security';
    execute 'drop policy if exists "Web users read own usage limits" on public.usage_limits';
    execute 'create policy "Web users read own usage limits" on public.usage_limits for select to authenticated using (user_id = auth.uid() or public.is_admin())';
  end if;
  if to_regclass('public.subscriptions') is not null then
    execute 'alter table public.subscriptions enable row level security';
    execute 'drop policy if exists "Web users read own subscriptions" on public.subscriptions';
    execute 'create policy "Web users read own subscriptions" on public.subscriptions for select to authenticated using (user_id = auth.uid() or public.is_admin())';
  end if;
end $$;
