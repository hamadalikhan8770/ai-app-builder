export type Profile = { id: string; email?: string | null; full_name?: string | null; role?: string | null; subscription_tier?: string | null; avatar_url?: string | null; };
export type AppProject = { id: string; name?: string | null; title?: string | null; description?: string | null; status?: string | null; target_platform?: string | null; selected_stack?: string | null; main_features?: string[] | null; created_at?: string | null; updated_at?: string | null; };
export type GeneratedOutput = { id: string; project_id?: string | null; output_type?: string | null; title?: string | null; content?: string | null; created_at?: string | null; app_projects?: { name?: string | null; title?: string | null } | null; };
export type MarketplaceTemplate = { id: string; title: string; category?: string | null; access_type?: string | null; difficulty?: string | null; short_description?: string | null; usage_count?: number | null; };
export type Team = { id: string; name: string; role?: string | null; status?: string | null; };
export type UsageSummary = { plan: string; generationCount: number; generationLimit: number; remaining: number; };
