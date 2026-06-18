'use client';
import { useRouter } from 'next/navigation';
import Button from '@/components/ui/Button';
import { createSupabaseBrowserClient, isSupabaseBrowserConfigured } from '@/lib/supabase/browser';
export default function LogoutButton({ configured }: { configured?: boolean }){ const router=useRouter(); async function logout(){ if(!isSupabaseBrowserConfigured()) { router.replace('/login'); router.refresh(); return; } await createSupabaseBrowserClient().auth.signOut(); router.replace('/login'); router.refresh(); } return <Button variant="secondary" onClick={logout} disabled={configured === false}>Logout</Button>; }
