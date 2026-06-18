-- =========================================================
-- Phase 13: Analytics + Usage Reports + Admin Insights
-- =========================================================

create extension if not exists "pgcrypto";

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  event_name text not null,
  event_category text not null,
  entity_type text not null default 'none',
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  platform text,
  app_version text,
  device_id text,
  session_id text,
  created_at timestamptz not null default now(),
  constraint analytics_events_category_check check (event_category in ('auth','project','ai_generation','export','subscription','notification','offline_sync','feedback','admin','system')),
  constraint analytics_events_entity_type_check check (entity_type in ('user','project','generated_output','template','subscription','notification','export','feedback','admin_action','none'))
);

create table if not exists public.user_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  session_id text not null,
  platform text,
  app_version text,
  device_id text,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  last_seen_at timestamptz not null default now(),
  unique(user_id, session_id)
);

create table if not exists public.daily_usage_reports (
  id uuid primary key default gen_random_uuid(),
  report_date date not null unique,
  total_users int not null default 0,
  new_users int not null default 0,
  active_users int not null default 0,
  free_users int not null default 0,
  premium_users int not null default 0,
  admin_users int not null default 0,
  projects_created int not null default 0,
  ai_generations int not null default 0,
  ai_generation_failures int not null default 0,
  template_outputs int not null default 0,
  pdf_exports int not null default 0,
  subscriptions_started int not null default 0,
  notifications_sent int not null default 0,
  feedback_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_daily_usage_reports_updated_at on public.daily_usage_reports;
create trigger set_daily_usage_reports_updated_at before update on public.daily_usage_reports for each row execute function public.set_updated_at();

create table if not exists public.user_usage_summaries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  month_key text not null,
  projects_created int not null default 0,
  ai_generations int not null default 0,
  ai_generation_failures int not null default 0,
  template_outputs int not null default 0,
  pdf_exports int not null default 0,
  notifications_received int not null default 0,
  last_active_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, month_key),
  constraint user_usage_summaries_month_key_check check (month_key ~ '^\d{4}-\d{2}$')
);

drop trigger if exists set_user_usage_summaries_updated_at on public.user_usage_summaries;
create trigger set_user_usage_summaries_updated_at before update on public.user_usage_summaries for each row execute function public.set_updated_at();

create index if not exists analytics_events_user_id_idx on public.analytics_events(user_id);
create index if not exists analytics_events_name_idx on public.analytics_events(event_name);
create index if not exists analytics_events_created_at_idx on public.analytics_events(created_at desc);
create index if not exists analytics_events_category_idx on public.analytics_events(event_category);
create index if not exists user_sessions_user_id_idx on public.user_sessions(user_id);
create index if not exists user_sessions_last_seen_idx on public.user_sessions(last_seen_at desc);
create index if not exists daily_usage_reports_date_idx on public.daily_usage_reports(report_date desc);
create index if not exists user_usage_summaries_user_month_idx on public.user_usage_summaries(user_id, month_key desc);

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
      and coalesce(p.is_disabled, false) = false
      and coalesce(p.is_blocked, false) = false
  );
$$;

alter table public.analytics_events enable row level security;
alter table public.user_sessions enable row level security;
alter table public.daily_usage_reports enable row level security;
alter table public.user_usage_summaries enable row level security;

drop policy if exists "Users insert own analytics events" on public.analytics_events;
drop policy if exists "Users read own analytics events or admins read all" on public.analytics_events;
create policy "Users insert own analytics events" on public.analytics_events for insert to authenticated with check (auth.uid() = user_id);
create policy "Users read own analytics events or admins read all" on public.analytics_events for select to authenticated using (auth.uid() = user_id or public.is_admin());

drop policy if exists "Users manage own sessions or admins read all" on public.user_sessions;
drop policy if exists "Users insert own sessions" on public.user_sessions;
drop policy if exists "Users update own sessions" on public.user_sessions;
create policy "Users manage own sessions or admins read all" on public.user_sessions for select to authenticated using (auth.uid() = user_id or public.is_admin());
create policy "Users insert own sessions" on public.user_sessions for insert to authenticated with check (auth.uid() = user_id);
create policy "Users update own sessions" on public.user_sessions for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Admins read daily reports" on public.daily_usage_reports;
create policy "Admins read daily reports" on public.daily_usage_reports for select to authenticated using (public.is_admin());

drop policy if exists "Users read own usage summaries or admins read all" on public.user_usage_summaries;
create policy "Users read own usage summaries or admins read all" on public.user_usage_summaries for select to authenticated using (auth.uid() = user_id or public.is_admin());

