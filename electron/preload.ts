import { contextBridge, ipcRenderer } from 'electron';

// Expose APIs to the renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // Basic system info
  platform: process.platform,
  version: process.version,
  // Configuration APIs
  loadIconConfig: () => ipcRenderer.invoke('load-icon-config'),
  saveIconConfig: (config: any) => ipcRenderer.invoke('save-icon-config', config),
  getConfig: () => ipcRenderer.invoke('get-config'),
  saveConfig: (config: any) => ipcRenderer.invoke('save-config', config),
  openSettings: () => ipcRenderer.invoke('open-settings'),

  // Configuration update listener
  onConfigUpdated: (callback: (config: any) => void) => {
    ipcRenderer.on('config-updated', (event, config) => callback(config));
  },
  removeConfigUpdatedListener: () => {
    ipcRenderer.removeAllListeners('config-updated');
  },
  // File/App launching APIs
  launchApp: (path: string) => ipcRenderer.invoke('launch-app', path),
  openUrl: (url: string) => ipcRenderer.invoke('open-url', url),
  openDirectory: (path: string) => ipcRenderer.invoke('open-directory', path),
  launchSteamGame: (steamId: string) => ipcRenderer.invoke('launch-steam-game', steamId),
  // Multi-monitor APIs
  getDisplays: () => ipcRenderer.invoke('get-displays'),
  createWindow: (displayIndex: number) => ipcRenderer.invoke('create-window', displayIndex),
  closeAllWindows: () => ipcRenderer.invoke('close-all-windows'),

  // Window level control APIs
  setWindowLevel: (level: string, windowId?: number) => ipcRenderer.invoke('set-window-level', level, windowId),
  bringToFront: (windowId?: number) => ipcRenderer.invoke('bring-to-front', windowId),
  setFocusable: (focusable: boolean, windowId?: number) => ipcRenderer.invoke('set-focusable', focusable, windowId),

  // Example API - will expand later
  getMessage: () => 'Hello from Electron!'
});

console.log('Preload script loaded');
