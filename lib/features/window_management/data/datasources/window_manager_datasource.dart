import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:custom_desktop/core/constants/app_constants.dart';

/// 윈도우 매니저 데이터 소스
class WindowManagerDataSource {
  static const WindowOptions _defaultWindowOptions = WindowOptions(
    size: Size(AppConstants.defaultWindowWidth, AppConstants.defaultWindowHeight),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
  );
  /// 윈도우 매니저 초기화
  Future<void> initialize() async {
    await windowManager.ensureInitialized();
    
    windowManager.waitUntilReadyToShow(_defaultWindowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /// 윈도우 표시
  Future<void> show() async {
    await windowManager.show();
    await windowManager.focus();
  }

  /// 윈도우 숨기기
  Future<void> hide() async {
    await windowManager.hide();
  }

  /// 윈도우가 보이는지 확인
  Future<bool> isVisible() async {
    return await windowManager.isVisible();
  }

  /// 앱 종료
  Future<void> close() async {
    await windowManager.close();
  }

  /// 윈도우에 포커스 주기
  Future<void> focus() async {
    await windowManager.focus();
  }

  /// 윈도우 최소화
  Future<void> minimize() async {
    await windowManager.minimize();
  }

  /// 윈도우 최대화
  Future<void> maximize() async {
    await windowManager.maximize();
  }

  /// 윈도우 크기 가져오기
  Future<Size> getSize() async {
    return await windowManager.getSize();
  }

  /// 윈도우 위치 가져오기
  Future<Offset> getPosition() async {
    return await windowManager.getPosition();
  }
}
