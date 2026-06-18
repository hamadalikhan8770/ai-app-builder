import LogoutButton from '@/components/dashboard/LogoutButton';
import SettingsForm from '@/components/dashboard/SettingsForm';
import Badge from '@/components/ui/Badge';
import { getCurrentUserAndProfile } from '@/lib/dashboard/queries';
export default async function SettingsPage(){const {user,profile,configured}=await getCurrentUserAndProfile(); return <div className="mx-auto max-w-3xl space-y-6"><div><h1 className="text-3xl font-black">Settings</h1><p className="text-slate-400">Manage your profile and session.</p></div><div className="card space-y-3"><p><strong>Email:</strong> {user?.email || 'Not connected'}</p><p><strong>Role:</strong> <Badge>{profile?.role || 'user'}</Badge></p><p><strong>Plan:</strong> <Badge tone="green">{profile?.subscription_tier || 'free'}</Badge></p><p className="text-slate-400">Notification preferences placeholder will be added in a later phase.</p><LogoutButton configured={configured}/></div><SettingsForm initialName={profile?.full_name || ''}/></div>}
