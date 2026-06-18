import EmptyState from '@/components/dashboard/EmptyState';
import OutputCard from '@/components/dashboard/OutputCard';
import { getOutputs } from '@/lib/dashboard/queries';
export default async function OutputsPage(){const outputs=await getOutputs(); return <div className="space-y-6"><div><h1 className="text-3xl font-black">Generated Outputs</h1><p className="text-slate-400">Review and copy your generated app plans, prompts, and code outputs.</p></div>{outputs.length? <div className="grid gap-4 lg:grid-cols-2">{outputs.map(o=><OutputCard key={o.id} output={o}/>)}</div>:<EmptyState title="No outputs" message="Generate AI outputs from projects to see them here."/>}</div>}
