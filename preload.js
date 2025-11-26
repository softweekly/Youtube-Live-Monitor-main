const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  getSettings: () => ipcRenderer.invoke('get-settings'),
  saveSettings: (settings) => ipcRenderer.send('save-settings', settings),
  onUpdateLiveChannels: (callback) => ipcRenderer.on('update-live-channels', callback),
  onUpdateAnalysisStatus: (callback) => ipcRenderer.on('update-analysis-status', callback)
});
