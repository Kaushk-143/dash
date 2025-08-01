import React from 'react'
import { Users, UserCheck, Activity, CreditCard } from 'lucide-react'
import { useAnalytics } from '../hooks/useAnalytics'
import MetricCard from './MetricCard'
import EventsChart from './EventsChart'
import UsersTable from './UsersTable'
import RecentEvents from './RecentEvents'
import UTMAnalytics from './UTMAnalytics'
import LoadingSpinner from './LoadingSpinner'
import ErrorMessage from './ErrorMessage'

const AnalyticsDashboard: React.FC = () => {
  const { data, loading, error, refetch } = useAnalytics()

  if (loading) return <LoadingSpinner />
  if (error) return <ErrorMessage message={error} onRetry={refetch} />

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-2xl font-bold text-gray-900">User Analytics</h2>
        <p className="text-gray-600 mt-1">Monitor user behavior and engagement metrics</p>
      </div>

      {/* Metrics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          title="Total Users"
          value={data.totalUsers}
          icon={Users}
          color="blue"
          trend={{ value: 12, isPositive: true }}
        />
        <MetricCard
          title="Active Users"
          value={data.activeUsers}
          icon={UserCheck}
          color="green"
          trend={{ value: 8, isPositive: true }}
        />
        <MetricCard
          title="Total Events"
          value={data.totalEvents}
          icon={Activity}
          color="purple"
          trend={{ value: 23, isPositive: true }}
        />
        <MetricCard
          title="Subscribed Users"
          value={data.subscribedUsers}
          icon={CreditCard}
          color="orange"
          trend={{ value: 5, isPositive: true }}
        />
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <EventsChart events={data.events} />
        <RecentEvents events={data.events} />
      </div>

      {/* UTM Analytics */}
      <UTMAnalytics events={data.events} />

      {/* Users Table */}
      <UsersTable users={data.users} />
    </div>
  )
}

export default AnalyticsDashboard