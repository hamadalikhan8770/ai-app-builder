'use client';
import { FormEvent, useState } from 'react';
import Button from '@/components/ui/Button';
import Input from '@/components/ui/Input';
import { createSupabaseBrowserClient, isSupabaseBrowserConfigured } from '@/lib/supabase/browser';
import { getSupabaseConfigError } from '@/lib/supabase/config';
export default function SettingsForm({ initialName }: { initialName: string }){const [name,setName]=useState(initialName); const [message,setMessage]=useState<string|null>(null); const [loading,setLoading]=useState(false); async function submit(e:FormEvent){e.preventDefault(); setLoading(true); setMessage(null); if(!isSupabaseBrowserConfigured()){setMessage(getSupabaseConfigError()); setLoading(false); return;} const supabase=createSupabaseBrowserClient(); const {data:{user}}=await supabase.auth.getUser(); if(!user){setMessage('Not logged in.'); setLoading(false); return;} const {error}=await supabase.from('profiles').update({full_name:name}).eq('id',user.id); setLoading(false); setMessage(error?error.message:'Profile updated.');} return <form onSubmit={submit} className="card space-y-4"><label className="text-sm font-bold">Full name</label><Input value={name} onChange={(e)=>setName(e.target.value)} /><Button disabled={loading}>{loading?'Saving...':'Save changes'}</Button>{message&&<p className="text-sm text-amber-200">{message}</p>}</form>}
