import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:custom_desktop/features/window_management/presentation/services/window_service.dart';
import 'dart:io';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 프로세스 타입 구분
  final bool isMainProcess = args.isEmpty;

  // 멀티윈도우 설정 (공통)
  if (runningInDesktopMode) {
    DesktopMultiWindow.setMethodHandler(_handleMethodCall);
  }

  if (isMainProcess) {
    // 메인 프로세스: 트레이 앱 실행
    runApp(const TrayApp());
    // 창 초기화 (메인 창 숨기기)
    doWhenWindowReady(() {
      appWindow.hide();
    });
  } else {
    // 서브 프로세스: 아이콘 윈도우는 별도 entry point에서 처리
    print('서브 윈도우 프로세스 시작: ${args.join(", ")}');
  }
}

bool get runningInDesktopMode {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}

Future<dynamic> _handleMethodCall(MethodCall call, int fromWindowId) async {
  return <String, String>{'status': 'main_window_received'};
}

class TrayApp extends StatefulWidget {
  const TrayApp({super.key});

  @override
  State<TrayApp> createState() => _TrayAppState();
}

class _TrayAppState extends State<TrayApp> with TrayListener {
  final WindowManagementService _windowService = WindowManagementService();

  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    try {
      // 윈도우 설정 로드
      await _windowService.loadWindowConfigurations();

      // 트레이 아이콘 설정 (메인 프로세스에서만)
      await trayManager.setIcon(
        Platform.isWindows ? 'assets/tray_icon.ico' : 'assets/tray_icon.png',
      );

      // 동적 트레이 메뉴 생성
      await _buildTrayMenu();

      await trayManager.setToolTip('Custom Desktop App');

      print('메인 프로세스 - 트레이 초기화 완료');
    } catch (e) {
      print('트레이 초기화 오류: $e');
      // 트레이 없이도 윈도우 설정은 로드
      try {
        await _windowService.loadWindowConfigurations();
      } catch (loadError) {
        print('윈도우 설정 로드 실패: $loadError');
      }
    }
  }

  Future<void> _buildTrayMenu() async {
    try {
      final List<Map<String, dynamic>> availableWindows = _windowService
          .getAvailableWindows();

      List<MenuItem> menuItems = <MenuItem>[];

      // 윈도우 목록 추가
      for (final Map<String, dynamic> window in availableWindows) {
        menuItems.add(
          MenuItem(
            key: window['id'],
            label: window['title'] ?? 'Unknown Window',
          ),
        );
      }

      // 구분선과 종료 메뉴 추가
      if (menuItems.isNotEmpty) {
        menuItems.add(MenuItem.separator());
      }
      menuItems.add(MenuItem(key: 'exit', label: '종료'));

      Menu menu = Menu(items: menuItems);
      await trayManager.setContextMenu(menu);
    } catch (e) {
      print('트레이 메뉴 생성 실패: $e');
    }
  }

  // 트레이 아이콘 클릭 이벤트
  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  // 트레이 메뉴 클릭 처리
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'exit') {
      _windowService.dispose();
      exit(0);
    } else {
      // 윈도우 열기
      _openWindow(menuItem.key!);
    }
  }

  Future<void> _openWindow(String windowId) async {
    try {
      final bool success = await _windowService.openWindow(windowId);
      if (!success) {
        print('윈도우 열기 실패: $windowId');
      }
    } catch (e) {
      print('윈도우 열기 중 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Custom Desktop App',
      debugShowCheckedModeBanner: false,
      home: SizedBox.shrink(), // 메모리 효율적인 빈 위젯
    );
  }
}
