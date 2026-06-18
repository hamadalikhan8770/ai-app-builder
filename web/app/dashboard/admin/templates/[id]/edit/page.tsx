import TemplateForm from '@/components/admin/TemplateForm';
import { getAdminTemplates } from '@/lib/admin/queries';
export default async function Page({params}:{params:Promise<{id:string}>}){const {id}=await params; const t=(await getAdminTemplates()).find(x=>x.id===id); return <div className='mx-auto max-w-4xl space-y-6'><h1 className='text-3xl font-black'>Edit Template</h1><TemplateForm template={t}/></div>}
