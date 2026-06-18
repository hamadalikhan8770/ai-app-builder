import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const corsHeaders = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
function jsonResponse(body: unknown, status = 200) { return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } }); }
function env(name: string) { const v = Deno.env.get(name); if (!v) throw new Error(`Missing env: ${name}`); return v; }

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return jsonResponse({ error: "Method not allowed." }, 405);
  try {
    const supabaseUrl = env("SUPABASE_URL");
    const anonKey = env("SUPABASE_ANON_KEY");
    const serviceRoleKey = env("SUPABASE_SERVICE_ROLE_KEY");
    const authorization = req.headers.get("Authorization");
    if (!authorization) return jsonResponse({ error: "Missing authorization." }, 401);
    const userClient = createClient(supabaseUrl, anonKey, { global: { headers: { Authorization: authorization } } });
    const adminClient = createClient(supabaseUrl, serviceRoleKey, { auth: { persistSession: false, autoRefreshToken: false } });
    const { data: { user } } = await userClient.auth.getUser();
    if (!user) return jsonResponse({ error: "Invalid session." }, 401);
    const { data: actorProfile } = await adminClient.from("profiles").select("role").eq("id", user.id).single();
    if (actorProfile?.role !== "admin") return jsonResponse({ error: "Admin access required." }, 403);

    const body = await req.json();
    if (!body.eventName || !body.eventCategory) return jsonResponse({ error: "eventName and eventCategory are required." }, 400);
    const { data, error } = await adminClient.from("analytics_events").insert({
      user_id: body.userId ?? null,
      event_name: body.eventName,
      event_category: body.eventCategory,
      entity_type: body.entityType ?? "none",
      entity_id: body.entityId ?? null,
      metadata: body.metadata ?? {},
      platform: body.platform ?? "server",
      app_version: body.appVersion ?? null,
      device_id: body.deviceId ?? null,
      session_id: body.sessionId ?? null,
    }).select().single();
    if (error) throw new Error(error.message);
    return jsonResponse({ success: true, event: data });
  } catch (error) {
    return jsonResponse({ error: error instanceof Error ? error.message : "Unknown error." }, 500);
  }
});
