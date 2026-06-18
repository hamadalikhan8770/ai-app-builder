'use client';
import Button from '@/components/ui/Button';
import { moderateReview } from '@/lib/admin/actions';
export default function ReviewActions({id}:{id:string}){async function set(s:string){try{await moderateReview(id,s); location.reload();}catch(e){alert(e instanceof Error?e.message:'Failed')}} return <div className='flex gap-2'><Button onClick={()=>set('published')}>Approve</Button><Button variant='danger' onClick={()=>set('hidden')}>Hide</Button><Button variant='secondary' onClick={()=>set('pending')}>Pending</Button></div>}
