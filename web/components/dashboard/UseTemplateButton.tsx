'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Button from '@/components/ui/Button';
import { createSupabaseBrowserClient, isSupabaseBrowserConfigured } from '@/lib/supabase/browser';
import { getSupabaseConfigError } from '@/lib/supabase/config';
export default function UseTemplateButton({ templateId }: { templateId: string }){const router=useRouter(); const [message,setMessage]=useState<string|null>(null); const [loading,setLoading]=useState(false); async function useTemplate(){setLoading(true); setMessage(null); if(!isSupabaseBrowserConfigured()){setMessage(getSupabaseConfigError()); setLoading(false); return;} const {data,error}=await createSupabaseBrowserClient().functions.invoke('use-marketplace-template',{body:{templateId}}); setLoading(false); if(error || data?.error){setMessage(data?.error || error?.message || 'Unable to use template.'); return;} const id=data?.project?.id; if(id){router.push(`/dashboard/projects/${id}`); router.refresh();}} return <div><Button onClick={useTemplate} disabled={loading}>{loading?'Creating...':'Use Template'}</Button>{message&&<p className="mt-2 text-sm text-amber-200">{message}</p>}</div>}
