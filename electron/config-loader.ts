import { screen } from 'electron';
import * as fs from 'fs';
import * as path from 'path';

export interface WindowConfig {
    width: number | string; // 숫자(픽셀) 또는 문자열(백분율, 예: "80%")
    height: number | string; // 숫자(픽셀) 또는 문자열(백분율, 예: "70%")
    position: {
        x: string | number;
        y: string | number;
        offsetX: number;
        offsetY: number;
    };
    minWidth: number;
    minHeight: number;
    windowLevel: 'default' | 'alwaysOnTop' | 'stayBehind'; // 창 레벨 통합
    resizable: boolean;
    movable: boolean;
    level?: 'normal' | 'floating' | 'torn-off-menu' | 'modal-panel' | 'main-menu' | 'status' | 'pop-up-menu' | 'screen-saver';
    visibleOnAllWorkspaces?: boolean;
    fullscreenable?: boolean;
}

export interface UIConfig {
    theme: string;
    transparency: number;
    borderRadius: number;
    showScrollbar: boolean;
    showTitleBar: boolean;
    showSettingsButton: boolean; // 설정 버튼 표시 여부
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

const defaultConfig: AppConfig = {    window: {
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
        windowLevel: 'alwaysOnTop', // 기본값: 다른 창 위에 떠있기
        resizable: true,
        movable: true,
        level: 'floating',
        visibleOnAllWorkspaces: true,
        fullscreenable: false,
    },
    ui: {
        theme: 'dark',
        transparency: 0.95,
        borderRadius: 12,
        showScrollbar: false,
        showTitleBar: false,
        showSettingsButton: false, // 기본값: 설정 버튼 숨김
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

export function saveConfig(config: AppConfig): boolean {
    try {
        const configPath = path.join(__dirname, '../config/window-config.json');
        const configDir = path.dirname(configPath);
        
        // 디렉토리가 없으면 생성
        if (!fs.existsSync(configDir)) {
            fs.mkdirSync(configDir, { recursive: true });
        }
        
        // 설정을 JSON 파일로 저장
        fs.writeFileSync(configPath, JSON.stringify(config, null, 4), 'utf8');
        console.log('Config saved successfully');
        return true;
    } catch (error) {
        console.error('Failed to save config:', error);
        return false;
    }
}

export function calculateWindowSize(config: WindowConfig, displayIndex: number = 0): { width: number; height: number } {
    const displays = screen.getAllDisplays();
    const targetDisplay = displays[displayIndex] || screen.getPrimaryDisplay();
    const { width: screenWidth, height: screenHeight } = targetDisplay.workAreaSize;

    let width: number;
    let height: number;

    // Width 계산
    if (typeof config.width === 'string' && config.width.endsWith('%')) {
        const percentage = parseFloat(config.width.replace('%', ''));
        width = Math.round((screenWidth * percentage) / 100);
    } else {
        width = typeof config.width === 'number' ? config.width : parseInt(config.width);
    }

    // Height 계산
    if (typeof config.height === 'string' && config.height.endsWith('%')) {
        const percentage = parseFloat(config.height.replace('%', ''));
        height = Math.round((screenHeight * percentage) / 100);
    } else {
        height = typeof config.height === 'number' ? config.height : parseInt(config.height);
    }

    return { width, height };
}

export function calculateWindowPosition(config: WindowConfig, displayIndex: number = 0): { x: number; y: number; width: number; height: number } {
    const displays = screen.getAllDisplays();
    const targetDisplay = displays[displayIndex] || screen.getPrimaryDisplay();
    const { width: screenWidth, height: screenHeight, x: displayX, y: displayY } = targetDisplay.workArea;

    // 창 크기 계산
    const { width, height } = calculateWindowSize(config, displayIndex);
    let x: number;
    let y: number;

    // X 좌표 계산
    if (config.position.x === 'center') {
        x = Math.round((screenWidth - width) / 2);
    } else if (config.position.x === 'center-bottom') {
        x = Math.round((screenWidth - width) / 2);
    } else if (config.position.x === 'left') {
        x = 20;
    } else if (config.position.x === 'right') {
        x = screenWidth - width - 20;
    } else if (typeof config.position.x === 'number') {
        x = config.position.x;
    } else {
        x = Math.round((screenWidth - width) / 2);
    }

    // Y 좌표 계산
    if (config.position.y === 'center') {
        y = Math.round((screenHeight - height) / 2);
    } else if (config.position.y === 'top') {
        y = 20;
    } else if (config.position.y === 'bottom') {
        y = screenHeight - height - 20;
    } else if (typeof config.position.y === 'number') {
        y = config.position.y;
    } else {
        y = screenHeight - height - 20;
    }

    // 오프셋 적용
    x += config.position.offsetX;
    y += config.position.offsetY;

    // 디스플레이 오프셋 적용 (멀티 모니터 지원)
    x += displayX;
    y += displayY;

    return { x, y, width, height };
}
