import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:custom_desktop/services/log_service.dart';
import 'package:custom_desktop/services/tray_service.dart';

/// MultiWindow 관리 서비스
/// 
/// **Tray 충돌 방지 전략:**
/// 1. Main Window에서만 TrayService 초기화
/// 2. Sub Window들은 TrayService 참조만 사용
/// 3. 창이 모두 닫혀도 Tray는 유지
class MultiWindowService {
  static MultiWindowService? _instance;
  static MultiWindowService get instance => _instance ??= MultiWindowService._();
  
  MultiWindowService._();

  final Map<int, WindowController> _windows = <int, WindowController>{};
  int _nextWindowId = 1;

  /// 새 창 생성 (Tray는 건드리지 않음)
  Future<int> createNewWindow({
    String title = 'New Window',
    Size size = const Size(800, 600),
    Offset? position,
  }) async {
    LogService.instance.info('새 창 생성 요청: $title');
    
    try {
      final int windowId = _nextWindowId++;
      
      final WindowController window = await DesktopMultiWindow.createWindow(
        jsonEncode(<String, dynamic>{
          'windowId': windowId,
          'title': title,
          'width': size.width,
          'height': size.height,
        }),
      );
      
      _windows[windowId] = window;
      
      // 창 크기 및 위치 설정
      await window.setFrame(Rect.fromLTWH(
        position?.dx ?? 100 + (windowId * 50),
        position?.dy ?? 100 + (windowId * 50),
        size.width,
        size.height,
      ));
      
      await window.center();
      await window.setTitle(title);
      await window.show();
      
      LogService.instance.info('새 창 생성 완료: ID=$windowId, Title=$title');
      return windowId;
      
    } catch (e, stackTrace) {
      LogService.instance.error('창 생성 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 특정 창 닫기 (Main Window가 아닌 경우에만)
  Future<void> closeWindow(int windowId) async {
    if (windowId == 0) {
      LogService.instance.warning('Main Window는 이 방법으로 닫을 수 없습니다');
      return;
    }
    
    final WindowController? window = _windows[windowId];
    if (window != null) {
      await window.close();
      _windows.remove(windowId);
      LogService.instance.info('창 닫기 완료: ID=$windowId');
    }
  }

  /// 모든 Sub Window 닫기 (Main Window와 Tray는 유지)
  Future<void> closeAllSubWindows() async {
    LogService.instance.info('모든 서브 창 닫기 시작');
    
    final List<int> subWindowIds = _windows.keys.where((int id) => id != 0).toList();
    
    for (final int windowId in subWindowIds) {
      await closeWindow(windowId);
    }
    
    LogService.instance.info('모든 서브 창 닫기 완료');
  }

  /// 현재 열린 창 목록
  List<int> get openWindowIds => _windows.keys.toList();
  
  /// 현재 열린 창 개수
  int get windowCount => _windows.length;
    /// 특정 창 표시
  Future<void> showWindow(int windowId) async {
    final WindowController? window = _windows[windowId];
    if (window != null) {
      await window.show();
      LogService.instance.info('창 표시: ID=$windowId');
    }
  }

  /// 특정 창 숨기기
  Future<void> hideWindow(int windowId) async {
    final WindowController? window = _windows[windowId];
    if (window != null) {
      await window.hide();
      LogService.instance.info('창 숨기기: ID=$windowId');
    }
  }

  /// 서비스 정리 (앱 종료 시)
  void dispose() {
    LogService.instance.info('MultiWindow 서비스 정리');
    _windows.clear();
  }
}

/// MultiWindow용 Tray 메뉴 확장
extension TrayMultiWindowSupport on TrayService {
  /// Tray 메뉴에 창 관리 기능 추가
  Future<void> updateMenuForMultiWindow() async {
    final List<MenuItem> windowMenuItems = <MenuItem>[];
    
    // 현재 열린 창들을 메뉴에 추가
    for (final int windowId in MultiWindowService.instance.openWindowIds) {
      windowMenuItems.add(
        MenuItem(
          key: 'show_window_$windowId',
          label: windowId == 0 ? 'Main Window' : 'Window $windowId',
        ),
      );
    }
    
    final Menu menu = Menu(
      items: <MenuItem>[
        // 기존 메뉴들
        MenuItem(key: 'show_window', label: 'Show Main Window'),
        MenuItem(key: 'hide_window', label: 'Hide Main Window'),
        MenuItem.separator(),
        
        // 새 창 생성
        MenuItem(key: 'new_window', label: 'New Window'),
        
        // 열린 창 목록 (있는 경우만)
        if (windowMenuItems.isNotEmpty) ...<MenuItem>[
          MenuItem.separator(),
          MenuItem(key: 'windows_header', label: 'Open Windows', disabled: true),
          ...windowMenuItems,
        ],
        
        MenuItem.separator(),
        MenuItem(key: 'close_all_sub', label: 'Close All Sub Windows'),
        MenuItem.separator(),
        MenuItem(key: 'settings', label: 'Settings'),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: 'Exit'),
      ],
    );
    
    await trayManager.setContextMenu(menu);
    LogService.instance.info('Tray 메뉴가 MultiWindow용으로 업데이트됨');
  }
}
