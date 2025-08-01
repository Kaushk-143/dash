/*
  # User Analytics Database Schema

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
      - `utm_campaign` (text)
      - `utm_source` (text)
      - `utm_medium` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to read data
*/

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL DEFAULT '',
  last_name text NOT NULL DEFAULT '',
  email text UNIQUE NOT NULL,
  phone text DEFAULT '',
  user_type text NOT NULL DEFAULT 'user',
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
  event_type text NOT NULL DEFAULT '',
  event_category text NOT NULL DEFAULT '',
  event_action text NOT NULL DEFAULT '',
  event_path text DEFAULT '',
  page_section text DEFAULT '',
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

-- Create policies for authenticated users to read all data
CREATE POLICY "Allow authenticated users to read users"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to read sessions"
  ON user_sessions
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to read events"
  ON user_analytics_events
  FOR SELECT
  TO authenticated
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_is_active ON user_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_user_id ON user_analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_event_type ON user_analytics_events(event_type);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_created_at ON user_analytics_events(created_at);