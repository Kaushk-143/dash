import { useState, useEffect } from 'react'
import { supabase, User, UserSession, UserAnalyticsEvent, UserWithSession } from '../lib/supabase'

export interface AnalyticsData {
  users: UserWithSession[]
  events: UserAnalyticsEvent[]
  totalUsers: number
  activeUsers: number
  totalEvents: number
  subscribedUsers: number
}

export const useAnalytics = () => {
  const [data, setData] = useState<AnalyticsData>({
    users: [],
    events: [],
    totalUsers: 0,
    activeUsers: 0,
    totalEvents: 0,
    subscribedUsers: 0
  })
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchAnalyticsData = async () => {
    try {
      setLoading(true)
      setError(null)

      // Fetch users with their sessions
      const { data: usersData, error: usersError } = await supabase
        .from('users')
        .select(`
          *,
          user_sessions (*)
        `)

      if (usersError) throw usersError

      // Fetch analytics events
      const { data: eventsData, error: eventsError } = await supabase
        .from('user_analytics_events')
        .select('*')
        .order('created_at', { ascending: false })

      if (eventsError) throw eventsError

      const users = usersData as UserWithSession[]
      const events = eventsData as UserAnalyticsEvent[]

      // Calculate metrics
      const totalUsers = users.length
      const activeUsers = users.filter(user => 
        user.user_sessions.some(session => session.is_active)
      ).length
      const totalEvents = events.length
      const subscribedUsers = users.filter(user => user.has_active_subscription).length

      setData({
        users,
        events,
        totalUsers,
        activeUsers,
        totalEvents,
        subscribedUsers
      })
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchAnalyticsData()
  }, [])

  return { data, loading, error, refetch: fetchAnalyticsData }
}