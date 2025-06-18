/// 앱 전체에서 사용되는 상수들을 정의
class AppConstants {
  // 윈도우 설정 상수
  static const double defaultWindowWidth = 800.0;
  static const double defaultWindowHeight = 600.0;

  // 앱 정보
  static const String appTitle = 'Custom Desktop App';
  static const String homeTitle = 'Custom Desktop';

  // 트레이 아이콘 및 메뉴
  static const String trayIconPath = 'assets/app_icon.ico';
  static const String trayTooltip = 'Custom Desktop App - Right click for menu';

  // 트레이 메뉴 키
  static const String showWindowKey = 'show_window';
  static const String hideWindowKey = 'hide_window';
  static const String settingsKey = 'settings';
  static const String exitAppKey = 'exit_app';

  // 트레이 메뉴 라벨
  static const String showWindowLabel = '📱 Show Window';
  static const String hideWindowLabel = '👁️ Hide Window';
  static const String settingsLabel = '⚙️ Settings';
  static const String exitAppLabel = '❌ Exit Application';

  // 스타일 상수
  static const double backgroundOpacity = 0.5;
  static const double appBarOpacity = 0.2;
  static const double gradientOpacity1 = 0.3;
  static const double gradientOpacity2 = 0.2;
  static const double fabOpacity = 0.8;
}

/// 디버그 메시지 상수
class DebugMessages {
  static const String trayInitialized = 'System tray initialized with context menu';
  static const String trayInitError = 'Error initializing system tray';
  static const String trayLeftClick = 'Tray icon left clicked';
  static const String trayRightClick = 'Tray icon right clicked';
  static const String menuItemClicked = 'Menu item clicked';
}
