import type { TextareaHTMLAttributes } from 'react';
export default function Textarea(props: TextareaHTMLAttributes<HTMLTextAreaElement>) { return <textarea {...props} className={`input min-h-28 ${props.className ?? ''}`} />; }
