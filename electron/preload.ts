import { contextBridge } from 'electron';

// Expose APIs to the renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // Basic system info
  platform: process.platform,
  version: process.version,
  
  // Example API - will expand later
  getMessage: () => 'Hello from Electron!'
});

console.log('Preload script loaded');
