export default function HeroSection() {
  return <section className="relative overflow-hidden">
    <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_left,_rgba(37,99,235,.35),transparent_35%),radial-gradient(circle_at_top_right,_rgba(168,85,247,.25),transparent_30%)]" />
    <div className="section relative grid items-center gap-12 lg:grid-cols-2">
      <div><p className="mb-4 inline-flex rounded-full border border-blue-300/30 bg-blue-500/10 px-4 py-2 text-sm font-bold text-blue-200">AI-powered mobile app builder</p><h1 className="text-5xl font-black tracking-tight sm:text-6xl">Build mobile apps faster with AI templates, plans, and team workflows.</h1><p className="mt-6 text-lg text-slate-300">Plan, generate, and manage iOS and Android app projects with AI-powered templates, code outputs, collaboration, analytics, and PDF exports.</p><div className="mt-8 flex flex-wrap gap-4"><a href="#download" className="btn-primary">Download the app</a><a href="/templates" className="btn-secondary">Browse templates</a></div></div>
      <div className="card"><div className="rounded-2xl bg-slate-900 p-5"><div className="mb-4 h-3 w-24 rounded-full bg-blue-400" /><div className="space-y-3">{['Choose template','Generate app plan','Invite team','Export PDF'].map((item) => <div key={item} className="rounded-xl bg-white/10 p-4 font-semibold">{item}</div>)}</div></div></div>
    </div>
  </section>;
}
