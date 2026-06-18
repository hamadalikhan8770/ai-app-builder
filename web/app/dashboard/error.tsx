'use client';
export default function Error({error,reset}:{error:Error;reset:()=>void}){return <div className='p-8'><div className='rounded-3xl border border-red-400/20 bg-red-500/10 p-6'><h2 className='text-xl font-black'>Dashboard error</h2><p className='mt-2 text-red-100'>{error.message}</p><button className='btn-secondary mt-4' onClick={reset}>Try again</button></div></div>}
