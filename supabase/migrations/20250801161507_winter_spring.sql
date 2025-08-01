/*
  # User Analytics Database Schema for Marketing Dashboard

  1. Tables Structure (for existing database)
    - `users` table with columns: first_name, last_name, email, phone, user_type, has_active_subscription
    - `user_sessions` table with columns: user_id, is_active
    - `user_analytics_events` table with columns: user_id, event_type, event_category, event_action, event_path, page_section, event_data, utm_campaign, utm_source, utm_medium

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to read data for marketing analytics
*/

-- Enable Row Level Security on existing tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_analytics_events ENABLE ROW LEVEL SECURITY;

-- Create policies for marketing team to read analytics data
CREATE POLICY "Allow authenticated users to read users for analytics"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to read sessions for analytics"
  ON user_sessions
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to read events for analytics"
  ON user_analytics_events
  FOR SELECT
  TO authenticated
  USING (true);

-- Create indexes for better performance on analytics queries
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_is_active ON user_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_user_id ON user_analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_event_type ON user_analytics_events(event_type);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_created_at ON user_analytics_events(created_at);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_utm_source ON user_analytics_events(utm_source);
CREATE INDEX IF NOT EXISTS idx_user_analytics_events_utm_campaign ON user_analytics_events(utm_campaign);