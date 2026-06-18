-- =========================================================
-- Phase 15: Marketplace / Template Store + Public Templates
-- =========================================================
create extension if not exists "pgcrypto";

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;

create table if not exists public.marketplace_templates (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  short_description text not null,
  full_description text not null,
  category text not null check (category in ('business','ecommerce','food_delivery','booking','education','health','fitness','finance','productivity','social','real_estate','logistics','ai_tools','marketplace','crm','pos','portfolio','other')),
  template_type text not null check (template_type in ('app_starter','ui_kit','backend_schema','prompt_pack','full_project_plan','code_starter','store_listing_pack','admin_panel_template','ai_workflow_template')),
  target_platform text not null default 'ios_android',
  recommended_stack text not null default 'Flutter + Supabase',
  difficulty text not null check (difficulty in ('beginner','intermediate','advanced')),
  access_type text not null default 'free' check (access_type in ('free','premium','admin_only')),
  cover_image_url text,
  preview_images text[] not null default '{}',
  tags text[] not null default '{}',
  features text[] not null default '{}',
  included_outputs text[] not null default '{}',
  template_payload jsonb not null default '{}'::jsonb,
  created_by uuid references public.profiles(id) on delete set null,
  status text not null default 'draft' check (status in ('draft','published','archived','rejected')),
  is_featured boolean not null default false,
  usage_count int not null default 0,
  favorite_count int not null default 0,
  rating_average numeric(3,2) not null default 0,
  rating_count int not null default 0,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.marketplace_template_favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  template_id uuid not null references public.marketplace_templates(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(user_id, template_id)
);

create table if not exists public.marketplace_template_reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  template_id uuid not null references public.marketplace_templates(id) on delete cascade,
  rating int not null check (rating between 1 and 5),
  review_text text,
  status text not null default 'pending' check (status in ('pending','published','hidden')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, template_id)
);

create table if not exists public.marketplace_template_usage (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  template_id uuid not null references public.marketplace_templates(id) on delete cascade,
  project_id uuid references public.app_projects(id) on delete set null,
  action_type text not null check (action_type in ('viewed','favorited','unfavorited','used','reviewed')),
  created_at timestamptz not null default now()
);

alter table if exists public.app_projects add column if not exists template_id uuid references public.marketplace_templates(id) on delete set null;
alter table if exists public.app_projects add column if not exists target_platform text;
alter table if exists public.app_projects add column if not exists selected_stack text;
alter table if exists public.app_projects add column if not exists main_features text[] not null default '{}';
alter table if exists public.app_projects add column if not exists status text not null default 'planning';

create index if not exists marketplace_templates_status_idx on public.marketplace_templates(status);
create index if not exists marketplace_templates_category_idx on public.marketplace_templates(category);
create index if not exists marketplace_templates_access_idx on public.marketplace_templates(access_type);
create index if not exists marketplace_templates_featured_idx on public.marketplace_templates(is_featured);
create index if not exists marketplace_favorites_user_idx on public.marketplace_template_favorites(user_id);
create index if not exists marketplace_reviews_template_idx on public.marketplace_template_reviews(template_id, status);
create index if not exists marketplace_usage_template_idx on public.marketplace_template_usage(template_id, action_type);

drop trigger if exists marketplace_templates_updated_at on public.marketplace_templates; create trigger marketplace_templates_updated_at before update on public.marketplace_templates for each row execute function public.set_updated_at();
drop trigger if exists marketplace_reviews_updated_at on public.marketplace_template_reviews; create trigger marketplace_reviews_updated_at before update on public.marketplace_template_reviews for each row execute function public.set_updated_at();

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin');
$$;

create or replace function public.user_has_premium_access(p_user_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.profiles p where p.id = p_user_id and (p.role = 'admin' or p.role = 'premium_user' or p.subscription_tier = 'premium'));
$$;

create or replace function public.recalculate_marketplace_template_rating(p_template_id uuid)
returns void language plpgsql security definer set search_path = public as $$
begin
  update public.marketplace_templates t set
    rating_average = coalesce((select round(avg(rating)::numeric, 2) from public.marketplace_template_reviews where template_id = p_template_id and status = 'published'), 0),
    rating_count = coalesce((select count(*) from public.marketplace_template_reviews where template_id = p_template_id and status = 'published'), 0)
  where t.id = p_template_id;
end; $$;

create or replace function public.update_marketplace_counts()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if tg_table_name = 'marketplace_template_favorites' then
    update public.marketplace_templates set favorite_count = (select count(*) from public.marketplace_template_favorites where template_id = coalesce(new.template_id, old.template_id)) where id = coalesce(new.template_id, old.template_id);
  elsif tg_table_name = 'marketplace_template_usage' and new.action_type = 'used' then
    update public.marketplace_templates set usage_count = usage_count + 1 where id = new.template_id;
  end if;
  return coalesce(new, old);
end; $$;

