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

serve(async (req) => { if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders }); try { const { admin, user } = await context(req); const body = await req.json(); if (!body.name?.trim()) return jsonResponse({ error: "Team name is required." }, 400); const slug = `${slugify(body.name)}-${crypto.randomUUID().slice(0, 8)}`; const { data: team, error } = await admin.from("teams").insert({ owner_user_id: user.id, name: body.name.trim(), slug, description: body.description ?? null }).select().single(); if (error) throw error; const { error: memberError } = await admin.from("team_members").insert({ team_id: team.id, user_id: user.id, role: "owner", status: "active", joined_at: new Date().toISOString() }); if (memberError) throw memberError; await log(admin, team.id, user.id, "team_created", "team", team.id); await analytics(admin, user.id, "team_created", "project", "none", team.id); return jsonResponse({ success: true, team }); } catch (e) { if (e instanceof Response) return e; return jsonResponse({ error: e instanceof Error ? e.message : "Unknown error." }, 500); } });
