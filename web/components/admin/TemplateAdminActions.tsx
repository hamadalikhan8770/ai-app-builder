'use client';
import Button from '@/components/ui/Button';
import { publishTemplate } from '@/lib/admin/actions';
export default function TemplateAdminActions({id,status}:{id:string;status?:string|null}){async function set(s:string){try{await publishTemplate(id,s); location.reload();}catch(e){alert(e instanceof Error?e.message:'Failed')}} return <div className='flex gap-2'><Button variant='secondary' onClick={()=>set(status==='published'?'draft':'published')}>{status==='published'?'Unpublish':'Publish'}</Button><Button href={`/dashboard/admin/templates/${id}/edit`} variant='secondary'>Edit</Button></div>}
