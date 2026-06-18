export default function LoadingState({ message='Loading...' }: { message?: string }) { return <div className="card animate-pulse text-slate-300">{message}</div>; }
