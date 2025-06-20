import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:custom_desktop/features/system_tray/domain/entities/system_tray_entity.dart';
import 'package:custom_desktop/core/di/injection.dart';
import 'package:custom_desktop/core/constants/app_constants.dart';

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
    final menuItems = [
      const SystemTrayMenuEntity(
        key: AppConstants.showWindowKey,
        label: AppConstants.showWindowLabel,
      ),
      const SystemTrayMenuEntity(
        key: AppConstants.hideWindowKey, 
        label: AppConstants.hideWindowLabel,
      ),
      const SystemTrayMenuEntity.separator(),
      const SystemTrayMenuEntity(
        key: AppConstants.exitAppKey,
        label: AppConstants.exitAppLabel,
      ),
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
    // 윈도우 보이기 & 메뉴 팝업
    await DependencyInjection.instance.showWindowUseCase();
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
      case AppConstants.exitAppKey:
        DependencyInjection.instance.closeAppUseCase();
        break;
    }
  }
}
