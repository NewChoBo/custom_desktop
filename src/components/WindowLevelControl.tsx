import React, { useState } from 'react';

interface WindowLevelControlProps {
    onClose?: () => void;
}

export const WindowLevelControl: React.FC<WindowLevelControlProps> = ({ onClose }) => {
    const [currentLevel, setCurrentLevel] = useState<WindowLevel>('floating');
    const [isFocusable, setIsFocusable] = useState(true);

    const windowLevels: { value: WindowLevel; label: string; description: string }[] = [
        {
            value: 'normal',
            label: '일반',
            description: '다른 창에 덮일 수 있음'
        },
        {
            value: 'floating',
            label: '떠있기',
            description: '대부분의 창 위에 떠있음 (권장)'
        },
        {
            value: 'status',
            label: '상태바',
            description: '시스템 상태바 수준'
        },
        {
            value: 'modal-panel',
            label: '모달 패널',
            description: '모달 창 수준'
        },
        {
            value: 'main-menu',
            label: '메인 메뉴',
            description: '메인 메뉴 수준'
        },
        {
            value: 'pop-up-menu',
            label: '팝업 메뉴',
            description: '팝업 메뉴 수준'
        },
        {
            value: 'screen-saver',
            label: '화면 보호기',
            description: '최상위 레벨 (모든 창 위)'
        }
    ];

    const handleLevelChange = async (level: WindowLevel) => {
        try {
            if (window.electronAPI?.setWindowLevel) {
                const result = await window.electronAPI.setWindowLevel(level);
                if (result.success) {
                    setCurrentLevel(level);
                    console.log(`Window level changed to: ${level}`);
                } else {
                    console.error('Failed to change window level:', result.error);
                }
            }
        } catch (error) {
            console.error('Failed to change window level:', error);
        }
    };

    const handleBringToFront = async () => {
        try {
            if (window.electronAPI?.bringToFront) {
                const result = await window.electronAPI.bringToFront();
                if (result.success) {
                    console.log('Window brought to front');
                } else {
                    console.error('Failed to bring window to front:', result.error);
                }
            }
        } catch (error) {
            console.error('Failed to bring window to front:', error);
        }
    };

    const handleFocusableChange = async (focusable: boolean) => {
        try {
            if (window.electronAPI?.setFocusable) {
                const result = await window.electronAPI.setFocusable(focusable);
                if (result.success) {
                    setIsFocusable(focusable);
                    console.log(`Window focusable set to: ${focusable}`);
                } else {
                    console.error('Failed to set focusable:', result.error);
                }
            }
        } catch (error) {
            console.error('Failed to set focusable:', error);
        }
    };

    return (
        <div className="window-level-control">
            <div className="control-header">
                <h3>창 레벨 제어</h3>
                {onClose && (
                    <button onClick={onClose} className="close-button">
                        ×
                    </button>
                )}
            </div>

            <div className="level-section">
                <h4>창 레벨 설정</h4>
                <p className="section-description">
                    다른 창에 덮이지 않도록 창의 우선순위를 설정합니다.
                </p>

                <div className="level-options">
                    {windowLevels.map((level) => (
                        <div
                            key={level.value}
                            className={`level-option ${currentLevel === level.value ? 'active' : ''}`}
                            onClick={() => handleLevelChange(level.value)}
                        >
                            <div className="level-info">
                                <strong>{level.label}</strong>
                                <small>{level.description}</small>
                            </div>
                            <div className="level-indicator">
                                {currentLevel === level.value && '✓'}
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            <div className="focus-section">
                <h4>포커스 설정</h4>
                <div className="focus-control">
                    <label className="checkbox-label">
                        <input
                            type="checkbox"
                            checked={isFocusable}
                            onChange={(e) => handleFocusableChange(e.target.checked)}
                        />
                        <span>창이 포커스를 받을 수 있음</span>
                    </label>
                    <small className="focus-description">
                        체크 해제 시 다른 창에 포커스를 뺏기지 않습니다
                    </small>
                </div>
            </div>

            <div className="control-actions">
                <button onClick={handleBringToFront} className="bring-front-button">
                    최상위로 올리기
                </button>
            </div>
        </div>
    );
};

export default WindowLevelControl;
