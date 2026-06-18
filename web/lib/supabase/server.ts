import { cookies } from 'next/headers';
import { createServerClient } from '@supabase/ssr';
import { getSupabaseConfig, getSupabaseConfigError } from './config';

export function isSupabaseServerConfigured() {
  return getSupabaseConfig().isConfigured;
}

export async function createSupabaseServerClientOrNull() {
  if (!isSupabaseServerConfigured()) {
    return null;
  }

  return createSupabaseServerClient();
}

export async function createSupabaseServerClient() {
  const cookieStore = await cookies();
  const { url, anonKey, isConfigured } = getSupabaseConfig();
  if (!isConfigured) throw new Error(getSupabaseConfigError());

  return createServerClient(url, anonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) => cookieStore.set(name, value, options));
        } catch {
          // Server Components cannot always set cookies; middleware refresh handles this.
        }
      }
    }
  });
}
