import React from 'react'
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip, Legend } from 'recharts'
import { UserAnalyticsEvent } from '../lib/supabase'

interface UTMAnalyticsProps {
  events: UserAnalyticsEvent[]
}

const UTMAnalytics: React.FC<UTMAnalyticsProps> = ({ events }) => {
  const COLORS = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#06b6d4']

  // Filter events with UTM data
  const utmEvents = events.filter(event => 
    event.utm_source || event.utm_medium || event.utm_campaign
  )

  // Group by UTM source
  const sourceData = utmEvents.reduce((acc, event) => {
    const source = event.utm_source || 'Direct'
    acc[source] = (acc[source] || 0) + 1
    return acc
  }, {} as Record<string, number>)

  // Group by UTM medium
  const mediumData = utmEvents.reduce((acc, event) => {
    const medium = event.utm_medium || 'None'
    acc[medium] = (acc[medium] || 0) + 1
    return acc
  }, {} as Record<string, number>)

  const sourceChartData = Object.entries(sourceData).map(([name, value]) => ({
    name,
    value
  }))

  const mediumChartData = Object.entries(mediumData).map(([name, value]) => ({
    name,
    value
  }))

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Traffic Sources</h3>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={sourceChartData}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                outerRadius={80}
                fill="#8884d8"
                dataKey="value"
              >
                {sourceChartData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Traffic Mediums</h3>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={mediumChartData}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                outerRadius={80}
                fill="#8884d8"
                dataKey="value"
              >
                {mediumChartData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  )
}

export default UTMAnalytics