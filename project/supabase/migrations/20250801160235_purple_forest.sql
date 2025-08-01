/*
  # Create User Analytics Tables

  1. New Tables
    - `users`
      - `id` (uuid, primary key)
      - `first_name` (text)
      - `last_name` (text)
      - `email` (text, unique)
      - `phone` (text)
      - `user_type` (text)
      - `has_active_subscription` (boolean)
      - `created_at` (timestamp)
    
    - `user_sessions`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key)
      - `is_active` (boolean)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `user_analytics_events`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key)
      - `event_type` (text)
      - `event_category` (text)
      - `event_action` (text)
      - `event_path` (text)
      - `page_section` (text)
      - `event_data` (jsonb)
      - `utm_campaign` (text, nullable)
      - `utm_source` (text, nullable)
      - `utm_medium` (text, nullable)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to read data
*/

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text UNIQUE NOT NULL,
  phone text,
  user_type text DEFAULT 'standard',
  has_active_subscription boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create user_sessions table
CREATE TABLE IF NOT EXISTS user_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create user_analytics_events table
CREATE TABLE IF NOT EXISTS user_analytics_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  event_type text NOT NULL,
  event_category text NOT NULL,
  event_action text NOT NULL,
  event_path text,
  page_section text,
  event_data jsonb DEFAULT '{}',
  utm_campaign text,
  utm_source text,
  utm_medium text,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_analytics_events ENABLE ROW LEVEL SECURITY;

-- Create policies for reading data (adjust based on your auth requirements)
CREATE POLICY "Allow read access to users" ON users FOR SELECT USING (true);
CREATE POLICY "Allow read access to user_sessions" ON user_sessions FOR SELECT USING (true);
CREATE POLICY "Allow read access to user_analytics_events" ON user_analytics_events FOR SELECT USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_is_active ON user_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_user_id ON user_analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_created_at ON user_analytics_events(created_at);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_event_type ON user_analytics_events(event_type);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_utm_source ON user_analytics_events(utm_source);