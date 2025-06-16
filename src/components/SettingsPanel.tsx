import React, { useCallback, useEffect, useState } from 'react';
import './SettingsPanel.css';

interface SettingsPanelProps {
  isOpen: boolean;
  onClose: () => void;
}

export const SettingsPanel: React.FC<SettingsPanelProps> = ({
  isOpen,
  onClose
}) => {
  const [config, setConfig] = useState<AppConfig | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasChanges, setHasChanges] = useState(false);

  // 설정 로드
  const loadConfig = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const result = await window.electronAPI.getConfig();
      
      if (result.success && result.config) {
        setConfig(result.config);
      } else {
        setError(result.error || 'Failed to load configuration');
      }
    } catch (err) {
      setError('Failed to load configuration');
      console.error('Config load error:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  // 설정 저장
  const saveConfig = useCallback(async () => {
    if (!config) return;

    try {
      setLoading(true);
      setError(null);
      const result = await window.electronAPI.saveConfig(config);
      
      if (result.success) {
        setHasChanges(false);
        alert('Settings saved successfully!');
      } else {
        setError(result.error || 'Failed to save configuration');
      }
    } catch (err) {
      setError('Failed to save configuration');
      console.error('Config save error:', err);
    } finally {
      setLoading(false);
    }
  }, [config]);

  // 컴포넌트 마운트 시 설정 로드
  useEffect(() => {
    if (isOpen) {
      loadConfig();
    }
  }, [isOpen, loadConfig]);

  // 설정 값 변경 핸들러
  const updateConfig = useCallback((path: string, value: any) => {
    if (!config) return;

    setConfig(prevConfig => {
      if (!prevConfig) return null;

      const newConfig = { ...prevConfig };
      const pathParts = path.split('.');
      let target: any = newConfig;

      // 경로를 따라 이동하면서 값 설정
      for (let i = 0; i < pathParts.length - 1; i++) {
        target = target[pathParts[i]];
      }
      target[pathParts[pathParts.length - 1]] = value;

      setHasChanges(true);
      return newConfig;
    });
  }, [config]);

  if (!isOpen) return null;

  return (
    <div className="settings-overlay">
      <div className="settings-panel">
        <div className="settings-header">
          <h2>Settings</h2>
          <button className="close-button" onClick={onClose}>
            ✕
          </button>
        </div>

        {loading && (
          <div className="settings-loading">
            <div className="spinner"></div>
            Loading settings...
          </div>
        )}

        {error && (
          <div className="settings-error">
            <span>❌ {error}</span>
            <button onClick={loadConfig}>Retry</button>
          </div>
        )}

        {config && (
          <div className="settings-content">
            {/* Window Settings */}
            <section className="settings-section">
              <h3>Window Settings</h3>
              
              <div className="setting-group">
                <label>
                  Width:
                  <input
                    type="text"
                    value={config.window.width}
                    onChange={(e) => updateConfig('window.width', 
                      isNaN(Number(e.target.value)) ? e.target.value : Number(e.target.value)
                    )}
                    placeholder="400 or 80%"
                  />
                </label>
                
                <label>
                  Height:
                  <input
                    type="text"
                    value={config.window.height}
                    onChange={(e) => updateConfig('window.height',
                      isNaN(Number(e.target.value)) ? e.target.value : Number(e.target.value)
                    )}
                    placeholder="600 or 70%"
                  />
                </label>
              </div>

              <div className="setting-group">
                <label>
                  Position X:
                  <select
                    value={config.window.position.x}
                    onChange={(e) => updateConfig('window.position.x', e.target.value)}
                  >
                    <option value="left">Left</option>
                    <option value="center">Center</option>
                    <option value="right">Right</option>
                    <option value="center-bottom">Center Bottom</option>
                  </select>
                </label>
                
                <label>
                  Position Y:
                  <select
                    value={config.window.position.y}
                    onChange={(e) => updateConfig('window.position.y', e.target.value)}
                  >
                    <option value="top">Top</option>
                    <option value="center">Center</option>
                    <option value="bottom">Bottom</option>
                  </select>
                </label>
              </div>

              <div className="setting-group">
                <label>
                  Offset X:
                  <input
                    type="number"
                    value={config.window.position.offsetX}
                    onChange={(e) => updateConfig('window.position.offsetX', Number(e.target.value))}
                  />
                </label>
                
                <label>
                  Offset Y:
                  <input
                    type="number"
                    value={config.window.position.offsetY}
                    onChange={(e) => updateConfig('window.position.offsetY', Number(e.target.value))}
                  />
                </label>
              </div>              <div className="checkbox-group">
                <label className="checkbox-label">
                  <input
                    type="radio"
                    name="windowLevel"
                    checked={config.window.windowLevel === 'default'}
                    onChange={() => updateConfig('window.windowLevel', 'default')}
                  />
                  Default (Normal Window)
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="radio"
                    name="windowLevel"
                    checked={config.window.windowLevel === 'alwaysOnTop'}
                    onChange={() => updateConfig('window.windowLevel', 'alwaysOnTop')}
                  />
                  Always on Top
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="radio"
                    name="windowLevel"
                    checked={config.window.windowLevel === 'stayBehind'}
                    onChange={() => updateConfig('window.windowLevel', 'stayBehind')}
                  />
                  Stay Behind Other Windows
                </label>
              </div>

              <div className="checkbox-group">
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.window.resizable}
                    onChange={(e) => updateConfig('window.resizable', e.target.checked)}
                  />
                  Resizable
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.window.movable}
                    onChange={(e) => updateConfig('window.movable', e.target.checked)}
                  />
                  Movable
                </label>
              </div>

              <div className="setting-group">
                <label>
                  Window Level:
                  <select
                    value={config.window.level || 'normal'}
                    onChange={(e) => updateConfig('window.level', e.target.value)}
                  >
                    <option value="normal">Normal</option>
                    <option value="floating">Floating</option>
                    <option value="status">Status</option>
                    <option value="modal-panel">Modal Panel</option>
                    <option value="pop-up-menu">Pop-up Menu</option>
                    <option value="screen-saver">Screen Saver</option>
                  </select>
                </label>
              </div>
            </section>

            {/* UI Settings */}
            <section className="settings-section">
              <h3>UI Settings</h3>
              
              <div className="setting-group">
                <label>
                  Theme:
                  <select
                    value={config.ui.theme}
                    onChange={(e) => updateConfig('ui.theme', e.target.value)}
                  >
                    <option value="dark">Dark</option>
                    <option value="light">Light</option>
                    <option value="auto">Auto</option>
                  </select>
                </label>
                
                <label>
                  Transparency:
                  <input
                    type="range"
                    min="0.1"
                    max="1"
                    step="0.05"
                    value={config.ui.transparency}
                    onChange={(e) => updateConfig('ui.transparency', Number(e.target.value))}
                  />
                  <span>{Math.round(config.ui.transparency * 100)}%</span>
                </label>
              </div>

              <div className="setting-group">
                <label>
                  Border Radius:
                  <input
                    type="range"
                    min="0"
                    max="20"
                    step="1"
                    value={config.ui.borderRadius}
                    onChange={(e) => updateConfig('ui.borderRadius', Number(e.target.value))}
                  />
                  <span>{config.ui.borderRadius}px</span>
                </label>
              </div>

              <div className="checkbox-group">
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.ui.showScrollbar}
                    onChange={(e) => updateConfig('ui.showScrollbar', e.target.checked)}
                  />
                  Show Scrollbar
                </label>
                  <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.ui.showTitleBar}
                    onChange={(e) => updateConfig('ui.showTitleBar', e.target.checked)}
                  />
                  Show Title Bar
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.ui.showSettingsButton}
                    onChange={(e) => updateConfig('ui.showSettingsButton', e.target.checked)}
                  />
                  Show Settings Button
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.ui.roundedCorners}
                    onChange={(e) => updateConfig('ui.roundedCorners', e.target.checked)}
                  />
                  Rounded Corners
                </label>
              </div>
            </section>

            {/* Behavior Settings */}
            <section className="settings-section">
              <h3>Behavior Settings</h3>
              
              <div className="checkbox-group">
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.behavior.hideToTray}
                    onChange={(e) => updateConfig('behavior.hideToTray', e.target.checked)}
                  />
                  Hide to System Tray
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.behavior.startMinimized}
                    onChange={(e) => updateConfig('behavior.startMinimized', e.target.checked)}
                  />
                  Start Minimized
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.behavior.autoStart}
                    onChange={(e) => updateConfig('behavior.autoStart', e.target.checked)}
                  />
                  Auto Start with System
                </label>
                
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    checked={config.behavior.hideFromTaskbar}
                    onChange={(e) => updateConfig('behavior.hideFromTaskbar', e.target.checked)}
                  />
                  Hide from Taskbar
                </label>
              </div>
            </section>
          </div>
        )}

        {config && (
          <div className="settings-footer">
            <button
              className="cancel-button"
              onClick={onClose}
              disabled={loading}
            >
              Cancel
            </button>
            <button
              className="save-button"
              onClick={saveConfig}
              disabled={loading || !hasChanges}
            >
              {loading ? 'Saving...' : 'Save Settings'}
            </button>
          </div>
        )}
      </div>
    </div>
  );
};
