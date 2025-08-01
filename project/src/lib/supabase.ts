import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || ''
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || ''

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Types for our database tables
export interface User {
  id: string
  first_name: string
  last_name: string
  email: string
  phone: string
  user_type: string
  has_active_subscription: boolean
  created_at: string
}

export interface UserSession {
  id: string
  user_id: string
  is_active: boolean
  created_at: string
  updated_at: string
}

export interface UserAnalyticsEvent {
  id: string
  user_id: string
  event_type: string
  event_category: string
  event_action: string
  event_path: string
  page_section: string
  event_data: any
  utm_campaign: string | null
  utm_source: string | null
  utm_medium: string | null
  created_at: string
}

export interface UserWithSession extends User {
  user_sessions: UserSession[]
}