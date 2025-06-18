import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AppConfigManager {
  static final AppConfigManager _instance = AppConfigManager._internal();
  factory AppConfigManager() => _instance;
  AppConfigManager._internal();

  YamlMap? _config;
  final ValueNotifier<AppConfig> _configNotifier = ValueNotifier(AppConfig.defaultConfig());

  ValueNotifier<AppConfig> get configNotifier => _configNotifier;
  AppConfig get currentConfig => _configNotifier.value;

  /// Assets에서 설정 파일 로드 (앱 내장)
  Future<void> loadConfigFromAssets() async {
    try {
      final String yamlString = await rootBundle.loadString('config/app_config.yaml');
      _config = loadYaml(yamlString);
      _updateConfigFromYaml();
    } catch (e) {
      debugPrint('Error loading config from assets: $e');
      _configNotifier.value = AppConfig.defaultConfig();
    }
  }

  /// 외부 파일에서 설정 로드 (동적 변경 가능)
  Future<void> loadConfigFromExternalFile([String? customPath]) async {
    try {
      String configPath;
      
      if (customPath != null) {
        configPath = customPath;
      } else {
        // 앱 실행 파일과 같은 디렉토리에서 config 파일 찾기
        final executablePath = Platform.resolvedExecutable;
        final executableDir = path.dirname(executablePath);
        configPath = path.join(executableDir, 'app_config.yaml');
        
        // 파일이 없으면 Documents 폴더에서 찾기
        if (!File(configPath).existsSync()) {
          final documentsDir = await getApplicationDocumentsDirectory();
          configPath = path.join(documentsDir.path, 'CustomDesktopApp', 'app_config.yaml');
        }
      }

      final file = File(configPath);
      if (await file.exists()) {
        final String yamlString = await file.readAsString();
        _config = loadYaml(yamlString);
        _updateConfigFromYaml();
        debugPrint('Config loaded from: $configPath');
      } else {
        debugPrint('External config file not found: $configPath');
        // Assets에서 기본 설정 로드
        await loadConfigFromAssets();
      }
    } catch (e) {
      debugPrint('Error loading external config: $e');
      await loadConfigFromAssets();
    }
  }

  /// 현재 설정을 외부 파일로 저장
  Future<void> saveConfigToExternalFile() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final configDir = Directory(path.join(documentsDir.path, 'CustomDesktopApp'));
      
      if (!await configDir.exists()) {
        await configDir.create(recursive: true);
      }
      
      final configFile = File(path.join(configDir.path, 'app_config.yaml'));
      
      // 현재 설정을 YAML 형식으로 저장
      final configYaml = _generateYamlFromConfig(_configNotifier.value);
      await configFile.writeAsString(configYaml);
      
      debugPrint('Config saved to: ${configFile.path}');
    } catch (e) {
      debugPrint('Error saving config: $e');
    }
  }

  void _updateConfigFromYaml() {
    if (_config == null) return;

    final config = AppConfig(
      title: _config!['app_settings']?['title'] ?? 'Custom Desktop App',
      version: _config!['app_settings']?['version'] ?? '1.0.0',
      primaryColor: Color(int.parse(_config!['theme']?['primary_color']?.toString().replaceFirst('#', '0xFF') ?? '0xFF6A1B9A')),
      secondaryColor: Color(int.parse(_config!['theme']?['secondary_color']?.toString().replaceFirst('#', '0xFF') ?? '0xFF03DAC6')),
      backgroundOpacity: (_config!['theme']?['background_opacity'] ?? 0.5).toDouble(),
      useGradient: _config!['theme']?['use_gradient'] ?? true,
      gradientColors: (_config!['theme']?['gradient_colors'] as List?)
          ?.map((color) => Color(int.parse(color.toString().replaceFirst('#', '0xFF'))))
          .toList() ?? [const Color(0xFF6A1B9A), const Color(0xFF3F51B5), const Color(0xFF2196F3)],
      windowWidth: (_config!['window']?['default_width'] ?? 800).toDouble(),
      windowHeight: (_config!['window']?['default_height'] ?? 600).toDouble(),
      resizable: _config!['window']?['resizable'] ?? true,
      alwaysOnTop: _config!['window']?['always_on_top'] ?? false,
      showCounter: _config!['ui']?['show_counter'] ?? true,
      counterText: _config!['ui']?['counter_text'] ?? 'You have pushed the button this many times:',
      buttonText: _config!['ui']?['button_text'] ?? 'Increment',
      fontSize: (_config!['ui']?['font_size'] ?? 16).toDouble(),
      trayTooltip: _config!['tray']?['tooltip'] ?? 'Custom Desktop App',
    );

    _configNotifier.value = config;
  }

  String _generateYamlFromConfig(AppConfig config) {
    return '''# 앱 설정 파일 - 빌드 후에도 동적으로 변경 가능
app_settings:
  title: "${config.title}"
  version: "${config.version}"
  
# 테마 설정
theme:
  primary_color: "#${config.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}"
  secondary_color: "#${config.secondaryColor.value.toRadixString(16).substring(2).toUpperCase()}"
  background_opacity: ${config.backgroundOpacity}
  use_gradient: ${config.useGradient}
  gradient_colors:
${config.gradientColors.map((color) => '    - "#${color.value.toRadixString(16).substring(2).toUpperCase()}"').join('\n')}
  
# 윈도우 설정
window:
  default_width: ${config.windowWidth.toInt()}
  default_height: ${config.windowHeight.toInt()}
  resizable: ${config.resizable}
  always_on_top: ${config.alwaysOnTop}
  
# UI 설정
ui:
  show_counter: ${config.showCounter}
  counter_text: "${config.counterText}"
  button_text: "${config.buttonText}"
  font_size: ${config.fontSize.toInt()}
  
# 시스템 트레이 설정
tray:
  tooltip: "${config.trayTooltip}"
  menu_items:
    - label: "📱 창 보이기"
      key: "show_window"
    - label: "👁️창 숨기기"
      key: "hide_window"
    - label: "⚙️ 설정"
      key: "settings"
    - label: "❌ 종료"
      key: "exit_app"''';
  }

  /// 설정 실시간 업데이트
  void updateConfig(AppConfig newConfig) {
    _configNotifier.value = newConfig;
  }

  /// 특정 설정값만 업데이트
  void updateTheme({Color? primaryColor, Color? secondaryColor, double? backgroundOpacity}) {
    final current = _configNotifier.value;
    _configNotifier.value = current.copyWith(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundOpacity: backgroundOpacity,
    );
  }
}

