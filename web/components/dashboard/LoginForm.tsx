'use client';
import { FormEvent, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import Button from '@/components/ui/Button';
import Input from '@/components/ui/Input';
import {
  createSupabaseBrowserClient,
  isSupabaseBrowserConfigured,
} from '@/lib/supabase/browser';
import { getSupabaseConfigError } from '@/lib/supabase/config';

export default function LoginForm(){
 const router=useRouter(); const [email,setEmail]=useState(''); const [password,setPassword]=useState(''); const [message,setMessage]=useState<string|null>(null); const [loading,setLoading]=useState(false);
 async function submit(e:FormEvent){e.preventDefault(); setMessage(null); if(!email||!password){setMessage('Email and password are required.'); return;} if(!isSupabaseBrowserConfigured()){setMessage(getSupabaseConfigError()); return;} setLoading(true); const {error}=await createSupabaseBrowserClient().auth.signInWithPassword({email,password}); setLoading(false); if(error){setMessage(error.message); return;} const next = new URLSearchParams(window.location.search).get('next') || '/dashboard'; router.replace(next); router.refresh();}
 return <form onSubmit={submit} className="card mx-auto max-w-md space-y-4"><h1 className="text-3xl font-black">Log in</h1><Input type="email" placeholder="Email" value={email} onChange={(e)=>setEmail(e.target.value)}/><Input type="password" placeholder="Password" value={password} onChange={(e)=>setPassword(e.target.value)}/><Button className="w-full" disabled={loading}>{loading?'Logging in...':'Log in'}</Button>{message&&<p className="text-sm text-amber-200">{message}</p>}<div className="flex justify-between text-sm text-slate-400"><Link href="/signup">Create account</Link><Link href="/forgot-password">Forgot password?</Link></div></form>;
}
