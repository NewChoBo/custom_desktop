import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:custom_desktop/utils/constants.dart';
import 'package:custom_desktop/services/log_service.dart';

/// 윈도우 관리 서비스 - 창 열기/닫기/크기조절 등을 담당
class WindowService {
  static WindowService? _instance;
  static WindowService get instance => _instance ??= WindowService._();

  WindowService._();

  /// 윈도우 초기 설정
  Future<void> initialize() async {
    LogService.instance.window('윈도우 매니저 초기화 시작');
    await windowManager.ensureInitialized();

    // 윈도우 옵션 설정
    WindowOptions windowOptions = const WindowOptions(
      size: Size(AppConstants.windowWidth, AppConstants.windowHeight),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // 제목표시줄 숨기기
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      LogService.instance.window('윈도우가 표시되고 포커스되었습니다');
    });

    LogService.instance.window('윈도우 초기화 완료');
  }

  /// 창 보이기
  Future<void> showWindow() async {
    await windowManager.show();
    await windowManager.focus();
    LogService.instance.window('창을 표시했습니다');
  }

  /// 창 숨기기
  Future<void> hideWindow() async {
    await windowManager.hide();
    LogService.instance.window('창을 숨겼습니다');
  }

  /// 창 표시/숨기기 토글
  Future<void> toggleWindow() async {
    if (await windowManager.isVisible()) {
      await hideWindow();
    } else {
      await showWindow();
    }
    LogService.instance.window('창 표시 상태를 토글했습니다');
  }

  /// 앱 완전히 종료
  Future<void> closeApp() async {
    LogService.instance.window('앱을 종료합니다');
    await windowManager.destroy();
  }
}
