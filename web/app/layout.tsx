import type { Metadata } from 'next';
import './globals.css';
import Navbar from '@/components/site/Navbar';
import Footer from '@/components/site/Footer';
import SEOJsonLd from '@/components/site/SEOJsonLd';
import { siteUrl } from '@/lib/constants';

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: { default: 'AI App Builder - Build Mobile Apps Faster with AI', template: '%s | AI App Builder' },
  description: 'Plan, generate, and manage iOS and Android app projects with AI-powered templates, code outputs, collaboration, and PDF exports.',
  alternates: { canonical: '/' },
  openGraph: { title: 'AI App Builder - Build Mobile Apps Faster with AI', description: 'AI-powered templates, code outputs, collaboration, and PDF exports for iOS and Android apps.', url: siteUrl, siteName: 'AI App Builder', type: 'website' },
  twitter: { card: 'summary_large_image', title: 'AI App Builder', description: 'Build mobile apps faster with AI.' }
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body><SEOJsonLd /><Navbar />{children}<Footer /></body></html>;
}
