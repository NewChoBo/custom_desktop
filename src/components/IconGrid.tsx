import { memo, useState } from 'react';
import { IconConfig, IconData } from '../types/IconTypes';
import { IconItem } from './IconItem';

interface IconGridProps {
    config: IconConfig;
    onIconClick?: (icon: IconData) => void;
    onIconDoubleClick?: (icon: IconData) => void;
}

export const IconGrid = memo(({ config, onIconClick, onIconDoubleClick }: IconGridProps) => {
    const [selectedIcon, setSelectedIcon] = useState<string | null>(null);

    const handleIconClick = (icon: IconData) => {
        setSelectedIcon(icon.id);
        onIconClick?.(icon);
    };

    const handleIconDoubleClick = (icon: IconData) => {
        onIconDoubleClick?.(icon);
    };

    const gridStyle = {
        display: 'grid',
        gridTemplateRows: `repeat(${config.layout.gridRows}, 1fr)`,
        gridTemplateColumns: `repeat(${config.layout.gridCols}, 1fr)`,
        gap: `${config.layout.gap || 12}px`,
        width: '100%',
        height: '100%',
        padding: '20px',
    };

    const visibleIcons = config.icons
        .filter(icon => icon.isVisible !== false)
        .sort((a, b) => (a.order || 0) - (b.order || 0));

    return (
        <div className="icon-grid" style={gridStyle}>
            {visibleIcons.map((icon) => (
                <IconItem
                    key={icon.id}
                    icon={icon}
                    onClick={handleIconClick}
                    onDoubleClick={handleIconDoubleClick}
                    isSelected={selectedIcon === icon.id}
                />
            ))}
        </div>
    );
});

IconGrid.displayName = 'IconGrid';
