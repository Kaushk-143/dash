/*
  # Insert Sample Data for Analytics Dashboard

  1. Sample Data
    - Insert sample users with various types and subscription statuses
    - Insert sample user sessions (active and inactive)
    - Insert sample analytics events with different categories and UTM parameters

  2. Purpose
    - Provide realistic data for testing the analytics dashboard
    - Demonstrate various user behaviors and event types
*/

-- Insert sample users
INSERT INTO users (first_name, last_name, email, phone, user_type, has_active_subscription) VALUES
('John', 'Doe', 'john.doe@example.com', '+1234567890', 'premium', true),
('Jane', 'Smith', 'jane.smith@example.com', '+1234567891', 'basic', false),
('Mike', 'Johnson', 'mike.johnson@example.com', '+1234567892', 'premium', true),
('Sarah', 'Wilson', 'sarah.wilson@example.com', '+1234567893', 'basic', true),
('David', 'Brown', 'david.brown@example.com', '+1234567894', 'admin', true),
('Lisa', 'Davis', 'lisa.davis@example.com', '+1234567895', 'basic', false),
('Tom', 'Miller', 'tom.miller@example.com', '+1234567896', 'premium', true),
('Emma', 'Garcia', 'emma.garcia@example.com', '+1234567897', 'basic', false),
('Alex', 'Martinez', 'alex.martinez@example.com', '+1234567898', 'premium', true),
('Sophie', 'Anderson', 'sophie.anderson@example.com', '+1234567899', 'basic', true)
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
  CASE 
    WHEN random() < 0.3 THEN 'click'
    WHEN random() < 0.6 THEN 'view'
    WHEN random() < 0.8 THEN 'purchase'
    ELSE 'signup'
  END,
  CASE 
    WHEN random() < 0.25 THEN 'navigation'
    WHEN random() < 0.5 THEN 'content'
    WHEN random() < 0.75 THEN 'commerce'
    ELSE 'user_action'
  END,
  CASE 
    WHEN random() < 0.2 THEN 'button_click'
    WHEN random() < 0.4 THEN 'page_view'
    WHEN random() < 0.6 THEN 'form_submit'
    WHEN random() < 0.8 THEN 'download'
    ELSE 'share'
  END,
  CASE 
    WHEN random() < 0.2 THEN '/dashboard'
    WHEN random() < 0.4 THEN '/products'
    WHEN random() < 0.6 THEN '/checkout'
    WHEN random() < 0.8 THEN '/profile'
    ELSE '/settings'
  END,
  CASE 
    WHEN random() < 0.25 THEN 'header'
    WHEN random() < 0.5 THEN 'sidebar'
    WHEN random() < 0.75 THEN 'main_content'
    ELSE 'footer'
  END,
  '{"browser": "Chrome", "device": "desktop"}',
  CASE 
    WHEN random() < 0.3 THEN 'summer_sale'
    WHEN random() < 0.6 THEN 'newsletter'
    ELSE NULL
  END,
  CASE 
    WHEN random() < 0.2 THEN 'google'
    WHEN random() < 0.4 THEN 'facebook'
    WHEN random() < 0.6 THEN 'twitter'
    WHEN random() < 0.8 THEN 'email'
    ELSE 'direct'
  END,
  CASE 
    WHEN random() < 0.3 THEN 'cpc'
    WHEN random() < 0.6 THEN 'social'
    WHEN random() < 0.8 THEN 'email'
    ELSE 'organic'
  END,
  now() - interval '1 day' * random() * 30
FROM users u
CROSS JOIN generate_series(1, 5 + floor(random() * 10)::int)
ON CONFLICT DO NOTHING;