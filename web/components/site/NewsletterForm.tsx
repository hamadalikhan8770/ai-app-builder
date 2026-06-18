'use client';
import { FormEvent, useState } from 'react';
import { supabase, isSupabaseConfigured } from '@/lib/supabaseClient';

export default function NewsletterForm({ source = 'website' }: { source?: string }) {
  const [email, setEmail] = useState(''); const [status, setStatus] = useState<string | null>(null); const [loading, setLoading] = useState(false);
  async function submit(e: FormEvent) { e.preventDefault(); setStatus(null); if (!/^\S+@\S+\.\S+$/.test(email)) { setStatus('Enter a valid email.'); return; } if (!isSupabaseConfigured || !supabase) { setStatus('Supabase is not configured yet.'); return; } setLoading(true); const { error } = await supabase.from('waitlist_subscribers').insert({ email, source }); setLoading(false); setStatus(error ? error.message : 'Thanks — you are on the list!'); if (!error) setEmail(''); }
  return <form onSubmit={submit} className="space-y-3"><label className="text-sm font-bold" htmlFor={`newsletter-${source}`}>Join the waitlist</label><div className="flex gap-2"><input id={`newsletter-${source}`} className="input" value={email} onChange={(e)=>setEmail(e.target.value)} placeholder="you@example.com" type="email" /><button className="btn-primary" disabled={loading}>{loading?'Saving...':'Join'}</button></div>{status && <p className="text-sm text-slate-300">{status}</p>}</form>;
}
