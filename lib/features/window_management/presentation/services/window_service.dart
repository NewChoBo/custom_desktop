import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

class WindowManagementService {
  static final WindowManagementService _instance =
      WindowManagementService._internal();
  factory WindowManagementService() => _instance;
  WindowManagementService._internal();
  final Map<String, int> _openWindows = <String, int>{};
  List<Map<String, dynamic>> _iconWindowConfigs = <Map<String, dynamic>>[];

  Future<void> loadWindowConfigurations() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/settings/defaults/icon_windows.json',
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      _iconWindowConfigs = List<Map<String, dynamic>>.from(
        jsonData['icon_windows'] ?? <dynamic>[],
      );
      print('윈도우 설정 로드 완료: ${_iconWindowConfigs.length}개 윈도우');
    } catch (e) {
      print('윈도우 설정 로드 실패: $e');
      _iconWindowConfigs = <Map<String, dynamic>>[];
    }
  }

  // 사용 가능한 윈도우 목록 반환
  List<Map<String, dynamic>> getAvailableWindows() {
    return _iconWindowConfigs;
  }

  // 특정 윈도우 설정 반환
  Map<String, dynamic>? getWindowConfig(String windowId) {
    try {
      return _iconWindowConfigs.firstWhere(
        (Map<String, dynamic> config) => config['id'] == windowId,
      );
    } catch (e) {
      return null;
    }
  }

  // 윈도우 열기
  Future<bool> openWindow(String windowId) async {
    try {
      // 이미 열린 윈도우인지 확인
      if (_openWindows.containsKey(windowId)) {
        final int windowHandle = _openWindows[windowId]!;
        // 기존 윈도우를 포그라운드로 가져오기
        await DesktopMultiWindow.invokeMethod(windowHandle, 'focus');
        return true;
      }

      // 윈도우 설정 가져오기
      final Map<String, dynamic>? windowConfig = getWindowConfig(windowId);
      if (windowConfig == null) {
        print('윈도우 설정을 찾을 수 없음: $windowId');
        return false;
      } // 새 윈도우 생성
      final WindowController windowController =
          await DesktopMultiWindow.createWindow(
            jsonEncode(windowConfig), // 설정을 JSON 문자열로 전달
          );

      windowController.setFrame(
        const Offset(100, 100) &
            Size(
              (windowConfig['width'] ?? 800).toDouble(),
              (windowConfig['height'] ?? 600).toDouble(),
            ),
      );

      await windowController.setTitle(windowConfig['title'] ?? 'Icon Window');
      await windowController.show();

      // 열린 윈도우 목록에 추가
      _openWindows[windowId] = windowController.windowId;

      print('윈도우 열기 성공: $windowId (Handle: ${windowController.windowId})');
      return true;
    } catch (e) {
      print('윈도우 열기 실패: $windowId, 오류: $e');
      return false;
    }
  }

  // 윈도우 닫기
  Future<bool> closeWindow(String windowId) async {
    try {
      if (!_openWindows.containsKey(windowId)) {
        return false;
      }

      final int windowHandle = _openWindows[windowId]!;
      await WindowController.fromWindowId(windowHandle).close();

      _openWindows.remove(windowId);
      print('윈도우 닫기 성공: $windowId');
      return true;
    } catch (e) {
      print('윈도우 닫기 실패: $windowId, 오류: $e');
      return false;
    }
  }

  // 모든 윈도우 닫기
  Future<void> closeAllWindows() async {
    final List<String> windowIds = List.from(_openWindows.keys);

    for (final String windowId in windowIds) {
      await closeWindow(windowId);
    }
  }

  // 열린 윈도우 목록 반환
  List<String> getOpenWindowIds() {
    return _openWindows.keys.toList();
  }

  // 윈도우가 열려있는지 확인
  bool isWindowOpen(String windowId) {
    return _openWindows.containsKey(windowId);
  }

  // 특정 윈도우에 메시지 전송
  Future<dynamic> sendMessageToWindow(
    String windowId,
    String method, [
    dynamic arguments,
  ]) async {
    try {
      if (!_openWindows.containsKey(windowId)) {
        return <String, String>{'error': 'Window not found'};
      }

      final int windowHandle = _openWindows[windowId]!;
      return await DesktopMultiWindow.invokeMethod(
        windowHandle,
        method,
        arguments,
      );
    } catch (e) {
      print('윈도우 메시지 전송 실패: $windowId, 메서드: $method, 오류: $e');
      return <String, String>{'error': e.toString()};
    }
  }

  // 모든 열린 윈도우에 브로드캐스트
  Future<void> broadcastToAllWindows(String method, [dynamic arguments]) async {
    final List<Future> futures = <Future>[];

    for (final int windowHandle in _openWindows.values) {
      futures.add(
        DesktopMultiWindow.invokeMethod(
          windowHandle,
          method,
          arguments,
        ).catchError((e) {
          print('브로드캐스트 실패 (Handle: $windowHandle): $e');
        }),
      );
    }

    await Future.wait(futures);
  }

  // 리소스 정리
  void dispose() {
    closeAllWindows();
    _openWindows.clear();
  }
}
