import React from 'react'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import { UserAnalyticsEvent } from '../lib/supabase'

interface EventsChartProps {
  events: UserAnalyticsEvent[]
}

const EventsChart: React.FC<EventsChartProps> = ({ events }) => {
  // Group events by category
  const eventsByCategory = events.reduce((acc, event) => {
    const category = event.event_category || 'Unknown'
    acc[category] = (acc[category] || 0) + 1
    return acc
  }, {} as Record<string, number>)

  const chartData = Object.entries(eventsByCategory).map(([category, count]) => ({
    category,
    count
  }))

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <h3 className="text-lg font-semibold text-gray-900 mb-4">Events by Category</h3>
      <div className="h-80">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="category" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="count" fill="#3b82f6" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  )
}

export default EventsChart