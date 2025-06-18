import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 윈도우 관리자 설정
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,  // 작업표시줄에서 숨기기
    titleBarStyle: TitleBarStyle.hidden, // 타이틀 바 숨기기
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TrayListener {
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    _initSystemTray();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }
  Future<void> _initSystemTray() async {
    try {
      await trayManager.setIcon('assets/app_icon.ico');
      await trayManager.setToolTip('Custom Desktop App - Right click for menu');
      
      Menu menu = Menu(
        items: [
          MenuItem(
            key: 'show_window',
            label: '📱 Show Window',
          ),
          MenuItem(
            key: 'hide_window',
            label: '👁️ Hide Window',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'exit_app',
            label: '❌ Exit Application',
          ),
        ],
      );
      
      await trayManager.setContextMenu(menu);
      debugPrint('System tray initialized with context menu');
    } catch (e) {
      debugPrint('Error initializing system tray: $e');
    }
  }

  @override
  void onTrayIconMouseDown() {
    debugPrint('Tray icon left clicked');
    _toggleWindow();
  }
  @override
  void onTrayIconRightMouseDown() async {
    debugPrint('Tray icon right clicked');
    
    // 권장 방식: 윈도우 포커싱과 메뉴 팝업 분리
    // 1) 창 보이기 & 포커스 주기
    await windowManager.show();
    await windowManager.focus();
      // 2) 트레이 메뉴 팝업 (기본 옵션 사용 - 크로스 플랫폼 통일)
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    debugPrint('Menu item clicked: ${menuItem.key}');
    switch (menuItem.key) {
      case 'show_window':
        _showWindow();
        break;
      case 'hide_window':
        _hideWindow();
        break;
      case 'exit_app':
        _exitApp();
        break;
    }
  }

  void _showWindow() {
    windowManager.show();
    windowManager.focus();
  }

  void _hideWindow() {
    windowManager.hide();
  }

  void _toggleWindow() async {
    if (await windowManager.isVisible()) {
      _hideWindow();
    } else {
      _showWindow();
    }
  }

  void _exitApp() {
    windowManager.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Desktop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // 전체 앱 배경을 투명하게 설정
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const MyHomePage(title: 'Custom Desktop'),
      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경을 50% 투명하게 설정
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      appBar: AppBar(
        // AppBar를 80% 투명하게 설정 (20% 불투명도)
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        // AppBar 그림자 제거
        elevation: 0,
        // 시스템 오버레이 스타일 설정
        foregroundColor: Colors.white,
      ),
      body: Container(
        // 배경 그라데이션 효과 추가
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withValues(alpha: 0.3),  // 30% 불투명 보라색
              Colors.blue.withValues(alpha: 0.2),        // 20% 불투명 파란색
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.8), // 80% 불투명
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
