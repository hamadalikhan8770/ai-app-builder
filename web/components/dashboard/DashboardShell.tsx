import DashboardSidebar from './DashboardSidebar';
import DashboardTopbar from './DashboardTopbar';
import SupabaseNotice from './SupabaseNotice';
import type { Profile } from '@/lib/dashboard/types';
export default function DashboardShell({ profile, configured, children }: { profile: Profile | null; configured: boolean; children: React.ReactNode }) { return <div className="min-h-screen bg-slate-950 text-slate-100"><div className="flex"><DashboardSidebar profile={profile}/><main className="min-w-0 flex-1"><DashboardTopbar profile={profile} configured={configured}/><div className="space-y-5 p-5 lg:p-8">{!configured && <SupabaseNotice />}{children}</div></main></div></div>; }
