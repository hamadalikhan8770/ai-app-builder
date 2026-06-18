import HeroSection from '@/components/site/HeroSection';
import FeatureSection from '@/components/site/FeatureSection';
import TemplatePreviewSection from '@/components/site/TemplatePreviewSection';
import PricingSection from '@/components/site/PricingSection';
import UseCaseSection from '@/components/site/UseCaseSection';
import TestimonialSection from '@/components/site/TestimonialSection';
import FAQSection from '@/components/site/FAQSection';
import CTASection from '@/components/site/CTASection';

export default function HomePage(){return <main><HeroSection /><section className="section"><div className="card"><p className="text-sm font-bold text-blue-200">Problem / Solution</p><h2 className="mt-3 text-3xl font-black">App ideas fail when planning, backend, permissions, subscriptions, and release steps are scattered.</h2><p className="mt-4 text-slate-300">AI App Builder centralizes templates, AI outputs, project management, teams, PDF exports, and analytics into one mobile-first workflow.</p></div></section><FeatureSection /><TemplatePreviewSection /><PricingSection /><UseCaseSection /><TestimonialSection /><FAQSection limit={5}/><CTASection /></main>}
