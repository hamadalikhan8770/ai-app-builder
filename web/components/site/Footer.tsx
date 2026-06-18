import Link from 'next/link';
import NewsletterForm from './NewsletterForm';

export default function Footer() {
  return <footer className="border-t border-white/10 bg-slate-950">
    <div className="section grid gap-10 md:grid-cols-3">
      <div><h3 className="text-xl font-black">AI App Builder</h3><p className="mt-3 text-slate-400">Plan, generate, collaborate, and launch mobile apps faster with AI.</p></div>
      <div className="grid grid-cols-2 gap-3 text-sm text-slate-300">
        <Link href="/pricing">Pricing</Link><Link href="/templates">Templates</Link><Link href="/use-cases">Use Cases</Link><Link href="/faq">FAQ</Link><Link href="/privacy">Privacy</Link><Link href="/terms">Terms</Link><Link href="/contact">Contact</Link>
      </div>
      <NewsletterForm source="footer" />
    </div>
    <div className="mx-auto max-w-7xl px-6 pb-8 text-sm text-slate-500 lg:px-8">© {new Date().getFullYear()} AI App Builder. All rights reserved.</div>
  </footer>;
}
