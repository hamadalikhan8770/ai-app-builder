-- Phase 10: PDF Export Logs

create extension if not exists "pgcrypto";

create table if not exists public.export_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  output_id uuid references public.generated_outputs(id) on delete set null,
  project_id uuid references public.app_projects(id) on delete set null,
  export_type text not null,
  file_name text not null,
  status text not null,
  error_message text,
  created_at timestamptz not null default now(),

  constraint export_logs_export_type_check
    check (export_type in ('pdf_preview', 'pdf_save', 'pdf_share')),
  constraint export_logs_status_check
    check (status in ('success', 'failed'))
);

create index if not exists export_logs_user_created_idx
on public.export_logs(user_id, created_at desc);

create index if not exists export_logs_output_created_idx
on public.export_logs(output_id, created_at desc);

alter table public.export_logs enable row level security;

drop policy if exists "Users read own export logs" on public.export_logs;
drop policy if exists "Users insert own export logs" on public.export_logs;
drop policy if exists "Admins read all export logs" on public.export_logs;

create policy "Users read own export logs"
on public.export_logs
for select
to authenticated
using (user_id = auth.uid());

create policy "Users insert own export logs"
on public.export_logs
for insert
to authenticated
with check (user_id = auth.uid());

create policy "Admins read all export logs"
on public.export_logs
for select
to authenticated
using (public.is_admin());