create or replace function public.increment_user_usage_summary()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  mk text := to_char(coalesce(new.created_at, now()), 'YYYY-MM');
begin
  if new.user_id is null then
    return new;
  end if;

  insert into public.user_usage_summaries (
    user_id, month_key, projects_created, ai_generations, ai_generation_failures,
    template_outputs, pdf_exports, notifications_received, last_active_at
  ) values (
    new.user_id,
    mk,
    case when new.event_name = 'project_created' then 1 else 0 end,
    case when new.event_name in ('ai_plan_generated','template_output_generated') then 1 else 0 end,
    case when new.event_name = 'generation_failed' then 1 else 0 end,
    case when new.event_name = 'template_output_generated' then 1 else 0 end,
    case when new.event_name in ('pdf_exported','pdf_shared','pdf_saved') then 1 else 0 end,
    case when new.event_name = 'notification_sent' then 1 else 0 end,
    now()
  )
  on conflict (user_id, month_key) do update set
    projects_created = user_usage_summaries.projects_created + excluded.projects_created,
    ai_generations = user_usage_summaries.ai_generations + excluded.ai_generations,
    ai_generation_failures = user_usage_summaries.ai_generation_failures + excluded.ai_generation_failures,
    template_outputs = user_usage_summaries.template_outputs + excluded.template_outputs,
    pdf_exports = user_usage_summaries.pdf_exports + excluded.pdf_exports,
    notifications_received = user_usage_summaries.notifications_received + excluded.notifications_received,
    last_active_at = now(),
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists increment_user_usage_summary_trigger on public.analytics_events;
create trigger increment_user_usage_summary_trigger after insert on public.analytics_events for each row execute function public.increment_user_usage_summary();

create or replace function public.admin_platform_summary()
returns table (
  total_users bigint,
  new_users bigint,
  active_users bigint,
  free_users bigint,
  premium_users bigint,
  admin_users bigint,
  total_projects bigint,
  total_generations bigint,
  failed_generations bigint,
  total_exports bigint,
  notifications_sent bigint,
  feedback_count bigint,
  subscriptions_started bigint
)
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  return query
  select
    (select count(*) from public.profiles),
    (select count(*) from public.profiles where created_at >= now() - interval '30 days'),
    (select count(distinct user_id) from public.analytics_events where created_at >= now() - interval '30 days'),
    (select count(*) from public.profiles where role = 'free_user'),
    (select count(*) from public.profiles where role = 'premium_user' or subscription_tier = 'premium'),
    (select count(*) from public.profiles where role = 'admin'),
    (select count(*) from public.app_projects),
    (select count(*) from public.ai_generations),
    (select count(*) from public.ai_generations where status = 'failed'),
    (select count(*) from public.export_logs where status = 'success'),
    (select count(*) from public.notifications where status in ('sent','read')),
    (select count(*) from public.feedback),
    (select count(*) from public.analytics_events where event_name in ('subscription_started','subscription_restored'));
end;
$$;

create or replace function public.admin_daily_usage()
returns setof public.daily_usage_reports language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  return query select * from public.daily_usage_reports order by report_date desc limit 90;
end;
$$;

create or replace function public.admin_template_usage()
returns table(template_id uuid, template_title text, output_type text, generation_count bigint, success_count bigint, failure_count bigint)
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  return query
  select pt.id, pt.title, pt.output_type,
    count(ag.id),
    count(ag.id) filter (where ag.status = 'success'),
    count(ag.id) filter (where ag.status = 'failed')
  from public.prompt_templates pt
  left join public.ai_generations ag on ag.template_id = pt.id
  group by pt.id, pt.title, pt.output_type
  order by count(ag.id) desc, pt.title;
end;
$$;

create or replace function public.admin_subscription_summary()
returns table(free_users bigint, premium_users bigint, active_subscriptions bigint, expired_subscriptions bigint, billing_issues bigint)
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  return query
  select
    (select count(*) from public.profiles where role = 'free_user'),
    (select count(*) from public.profiles where role = 'premium_user' or subscription_tier = 'premium'),
    (select count(*) from public.subscriptions where status = 'active'),
    (select count(*) from public.subscriptions where status in ('expired','canceled')),
    (select count(*) from public.subscriptions where status in ('billing_issue','past_due'));
end;
$$;

create or replace function public.admin_failure_stats()
returns table(event_date date, failure_type text, failure_count bigint)
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'Admin access required'; end if;
  return query
  select created_at::date, event_name, count(*)
  from public.analytics_events
  where event_name in ('generation_failed','offline_sync_failed')
  group by created_at::date, event_name
  order by created_at::date desc, event_name;
end;
$$;
