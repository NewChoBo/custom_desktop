import React, { memo, useCallback, useEffect, useMemo, useState } from 'react';
import './App.css';
import { IconGrid } from './components/IconGrid';
import { SettingsPanel } from './components/SettingsPanel';
import { IconConfig, IconData } from './types/IconTypes';

// 커스텀 타이틀바 컴포넌트
interface CustomTitleBarProps {
  onSettingsClick: () => void;
}

const CustomTitleBar = memo<CustomTitleBarProps>(({ onSettingsClick }) => {
  const handleClose = () => {
    window.close();
  };

  const handleMinimize = () => {
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
          className="titlebar-button settings"
          onClick={onSettingsClick}
          aria-label="설정"
          title="설정"
        >
          ⚙️
        </button>
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

// 메인 앱 컴포넌트
const App: React.FC = () => {
  // 설정 패널 상태
  const [isSettingsOpen, setIsSettingsOpen] = useState<boolean>(false);

  // 앱 설정 상태
  const [appConfig, setAppConfig] = useState<AppConfig | null>(null);

  // 아이콘 설정 로드
  const [iconConfig, setIconConfig] = useState<IconConfig | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  // 설정 패널 핸들러
  const handleSettingsOpen = useCallback(() => {
    setIsSettingsOpen(true);
  }, []);

  const handleSettingsClose = useCallback(() => {
    setIsSettingsOpen(false);
  }, []);

  // 앱 설정 로드
  useEffect(() => {
    const loadAppConfig = async () => {
      try {
        if (window.electronAPI?.getConfig) {
          const result = await window.electronAPI.getConfig();
          if (result.success && result.config) {
            setAppConfig(result.config);
          }
        }
      } catch (err) {
        console.error('Failed to load app config:', err);
      }
    };

    loadAppConfig();

    // 설정 변경 리스너
    if (window.electronAPI?.onConfigUpdated) {
      window.electronAPI.onConfigUpdated((newConfig: AppConfig) => {
        setAppConfig(newConfig);
      });
    }

    return () => {
      if (window.electronAPI?.removeConfigUpdatedListener) {
        window.electronAPI.removeConfigUpdatedListener();
      }
    };
  }, []);

  // 기본 아이콘 설정 (폴백용)
  const defaultIconConfig: IconConfig = useMemo(() => ({
    layout: {
      gridRows: 4,
      gridCols: 6,
      gap: 12,
      iconSize: {
        width: 64,
        height: 64
      },
      autoArrange: false
    },
    icons: [
      {
        id: 'chrome',
        title: 'Chrome',
        description: 'Google Chrome 브라우저',
        icon: '🌐',
        type: 'app',
        path: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
        gridPosition: { row: 1, col: 1 },
        style: { backgroundColor: '#4285f4', textColor: '#ffffff' },
        isVisible: true,
        order: 1
      },
      {
        id: 'steam',
        title: 'Steam',
        description: 'Steam 게임 플랫폼',
        icon: '🎮',
        type: 'app',
        path: 'C:\\Program Files (x86)\\Steam\\steam.exe',
        gridPosition: { row: 1, col: 2 },
        style: { backgroundColor: '#1b2838', textColor: '#ffffff' },
        isVisible: true,
        order: 2
      },
      {
        id: 'github',
        title: 'GitHub',
        description: '코드 저장소',
        icon: '🐙',
        type: 'url',
        url: 'https://github.com',
        gridPosition: { row: 1, col: 3 },
        style: { backgroundColor: '#24292f', textColor: '#ffffff' },
        isVisible: true,
        order: 3
      }
    ]
  }), []);

  // 아이콘 설정 로드
  useEffect(() => {
    const loadIconConfig = async () => {
      try {
        setLoading(true);
        setError(null);

        // Electron API를 통해 아이콘 설정 로드
        if (window.electronAPI?.loadIconConfig) {
          const config = await window.electronAPI.loadIconConfig();
          setIconConfig(config);
        } else {
          // 개발 환경에서는 기본 설정 사용
          setIconConfig(defaultIconConfig);
        }
      } catch (err) {
        console.error('Failed to load icon config:', err);
        setError('아이콘 설정을 로드하는데 실패했습니다.');
        setIconConfig(defaultIconConfig); // 기본 설정으로 폴백
      } finally {
        setLoading(false);
      }
    };

    loadIconConfig();
  }, [defaultIconConfig]);

  const handleIconClick = (icon: IconData) => {
    console.log('Icon clicked:', icon.title);
  };

  const handleIconDoubleClick = async (icon: IconData) => {
    console.log('Icon double-clicked:', icon.title);

    if (!window.electronAPI) {
      console.warn('Electron API not available');
      return;
    }

    try {
      switch (icon.type) {
        case 'app':
          if (icon.path) {
            const result = await window.electronAPI.launchApp(icon.path);
            if (!result.success) {
              console.error('Failed to launch app:', result.error);
            }
          }
          break;
        case 'directory':
          if (icon.path) {
            const result = await window.electronAPI.openDirectory(icon.path);
            if (!result.success) {
              console.error('Failed to open directory:', result.error);
            }
          }
          break;
        case 'url':
          if (icon.url) {
            const result = await window.electronAPI.openUrl(icon.url);
            if (!result.success) {
              console.error('Failed to open URL:', result.error);
            }
          }
          break;
        case 'steam-game':
          if (icon.steamId) {
            const result = await window.electronAPI.launchSteamGame(icon.steamId);
            if (!result.success) {
              console.error('Failed to launch Steam game:', result.error);
            }
          }
          break;
        default:
          console.log('Unknown icon type:', icon.type);
      }
    } catch (error) {
      console.error('Failed to execute icon action:', error);
    }
  };
  // CSS 변수 설정
  const appStyle = useMemo(() => ({
    '--border-radius': `${appConfig?.ui.borderRadius || 12}px`,
  } as React.CSSProperties), [appConfig?.ui.borderRadius]);

  // 로딩 중이면 로딩 화면 표시
  if (!appConfig) {
    return (
      <div className="App">
        <div className="loading">
          <div className="loading-spinner">⏳</div>
          <p>설정 로딩 중...</p>
        </div>
      </div>
    );
  }

  return (
    <div
      className={`App ${appConfig.ui.roundedCorners ? 'rounded-corners' : ''}`}
      role="main"
      style={appStyle}
    >
      {appConfig.ui.showTitleBar && <CustomTitleBar onSettingsClick={handleSettingsOpen} />}

      <div className="app-content">
        {loading ? (
          <div className="loading">
            <div className="loading-spinner">⏳</div>
            <p>아이콘 로딩 중...</p>
          </div>
        ) : error ? (
          <div className="error">
            <div className="error-icon">⚠️</div>
            <p>{error}</p>
            <button onClick={() => window.location.reload()} className="retry-button">
              다시 시도
            </button>
          </div>
        ) : iconConfig ? (
          <IconGrid
            config={iconConfig}
            onIconClick={handleIconClick}
            onIconDoubleClick={handleIconDoubleClick}
          />
        ) : (
          <div className="no-icons">
            <div className="no-icons-icon">📂</div>
            <p>아이콘이 없습니다.</p>
          </div>
        )}
      </div>

      {/* 설정 패널 */}
      <SettingsPanel
        isOpen={isSettingsOpen}
        onClose={handleSettingsClose}
      />

      {/* 플로팅 설정 버튼 (조건부 표시) */}
      {appConfig.ui.showSettingsButton && !appConfig.ui.showTitleBar && (
        <button
          className="floating-settings-button"
          onClick={handleSettingsOpen}
          aria-label="설정"
          title="설정"
        >
          ⚙️
        </button>
      )}
    </div>
  )
}

export default memo(App)