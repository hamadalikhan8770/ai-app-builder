'use client';
import { FormEvent, useState } from 'react';
import Button from '@/components/ui/Button';
import Input from '@/components/ui/Input';
import { createSupabaseBrowserClient, isSupabaseBrowserConfigured } from '@/lib/supabase/browser';
import { getSupabaseConfigError } from '@/lib/supabase/config';
export default function ForgotPasswordForm(){ const [email,setEmail]=useState(''); const [message,setMessage]=useState<string|null>(null); const [loading,setLoading]=useState(false); async function submit(e:FormEvent){e.preventDefault(); setMessage(null); if(!/^\S+@\S+\.\S+$/.test(email)){setMessage('Enter a valid email.');return;} if(!isSupabaseBrowserConfigured()){setMessage(getSupabaseConfigError()); return;} setLoading(true); const {error}=await createSupabaseBrowserClient().auth.resetPasswordForEmail(email,{redirectTo:`${location.origin}/login`}); setLoading(false); setMessage(error?error.message:'Password reset email sent.'); } return <form onSubmit={submit} className="card mx-auto max-w-md space-y-4"><h1 className="text-3xl font-black">Reset password</h1><Input type="email" placeholder="Email" value={email} onChange={(e)=>setEmail(e.target.value)}/><Button className="w-full" disabled={loading}>{loading?'Sending...':'Send reset email'}</Button>{message&&<p className="text-sm text-amber-200">{message}</p>}</form>;}
