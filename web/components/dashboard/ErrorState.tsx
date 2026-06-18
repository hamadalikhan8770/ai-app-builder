export default function ErrorState({ message }: { message: string }) { return <div className="rounded-3xl border border-red-400/20 bg-red-500/10 p-6 text-red-100">{message}</div>; }
