-- =========================================================
-- Phase 14: Team Collaboration + Shared Projects + Roles
-- =========================================================
create extension if not exists "pgcrypto";

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

create table if not exists public.app_projects (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Untitled Project',
  description text,
  owner_user_id uuid references public.profiles(id) on delete cascade,
  created_by_user_id uuid references public.profiles(id) on delete set null,
  user_id uuid references public.profiles(id) on delete cascade,
  team_id uuid,
  visibility text not null default 'private',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table if exists public.app_projects add column if not exists team_id uuid;
alter table if exists public.app_projects add column if not exists visibility text not null default 'private';
alter table if exists public.app_projects add column if not exists created_by_user_id uuid references public.profiles(id) on delete set null;
alter table if exists public.app_projects add column if not exists owner_user_id uuid references public.profiles(id) on delete cascade;
alter table if exists public.app_projects add constraint app_projects_visibility_check check (visibility in ('private','team')) not valid;

create table if not exists public.teams (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  slug text not null unique,
  description text,
  avatar_url text,
  plan_type text not null default 'free' check (plan_type in ('free','premium','enterprise')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.team_members (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null check (role in ('owner','admin','editor','viewer')),
  status text not null default 'active' check (status in ('active','invited','removed','left')),
  invited_by uuid references public.profiles(id) on delete set null,
  joined_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(team_id, user_id)
);

create table if not exists public.team_invites (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  email text not null,
  role text not null check (role in ('admin','editor','viewer')),
  token text not null unique,
  invited_by uuid references public.profiles(id) on delete set null,
  status text not null default 'pending' check (status in ('pending','accepted','declined','expired','canceled')),
  expires_at timestamptz not null default (now() + interval '7 days'),
  accepted_at timestamptz,
  declined_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(team_id, email, status)
);

create table if not exists public.project_shares (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.app_projects(id) on delete cascade,
  team_id uuid not null references public.teams(id) on delete cascade,
  shared_by uuid references public.profiles(id) on delete set null,
  permission text not null default 'view' check (permission in ('view','edit','manage')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(project_id, team_id)
);

create table if not exists public.team_activity_logs (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  actor_user_id uuid references public.profiles(id) on delete set null,
  action text not null check (action in ('team_created','member_invited','invite_accepted','invite_declined','member_removed','member_role_changed','project_shared','project_unshared','project_created','project_updated','project_deleted','ai_generated','pdf_exported','ownership_transferred','team_deleted')),
  entity_type text not null default 'none',
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.app_projects add constraint app_projects_team_fk foreign key (team_id) references public.teams(id) on delete set null not valid;

drop trigger if exists set_teams_updated_at on public.teams; create trigger set_teams_updated_at before update on public.teams for each row execute function public.set_updated_at();
drop trigger if exists set_team_members_updated_at on public.team_members; create trigger set_team_members_updated_at before update on public.team_members for each row execute function public.set_updated_at();
drop trigger if exists set_team_invites_updated_at on public.team_invites; create trigger set_team_invites_updated_at before update on public.team_invites for each row execute function public.set_updated_at();
drop trigger if exists set_project_shares_updated_at on public.project_shares; create trigger set_project_shares_updated_at before update on public.project_shares for each row execute function public.set_updated_at();

create index if not exists teams_owner_idx on public.teams(owner_user_id);
create index if not exists team_members_team_user_idx on public.team_members(team_id, user_id);
create index if not exists team_members_user_idx on public.team_members(user_id);
create index if not exists team_invites_email_idx on public.team_invites(lower(email));
create index if not exists project_shares_project_idx on public.project_shares(project_id);
create index if not exists project_shares_team_idx on public.project_shares(team_id);
create index if not exists team_activity_logs_team_idx on public.team_activity_logs(team_id, created_at desc);
create index if not exists app_projects_team_idx on public.app_projects(team_id);

create or replace function public.is_team_member(p_team_id uuid, p_user_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.team_members tm where tm.team_id = p_team_id and tm.user_id = p_user_id and tm.status = 'active');
$$;

create or replace function public.get_team_role(p_team_id uuid, p_user_id uuid)
returns text language sql stable security definer set search_path = public as $$
  select tm.role from public.team_members tm where tm.team_id = p_team_id and tm.user_id = p_user_id and tm.status = 'active' limit 1;
$$;

create or replace function public.can_manage_team(p_team_id uuid, p_user_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select coalesce(public.get_team_role(p_team_id, p_user_id) in ('owner','admin'), false);
$$;

create or replace function public.can_edit_team_project(p_project_id uuid, p_user_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists(
    select 1 from public.app_projects p
    left join public.project_shares ps on ps.project_id = p.id
    where p.id = p_project_id and (
      coalesce(p.owner_user_id, p.user_id) = p_user_id or
      (p.team_id is not null and public.get_team_role(p.team_id, p_user_id) in ('owner','admin','editor')) or
      (ps.team_id is not null and ps.permission in ('edit','manage') and public.get_team_role(ps.team_id, p_user_id) in ('owner','admin','editor'))
    )
  );
$$;

create or replace function public.can_view_team_project(p_project_id uuid, p_user_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists(
    select 1 from public.app_projects p
    left join public.project_shares ps on ps.project_id = p.id
    where p.id = p_project_id and (
      coalesce(p.owner_user_id, p.user_id) = p_user_id or
      (p.team_id is not null and public.is_team_member(p.team_id, p_user_id)) or
      (ps.team_id is not null and public.is_team_member(ps.team_id, p_user_id))
    )
  );
$$;

alter table public.teams enable row level security;
alter table public.team_members enable row level security;
alter table public.team_invites enable row level security;
alter table public.project_shares enable row level security;
alter table public.team_activity_logs enable row level security;
alter table public.app_projects enable row level security;

drop policy if exists "Team members view teams" on public.teams;
drop policy if exists "Authenticated users create teams" on public.teams;
drop policy if exists "Owners update teams" on public.teams;
drop policy if exists "Owners delete teams" on public.teams;
create policy "Team members view teams" on public.teams for select to authenticated using (public.is_team_member(id, auth.uid()));
create policy "Authenticated users create teams" on public.teams for insert to authenticated with check (owner_user_id = auth.uid());
create policy "Owners update teams" on public.teams for update to authenticated using (public.get_team_role(id, auth.uid()) = 'owner') with check (public.get_team_role(id, auth.uid()) = 'owner');
create policy "Owners delete teams" on public.teams for delete to authenticated using (public.get_team_role(id, auth.uid()) = 'owner');

drop policy if exists "Members view team member list" on public.team_members;
drop policy if exists "Managers insert team members" on public.team_members;
drop policy if exists "Members update own leave managers manage" on public.team_members;
create policy "Members view team member list" on public.team_members for select to authenticated using (public.is_team_member(team_id, auth.uid()));
create policy "Managers insert team members" on public.team_members for insert to authenticated with check (public.can_manage_team(team_id, auth.uid()) or user_id = auth.uid());
create policy "Members update own leave managers manage" on public.team_members for update to authenticated using (user_id = auth.uid() or public.can_manage_team(team_id, auth.uid())) with check (user_id = auth.uid() or public.can_manage_team(team_id, auth.uid()));

drop policy if exists "Team managers and invited email view invites" on public.team_invites;
drop policy if exists "Managers create invites" on public.team_invites;
drop policy if exists "Managers or invited email update invites" on public.team_invites;
create policy "Team managers and invited email view invites" on public.team_invites for select to authenticated using (public.can_manage_team(team_id, auth.uid()) or lower(email) = lower((auth.jwt() ->> 'email')));
create policy "Managers create invites" on public.team_invites for insert to authenticated with check (public.can_manage_team(team_id, auth.uid()));
create policy "Managers or invited email update invites" on public.team_invites for update to authenticated using (public.can_manage_team(team_id, auth.uid()) or lower(email) = lower((auth.jwt() ->> 'email'))) with check (public.can_manage_team(team_id, auth.uid()) or lower(email) = lower((auth.jwt() ->> 'email')));

drop policy if exists "Team members view project shares" on public.project_shares;
drop policy if exists "Project owners or managers manage shares" on public.project_shares;
create policy "Team members view project shares" on public.project_shares for select to authenticated using (public.is_team_member(team_id, auth.uid()) or public.can_view_team_project(project_id, auth.uid()));
create policy "Project owners or managers manage shares" on public.project_shares for all to authenticated using (public.can_manage_team(team_id, auth.uid()) or exists(select 1 from public.app_projects p where p.id = project_id and coalesce(p.owner_user_id, p.user_id) = auth.uid())) with check (public.can_manage_team(team_id, auth.uid()) or exists(select 1 from public.app_projects p where p.id = project_id and coalesce(p.owner_user_id, p.user_id) = auth.uid()));

drop policy if exists "Team members read activity" on public.team_activity_logs;
create policy "Team members read activity" on public.team_activity_logs for select to authenticated using (public.is_team_member(team_id, auth.uid()));

drop policy if exists "Users and team members view projects" on public.app_projects;
drop policy if exists "Users and team editors create projects" on public.app_projects;
drop policy if exists "Owners and team editors update projects" on public.app_projects;
drop policy if exists "Owners and team managers delete projects" on public.app_projects;
create policy "Users and team members view projects" on public.app_projects for select to authenticated using (coalesce(owner_user_id, user_id) = auth.uid() or public.can_view_team_project(id, auth.uid()));
create policy "Users and team editors create projects" on public.app_projects for insert to authenticated with check (coalesce(owner_user_id, user_id) = auth.uid() or (team_id is not null and public.get_team_role(team_id, auth.uid()) in ('owner','admin','editor')));
create policy "Owners and team editors update projects" on public.app_projects for update to authenticated using (coalesce(owner_user_id, user_id) = auth.uid() or public.can_edit_team_project(id, auth.uid())) with check (coalesce(owner_user_id, user_id) = auth.uid() or public.can_edit_team_project(id, auth.uid()));
create policy "Owners and team managers delete projects" on public.app_projects for delete to authenticated using (coalesce(owner_user_id, user_id) = auth.uid() or (team_id is not null and public.get_team_role(team_id, auth.uid()) in ('owner','admin')));

-- generated_outputs policy update when table exists
create table if not exists public.generated_outputs (id uuid primary key default gen_random_uuid(), project_id uuid references public.app_projects(id) on delete cascade, user_id uuid references public.profiles(id) on delete cascade, content text, created_at timestamptz not null default now());
alter table public.generated_outputs enable row level security;
drop policy if exists "Users and team members view outputs" on public.generated_outputs;
create policy "Users and team members view outputs" on public.generated_outputs for select to authenticated using (user_id = auth.uid() or public.can_view_team_project(project_id, auth.uid()));
