import Badge from '@/components/ui/Badge';
export default function AdminPlanBadge({plan}:{plan?:string|null}){return <Badge tone={plan==='premium'||plan==='enterprise'?'amber':'green'}>{plan||'free'}</Badge>}
