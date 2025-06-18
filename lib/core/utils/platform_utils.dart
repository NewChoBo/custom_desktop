import 'dart:io';
import 'package:flutter/foundation.dart';

/// 플랫폼 관련 유틸리티 함수들
class PlatformUtils {
  /// 현재 플랫폼이 데스크톱인지 확인
  static bool get isDesktop => 
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  
  /// 현재 플랫폼이 모바일인지 확인
  static bool get isMobile => 
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  
  /// 현재 플랫폼이 웹인지 확인
  static bool get isWeb => kIsWeb;
  
  /// 현재 플랫폼이 Windows인지 확인
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  
  /// 현재 플랫폼이 macOS인지 확인
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  
  /// 현재 플랫폼이 Linux인지 확인
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  
  /// 플랫폼별 기본 설정을 반환
  static Map<String, dynamic> getPlatformDefaults() {
    if (isWindows) {
      return {
        'skipTaskbar': true,
        'titleBarStyle': 'hidden',
      };
    } else if (isMacOS) {
      return {
        'skipTaskbar': false,
        'titleBarStyle': 'normal',
      };
    } else if (isLinux) {
      return {
        'skipTaskbar': true,
        'titleBarStyle': 'hidden',
      };
    }
    return {};
  }
}
