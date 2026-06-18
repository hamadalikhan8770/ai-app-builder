'use client';
import { FormEvent, useState } from 'react';
import { supabase, isSupabaseConfigured } from '@/lib/supabaseClient';

export default function ContactForm() {
  const [form,setForm]=useState({name:'',email:'',subject:'',message:''}); const [status,setStatus]=useState<string|null>(null); const [loading,setLoading]=useState(false);
  function update(key:string,value:string){setForm((f)=>({...f,[key]:value}));}
  async function submit(e:FormEvent){e.preventDefault(); setStatus(null); if(!form.name.trim() || !/^\S+@\S+\.\S+$/.test(form.email) || !form.message.trim()){setStatus('Please complete name, valid email, and message.'); return;} if(!isSupabaseConfigured || !supabase){setStatus('Supabase is not configured yet.'); return;} setLoading(true); const {error}=await supabase.from('contact_messages').insert(form); setLoading(false); setStatus(error?error.message:'Message sent. We will reply soon.'); if(!error)setForm({name:'',email:'',subject:'',message:''});}
  return <form onSubmit={submit} className="card space-y-4"><input className="input" aria-label="Name" placeholder="Name" value={form.name} onChange={(e)=>update('name',e.target.value)} /><input className="input" aria-label="Email" placeholder="Email" type="email" value={form.email} onChange={(e)=>update('email',e.target.value)} /><input className="input" aria-label="Subject" placeholder="Subject" value={form.subject} onChange={(e)=>update('subject',e.target.value)} /><textarea className="input min-h-36" aria-label="Message" placeholder="How can we help?" value={form.message} onChange={(e)=>update('message',e.target.value)} /><button className="btn-primary" disabled={loading}>{loading?'Sending...':'Send message'}</button>{status&&<p className="text-sm text-slate-300">{status}</p>}</form>;
}
