import Badge from '@/components/ui/Badge';
export default function AdminStatusBadge({status}:{status?:string|null}){const s=status||'unknown';return <Badge tone={s==='published'||s==='active'?'green':s==='hidden'||s==='disabled'?'red':s==='premium'?'amber':'slate'}>{s}</Badge>}
