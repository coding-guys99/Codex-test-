import { createClient } from '@supabase/supabase-js'

const FALLBACK_URL = 'https://edpdaxgphxrzvfjquzgp.supabase.co'
const FALLBACK_KEY = 'sb_publishable_gZitOhTr8USGqEJFyBvOHQ_VsSM9T1O'

export function getSupabase() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL || FALLBACK_URL
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || FALLBACK_KEY
  return createClient(url, key)
}
