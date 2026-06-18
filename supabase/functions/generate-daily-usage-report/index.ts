import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } });
}
function env(name: string) { const v = Deno.env.get(name); if (!v) throw new Error(`Missing env: ${name}`); return v; }
function dayBounds(date: string) { return { start: `${date}T00:00:00.000Z`, end: `${date}T23:59:59.999Z` }; }

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
    const { data: profile } = await adminClient.from("profiles").select("role").eq("id", user.id).single();
    if (profile?.role !== "admin") return jsonResponse({ error: "Admin access required." }, 403);

    const body = await req.json().catch(() => ({}));
    const reportDate = body.reportDate ?? new Date(Date.now() - 86400000).toISOString().slice(0, 10);
    const { start, end } = dayBounds(reportDate);

    const count = async (table: string, build: (q: any) => any) => {
      const { count, error } = await build(adminClient.from(table).select("id", { count: "exact", head: true }));
      if (error) throw new Error(`${table}: ${error.message}`);
      return count ?? 0;
    };

    const [totalUsers, newUsers, freeUsers, premiumUsers, adminUsers, projectsCreated, aiGenerations, aiFailures, templateOutputs, pdfExports, subscriptionsStarted, notificationsSent, feedbackCount] = await Promise.all([
      count("profiles", (q) => q),
      count("profiles", (q) => q.gte("created_at", start).lte("created_at", end)),
      count("profiles", (q) => q.eq("role", "free_user")),
      count("profiles", (q) => q.or("role.eq.premium_user,subscription_tier.eq.premium")),
      count("profiles", (q) => q.eq("role", "admin")),
      count("app_projects", (q) => q.gte("created_at", start).lte("created_at", end)),
      count("ai_generations", (q) => q.gte("created_at", start).lte("created_at", end)),
      count("ai_generations", (q) => q.eq("status", "failed").gte("created_at", start).lte("created_at", end)),
      count("analytics_events", (q) => q.eq("event_name", "template_output_generated").gte("created_at", start).lte("created_at", end)),
      count("export_logs", (q) => q.eq("status", "success").gte("created_at", start).lte("created_at", end)),
      count("analytics_events", (q) => q.in("event_name", ["subscription_started", "subscription_restored"]).gte("created_at", start).lte("created_at", end)),
      count("notifications", (q) => q.in("status", ["sent", "read"]).gte("created_at", start).lte("created_at", end)),
      count("feedback", (q) => q.gte("created_at", start).lte("created_at", end)),
    ]);

    const { data: activeRows, error: activeError } = await adminClient.from("analytics_events").select("user_id").gte("created_at", start).lte("created_at", end);
    if (activeError) throw new Error(activeError.message);
    const activeUsers = new Set((activeRows ?? []).map((r: any) => r.user_id).filter(Boolean)).size;

    const payload = { report_date: reportDate, total_users: totalUsers, new_users: newUsers, active_users: activeUsers, free_users: freeUsers, premium_users: premiumUsers, admin_users: adminUsers, projects_created: projectsCreated, ai_generations: aiGenerations, ai_generation_failures: aiFailures, template_outputs: templateOutputs, pdf_exports: pdfExports, subscriptions_started: subscriptionsStarted, notifications_sent: notificationsSent, feedback_count: feedbackCount, updated_at: new Date().toISOString() };
    const { data, error } = await adminClient.from("daily_usage_reports").upsert(payload, { onConflict: "report_date" }).select().single();
    if (error) throw new Error(error.message);
    return jsonResponse({ success: true, report: data });
  } catch (error) {
    return jsonResponse({ error: error instanceof Error ? error.message : "Unknown error." }, 500);
  }
});