class AppConfig {
  final String title;
  final String version;
  final Color primaryColor;
  final Color secondaryColor;
  final double backgroundOpacity;
  final bool useGradient;
  final List<Color> gradientColors;
  final double windowWidth;
  final double windowHeight;
  final bool resizable;
  final bool alwaysOnTop;
  final bool showCounter;
  final String counterText;
  final String buttonText;
  final double fontSize;
  final String trayTooltip;

  const AppConfig({
    required this.title,
    required this.version,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundOpacity,
    required this.useGradient,
    required this.gradientColors,
    required this.windowWidth,
    required this.windowHeight,
    required this.resizable,
    required this.alwaysOnTop,
    required this.showCounter,
    required this.counterText,
    required this.buttonText,
    required this.fontSize,
    required this.trayTooltip,
  });

  factory AppConfig.defaultConfig() {
    return const AppConfig(
      title: 'Custom Desktop App',
      version: '1.0.0',
      primaryColor: Color(0xFF6A1B9A),
      secondaryColor: Color(0xFF03DAC6),
      backgroundOpacity: 0.5,
      useGradient: true,
      gradientColors: [Color(0xFF6A1B9A), Color(0xFF3F51B5), Color(0xFF2196F3)],
      windowWidth: 800,
      windowHeight: 600,
      resizable: true,
      alwaysOnTop: false,
      showCounter: true,
      counterText: 'You have pushed the button this many times:',
      buttonText: 'Increment',
      fontSize: 16,
      trayTooltip: 'Custom Desktop App',
    );
  }

  AppConfig copyWith({
    String? title,
    String? version,
    Color? primaryColor,
    Color? secondaryColor,
    double? backgroundOpacity,
    bool? useGradient,
    List<Color>? gradientColors,
    double? windowWidth,
    double? windowHeight,
    bool? resizable,
    bool? alwaysOnTop,
    bool? showCounter,
    String? counterText,
    String? buttonText,
    double? fontSize,
    String? trayTooltip,
  }) {
    return AppConfig(
      title: title ?? this.title,
      version: version ?? this.version,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      useGradient: useGradient ?? this.useGradient,
      gradientColors: gradientColors ?? this.gradientColors,
      windowWidth: windowWidth ?? this.windowWidth,
      windowHeight: windowHeight ?? this.windowHeight,
      resizable: resizable ?? this.resizable,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      showCounter: showCounter ?? this.showCounter,
      counterText: counterText ?? this.counterText,
      buttonText: buttonText ?? this.buttonText,
      fontSize: fontSize ?? this.fontSize,
      trayTooltip: trayTooltip ?? this.trayTooltip,
    );
  }
}
