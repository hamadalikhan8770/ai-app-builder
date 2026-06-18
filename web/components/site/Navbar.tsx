import Link from 'next/link';
import { navLinks } from '@/lib/constants';

export default function Navbar() {
  return <header className="sticky top-0 z-50 border-b border-white/10 bg-slate-950/80 backdrop-blur">
    <nav className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4 lg:px-8">
      <Link href="/" className="text-lg font-black tracking-tight">AI App Builder</Link>
      <div className="hidden items-center gap-6 md:flex">{navLinks.map((link) => <Link key={link.href} href={link.href} className="text-sm text-slate-300 hover:text-white">{link.label}</Link>)}</div>
      <div className="flex gap-3"><Link href="/login" className="btn-secondary hidden sm:inline-flex">Login</Link><a href="#download" className="btn-primary">Download</a></div>
    </nav>
  </header>;
}
