export { };

declare global {
    interface Window {
        electronAPI: {
            platform: string;
            version: string;
            loadIconConfig: () => Promise<any>;
            saveIconConfig: (config: any) => Promise<{ success: boolean; error?: string }>;
            launchApp: (path: string) => Promise<{ success: boolean; error?: string }>;
            openUrl: (url: string) => Promise<{ success: boolean; error?: string }>;
            openDirectory: (path: string) => Promise<{ success: boolean; error?: string }>;
            launchSteamGame: (steamId: string) => Promise<{ success: boolean; error?: string }>;
            getMessage: () => string;
        };
    }
}
