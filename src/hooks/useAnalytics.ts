@@ .. @@
   const fetchAnalyticsData = async () => {
     try {
       setLoading(true)
       setError(null)
     }
   }

-      // Fetch users with their sessions
+      // Fetch users with their sessions from existing database
       const { data: usersData, error: usersError } = await supabase
         .from('users')
-        .select(`
-          *,
-          user_sessions (*)
-        `)
+        .select(`
+          id,
+          first_name,
+          last_name,
+          email,
+          phone,
+          user_type,
+          has_active_subscription,
+          user_sessions (
+            id,
+            user_id,
+            is_active
+          )
+        `)

       if (usersError) throw usersError

-      // Fetch analytics events
+      // Fetch analytics events from existing database
       const { data: eventsData, error: eventsError } = await supabase
         .from('user_analytics_events')
-        .select('*')
-        .order('created_at', { ascending: false })
+        .select(`
+          id,
+          user_id,
+          event_type,
+          event_category,
+          event_action,
+          event_path,
+          page_section,
+          event_data,
+          utm_campaign,
+          utm_source,
+          utm_medium
+        `)
+        .order('id', { ascending: false })

       if (eventsError) throw eventsError