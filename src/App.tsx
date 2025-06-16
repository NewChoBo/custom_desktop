import React, { memo, useMemo } from 'react'
import './App.css'

// 프로젝트 정보 타입 정의
interface ProjectInfo {
  id: string
  label: string
  completed: boolean
}

// 커스텀 타이틀바 컴포넌트
const CustomTitleBar = memo(() => {
  const handleClose = () => {
    // 일단 브라우저의 기본 닫기 동작 사용
    window.close();
  };

  const handleMinimize = () => {
    // 최소화는 일단 숨기기로 대체
    console.log('Minimize clicked');
  };

  return (
    <div className="custom-titlebar" style={{ WebkitAppRegion: 'drag' } as React.CSSProperties}>
      <div className="titlebar-content">
        <span className="app-icon">🎯</span>
        <span className="app-name">Desktop Icons</span>
      </div>
      <div className="titlebar-controls" style={{ WebkitAppRegion: 'no-drag' } as React.CSSProperties}>
        <button 
          className="titlebar-button minimize" 
          onClick={handleMinimize}
          aria-label="최소화"
          title="최소화"
        >
          −
        </button>
        <button 
          className="titlebar-button close" 
          onClick={handleClose}
          aria-label="닫기"
          title="닫기"
        >
          ×
        </button>
      </div>
    </div>
  );
});

CustomTitleBar.displayName = 'CustomTitleBar';

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
  const appStatus = useMemo(() => '정상 동작', []);

  return (
    <div className="App" role="main">
      <CustomTitleBar />
      <div className="app-content">
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
    </div>
  )
}

export default memo(App)