drop trigger if exists marketplace_favorite_count_insert on public.marketplace_template_favorites; create trigger marketplace_favorite_count_insert after insert or delete on public.marketplace_template_favorites for each row execute function public.update_marketplace_counts();
drop trigger if exists marketplace_usage_count_insert on public.marketplace_template_usage; create trigger marketplace_usage_count_insert after insert on public.marketplace_template_usage for each row execute function public.update_marketplace_counts();

alter table public.marketplace_templates enable row level security;
alter table public.marketplace_template_favorites enable row level security;
alter table public.marketplace_template_reviews enable row level security;
alter table public.marketplace_template_usage enable row level security;

drop policy if exists "Authenticated users read published marketplace templates" on public.marketplace_templates;
drop policy if exists "Admins manage marketplace templates" on public.marketplace_templates;
create policy "Authenticated users read published marketplace templates" on public.marketplace_templates for select to authenticated using (status = 'published' and (access_type in ('free','premium') or public.is_admin()));
create policy "Admins manage marketplace templates" on public.marketplace_templates for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "Users manage own favorites" on public.marketplace_template_favorites;
drop policy if exists "Users read own favorites admins all" on public.marketplace_template_favorites;
create policy "Users read own favorites admins all" on public.marketplace_template_favorites for select to authenticated using (user_id = auth.uid() or public.is_admin());
create policy "Users manage own favorites" on public.marketplace_template_favorites for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "Read published reviews" on public.marketplace_template_reviews;
drop policy if exists "Users create own reviews" on public.marketplace_template_reviews;
drop policy if exists "Users update own pending reviews admins moderate" on public.marketplace_template_reviews;
create policy "Read published reviews" on public.marketplace_template_reviews for select to authenticated using (status = 'published' or user_id = auth.uid() or public.is_admin());
create policy "Users create own reviews" on public.marketplace_template_reviews for insert to authenticated with check (user_id = auth.uid());
create policy "Users update own pending reviews admins moderate" on public.marketplace_template_reviews for update to authenticated using ((user_id = auth.uid() and status = 'pending') or public.is_admin()) with check ((user_id = auth.uid()) or public.is_admin());

drop policy if exists "Users insert own usage" on public.marketplace_template_usage;
drop policy if exists "Users read own usage admins all" on public.marketplace_template_usage;
create policy "Users insert own usage" on public.marketplace_template_usage for insert to authenticated with check (user_id = auth.uid());
create policy "Users read own usage admins all" on public.marketplace_template_usage for select to authenticated using (user_id = auth.uid() or public.is_admin());

