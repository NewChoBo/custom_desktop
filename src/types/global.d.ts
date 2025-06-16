export { };

declare global {
    interface Window {        electronAPI: {
            platform: string;
            version: string;
            loadIconConfig: () => Promise<any>;
            saveIconConfig: (config: any) => Promise<{ success: boolean; error?: string }>;
            getConfig: () => Promise<{ success: boolean; config?: AppConfig; error?: string }>;
            saveConfig: (config: AppConfig) => Promise<{ success: boolean; error?: string }>;
            openSettings: () => Promise<{ success: boolean; error?: string }>;
            onConfigUpdated: (callback: (config: AppConfig) => void) => void;
            removeConfigUpdatedListener: () => void;
            launchApp: (path: string) => Promise<{ success: boolean; error?: string }>;
            openUrl: (url: string) => Promise<{ success: boolean; error?: string }>;
            openDirectory: (path: string) => Promise<{ success: boolean; error?: string }>;
            launchSteamGame: (steamId: string) => Promise<{ success: boolean; error?: string }>;getDisplays: () => Promise<DisplayInfo[]>;
            createWindow: (displayIndex: number) => Promise<{ success: boolean; windowId?: number; error?: string }>;
            closeAllWindows: () => Promise<{ success: boolean; error?: string }>;
            setWindowLevel: (level: WindowLevel, windowId?: number) => Promise<{ success: boolean; error?: string }>;
            bringToFront: (windowId?: number) => Promise<{ success: boolean; error?: string }>;
            setFocusable: (focusable: boolean, windowId?: number) => Promise<{ success: boolean; error?: string }>;
            getMessage: () => string;
        };
    }

    type WindowLevel = 'normal' | 'floating' | 'torn-off-menu' | 'modal-panel' | 'main-menu' | 'status' | 'pop-up-menu' | 'screen-saver';

    interface DisplayInfo {
        id: number;
        index: number;
        bounds: { x: number; y: number; width: number; height: number };
        workArea: { x: number; y: number; width: number; height: number };
        size: { width: number; height: number };
        workAreaSize: { width: number; height: number };
        scaleFactor: number;
        label: string;
        primary: boolean;
    }

    // App configuration types
    interface AppConfig {
        window: WindowConfig;
        ui: UIConfig;
        behavior: BehaviorConfig;
    }    interface WindowConfig {
        width: number | string;
        height: number | string;
        position: {
            x: string | number;
            y: string | number;
            offsetX: number;
            offsetY: number;
        };
        minWidth: number;
        minHeight: number;
        windowLevel: 'default' | 'alwaysOnTop' | 'stayBehind';
        resizable: boolean;
        movable: boolean;
        level?: WindowLevel;
        visibleOnAllWorkspaces?: boolean;
        fullscreenable?: boolean;
    }

    interface UIConfig {
        theme: string;
        transparency: number;
        borderRadius: number;
        showScrollbar: boolean;
        showTitleBar: boolean;
        showSettingsButton: boolean;
        roundedCorners: boolean;
    }

    interface BehaviorConfig {
        hideToTray: boolean;
        startMinimized: boolean;
        autoStart: boolean;
        hideFromTaskbar: boolean;
    }
}
