import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:custom_desktop/core/constants/app_constants.dart';

/// 시스템 트레이 데이터 소스
class SystemTrayDataSource with TrayListener {
  /// 시스템 트레이 초기화
  Future<void> initialize() async {
    try {
      trayManager.addListener(this);
      await trayManager.setIcon(AppConstants.trayIconPath);
      await trayManager.setToolTip(AppConstants.trayTooltip);
      debugPrint(DebugMessages.trayInitialized);
    } catch (e) {
      debugPrint('${DebugMessages.trayInitError}: $e');
    }
  }

  /// 트레이 아이콘 설정
  Future<void> setIcon(String iconPath) async {
    await trayManager.setIcon(iconPath);
  }

  /// 트레이 툴팁 설정
  Future<void> setTooltip(String tooltip) async {
    await trayManager.setToolTip(tooltip);
  }

  /// 컨텍스트 메뉴 설정
  Future<void> setContextMenu(List<MenuItem> menuItems) async {
    final Menu menu = Menu(items: menuItems);
    await trayManager.setContextMenu(menu);
  }

  /// 컨텍스트 메뉴 팝업
  Future<void> popUpContextMenu() async {
    await trayManager.popUpContextMenu();
  }

  /// 리소스 정리
  void dispose() {
    trayManager.removeListener(this);
  }

  // TrayListener 구현 (필요에 따라 오버라이드)
  @override
  void onTrayIconMouseDown() {
    // 서브클래스에서 구현
  }

  @override
  void onTrayIconRightMouseDown() {
    // 서브클래스에서 구현
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    // 서브클래스에서 구현
  }
}
