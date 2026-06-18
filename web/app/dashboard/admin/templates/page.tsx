import Link from 'next/link';
import AdminTable from '@/components/admin/AdminTable';
import AdminStatusBadge from '@/components/admin/AdminStatusBadge';
import TemplateAdminActions from '@/components/admin/TemplateAdminActions';
import { getAdminTemplates } from '@/lib/admin/queries';
export default async function Page(){const rows=await getAdminTemplates(); return <div className='space-y-6'><div className='flex justify-between'><h1 className='text-3xl font-black'>Marketplace Templates</h1><Link className='btn-primary' href='/dashboard/admin/templates/new'>Create</Link></div><AdminTable headers={['Title','Category','Access','Status','Featured','Usage','Actions']}>{rows.map(t=><tr key={t.id}><td className='px-4 py-3'>{t.title}</td><td className='px-4 py-3'>{t.category}</td><td className='px-4 py-3'>{t.access_type}</td><td className='px-4 py-3'><AdminStatusBadge status={t.status}/></td><td className='px-4 py-3'>{t.is_featured?'Yes':'No'}</td><td className='px-4 py-3'>{t.usage_count??0}</td><td className='px-4 py-3'><TemplateAdminActions id={t.id} status={t.status}/></td></tr>)}</AdminTable></div>}
