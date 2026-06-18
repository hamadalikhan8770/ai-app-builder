import {
  createSupabaseBrowserClient,
  isSupabaseBrowserConfigured,
} from '@/lib/supabase/browser';
import { getSupabaseConfigError } from '@/lib/supabase/config';
async function invoke(name:string, body:Record<string,unknown>){if(!isSupabaseBrowserConfigured()) throw new Error(getSupabaseConfigError()); const {data,error}=await createSupabaseBrowserClient().functions.invoke(name,{body}); if(error||data?.error) throw new Error(data?.error||error?.message||'Admin action failed'); return data;}
export const updateUserRole=(userId:string,role:string)=>invoke('admin-update-user-role',{userId,role});
export const updateUsageLimit=(userId:string,generationLimit:number)=>invoke('admin-update-usage-limit',{userId,generationLimit});
export const disableUser=(userId:string,disabled:boolean)=>invoke('admin-disable-user',{userId,disabled});
export const publishTemplate=(templateId:string,status:string)=>invoke('publish-marketplace-template',{templateId,status});
export const moderateReview=(reviewId:string,status:string)=>invoke('moderate-template-review',{reviewId,status});
export const sendAnnouncement=(title:string,message:string,targetPlan:string,channels:string[])=>invoke('send-admin-announcement',{title,message,targetPlan,channels});
