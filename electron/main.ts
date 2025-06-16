import { exec } from 'child_process';
import { app, BrowserWindow, ipcMain, Menu, nativeImage, shell, Tray } from 'electron';
import * as fs from 'fs';
import * as path from 'path';
import { AppConfig, calculateWindowPosition, loadConfig } from './config-loader';

let mainWindow: BrowserWindow | null = null;
let tray: Tray | null = null;
let isQuitting = false;
let appConfig: AppConfig;

const isDev = process.env.NODE_ENV === 'development';

// stayBehind 모드를 위한 간단한 이벤트 리스너
const stayBehindWindows = new Set<BrowserWindow>();

function setupStayBehindMode(window: BrowserWindow): void {
  stayBehindWindows.add(window);

  // 포커스를 받으면 즉시 제거
  const handleFocus = () => {
    if (stayBehindWindows.has(window) && !window.isDestroyed()) {
      window.blur();
    }
  };

  // 이벤트 리스너 등록
  window.on('focus', handleFocus);

  // 창이 닫힐 때 정리
  window.on('closed', () => {
    stayBehindWindows.delete(window);
  });
}

function stopStayBehindMode(): void {
  // stayBehindWindows Set에서 모든 창 제거
  stayBehindWindows.clear();
}

// 설정 기반으로 창을 배치하는 함수
function setWindowPosition(window: BrowserWindow, displayIndex: number = 0): void {
  try {
    // 설정에서 위치 및 크기 계산
    const { x, y, width, height } = calculateWindowPosition(appConfig.window, displayIndex);

    window.setSize(width, height);
    window.setPosition(x, y);

    // 기타 설정 적용
    window.setAlwaysOnTop(appConfig.window.windowLevel === 'alwaysOnTop');
    window.setResizable(appConfig.window.resizable);

    // 작업표시줄 숨김 설정
    if (appConfig.behavior.hideFromTaskbar) {
      window.setSkipTaskbar(true);
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

// 여러 창을 생성하는 함수
function createMultipleWindows(displayIndexes: number[] = [0]): BrowserWindow[] {
  const windows: BrowserWindow[] = [];

  displayIndexes.forEach((displayIndex, index) => {
    const window = createWindow(displayIndex, index === 0); // 첫 번째 창만 메인 창으로 설정
    if (window) {
      windows.push(window);
    }
  });

  return windows;
}

function createWindow(displayIndex: number = 0, isMain: boolean = true): BrowserWindow | null {
  // 설정 로드 (메인 창일 때만)
  if (isMain) {
    appConfig = loadConfig();
  }

  // 창 크기 및 위치 계산
  const { x, y, width, height } = calculateWindowPosition(appConfig.window, displayIndex);

  // 창 설정 객체 생성
  const windowOptions: Electron.BrowserWindowConstructorOptions = {
    width,
    height,
    x,
    y,
    minWidth: appConfig.window.minWidth,
    minHeight: appConfig.window.minHeight,
    show: false,

    // UI 설정
    frame: false,
    transparent: !appConfig.ui.roundedCorners,

    // 위젯 설정 - 항상 toolbar 타입으로 통일
    type: 'toolbar',
    alwaysOnTop: appConfig.window.windowLevel === 'alwaysOnTop',
    skipTaskbar: appConfig.window.windowLevel === 'stayBehind' || appConfig.behavior.hideFromTaskbar,
    focusable: appConfig.window.windowLevel !== 'stayBehind',

    // 창 동작 설정
    resizable: appConfig.window.resizable,
    movable: appConfig.window.movable,
    minimizable: false,
    maximizable: false,
    closable: true,
    fullscreenable: appConfig.window.fullscreenable || false,

    // 보안 설정
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
      webSecurity: !isDev
    }
  };

  // Windows 전용 설정
  if (process.platform === 'win32') {
    windowOptions.autoHideMenuBar = true;
    windowOptions.roundedCorners = appConfig.ui.roundedCorners;
  }

  const window = new BrowserWindow(windowOptions);

  // Load the app
  if (isDev) {
    window.loadURL('http://localhost:5173');
    window.webContents.openDevTools();
  } else {
    window.loadFile(path.join(__dirname, '../dist/index.html'));
  }

  // Show window when ready
  window.once('ready-to-show', () => {
    window.show();

    // 작업표시줄 숨김 설정 (이미 창 생성 시 설정되었지만 확실히)
    if (appConfig.behavior.hideFromTaskbar || appConfig.window.windowLevel === 'stayBehind') {
      window.setSkipTaskbar(true);
    }

    // 모든 워크스페이스에서 보이기 설정
    if (appConfig.window.visibleOnAllWorkspaces) {
      window.setVisibleOnAllWorkspaces(true, { visibleOnFullScreen: true });
    }

    // 창 레벨별 설정 적용
    applyWindowLevelSettings(window, appConfig.window.windowLevel, isMain);
  });

  // Handle window close - 메인 창은 트레이로 숨기기, 서브 창은 닫기
  window.on('close', (event) => {
    if (isMain && !isQuitting) {
      event.preventDefault();
      window.hide();
    }
  });
  window.on('closed', () => {
    if (isMain) {
      stopStayBehindMode(); // interval 정리
      mainWindow = null;
    }
  });

  // 메인 창 설정
  if (isMain) {
    mainWindow = window;
  }

  return window;
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
    }, {
      label: '설정',
      type: 'normal',
      click: () => {
        createSettingsWindow();
      }
    },
    {
      type: 'separator'
    },
    {
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
  stopStayBehindMode(); // interval 정리
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  stopStayBehindMode(); // interval 정리
  isQuitting = true;
});

// IPC 핸들러들
// 모니터 정보 조회
ipcMain.handle('get-displays', async () => {
  try {
    const { screen } = require('electron');
    const displays = screen.getAllDisplays();
    return displays.map((display: any, index: number) => ({
      id: display.id,
      index,
      bounds: display.bounds,
      workArea: display.workArea,
      size: display.size,
      workAreaSize: display.workAreaSize,
      scaleFactor: display.scaleFactor,
      label: `Monitor ${index + 1}`,
      primary: display.id === screen.getPrimaryDisplay().id
    }));
  } catch (error) {
    console.error('Failed to get displays:', error);
    return [];
  }
});

// 새 창 생성 (특정 모니터에)
ipcMain.handle('create-window', async (event, displayIndex: number = 0) => {
  try {
    const window = createWindow(displayIndex, false);
    return { success: true, windowId: window?.id };
  } catch (error) {
    console.error('Failed to create window:', error);
    return { success: false, error: error instanceof Error ? error.message : 'Unknown error' };
  }
});

// 모든 창 닫기
ipcMain.handle('close-all-windows', async () => {
  try {
    BrowserWindow.getAllWindows().forEach(window => {
      if (window !== mainWindow) {
        window.close();
      }
    });
    return { success: true };
  } catch (error) {
    console.error('Failed to close windows:', error);
    return { success: false, error: error instanceof Error ? error.message : 'Unknown error' };
  }
});

ipcMain.handle('load-icon-config', async () => {
  try {
    const configPath = path.join(__dirname, '..', 'config', 'icons.json');
    const configData = fs.readFileSync(configPath, 'utf8');
    return JSON.parse(configData);
  } catch (error) {
    console.error('Failed to load icon config:', error);
    // 기본 설정 반환
    return {
      layout: {
        gridRows: 4,
        gridCols: 6,
        gap: 12,
        iconSize: { width: 64, height: 64 },
        autoArrange: false
      },
      icons: []
    };
  }
});

ipcMain.handle('save-icon-config', async (event, config) => {
  try {
    const configPath = path.join(__dirname, '..', 'config', 'icons.json');
    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    return { success: true };
  } catch (error) {
    console.error('Failed to save icon config:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

ipcMain.handle('launch-app', async (event, appPath: string) => {
  try {
    // 환경 변수 처리
    const expandedPath = appPath.replace(
      /%([^%]+)%/g,
      (_match: string, envVar: string) => {
        return process.env[envVar] || '';
      }
    );

    exec(`"${expandedPath}"`, (error) => {
      if (error) {
        console.error('Failed to launch app:', error);
      }
    });

    return { success: true };
  } catch (error) {
    console.error('Failed to launch app:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

ipcMain.handle('open-url', async (event, url: string) => {
  try {
    await shell.openExternal(url);
    return { success: true };
  } catch (error) {
    console.error('Failed to open URL:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

ipcMain.handle('open-directory', async (event, dirPath: string) => {
  try {
    // 환경 변수 처리
    const expandedPath = dirPath.replace(
      /%([^%]+)%/g,
      (_match: string, envVar: string) => {
        return process.env[envVar] || '';
      }
    );

    await shell.openPath(expandedPath);
    return { success: true };
  } catch (error) {
    console.error('Failed to open directory:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

ipcMain.handle('launch-steam-game', async (event, steamId: string) => {
  try {
    const steamUrl = `steam://rungameid/${steamId}`;
    await shell.openExternal(steamUrl);
    return { success: true };
  } catch (error) {
    console.error('Failed to launch Steam game:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 창 레벨 설정 (다른 창에 덮이지 않도록)
ipcMain.handle('set-window-level', async (event, level: string, windowId?: number) => {
  try {
    const targetWindow = windowId
      ? BrowserWindow.fromId(windowId)
      : mainWindow;

    if (!targetWindow) {
      return { success: false, error: 'Window not found' };
    }

    // alwaysOnTop과 레벨 설정
    switch (level) {
      case 'normal':
        targetWindow.setAlwaysOnTop(false);
        break;
      case 'floating':
        targetWindow.setAlwaysOnTop(true, 'floating');
        break;
      case 'torn-off-menu':
        targetWindow.setAlwaysOnTop(true, 'torn-off-menu');
        break;
      case 'modal-panel':
        targetWindow.setAlwaysOnTop(true, 'modal-panel');
        break;
      case 'main-menu':
        targetWindow.setAlwaysOnTop(true, 'main-menu');
        break;
      case 'status':
        targetWindow.setAlwaysOnTop(true, 'status');
        break;
      case 'pop-up-menu':
        targetWindow.setAlwaysOnTop(true, 'pop-up-menu');
        break;
      case 'screen-saver':
        targetWindow.setAlwaysOnTop(true, 'screen-saver');
        break;
      default:
        targetWindow.setAlwaysOnTop(true, 'floating');
    }

    return { success: true };
  } catch (error) {
    console.error('Failed to set window level:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 창을 다른 모든 창 위로 올리기
ipcMain.handle('bring-to-front', async (event, windowId?: number) => {
  try {
    const targetWindow = windowId
      ? BrowserWindow.fromId(windowId)
      : mainWindow;

    if (!targetWindow) {
      return { success: false, error: 'Window not found' };
    }

    targetWindow.moveTop();
    targetWindow.focus();
    return { success: true };
  } catch (error) {
    console.error('Failed to bring window to front:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 창의 포커스 상태 설정
ipcMain.handle('set-focusable', async (event, focusable: boolean, windowId?: number) => {
  try {
    const targetWindow = windowId
      ? BrowserWindow.fromId(windowId)
      : mainWindow;

    if (!targetWindow) {
      return { success: false, error: 'Window not found' };
    }

    targetWindow.setFocusable(focusable);
    return { success: true };
  } catch (error) {
    console.error('Failed to set focusable:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 설정 창 생성 함수
let settingsWindow: BrowserWindow | null = null;

function createSettingsWindow(): void {
  if (settingsWindow) {
    settingsWindow.focus();
    return;
  }

  settingsWindow = new BrowserWindow({
    width: 800,
    height: 700,
    minWidth: 600,
    minHeight: 500,
    show: false,
    center: true,
    title: 'Custom Desktop Settings',
    icon: path.join(__dirname, '../assets/icon.png'),
    frame: true,
    resizable: true,
    maximizable: true,
    minimizable: true,
    closable: true,
    alwaysOnTop: false,
    modal: true,
    parent: mainWindow || undefined,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
      webSecurity: !isDev
    }
  });

  // 설정 창 URL 로드
  if (isDev) {
    settingsWindow.loadURL('http://localhost:5173/#/settings');
  } else {
    settingsWindow.loadFile(path.join(__dirname, '../dist/index.html'), {
      hash: 'settings'
    });
  }

  settingsWindow.once('ready-to-show', () => {
    settingsWindow?.show();
  });

  settingsWindow.on('closed', () => {
    settingsWindow = null;
  });
}

// 설정 창 열기
ipcMain.handle('open-settings', async () => {
  try {
    createSettingsWindow();
    return { success: true };
  } catch (error) {
    console.error('Failed to open settings:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 현재 설정 가져오기
ipcMain.handle('get-config', async () => {
  try {
    return { success: true, config: appConfig };
  } catch (error) {
    console.error('Failed to get config:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 설정 저장하기
ipcMain.handle('save-config', async (event, newConfig: AppConfig) => {
  try {
    const { saveConfig } = await import('./config-loader');
    const saved = saveConfig(newConfig);

    if (saved) {
      // 설정을 메모리에도 업데이트
      appConfig = newConfig;

      // 메인 창에 설정 변경 알림
      if (mainWindow) {
        mainWindow.webContents.send('config-updated', newConfig);

        // 즉시 적용되는 설정들
        applyWindowSettings(mainWindow, newConfig);
      }

      return { success: true };
    } else {
      return { success: false, error: 'Failed to save config file' };
    }
  } catch (error) {
    console.error('Failed to save config:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
});

// 창 설정을 즉시 적용하는 함수
function applyWindowSettings(window: BrowserWindow, config: AppConfig): void {
  try {
    // 크기 및 위치 설정
    const { x, y, width, height } = calculateWindowPosition(config.window, 0);
    window.setSize(width, height);
    window.setPosition(x, y);

    // 창 레벨 설정 (새로운 함수 사용)
    applyWindowLevelSettings(window, config.window.windowLevel, true);

    // 기본 설정들
    window.setResizable(config.window.resizable);
    window.setSkipTaskbar(config.behavior.hideFromTaskbar || config.window.windowLevel === 'stayBehind');

    // 모든 워크스페이스에서 보이기
    if (config.window.visibleOnAllWorkspaces) {
      window.setVisibleOnAllWorkspaces(true, { visibleOnFullScreen: true });
    }

  } catch (error) {
    console.error('Failed to apply window settings:', error);
  }
}

// 창 레벨별 설정을 적용하는 함수
function applyWindowLevelSettings(window: BrowserWindow, windowLevel: string, isMain: boolean): void {
  try {
    switch (windowLevel) {
      case 'alwaysOnTop':
        window.setAlwaysOnTop(true);
        if (appConfig.window.level === 'floating') {
          window.setAlwaysOnTop(true, 'floating');
        } else if (appConfig.window.level === 'status') {
          window.setAlwaysOnTop(true, 'status');
        }
        break;

      case 'stayBehind':
        window.setAlwaysOnTop(false);
        window.blur(); // 즉시 포커스 제거
        if (isMain) {
          setupStayBehindMode(window);
        }
        break;

      case 'default':
      default:
        window.setAlwaysOnTop(false);
        break;
    }
  } catch (error) {
    console.log('Failed to set window level:', error);
  }
}

console.log('🚀 Electron app starting...');
