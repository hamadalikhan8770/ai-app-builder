import Button from '@/components/ui/Button';
import EmptyState from '@/components/dashboard/EmptyState';
import ProjectCard from '@/components/dashboard/ProjectCard';
import { getProjects } from '@/lib/dashboard/queries';
export default async function ProjectsPage(){const projects=await getProjects(); return <div className="space-y-6"><div className="flex items-center justify-between gap-4"><div><h1 className="text-3xl font-black">Projects</h1><p className="text-slate-400">Your app projects from the shared Supabase backend.</p></div><Button href="/dashboard/projects/new">New Project</Button></div>{projects.length? <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">{projects.map(p=><ProjectCard key={p.id} project={p}/>)}</div>:<EmptyState title="No projects" message="Create your first project to start planning."/>}</div>}