insert into public.marketplace_templates (title, slug, short_description, full_description, category, template_type, target_platform, recommended_stack, difficulty, access_type, tags, features, included_outputs, template_payload, status, is_featured, published_at) values
('Food Delivery App','food-delivery-app','Food Delivery App starter template','A production-ready food delivery app blueprint with screens, schema, features, and launch checklist.','food_delivery','full_project_plan','ios_android','Flutter + Supabase + Maps','intermediate','premium', array['food delivery', 'mobile', 'template']::text[], array['Restaurant menu', 'Cart checkout', 'Driver tracking', 'Order admin']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase + Maps", "main_features": ["Restaurant menu", "Cart checkout", "Driver tracking", "Order admin"], "status": "planning"}'::jsonb, 'published', true, now()),
('Booking Appointment App','booking-appointment-app','Booking Appointment App starter template','A production-ready booking appointment app blueprint with screens, schema, features, and launch checklist.','booking','app_starter','ios_android','Flutter + Supabase','beginner','free', array['booking', 'mobile', 'template']::text[], array['Calendar slots', 'Staff profiles', 'Booking reminders', 'Admin schedule']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase", "main_features": ["Calendar slots", "Staff profiles", "Booking reminders", "Admin schedule"], "status": "planning"}'::jsonb, 'published', true, now()),
('E-commerce Store App','ecommerce-store-app','E-commerce Store App starter template','A production-ready e-commerce store app blueprint with screens, schema, features, and launch checklist.','ecommerce','full_project_plan','ios_android','Flutter + Supabase + RevenueCat','intermediate','premium', array['ecommerce', 'mobile', 'template']::text[], array['Product catalog', 'Cart', 'Orders', 'Inventory admin']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase + RevenueCat", "main_features": ["Product catalog", "Cart", "Orders", "Inventory admin"], "status": "planning"}'::jsonb, 'published', true, now()),
('Fitness Tracker App','fitness-tracker-app','Fitness Tracker App starter template','A production-ready fitness tracker app blueprint with screens, schema, features, and launch checklist.','fitness','ui_kit','ios_android','Flutter + Hive + Supabase','beginner','free', array['fitness', 'mobile', 'template']::text[], array['Workout logs', 'Progress charts', 'Goals', 'Profile stats']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Hive + Supabase", "main_features": ["Workout logs", "Progress charts", "Goals", "Profile stats"], "status": "planning"}'::jsonb, 'published', true, now()),
('Learning Management App','learning-management-app','Learning Management App starter template','A production-ready learning management app blueprint with screens, schema, features, and launch checklist.','education','full_project_plan','ios_android','Flutter + Supabase Storage','advanced','premium', array['education', 'mobile', 'template']::text[], array['Courses', 'Lessons', 'Quizzes', 'Instructor dashboard']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase Storage", "main_features": ["Courses", "Lessons", "Quizzes", "Instructor dashboard"], "status": "planning"}'::jsonb, 'published', false, now()),
('Real Estate Listing App','real-estate-listing-app','Real Estate Listing App starter template','A production-ready real estate listing app blueprint with screens, schema, features, and launch checklist.','real_estate','app_starter','ios_android','Flutter + Supabase + Maps','intermediate','free', array['real estate', 'mobile', 'template']::text[], array['Listings', 'Saved homes', 'Agent contact', 'Map search']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase + Maps", "main_features": ["Listings", "Saved homes", "Agent contact", "Map search"], "status": "planning"}'::jsonb, 'published', false, now()),
('POS Inventory App','pos-inventory-app','POS Inventory App starter template','A production-ready pos inventory app blueprint with screens, schema, features, and launch checklist.','pos','backend_schema','ios_android','Flutter + Supabase','advanced','premium', array['pos', 'mobile', 'template']::text[], array['Inventory', 'Sales', 'Receipts', 'Staff roles']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase", "main_features": ["Inventory", "Sales", "Receipts", "Staff roles"], "status": "planning"}'::jsonb, 'published', false, now()),
('AI Chatbot App','ai-chatbot-app','AI Chatbot App starter template','A production-ready ai chatbot app blueprint with screens, schema, features, and launch checklist.','ai_tools','ai_workflow_template','ios_android','Flutter + Supabase Edge Functions','advanced','premium', array['ai tools', 'mobile', 'template']::text[], array['Chat UI', 'Prompt templates', 'Usage limits', 'Conversation history']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase Edge Functions", "main_features": ["Chat UI", "Prompt templates", "Usage limits", "Conversation history"], "status": "planning"}'::jsonb, 'published', false, now()),
('CRM Sales App','crm-sales-app','CRM Sales App starter template','A production-ready crm sales app blueprint with screens, schema, features, and launch checklist.','crm','admin_panel_template','ios_android','Flutter + Supabase','intermediate','premium', array['crm', 'mobile', 'template']::text[], array['Leads', 'Deals', 'Pipeline', 'Tasks']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase", "main_features": ["Leads", "Deals", "Pipeline", "Tasks"], "status": "planning"}'::jsonb, 'published', false, now()),
('Portfolio Builder App','portfolio-builder-app','Portfolio Builder App starter template','A production-ready portfolio builder app blueprint with screens, schema, features, and launch checklist.','portfolio','code_starter','ios_android','Flutter + Supabase','beginner','free', array['portfolio', 'mobile', 'template']::text[], array['Projects', 'Themes', 'Contact form', 'Share profile']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase", "main_features": ["Projects", "Themes", "Contact form", "Share profile"], "status": "planning"}'::jsonb, 'published', false, now()),
('Delivery Tracking App','delivery-tracking-app','Delivery Tracking App starter template','A production-ready delivery tracking app blueprint with screens, schema, features, and launch checklist.','logistics','app_starter','ios_android','Flutter + Supabase + Maps','advanced','premium', array['logistics', 'mobile', 'template']::text[], array['Live tracking', 'Proof of delivery', 'Driver app', 'Dispatch board']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase + Maps", "main_features": ["Live tracking", "Proof of delivery", "Driver app", "Dispatch board"], "status": "planning"}'::jsonb, 'published', false, now()),
('Finance Budget App','finance-budget-app','Finance Budget App starter template','A production-ready finance budget app blueprint with screens, schema, features, and launch checklist.','finance','app_starter','ios_android','Flutter + Supabase','intermediate','free', array['finance', 'mobile', 'template']::text[], array['Budgets', 'Transactions', 'Reports', 'Categories']::text[], array['App plan', 'Database schema', 'Screen list', 'MVP roadmap']::text[], '{"target_platform": "ios_android", "selected_stack": "Flutter + Supabase", "main_features": ["Budgets", "Transactions", "Reports", "Categories"], "status": "planning"}'::jsonb, 'published', false, now())
on conflict (slug) do update set
  short_description = excluded.short_description,
  full_description = excluded.full_description,
  category = excluded.category,
  template_type = excluded.template_type,
  recommended_stack = excluded.recommended_stack,
  difficulty = excluded.difficulty,
  access_type = excluded.access_type,
  tags = excluded.tags,
  features = excluded.features,
  included_outputs = excluded.included_outputs,
  template_payload = excluded.template_payload,
  status = excluded.status,
  is_featured = excluded.is_featured,
  published_at = coalesce(public.marketplace_templates.published_at, excluded.published_at);
