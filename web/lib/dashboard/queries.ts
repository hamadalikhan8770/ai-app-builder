import {
  createSupabaseServerClientOrNull,
  isSupabaseServerConfigured,
} from '@/lib/supabase/server';
import type { AppProject, GeneratedOutput, MarketplaceTemplate, Profile, Team, UsageSummary } from './types';

export async function getCurrentUserAndProfile() {
  const supabase = await createSupabaseServerClientOrNull();
  if (!supabase) {
    return { user: null, profile: null, configured: false };
  }
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { user: null, profile: null, configured: true };
  const { data } = await supabase.from('profiles').select('id,email,full_name,role,subscription_tier,avatar_url').eq('id', user.id).maybeSingle();
  const profile = (data ?? { id: user.id, email: user.email, full_name: user.user_metadata?.full_name ?? null, role: 'user', subscription_tier: 'free' }) as Profile;
  return { user, profile, configured: true };
}

export async function getProjects(limit?: number): Promise<AppProject[]> {
  const supabase = await createSupabaseServerClientOrNull();
  if (!supabase) return [];
  let query = supabase.from('app_projects').select('id,name,title,description,status,target_platform,selected_stack,main_features,created_at,updated_at').order('created_at', { ascending: false });
  if (limit) query = query.limit(limit);
  const { data } = await query;
  return (data ?? []) as AppProject[];
}

export async function getProject(id: string): Promise<AppProject | null> {
  const supabase = await createSupabaseServerClientOrNull();
  if (!supabase) return null;
  const { data } = await supabase.from('app_projects').select('id,name,title,description,status,target_platform,selected_stack,main_features,created_at,updated_at').eq('id', id).maybeSingle();
  return data as AppProject | null;
}

export async function getOutputs(limit?: number): Promise<GeneratedOutput[]> {
  const supabase = await createSupabaseServerClientOrNull();
  if (!supabase) return [];
  let query = supabase.from('generated_outputs').select('id,project_id,output_type,title,content,created_at,app_projects(name,title)').order('created_at', { ascending: false });
  if (limit) query = query.limit(limit);
  const { data } = await query;
  return (data ?? []) as unknown as GeneratedOutput[];
}

export async function getTemplates(): Promise<MarketplaceTemplate[]> {
  const supabase = await createSupabaseServerClientOrNull();
  if (!supabase) return [];
  const { data } = await supabase.from('marketplace_templates').select('id,title,category,access_type,difficulty,short_description,usage_count').eq('status', 'published').order('usage_count', { ascending: false }).limit(50);
  return (data ?? []) as MarketplaceTemplate[];
}

export async function getTeams(): Promise<Team[]> {
  const supabase = await createSupabaseServerClientOrNull();
  if (!supabase) return [];
  const { data } = await supabase.from('team_members').select('role,status,teams(id,name)').eq('status', 'active');
  return (data ?? []).map((row: any) => ({ id: row.teams?.id ?? '', name: row.teams?.name ?? 'Team', role: row.role, status: row.status })).filter((t: Team) => t.id);
}

export async function getUsageSummary(): Promise<UsageSummary> {
  const { profile } = await getCurrentUserAndProfile();
  const supabase = await createSupabaseServerClientOrNull();
  const { data } = supabase
    ? await supabase.from('usage_limits').select('*').maybeSingle()
    : { data: null };
  const generationCount = Number(data?.generation_count ?? data?.monthly_generation_count ?? 0);
  const generationLimit = Number(data?.generation_limit ?? data?.monthly_generation_limit ?? (profile?.subscription_tier === 'premium' ? 250 : 5));
  return { plan: profile?.subscription_tier ?? 'free', generationCount, generationLimit, remaining: Math.max(generationLimit - generationCount, 0) };
}

export function isDashboardConfigured() {
  return isSupabaseServerConfigured();
}
