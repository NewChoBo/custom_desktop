import { contextBridge, ipcRenderer } from 'electron';

// Expose APIs to the renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // Basic system info
  platform: process.platform,
  version: process.version,

  // Configuration APIs
  loadIconConfig: () => ipcRenderer.invoke('load-icon-config'),
  saveIconConfig: (config: any) => ipcRenderer.invoke('save-icon-config', config),

  // File/App launching APIs
  launchApp: (path: string) => ipcRenderer.invoke('launch-app', path),
  openUrl: (url: string) => ipcRenderer.invoke('open-url', url),
  openDirectory: (path: string) => ipcRenderer.invoke('open-directory', path),
  launchSteamGame: (steamId: string) => ipcRenderer.invoke('launch-steam-game', steamId),

  // Example API - will expand later
  getMessage: () => 'Hello from Electron!'
});

console.log('Preload script loaded');
