import React, { useState } from 'react'
import Sidebar from './components/Sidebar'
import AnalyticsDashboard from './components/AnalyticsDashboard'

function App() {
  const [activeSection, setActiveSection] = useState('analytics')

  return (
    <div className="min-h-screen bg-gray-50">
      <Sidebar activeSection={activeSection} onSectionChange={setActiveSection} />
      
      <main className="ml-64 p-8">
        {activeSection === 'analytics' && <AnalyticsDashboard />}
      </main>
    </div>
  )
}

export default App