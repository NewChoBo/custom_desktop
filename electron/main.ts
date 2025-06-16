import { app, BrowserWindow, Tray, Menu, nativeImage } from 'electron';
import * as path from 'path';
import { loadConfig, calculateWindowPosition, AppConfig } from './config-loader';

let mainWindow: BrowserWindow | null = null;
let tray: Tray | null = null;
let isQuitting = false;
let appConfig: AppConfig;

const isDev = process.env.NODE_ENV === 'development';

// 설정 기반으로 창을 배치하는 함수
function setWindowPosition(window: BrowserWindow): void {
  try {
    // 설정에서 위치 계산
    const position = calculateWindowPosition(appConfig.window);
    
    window.setSize(appConfig.window.width, appConfig.window.height);
    window.setPosition(position.x, position.y);
    
    // 기타 설정 적용
    window.setAlwaysOnTop(appConfig.window.alwaysOnTop);
    window.setResizable(appConfig.window.resizable);
    
    if (appConfig.behavior.hideToTray) {
      window.setSkipTaskbar(false); // 트레이 사용 시 작업표시줄에 표시
    }
    
    // 포커스 관련 설정
    window.setVisibleOnAllWorkspaces(true);
    
    if (appConfig.behavior.startMinimized) {
      window.blur();
    }
    
  } catch (error) {
    console.log('Window positioning failed:', error);
  }
}

function createWindow(): void {
  // 설정 로드
  appConfig = loadConfig();
  
  mainWindow = new BrowserWindow({
    width: appConfig.window.width,
    height: appConfig.window.height,
    minWidth: appConfig.window.minWidth,
    minHeight: appConfig.window.minHeight,
    show: false,
    // 가벼운 위젯 UI 설정
    frame: false, // 타이틀바 완전 제거
    transparent: true, // 투명 배경 (더 가벼운 느낌)
    alwaysOnTop: appConfig.window.alwaysOnTop,
    skipTaskbar: false,
    resizable: appConfig.window.resizable,
    movable: appConfig.window.movable,
    minimizable: false, // 최소화 버튼 제거
    maximizable: false, // 최대화 버튼 제거
    closable: true,
    focusable: true,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
      webSecurity: !isDev
    },
    // Windows에서 추가 설정
    ...(process.platform === 'win32' && {
      autoHideMenuBar: true,
      type: 'normal',
      roundedCorners: true // Windows 11에서 둥근 모서리
    })
  });

  // Load the app
  if (isDev) {
    mainWindow.loadURL('http://localhost:5173');
    mainWindow.webContents.openDevTools();
  } else {
    mainWindow.loadFile(path.join(__dirname, '../dist/index.html'));
  }  // Show window when ready
  mainWindow.once('ready-to-show', () => {
    mainWindow?.show();    // 바탕화면 위젯으로 설정
    if (mainWindow) {
      setWindowPosition(mainWindow);
    }
  });  // Handle window close - 트레이로 숨기기
  mainWindow.on('close', (event) => {
    if (!isQuitting) {
      event.preventDefault();
      mainWindow?.hide();
    }
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// 시스템 트레이 생성 함수
function createTray(): void {
  // 트레이 아이콘 생성 (간단한 텍스트 기반 아이콘)
  const icon = nativeImage.createFromDataURL(
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='
  );
  
  tray = new Tray(icon);
  
  const contextMenu = Menu.buildFromTemplate([
    {
      label: '🎯 Desktop Icons',
      type: 'normal',
      enabled: false
    },
    {
      type: 'separator'
    },
    {
      label: '보이기',
      type: 'normal',
      click: () => {
        if (mainWindow) {
          mainWindow.show();
          mainWindow.focus();
        }
      }
    },
    {
      label: '숨기기',
      type: 'normal',
      click: () => {
        if (mainWindow) {
          mainWindow.hide();
        }
      }
    },
    {
      type: 'separator'
    },
    {
      label: '설정',
      type: 'normal',
      click: () => {
        console.log('설정 열기');
      }
    },
    {
      type: 'separator'
    },    {
      label: '종료',
      type: 'normal',
      click: () => {
        isQuitting = true;
        app.quit();
      }
    }
  ]);
  
  tray.setContextMenu(contextMenu);
  tray.setToolTip('Custom Desktop Icons');
  
  // 트레이 아이콘 더블클릭 시 창 보이기/숨기기
  tray.on('double-click', () => {
    if (mainWindow) {
      if (mainWindow.isVisible()) {
        mainWindow.hide();
      } else {
        mainWindow.show();
        mainWindow.focus();
      }
    }
  });
}

app.whenReady().then(() => {
  createWindow();
  createTray();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  isQuitting = true;
});

console.log('🚀 Electron app starting...');
