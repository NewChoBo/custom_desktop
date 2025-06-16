export interface IconData {
    id: string;
    title: string;
    description?: string;
    icon: string; // 이모지 또는 이미지 URL
    thumbnail?: string; // 썸네일 이미지 URL
    type: 'app' | 'file' | 'directory' | 'url' | 'steam-game';
    path?: string; // 앱 경로 또는 파일 경로
    url?: string; // 웹 URL
    steamId?: string; // Steam 게임 ID
    width?: number; // 아이콘 너비 (기본값 사용하려면 생략)
    height?: number; // 아이콘 높이 (기본값 사용하려면 생략)
    gridPosition?: {
        row: number;
        col: number;
        rowSpan?: number; // 여러 행 차지 (기본값 1)
        colSpan?: number; // 여러 열 차지 (기본값 1)
    };
    style?: {
        backgroundColor?: string;
        textColor?: string;
        borderRadius?: number;
        opacity?: number;
    };
    isVisible?: boolean; // 표시/숨김
    order?: number; // 정렬 순서
}

export interface IconLayout {
    gridRows: number; // 전체 행 수
    gridCols: number; // 전체 열 수
    gap?: number; // 아이콘 간격 (px)
    iconSize?: {
        width: number;
        height: number;
    };
    autoArrange?: boolean; // 자동 배치 여부
}

export interface IconConfig {
    layout: IconLayout;
    icons: IconData[];
}
