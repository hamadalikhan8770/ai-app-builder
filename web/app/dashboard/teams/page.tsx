import Button from '@/components/ui/Button';
import Badge from '@/components/ui/Badge';
import EmptyState from '@/components/dashboard/EmptyState';
import { getTeams } from '@/lib/dashboard/queries';
export default async function TeamsPage(){const teams=await getTeams(); return <div className="space-y-6"><div className="flex items-center justify-between gap-4"><div><h1 className="text-3xl font-black">Teams</h1><p className="text-slate-400">Read-only MVP view of teams you belong to.</p></div><Button variant="secondary" disabled>Create team — coming soon</Button></div>{teams.length? <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">{teams.map(t=><div key={t.id} className="card"><h3 className="font-black">{t.name}</h3><div className="mt-4 flex gap-2"><Badge>{t.role || 'member'}</Badge><Badge tone="green">{t.status || 'active'}</Badge></div></div>)}</div>:<EmptyState title="No teams" message="Team memberships and pending invites will appear here."/>}</div>}
