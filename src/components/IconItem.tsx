import React, { memo } from 'react';
import { IconData } from '../types/IconTypes';

interface IconItemProps {
  icon: IconData;
  onClick: (icon: IconData) => void;
  onDoubleClick: (icon: IconData) => void;
  isSelected?: boolean;
}

export const IconItem = memo(({ icon, onClick, onDoubleClick, isSelected = false }: IconItemProps) => {
  const handleClick = () => {
    onClick(icon);
  };

  const handleDoubleClick = () => {
    onDoubleClick(icon);
  };

  const iconStyle = {
    backgroundColor: icon.style?.backgroundColor || '#666666',
    color: icon.style?.textColor || '#ffffff',
    borderRadius: `${icon.style?.borderRadius || 8}px`,
    opacity: icon.style?.opacity || 1,
    width: icon.width || '100%',
    height: icon.height || '100%',
    gridRow: icon.gridPosition ? `${icon.gridPosition.row} / span ${icon.gridPosition.rowSpan || 1}` : 'auto',
    gridColumn: icon.gridPosition ? `${icon.gridPosition.col} / span ${icon.gridPosition.colSpan || 1}` : 'auto',
  };

  return (
    <div
      className={`icon-item ${isSelected ? 'selected' : ''}`}
      style={iconStyle}
      onClick={handleClick}
      onDoubleClick={handleDoubleClick}
      title={icon.description || icon.title}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          handleDoubleClick();
        }
      }}
    >
      <div className="icon-content">
        <div className="icon-symbol">
          {icon.thumbnail ? (
            <img src={icon.thumbnail} alt={icon.title} className="icon-thumbnail" />
          ) : (
            <span className="icon-emoji">{icon.icon}</span>
          )}
        </div>
        <div className="icon-title">{icon.title}</div>
      </div>
    </div>
  );
});

IconItem.displayName = 'IconItem';
