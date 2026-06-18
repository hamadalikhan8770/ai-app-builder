import type { ButtonHTMLAttributes, AnchorHTMLAttributes, ReactNode } from 'react';

type Props = ButtonHTMLAttributes<HTMLButtonElement> & { href?: never; children: ReactNode; variant?: 'primary' | 'secondary' | 'danger' };
type LinkProps = AnchorHTMLAttributes<HTMLAnchorElement> & { href: string; children: ReactNode; variant?: 'primary' | 'secondary' | 'danger' };
const styles = { primary: 'bg-blue-500 text-white hover:bg-blue-400', secondary: 'border border-white/10 bg-white/5 text-white hover:bg-white/10', danger: 'bg-red-500 text-white hover:bg-red-400' };
export default function Button(props: Props | LinkProps) { const cls = `inline-flex items-center justify-center rounded-xl px-4 py-2 text-sm font-bold transition disabled:opacity-50 ${styles[props.variant ?? 'primary']}`; if ('href' in props && props.href) { const { variant, className='', ...rest } = props; return <a className={`${cls} ${className}`} {...rest} />; } const { variant, className='', ...rest } = props as Props; return <button className={`${cls} ${className}`} {...rest} />; }
