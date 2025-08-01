/*
  # Insert Sample Data for User Analytics

  1. Sample Data
    - Insert sample users with various types and subscription statuses
    - Insert sample user sessions (active and inactive)
    - Insert sample analytics events with different types and UTM parameters

  2. Purpose
    - Provides realistic data for testing the analytics dashboard
    - Demonstrates various user behaviors and event types
*/

-- Insert sample users
INSERT INTO users (first_name, last_name, email, phone, user_type, has_active_subscription) VALUES
('John', 'Doe', 'john.doe@example.com', '+1-555-0101', 'premium', true),
('Jane', 'Smith', 'jane.smith@example.com', '+1-555-0102', 'standard', false),
('Mike', 'Johnson', 'mike.johnson@example.com', '+1-555-0103', 'premium', true),
('Sarah', 'Williams', 'sarah.williams@example.com', '+1-555-0104', 'standard', false),
('David', 'Brown', 'david.brown@example.com', '+1-555-0105', 'enterprise', true),
('Lisa', 'Davis', 'lisa.davis@example.com', '+1-555-0106', 'standard', true),
('Tom', 'Wilson', 'tom.wilson@example.com', '+1-555-0107', 'premium', false),
('Emma', 'Taylor', 'emma.taylor@example.com', '+1-555-0108', 'standard', true)
ON CONFLICT (email) DO NOTHING;

-- Insert sample user sessions
INSERT INTO user_sessions (user_id, is_active, created_at, updated_at)
SELECT 
  u.id,
  CASE WHEN random() > 0.3 THEN true ELSE false END,
  now() - interval '1 day' * random() * 30,
  now() - interval '1 hour' * random() * 24
FROM users u
ON CONFLICT DO NOTHING;

-- Insert additional sessions for some users
INSERT INTO user_sessions (user_id, is_active, created_at, updated_at)
SELECT 
  u.id,
  CASE WHEN random() > 0.5 THEN true ELSE false END,
  now() - interval '1 day' * random() * 7,
  now() - interval '1 hour' * random() * 12
FROM users u
WHERE random() > 0.5
ON CONFLICT DO NOTHING;

-- Insert sample analytics events
INSERT INTO user_analytics_events (
  user_id, 
  event_type, 
  event_category, 
  event_action, 
  event_path, 
  page_section, 
  event_data,
  utm_campaign,
  utm_source,
  utm_medium,
  created_at
)
SELECT 
  u.id,
  (ARRAY['click', 'view', 'hover', 'scroll', 'form_submit'])[floor(random() * 5 + 1)],
  (ARRAY['navigation', 'content', 'form', 'button', 'link'])[floor(random() * 5 + 1)],
  (ARRAY['page_view', 'button_click', 'form_submit', 'link_click', 'scroll_depth'])[floor(random() * 5 + 1)],
  (ARRAY['/home', '/dashboard', '/profile', '/settings', '/billing', '/help'])[floor(random() * 6 + 1)],
  (ARRAY['header', 'sidebar', 'main', 'footer', 'modal'])[floor(random() * 5 + 1)],
  '{"additional": "data"}',
  CASE WHEN random() > 0.7 THEN (ARRAY['summer_sale', 'new_user', 'retention', 'feature_launch'])[floor(random() * 4 + 1)] ELSE NULL END,
  CASE WHEN random() > 0.6 THEN (ARRAY['google', 'facebook', 'twitter', 'email', 'direct'])[floor(random() * 5 + 1)] ELSE NULL END,
  CASE WHEN random() > 0.6 THEN (ARRAY['cpc', 'organic', 'social', 'email', 'referral'])[floor(random() * 5 + 1)] ELSE NULL END,
  now() - interval '1 day' * random() * 30
FROM users u
CROSS JOIN generate_series(1, floor(random() * 20 + 5)::int);