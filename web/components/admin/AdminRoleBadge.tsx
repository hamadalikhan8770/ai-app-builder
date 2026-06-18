import Badge from '@/components/ui/Badge';
export default function AdminRoleBadge({role}:{role?:string|null}){return <Badge tone={role==='admin'?'amber':'blue'}>{role||'user'}</Badge>}
