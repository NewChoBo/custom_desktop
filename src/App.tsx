import React, { memo, useMemo } from 'react'
import './App.css'

// 프로젝트 정보 타입 정의
interface ProjectInfo {
  id: string
  label: string
  completed: boolean
}

// 프로젝트 정보 컴포넌트
const ProjectInfoItem = memo(({ label, completed }: { label: string; completed: boolean }) => (
  <li className="project-info-item" aria-label={`${label} ${completed ? '완료됨' : '진행중'}`}>
    <span className="status-icon" role="img" aria-label={completed ? '완료' : '진행중'}>
      {completed ? '✅' : '🔄'}
    </span>
    {label}
  </li>
))

ProjectInfoItem.displayName = 'ProjectInfoItem'

// 상태 표시 컴포넌트
const StatusBadge = memo(({ status }: { status: string }) => (
  <p className="status" role="status" aria-live="polite">
    상태: <span className="success">{status}</span>
  </p>
))

StatusBadge.displayName = 'StatusBadge'

// 메인 앱 컴포넌트
const App: React.FC = () => {
  // 프로젝트 정보 데이터 - useMemo로 최적화
  const projectInfos = useMemo((): ProjectInfo[] => [
    { id: 'react-ts', label: 'React + TypeScript', completed: true },
    { id: 'electron', label: 'Electron', completed: true },
    { id: 'vite', label: 'Vite', completed: true },
    { id: 'cross-platform', label: '크로스 플랫폼 지원', completed: true }
  ], [])

  // 앱 상태 - 향후 동적으로 변경 가능
  const appStatus = useMemo(() => '정상 동작', [])

  return (
    <div className="App" role="main">
      <header className="App-header">
        <h1 className="app-title">
          <span role="img" aria-label="타겟">🎯</span>
          Custom Desktop Icons
        </h1>
        
        <p className="welcome-message">
          Hello World! 앱이 정상적으로 실행되었습니다.
        </p>
        
        <section className="info-box" aria-labelledby="project-info-title">
          <h2 id="project-info-title" className="info-title">
            프로젝트 정보
          </h2>
          <ul className="project-info-list" role="list">
            {projectInfos.map((info) => (
              <ProjectInfoItem 
                key={info.id}
                label={info.label}
                completed={info.completed}
              />
            ))}
          </ul>
        </section>
        
        <StatusBadge status={appStatus} />
      </header>
    </div>
  )
}

export default memo(App)