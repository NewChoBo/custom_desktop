import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

/// 윈도우 관리 서비스
class WindowService {
  // TODO [Copilot]: 설정창 중복 방지를 위한 윈도우 ID 추적
  static int? _settingsWindowId;
  static bool _isSettingsWindowOpen = false;

  /// 설정 윈도우를 별도 창으로 열기 (중복 방지)
  static Future<void> openSettingsWindow() async {
    try {
      // 이미 설정창이 열려있는지 확인
      if (_isSettingsWindowOpen && _settingsWindowId != null) {
        debugPrint('Settings window is already open (ID: $_settingsWindowId)'); // 기존 윈도우를 앞으로 가져오기 시도
        try {
          final List<int> existingWindows = await DesktopMultiWindow.getAllSubWindowIds();
          debugPrint('All existing windows: $existingWindows');

          if (existingWindows.contains(_settingsWindowId)) {
            debugPrint('Existing settings window found, bringing to front...');
            final WindowController controller = WindowController.fromWindowId(
              _settingsWindowId!,
            ); // 윈도우를 앞으로 가져오기 위한 여러 시도
            await controller.setFrame(const Offset(100, 100) & const Size(500, 400));
            await controller.center();
            await controller.show();

            debugPrint('Settings window brought to front successfully');
            return;
          } else {
            // 윈도우가 더 이상 존재하지 않으면 상태 초기화
            debugPrint('Settings window no longer exists, resetting state...');
            _isSettingsWindowOpen = false;
            _settingsWindowId = null;
          }
        } catch (e) {
          debugPrint('Error checking existing window: $e');
          _isSettingsWindowOpen = false;
          _settingsWindowId = null;
        }
      }

      debugPrint('Opening new settings window...'); // 새 윈도우 생성
      final WindowController window = await DesktopMultiWindow.createWindow(
        jsonEncode(<String, String>{'route': '/settings', 'title': 'Settings'}),
      ); // 윈도우 설정
      await window
        ..setFrame(const Offset(100, 100) & const Size(500, 400))
        ..center()
        ..setTitle('Custom Desktop - Settings')
        ..show();

      // 상태 업데이트
      _settingsWindowId = window.windowId;
      _isSettingsWindowOpen = true;

      debugPrint('Settings window opened successfully (ID: ${window.windowId})');
    } catch (e) {
      debugPrint('Failed to open settings window: $e');
      // 에러 발생 시 상태 초기화
      _isSettingsWindowOpen = false;
      _settingsWindowId = null;
    }
  }

  /// 설정창 상태 초기화 (윈도우가 닫혔을 때 호출)
  static void resetSettingsWindowState() {
    _isSettingsWindowOpen = false;
    _settingsWindowId = null;
    debugPrint('Settings window state reset');
  }

  /// 현재 설정창이 열려있는지 확인
  static bool get isSettingsWindowOpen => _isSettingsWindowOpen;
}
