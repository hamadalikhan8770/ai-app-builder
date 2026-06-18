import { redirect } from 'next/navigation';
import DashboardShell from '@/components/dashboard/DashboardShell';
import { getCurrentUserAndProfile } from '@/lib/dashboard/queries';
export const metadata = { title: 'Dashboard', description: 'AI App Builder web dashboard.' };
export default async function DashboardLayout({ children }: { children: React.ReactNode }) { const { user, profile, configured } = await getCurrentUserAndProfile(); if (configured && !user) redirect('/login'); return <DashboardShell profile={profile} configured={configured}>{children}</DashboardShell>; }
