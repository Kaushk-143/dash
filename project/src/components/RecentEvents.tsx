import React from 'react'
import { UserAnalyticsEvent } from '../lib/supabase'
import { Activity, MousePointer, Eye, Click } from 'lucide-react'

interface RecentEventsProps {
  events: UserAnalyticsEvent[]
}

const RecentEvents: React.FC<RecentEventsProps> = ({ events }) => {
  const getEventIcon = (eventType: string) => {
    switch (eventType.toLowerCase()) {
      case 'click':
        return <Click className="w-4 h-4" />
      case 'view':
        return <Eye className="w-4 h-4" />
      case 'hover':
        return <MousePointer className="w-4 h-4" />
      default:
        return <Activity className="w-4 h-4" />
    }
  }

  const getEventColor = (eventType: string) => {
    switch (eventType.toLowerCase()) {
      case 'click':
        return 'text-blue-600 bg-blue-50'
      case 'view':
        return 'text-green-600 bg-green-50'
      case 'hover':
        return 'text-purple-600 bg-purple-50'
      default:
        return 'text-gray-600 bg-gray-50'
    }
  }

  const recentEvents = events.slice(0, 10)

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Events</h3>
      <div className="space-y-4">
        {recentEvents.map((event) => (
          <div key={event.id} className="flex items-start space-x-3 p-3 rounded-lg hover:bg-gray-50">
            <div className={`p-2 rounded-lg ${getEventColor(event.event_type)}`}>
              {getEventIcon(event.event_type)}
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between">
                <p className="text-sm font-medium text-gray-900">
                  {event.event_action}
                </p>
                <p className="text-xs text-gray-500">
                  {new Date(event.created_at).toLocaleTimeString()}
                </p>
              </div>
              <p className="text-sm text-gray-600">{event.event_category}</p>
              <p className="text-xs text-gray-500 mt-1">{event.event_path}</p>
              {event.page_section && (
                <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800 mt-2">
                  {event.page_section}
                </span>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default RecentEvents

export default RecentEvents