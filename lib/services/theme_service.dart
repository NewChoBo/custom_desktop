import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_desktop/models/theme_model.dart';
import 'package:custom_desktop/services/log_service.dart';

/// 테마 관리 서비스 (최적화 - 정적 테마)
class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  static ThemeService get instance => _instance;
  ThemeService._internal();

  // 현재 적용된 테마
  AppTheme? _currentTheme;
  AppTheme? get currentTheme => _currentTheme;

  // 사용 가능한 모든 테마
  final Map<String, AppTheme> _availableThemes = <String, AppTheme>{};
  Map<String, AppTheme> get availableThemes => _availableThemes;

  // 현재 선택된 테마 이름
  String _selectedThemeName = 'dark';
  String get selectedThemeName => _selectedThemeName;

  /// 테마 서비스 초기화
  Future<void> initialize() async {
    try {
      LogService.instance.startup('테마 서비스 초기화 시작');

      // 기본 테마들 로드
      await _loadAvailableThemes();

      // 사용자 설정에서 선택된 테마 로드
      await _loadSelectedTheme();

      // 테마 적용
      await _applyTheme();

      LogService.instance.startup('테마 서비스 초기화 완료');
    } catch (e, stackTrace) {
      LogService.instance.error('테마 서비스 초기화 실패', e, stackTrace);
      // 기본 테마로 폴백
      _setDefaultTheme();
    }
  }

  /// 사용 가능한 테마들을 로드
  Future<void> _loadAvailableThemes() async {
    try {
      // assets에서 기본 테마 파일 읽기
      final String themesJson = await rootBundle.loadString(
        'assets/settings/defaults/themes.json',
      );
      final Map<String, dynamic> themesData = json.decode(themesJson);

      if (themesData['themes'] != null) {
        final Map<String, dynamic> themes = themesData['themes'];

        for (String key in themes.keys) {
          _availableThemes[key] = AppTheme.fromJson(themes[key]);
        }

        LogService.instance.info('${_availableThemes.length}개 테마 로드 완료');
      }
    } catch (e) {
      LogService.instance.error('테마 파일 로드 실패', e);
      throw e;
    }
  }

  /// 사용자 설정에서 선택된 테마 이름 로드
  Future<void> _loadSelectedTheme() async {
    try {
      // 사용자 설정 파일 읽기
      final String configJson = await rootBundle.loadString(
        'assets/settings/user/config.json',
      );
      final Map<String, dynamic> configData = json.decode(configJson);

      if (configData['ui'] != null && configData['ui']['theme'] != null) {
        _selectedThemeName = configData['ui']['theme'];
        LogService.instance.info('선택된 테마: $_selectedThemeName');
      }
    } catch (e) {
      LogService.instance.warning('사용자 설정 로드 실패, 기본 테마 사용', e);
      _selectedThemeName = 'dark'; // 기본값
    }
  }

  /// 테마 적용
  Future<void> _applyTheme() async {
    if (_availableThemes.containsKey(_selectedThemeName)) {
      _currentTheme = _availableThemes[_selectedThemeName];
      LogService.instance.info('테마 적용 완료: ${_currentTheme?.name}');
    } else {
      LogService.instance.warning('선택된 테마를 찾을 수 없음: $_selectedThemeName');
      _setDefaultTheme();
    }
  }

  /// 기본 테마 설정
  void _setDefaultTheme() {
    _currentTheme = const AppTheme(
      name: 'Default Dark',
      primaryColor: Colors.blue,
      backgroundColor: Color(0xFF121212),
      surfaceColor: Color(0xFF1E1E1E),
      textColor: Colors.white,
      iconColor: Colors.white70,
    );
    _selectedThemeName = 'dark';
    LogService.instance.info('기본 테마 적용');
  }

  /// 테마 변경 (앱 재시작 필요)
  Future<void> changeTheme(String themeName) async {
    if (_availableThemes.containsKey(themeName)) {
      // 사용자 설정에 저장 (향후 구현)
      await _saveThemePreference(themeName);

      LogService.instance.info(
        '테마 변경 요청: ${_availableThemes[themeName]?.name}',
      );
      LogService.instance.info('테마 적용을 위해 앱을 재시작해주세요');

      // 앱 재시작 안내
      return;
    }
  }

  /// 테마 설정 저장 (나중에 구현)
  Future<void> _saveThemePreference(String themeName) async {
    // TODO: 사용자 설정 파일에 테마 선택 저장
    LogService.instance.info('테마 설정 저장: $themeName');
  }

  /// 현재 테마의 ThemeData 반환
  ThemeData getThemeData() {
    return _currentTheme?.toThemeData() ?? ThemeData.dark();
  }
}
