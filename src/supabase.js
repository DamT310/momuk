import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL || 'https://pnjeklaxacepvztnfgom.supabase.co';
const publishableKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_MKqnY9-DncQvrvqGjBEPpA_Bisx32sn';

export const supabaseEnabled = Boolean(url && publishableKey);
export const supabase = supabaseEnabled
  ? createClient(url, publishableKey, {
      auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
    })
  : null;

export const RESOURCE_BUCKET = 'learning-materials';

export async function fetchResources() {
  if (!supabase) return [];
  const { data, error } = await supabase
    .from('learning_resources')
    .select('*')
    .order('created_at', { ascending: false });
  if (error) throw error;
  return data.map(row => ({
    id: row.id,
    kind: row.kind,
    title: row.title,
    description: row.description,
    url: row.external_url || (row.storage_path
      ? supabase.storage.from(RESOURCE_BUCKET).getPublicUrl(row.storage_path).data.publicUrl
      : ''),
    storagePath: row.storage_path,
    fileName: row.file_name || '',
    fileSize: row.file_size || 0,
    createdAt: new Date(row.created_at).toLocaleDateString('ko-KR')
  }));
}

export async function createResource({ kind, title, description, url, file }) {
  if (!supabase) throw new Error('Supabase가 설정되지 않았습니다.');
  let storagePath = null;
  if (file) {
    const safeName = file.name.normalize('NFKD').replace(/[^a-zA-Z0-9._-]/g, '-');
    storagePath = `${kind}/${crypto.randomUUID()}-${safeName}`;
    const { error: uploadError } = await supabase.storage
      .from(RESOURCE_BUCKET)
      .upload(storagePath, file, { cacheControl: '3600', upsert: false, contentType: file.type || undefined });
    if (uploadError) throw uploadError;
  }
  const { data, error } = await supabase.from('learning_resources').insert({
    kind,
    title,
    description,
    external_url: url || null,
    storage_path: storagePath,
    file_name: file?.name || null,
    file_size: file?.size || null
  }).select().single();
  if (error) {
    if (storagePath) await supabase.storage.from(RESOURCE_BUCKET).remove([storagePath]);
    throw error;
  }
  return data;
}

