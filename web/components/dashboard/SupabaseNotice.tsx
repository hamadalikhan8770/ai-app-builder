export default function SupabaseNotice() {
  return (
    <div className="rounded-2xl border border-amber-400/30 bg-amber-300/10 px-4 py-3 text-sm text-amber-100">
      Supabase is not configured yet. Add `NEXT_PUBLIC_SUPABASE_URL` and
      `NEXT_PUBLIC_SUPABASE_ANON_KEY` in `web/.env.local` to enable login,
      dashboard data, and edge-function actions.
    </div>
  );
}
