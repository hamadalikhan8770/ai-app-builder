import AdminShell from '@/components/admin/AdminShell';
import { requireAdmin } from '@/lib/admin/queries';
export default async function AdminLayout({children}:{children:React.ReactNode}){const {isAdmin}=await requireAdmin(); if(!isAdmin) return <div className='p-8'><div className='card'><h1 className='text-3xl font-black text-red-200'>Forbidden</h1><p className='mt-2 text-slate-400'>Admin role required.</p></div></div>; return <AdminShell>{children}</AdminShell>}
