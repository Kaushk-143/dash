import React from 'react'
import { BarChart3 } from 'lucide-react'

interface SidebarProps {
  activeSection: string
  onSectionChange: (section: string) => void
}

const Sidebar: React.FC<SidebarProps> = ({ activeSection, onSectionChange }) => {
  return (
    <div className="w-64 bg-white border-r border-gray-200 h-screen fixed left-0 top-0 z-10">
      <div className="p-6">
        <div className="flex items-center space-x-3 mb-8">
          <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
            <BarChart3 className="w-5 h-5 text-white" />
          </div>
          <h1 className="text-xl font-bold text-gray-900">Analytics</h1>
        </div>
        
        <nav className="space-y-2">
          <button
            onClick={() => onSectionChange('analytics')}
            className={`sidebar-item w-full text-left ${
              activeSection === 'analytics' ? 'active' : ''
            }`}
          >
            <BarChart3 className="w-5 h-5 mr-3" />
            User Analytics
          </button>
        </nav>
      </div>
    </div>
  )
}

export default Sidebar