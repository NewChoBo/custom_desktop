import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TrayApp());

  // 창 초기화 (메인 창 숨기기)
  doWhenWindowReady(() {
    appWindow.hide(); // 메인 창 숨기기
  });
}

class TrayApp extends StatefulWidget {
  const TrayApp({super.key});

  @override
  State<TrayApp> createState() => _TrayAppState();
}

class _TrayAppState extends State<TrayApp> with TrayListener {
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
    // 트레이 아이콘 설정
    await trayManager.setIcon(
      Platform.isWindows ? 'assets/tray_icon.ico' : 'assets/tray_icon.png',
    );

    // 트레이 메뉴 설정
    Menu menu = Menu(
      items: <MenuItem>[
        MenuItem(key: 'window1', label: 'Window 1 열기'),
        MenuItem(key: 'window2', label: 'Window 2 열기'),
        MenuItem(key: 'window3', label: 'Window 3 열기'),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: '종료'),
      ],
    );

    await trayManager.setContextMenu(menu);
    await trayManager.setToolTip('Custom Desktop App');
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
    switch (menuItem.key) {
      case 'window1':
        _openWindow('Window 1', 'window1');
        break;
      case 'window2':
        _openWindow('Window 2', 'window2');
        break;
      case 'window3':
        _openWindow('Window 3', 'window3');
        break;
      case 'exit':
        exit(0);
        break;
    }
  }

  Future<void> _openWindow(String title, String windowId) async {
    // 멀티윈도우 생성 (일단 기본 구현)
    print('Opening $title ($windowId)');
    // TODO: desktop_multi_window로 실제 윈도우 생성
  }

  @override
  Widget build(BuildContext context) {
    // 메인 윈도우는 숨김 (백그라운드 실행)
    return MaterialApp(
      title: 'Custom Desktop App',
      home: Container(), // 빈 컨테이너 (화면에 표시 안됨)
    );
  }
}
