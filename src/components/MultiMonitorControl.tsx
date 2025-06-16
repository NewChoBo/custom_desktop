import React, { useEffect, useState } from 'react';

interface MultiMonitorControlProps {
    onClose?: () => void;
}

export const MultiMonitorControl: React.FC<MultiMonitorControlProps> = ({ onClose }) => {
    const [displays, setDisplays] = useState<DisplayInfo[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadDisplays();
    }, []);

    const loadDisplays = async () => {
        try {
            setLoading(true);
            if (window.electronAPI?.getDisplays) {
                const displayList = await window.electronAPI.getDisplays();
                setDisplays(displayList);
            }
        } catch (error) {
            console.error('Failed to load displays:', error);
        } finally {
            setLoading(false);
        }
    };

    const createWindowOnDisplay = async (displayIndex: number) => {
        try {
            if (window.electronAPI?.createWindow) {
                const result = await window.electronAPI.createWindow(displayIndex);
                if (result.success) {
                    console.log(`Window created on display ${displayIndex}`);
                } else {
                    console.error('Failed to create window:', result.error);
                }
            }
        } catch (error) {
            console.error('Failed to create window:', error);
        }
    };

    const closeAllWindows = async () => {
        try {
            if (window.electronAPI?.closeAllWindows) {
                const result = await window.electronAPI.closeAllWindows();
                if (result.success) {
                    console.log('All secondary windows closed');
                }
            }
        } catch (error) {
            console.error('Failed to close windows:', error);
        }
    };

    if (loading) {
        return (
            <div className="multi-monitor-control loading">
                <p>모니터 정보를 로딩 중...</p>
            </div>
        );
    }

    return (
        <div className="multi-monitor-control">
            <div className="control-header">
                <h3>멀티 모니터 제어</h3>
                {onClose && (
                    <button onClick={onClose} className="close-button">
                        ×
                    </button>
                )}
            </div>

            <div className="display-list">
                <p>사용 가능한 모니터:</p>
                {displays.map((display) => (
                    <div key={display.id} className="display-item">
                        <div className="display-info">
                            <strong>{display.label}</strong>
                            {display.primary && <span className="primary-badge">주</span>}
                            <br />
                            <small>
                                {display.workAreaSize.width} × {display.workAreaSize.height}
                                {display.scaleFactor !== 1 && ` (${Math.round(display.scaleFactor * 100)}%)`}
                            </small>
                        </div>
                        <button
                            onClick={() => createWindowOnDisplay(display.index)}
                            className="create-window-button"
                        >
                            창 생성
                        </button>
                    </div>
                ))}
            </div>

            <div className="control-actions">
                <button onClick={closeAllWindows} className="close-all-button">
                    모든 서브 창 닫기
                </button>
                <button onClick={loadDisplays} className="refresh-button">
                    새로고침
                </button>
            </div>
        </div>
    );
};

export default MultiMonitorControl;
