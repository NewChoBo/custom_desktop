import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

/// 윈도우 관리 서비스
class WindowService {
  /// 설정 윈도우를 별도 창으로 열기
  static Future<void> openSettingsWindow() async {
    try {
      debugPrint('Opening settings window...');

      // 새 윈도우 생성
      final WindowController window = await DesktopMultiWindow.createWindow(
        jsonEncode(<String, String>{'route': '/settings', 'title': 'Settings'}),
      );

      // 윈도우 설정
      await window
        ..setFrame(const Offset(100, 100) & const Size(500, 400))
        ..center()
        ..setTitle('Custom Desktop - Settings')
        ..show();

      debugPrint('Settings window opened successfully');
    } catch (e) {
      debugPrint('Failed to open settings window: $e');
    }
  }
}
