import { createBrowserClient } from '@supabase/ssr';
import { getSupabaseConfig, getSupabaseConfigError } from './config';

let browserClient: ReturnType<typeof createBrowserClient> | null = null;

export function isSupabaseBrowserConfigured() {
  return getSupabaseConfig().isConfigured;
}

export function createSupabaseBrowserClient() {
  const { url, anonKey, isConfigured } = getSupabaseConfig();

  if (!isConfigured) {
    throw new Error(getSupabaseConfigError());
  }

  if (!browserClient) {
    browserClient = createBrowserClient(url, anonKey);
  }

  return browserClient;
}
