import AdminHeader from './AdminHeader';import AdminSidebar from './AdminSidebar';
export default function AdminShell({children}:{children:React.ReactNode}){return <div className='min-h-screen bg-slate-950 text-slate-100'><div className='flex'><AdminSidebar/><main className='min-w-0 flex-1'><AdminHeader/><div className='p-5 lg:p-8'>{children}</div></main></div></div>}
