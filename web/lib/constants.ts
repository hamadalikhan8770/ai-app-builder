export const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || 'https://ai-app-builder.example.com';

export const navLinks = [
  { href: '/', label: 'Home' },
  { href: '/pricing', label: 'Pricing' },
  { href: '/templates', label: 'Templates' },
  { href: '/use-cases', label: 'Use Cases' },
  { href: '/faq', label: 'FAQ' },
  { href: '/contact', label: 'Contact' }
];

export const features = [
  'AI-powered app planning and code outputs',
  'Flutter iOS and Android project workflow',
  'Supabase Auth, PostgreSQL, RLS, and Edge Functions',
  'Template marketplace with premium starters',
  'Team collaboration with project roles',
  'PDF export, analytics, notifications, and admin tools'
];

export const templates = [
  { title: 'Food Delivery App', category: 'Food Delivery', stack: 'Flutter + Supabase + Maps', access: 'Premium' },
  { title: 'Booking Appointment App', category: 'Booking', stack: 'Flutter + Supabase', access: 'Free' },
  { title: 'E-commerce Store App', category: 'E-commerce', stack: 'Flutter + Supabase + RevenueCat', access: 'Premium' },
  { title: 'Fitness Tracker App', category: 'Fitness', stack: 'Flutter + Hive + Supabase', access: 'Free' },
  { title: 'Learning Management App', category: 'Education', stack: 'Flutter + Supabase Storage', access: 'Premium' },
  { title: 'Real Estate Listing App', category: 'Real Estate', stack: 'Flutter + Maps', access: 'Free' },
  { title: 'POS Inventory App', category: 'POS', stack: 'Flutter + Supabase', access: 'Premium' },
  { title: 'AI Chatbot App', category: 'AI Tools', stack: 'Flutter + Edge Functions', access: 'Premium' }
];

export const faqs = [
  ['What is AI App Builder?', 'A mobile app platform that helps you plan, generate, organize, and export production-style iOS and Android app projects.'],
  ['Does it generate real code?', 'Yes. It creates structured app plans, backend schemas, UI guidance, and code-oriented outputs that can be expanded into real Flutter/Supabase apps.'],
  ['Can I build iOS and Android apps?', 'Yes. The default stack is Flutter so one codebase can target both platforms.'],
  ['Is my AI API key safe?', 'Yes. AI calls run through secure Supabase Edge Functions, not directly from the mobile app.'],
  ['Can teams collaborate?', 'Yes. Teams can share projects with owner, admin, editor, and viewer roles.'],
  ['Can I export PDFs?', 'Yes. Premium users can export and share generated plans as PDFs.'],
  ['Is there a free plan?', 'Yes. Free users can start with limited monthly AI generations and free templates.'],
  ['How do subscriptions work?', 'Mobile subscriptions are handled through RevenueCat with App Store and Google Play billing.'],
  ['Can I use templates?', 'Yes. Browse free and premium marketplace templates to start projects faster.'],
  ['Do I need coding experience?', 'No. Beginners can use templates and guided outputs; developers can use the generated architecture as a fast starting point.']
];

export const useCases = [
  ['Startup founders', 'Validate app ideas faster with AI-generated scopes, MVP plans, and launch checklists.'],
  ['Freelancers', 'Create professional app proposals and project blueprints for clients.'],
  ['Agencies', 'Standardize discovery, estimation, templates, and handoff workflows across teams.'],
  ['Students', 'Learn how real mobile apps are structured with backend, auth, and deployment steps.'],
  ['Product managers', 'Turn feature ideas into organized requirements and implementation phases.'],
  ['Developers', 'Accelerate boilerplate planning for Flutter, Supabase, permissions, and release tasks.'],
  ['Small businesses', 'Explore app ideas for bookings, commerce, delivery, CRM, POS, and more.']
];
