import AdminTable from '@/components/admin/AdminTable';
import AdminStatusBadge from '@/components/admin/AdminStatusBadge';
import ReviewActions from '@/components/admin/ReviewActions';
import { getAdminReviews } from '@/lib/admin/queries';
export default async function Page(){const rows=await getAdminReviews(); return <div className='space-y-6'><h1 className='text-3xl font-black'>Marketplace Reviews</h1><AdminTable headers={['Rating','Review','Status','Template','User','Created','Actions']}>{rows.map(r=><tr key={r.id}><td className='px-4 py-3'>{r.rating}/5</td><td className='px-4 py-3'>{r.review_text||'—'}</td><td className='px-4 py-3'><AdminStatusBadge status={r.status}/></td><td className='px-4 py-3'>{r.template_id}</td><td className='px-4 py-3'>{r.user_id}</td><td className='px-4 py-3'>{r.created_at}</td><td className='px-4 py-3'><ReviewActions id={r.id}/></td></tr>)}</AdminTable></div>}
