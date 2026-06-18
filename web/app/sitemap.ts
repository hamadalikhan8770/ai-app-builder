import type { MetadataRoute } from 'next';
import { siteUrl } from '@/lib/constants';
const routes=['/','/pricing','/templates','/use-cases','/faq','/contact','/privacy','/terms'];
export default function sitemap(): MetadataRoute.Sitemap { return routes.map((route)=>({url:`${siteUrl}${route}`, lastModified:new Date(), changeFrequency:'weekly', priority: route==='/'?1:0.8})); }
