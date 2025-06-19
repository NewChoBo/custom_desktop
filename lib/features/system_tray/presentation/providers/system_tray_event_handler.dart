import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:custom_desktop/features/system_tray/domain/entities/system_tray_entity.dart';
import 'package:custom_desktop/core/di/injection.dart';
import 'package:custom_desktop/core/constants/app_constants.dart';
import 'package:custom_desktop/core/services/window_service.dart';

/// 시스템 트레이 이벤트 핸들러
class SystemTrayEventHandler with TrayListener {
  static SystemTrayEventHandler? _instance;
  static SystemTrayEventHandler get instance => _instance ??= SystemTrayEventHandler._();

  SystemTrayEventHandler._();

  /// 시스템 트레이 이벤트 리스너 등록
  void initialize() {
    trayManager.addListener(this);
    _setupDefaultMenu();
  }

  /// 기본 메뉴 설정
  void _setupDefaultMenu() {
    final List<SystemTrayMenuEntity> menuItems = <SystemTrayMenuEntity>[
      const SystemTrayMenuEntity(key: AppConstants.showWindowKey, label: AppConstants.showWindowLabel),
      const SystemTrayMenuEntity(key: AppConstants.hideWindowKey, label: AppConstants.hideWindowLabel),
      const SystemTrayMenuEntity.separator(),
      const SystemTrayMenuEntity(key: AppConstants.settingsKey, label: AppConstants.settingsLabel),
      const SystemTrayMenuEntity.separator(),
      const SystemTrayMenuEntity(key: AppConstants.exitAppKey, label: AppConstants.exitAppLabel),
    ];

    DependencyInjection.instance.setTrayContextMenuUseCase(menuItems);
  }

  /// 리소스 정리
  void dispose() {
    trayManager.removeListener(this);
  }

  @override
  void onTrayIconMouseDown() {
    debugPrint(DebugMessages.trayLeftClick);
    // 윈도우 토글
    DependencyInjection.instance.toggleWindowUseCase();
  }

  @override
  void onTrayIconRightMouseDown() async {
    debugPrint(DebugMessages.trayRightClick);
    // 메뉴 팝업 표시
    await DependencyInjection.instance.popUpTrayMenuUseCase();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    debugPrint('${DebugMessages.menuItemClicked}: ${menuItem.key}');
    switch (menuItem.key) {
      case AppConstants.showWindowKey:
        DependencyInjection.instance.showWindowUseCase();
        break;
      case AppConstants.hideWindowKey:
        DependencyInjection.instance.hideWindowUseCase();
        break;
      case AppConstants.settingsKey:
        _handleSettingsClick();
        break;
      case AppConstants.exitAppKey:
        DependencyInjection.instance.closeAppUseCase();
        break;
    }
  }

  /// Settings 메뉴 클릭 처리
  void _handleSettingsClick() async {
    debugPrint('Settings menu clicked - opening settings...');
    // 설정 윈도우를 별도 창으로 열기
    await WindowService.openSettingsWindow();
  }
}
