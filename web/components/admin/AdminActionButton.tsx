'use client';
import Button from '@/components/ui/Button';
export default function AdminActionButton({label,onClick}:{label:string;onClick:()=>Promise<void>}){return <Button variant='secondary' onClick={()=>onClick().catch((e)=>alert(e.message))}>{label}</Button>}
