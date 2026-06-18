import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const corsHeaders = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
function jsonResponse(body: unknown, status = 200) { return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } }); }
function env(name: string) { const v = Deno.env.get(name); if (!v) throw new Error(`Missing env: ${name}`); return v; }
function slugify(value: string) { return value.toLowerCase().trim().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "").slice(0, 48) || "team"; }
function randomToken() { return crypto.randomUUID().replaceAll("-", "") + crypto.randomUUID().replaceAll("-", ""); }
async function context(req: Request) {
  const supabaseUrl = env("SUPABASE_URL"); const anonKey = env("SUPABASE_ANON_KEY"); const serviceRoleKey = env("SUPABASE_SERVICE_ROLE_KEY");
  const authorization = req.headers.get("Authorization"); if (!authorization) throw new Response(JSON.stringify({ error: "Missing authorization." }), { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  const userClient = createClient(supabaseUrl, anonKey, { global: { headers: { Authorization: authorization } } });
  const admin = createClient(supabaseUrl, serviceRoleKey, { auth: { persistSession: false, autoRefreshToken: false } });
  const { data: { user }, error } = await userClient.auth.getUser(); if (error || !user) throw new Response(JSON.stringify({ error: "Invalid session." }), { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  return { admin, user };
}
async function role(admin: any, teamId: string, userId: string) { const { data } = await admin.from("team_members").select("role,status").eq("team_id", teamId).eq("user_id", userId).eq("status", "active").maybeSingle(); return data?.role ?? null; }
function canManage(r: string | null) { return r === "owner" || r === "admin"; }
async function log(admin: any, teamId: string, actor: string, action: string, entityType = "none", entityId: string | null = null, metadata: Record<string, unknown> = {}) { await admin.from("team_activity_logs").insert({ team_id: teamId, actor_user_id: actor, action, entity_type: entityType, entity_id: entityId, metadata }); }
async function analytics(admin: any, userId: string, event: string, category = "project", entityType = "none", entityId: string | null = null, metadata: Record<string, unknown> = {}) { await admin.from("analytics_events").insert({ user_id: userId, event_name: event, event_category: category, entity_type: entityType, entity_id: entityId, metadata, platform: "server" }); }

serve(async (req) => { if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders }); try { const { admin, user } = await context(req); const { projectId, teamId } = await req.json(); const { data: project } = await admin.from("app_projects").select("id, owner_user_id, user_id").eq("id", projectId).single(); const owns = (project.owner_user_id ?? project.user_id) === user.id; if (!owns && !canManage(await role(admin, teamId, user.id))) return jsonResponse({ error: "Project owner or team manager access required." }, 403); const { error } = await admin.from("project_shares").delete().eq("project_id", projectId).eq("team_id", teamId); if (error) throw error; await log(admin, teamId, user.id, "project_unshared", "project", projectId); await analytics(admin, user.id, "project_unshared", "project", "project", projectId, { teamId }); return jsonResponse({ success: true }); } catch (e) { if (e instanceof Response) return e; return jsonResponse({ error: e instanceof Error ? e.message : "Unknown error." }, 500); } });
