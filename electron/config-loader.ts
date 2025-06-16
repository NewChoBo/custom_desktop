import * as fs from 'fs';
import * as path from 'path';
import { screen } from 'electron';

export interface WindowConfig {
  width: number;
  height: number;
  position: {
    x: string | number;
    y: string | number;
    offsetX: number;
    offsetY: number;
  };
  minWidth: number;
  minHeight: number;
  alwaysOnTop: boolean;
  resizable: boolean;
  movable: boolean;
}

export interface UIConfig {
  theme: string;
  transparency: number;
  borderRadius: number;
  showScrollbar: boolean;
  showTitleBar: boolean;
  roundedCorners: boolean;
}

export interface BehaviorConfig {
  hideToTray: boolean;
  startMinimized: boolean;
  autoStart: boolean;
  hideFromTaskbar: boolean;
}

export interface AppConfig {
  window: WindowConfig;
  ui: UIConfig;
  behavior: BehaviorConfig;
}

const defaultConfig: AppConfig = {
  window: {
    width: 400,
    height: 600,
    position: {
      x: 'center-bottom',
      y: 'bottom',
      offsetX: 0,
      offsetY: -50,
    },
    minWidth: 300,
    minHeight: 400,
    alwaysOnTop: false,
    resizable: true,
    movable: true,
  },  ui: {
    theme: 'dark',
    transparency: 0.95,
    borderRadius: 12,
    showScrollbar: false,
    showTitleBar: false,
    roundedCorners: true,
  },
  behavior: {
    hideToTray: true,
    startMinimized: false,
    autoStart: false,
    hideFromTaskbar: true,
  },
};

export function loadConfig(): AppConfig {
  try {
    const configPath = path.join(__dirname, '../config/window-config.json');
    if (fs.existsSync(configPath)) {
      const configFile = fs.readFileSync(configPath, 'utf8');
      const userConfig = JSON.parse(configFile);
      return { ...defaultConfig, ...userConfig };
    }
  } catch (error) {
    console.log('Config loading failed, using defaults:', error);
  }
  
  return defaultConfig;
}

export function calculateWindowPosition(config: WindowConfig): { x: number; y: number } {
  const primaryDisplay = screen.getPrimaryDisplay();
  const { width: screenWidth, height: screenHeight } = primaryDisplay.workAreaSize;
  
  let x: number;
  let y: number;
  
  // X 좌표 계산
  if (config.position.x === 'center') {
    x = Math.round((screenWidth - config.width) / 2);
  } else if (config.position.x === 'center-bottom') {
    x = Math.round((screenWidth - config.width) / 2);
  } else if (config.position.x === 'left') {
    x = 20;
  } else if (config.position.x === 'right') {
    x = screenWidth - config.width - 20;
  } else if (typeof config.position.x === 'number') {
    x = config.position.x;
  } else {
    x = Math.round((screenWidth - config.width) / 2);
  }
  
  // Y 좌표 계산
  if (config.position.y === 'center') {
    y = Math.round((screenHeight - config.height) / 2);
  } else if (config.position.y === 'top') {
    y = 20;
  } else if (config.position.y === 'bottom') {
    y = screenHeight - config.height - 20;
  } else if (typeof config.position.y === 'number') {
    y = config.position.y;
  } else {
    y = screenHeight - config.height - 20;
  }
  
  // 오프셋 적용
  x += config.position.offsetX;
  y += config.position.offsetY;
  
  return { x, y };
}
