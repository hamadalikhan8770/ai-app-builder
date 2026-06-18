-- =========================================================
-- Phase 20: Security Hardening + Performance Optimization
-- =========================================================

create extension if not exists "pgcrypto";

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and coalesce(p.disabled,false) = false);
$$;

-- Helpful indexes for dashboard/admin queries.
do $$ begin
  if to_regclass('public.profiles') is not null then
    create index if not exists profiles_role_idx on public.profiles(role);
    create index if not exists profiles_subscription_tier_idx on public.profiles(subscription_tier);
    create index if not exists profiles_created_at_idx on public.profiles(created_at desc);
  end if;
  if to_regclass('public.app_projects') is not null then
    create index if not exists app_projects_owner_created_idx on public.app_projects(owner_user_id, created_at desc);
    create index if not exists app_projects_user_created_idx on public.app_projects(user_id, created_at desc);
    create index if not exists app_projects_status_idx on public.app_projects(status);
    create index if not exists app_projects_team_idx on public.app_projects(team_id) where team_id is not null;
  end if;
  if to_regclass('public.generated_outputs') is not null then
    create index if not exists generated_outputs_project_created_idx on public.generated_outputs(project_id, created_at desc);
    create index if not exists generated_outputs_user_created_idx on public.generated_outputs(user_id, created_at desc);
  end if;
  if to_regclass('public.marketplace_templates') is not null then
    create index if not exists marketplace_templates_status_access_idx on public.marketplace_templates(status, access_type);
    create index if not exists marketplace_templates_category_status_idx on public.marketplace_templates(category, status);
  end if;
  if to_regclass('public.marketplace_template_reviews') is not null then
    create index if not exists marketplace_reviews_status_created_idx on public.marketplace_template_reviews(status, created_at desc);
  end if;
  if to_regclass('public.team_members') is not null then
    create index if not exists team_members_user_status_idx on public.team_members(user_id, status);
    create index if not exists team_members_team_status_idx on public.team_members(team_id, status);
  end if;
end $$;

-- Public form tables stay insert-only for anon/authenticated users; admin read only.
alter table if exists public.waitlist_subscribers enable row level security;
alter table if exists public.contact_messages enable row level security;
