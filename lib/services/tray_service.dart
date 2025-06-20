import 'package:tray_manager/tray_manager.dart';
import 'package:custom_desktop/services/window_service.dart';
import 'package:custom_desktop/utils/constants.dart';

/// 시스템 트레이 관리 서비스 - 트레이 아이콘과 메뉴를 담당
class TrayService with TrayListener {
  static TrayService? _instance;
  static TrayService get instance => _instance ??= TrayService._();

  TrayService._();

  /// 트레이 초기 설정
  Future<void> initialize() async {
    // 트레이 리스너 등록
    trayManager.addListener(this);

    // 트레이 아이콘 설정
    await trayManager.setIcon(AppConstants.trayIconPath);
    await trayManager.setToolTip(AppConstants.trayTooltip);

    // 트레이 메뉴 만들기
    await _createTrayMenu();

    print('✅ 시스템 트레이가 초기화되었습니다');
  }

  /// 트레이 메뉴 생성
  Future<void> _createTrayMenu() async {
    Menu menu = Menu(
      items: <MenuItem>[
        MenuItem(key: 'show_window', label: AppConstants.showWindow),
        MenuItem(key: 'hide_window', label: AppConstants.hideWindow),
        MenuItem.separator(),
        MenuItem(key: 'settings', label: AppConstants.settings),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: AppConstants.exitApp),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  /// 트레이 아이콘 왼쪽 클릭 - 창 토글
  @override
  void onTrayIconMouseDown() {
    WindowService.instance.toggleWindow();
    print('🖱️ 트레이 아이콘 클릭됨 - 창 토글');
  }

  /// 트레이 아이콘 오른쪽 클릭 - 메뉴 표시
  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
    print('🖱️ 트레이 우클릭 - 메뉴 표시');
  }

  /// 트레이 메뉴 항목 클릭 처리
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    print('📋 메뉴 클릭됨: ${menuItem.key}');

    switch (menuItem.key) {
      case 'show_window':
        WindowService.instance.showWindow();
        break;
      case 'hide_window':
        WindowService.instance.hideWindow();
        break;
      case 'settings':
        _openSettings();
        break;
      case 'exit':
        _exitApp();
        break;
    }
  }

  /// 설정 창 열기 (나중에 구현)
  void _openSettings() {
    print('⚙️ 설정 창 열기 (구현 예정)');
  }

  /// 앱 종료
  void _exitApp() {
    print('❌ 앱 종료');
    WindowService.instance.closeApp();
  }

  /// 서비스 정리
  void dispose() {
    trayManager.removeListener(this);
  }
}
