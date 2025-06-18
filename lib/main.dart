import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'config_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 설정 파일 로드
  final configManager = AppConfigManager();
  await configManager.loadConfigFromExternalFile();
  
  // 윈도우 관리자 설정
  await windowManager.ensureInitialized();
  
  final config = configManager.currentConfig;
  WindowOptions windowOptions = WindowOptions(
    size: Size(config.windowWidth, config.windowHeight),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,  // 작업표시줄에서 숨기기
    titleBarStyle: TitleBarStyle.hidden, // 타이틀 바 숨기기
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  
  runApp(MyApp(configManager: configManager));
}

class MyApp extends StatefulWidget {
  final AppConfigManager configManager;
  
  const MyApp({super.key, required this.configManager});

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
    debugPrint('Tray icon mouse down');
    _toggleWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    debugPrint('Tray icon right mouse down');
    trayManager.popUpContextMenu();
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
    return ValueListenableBuilder<AppConfig>(
      valueListenable: widget.configManager.configNotifier,
      builder: (context, config, child) {
        return MaterialApp(
          title: config.title,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: config.primaryColor),
            // 전체 앱 배경을 투명하게 설정
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: MyHomePage(
            title: config.title,
            configManager: widget.configManager,
          ),
          // 디버그 배너 제거
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final AppConfigManager configManager;
  
  const MyHomePage({super.key, required this.title, required this.configManager});

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

  void _reloadConfig() async {
    await widget.configManager.loadConfigFromExternalFile();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('설정이 다시 로드되었습니다!')),
      );
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(configManager: widget.configManager),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppConfig>(
      valueListenable: widget.configManager.configNotifier,
      builder: (context, config, child) {
        return Scaffold(
          // 배경을 설정된 투명도로 설정
          backgroundColor: Colors.black.withValues(alpha: config.backgroundOpacity),
          appBar: AppBar(
            // AppBar를 80% 투명하게 설정 (20% 불투명도)
            backgroundColor: config.primaryColor.withValues(alpha: 0.2),
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
            // AppBar 그림자 제거
            elevation: 0,
            // 시스템 오버레이 스타일 설정
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _showSettingsDialog,
                tooltip: '설정',
              ),
            ],
          ),
          body: Container(
            // 배경 그라데이션 효과 추가
            decoration: config.useGradient
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: config.gradientColors
                          .map((color) => color.withValues(alpha: config.backgroundOpacity))
                          .toList(),
                    ),
                  )
                : null,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (config.showCounter) ...[
                    Text(
                      config.counterText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: config.fontSize,
                      ),
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _reloadConfig,
                    child: const Text('설정 다시 로드'),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: config.buttonText,
            backgroundColor: config.primaryColor.withValues(alpha: 0.8), // 80% 불투명
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

class SettingsDialog extends StatefulWidget {
  final AppConfigManager configManager;
  
  const SettingsDialog({super.key, required this.configManager});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late double _backgroundOpacity;
  late bool _useGradient;
  late bool _showCounter;
  late Color _primaryColor;
  late Color _secondaryColor;

  @override
  void initState() {
    super.initState();
    final config = widget.configManager.currentConfig;
    _backgroundOpacity = config.backgroundOpacity;
    _useGradient = config.useGradient;
    _showCounter = config.showCounter;
    _primaryColor = config.primaryColor;
    _secondaryColor = config.secondaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('앱 설정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('배경 투명도'),
            Slider(
              value: _backgroundOpacity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: '${(_backgroundOpacity * 100).round()}%',
              onChanged: (value) {
                setState(() {
                  _backgroundOpacity = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('그라데이션 배경 사용'),
              value: _useGradient,
              onChanged: (value) {
                setState(() {
                  _useGradient = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('카운터 표시'),
              value: _showCounter,
              onChanged: (value) {
                setState(() {
                  _showCounter = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('기본 색상'),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showColorPicker(true),
                  child: const Text('변경'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('보조 색상'),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _secondaryColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _showColorPicker(false),
                  child: const Text('변경'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: _saveSettings,
          child: const Text('저장'),
        ),
        TextButton(
          onPressed: _saveToFile,
          child: const Text('파일로 저장'),
        ),
      ],
    );
  }

  void _showColorPicker(bool isPrimary) {
    // 간단한 색상 선택기 (실제로는 더 복잡한 색상 선택기를 사용할 수 있습니다)
    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPrimary ? '기본 색상 선택' : '보조 색상 선택'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isPrimary) {
                    _primaryColor = color;
                  } else {
                    _secondaryColor = color;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _saveSettings() {
    final currentConfig = widget.configManager.currentConfig;
    final newConfig = currentConfig.copyWith(
      backgroundOpacity: _backgroundOpacity,
      useGradient: _useGradient,
      showCounter: _showCounter,
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
    );

    widget.configManager.updateConfig(newConfig);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설정이 적용되었습니다!')),
    );
  }

  void _saveToFile() async {
    _saveSettings();
    await widget.configManager.saveConfigToExternalFile();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('설정이 파일로 저장되었습니다!')),
      );
    }
  }
}
