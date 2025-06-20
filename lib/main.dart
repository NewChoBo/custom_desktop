import 'package:flutter/material.dart';
import 'package:custom_desktop/app.dart';
import 'package:custom_desktop/services/window_service.dart';
import 'package:custom_desktop/services/tray_service.dart';

/// 🚀 앱 시작점
///
/// 이 함수가 앱이 시작될 때 가장 먼저 실행됩니다.
/// 1. Flutter 초기화
/// 2. 윈도우 서비스 초기화 (창 관리)
/// 3. 트레이 서비스 초기화 (시스템 트레이)
/// 4. 앱 실행
Future<void> main() async {
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  print('🔧 앱 초기화 중...');

  try {
    // 윈도우 서비스 초기화 (창 크기, 위치 등 설정)
    await WindowService.instance.initialize();
    print('✅ 윈도우 서비스 초기화 완료');

    // 트레이 서비스 초기화 (시스템 트레이 아이콘, 메뉴 설정)
    await TrayService.instance.initialize();
    print('✅ 트레이 서비스 초기화 완료');

    print('🎉 모든 초기화 완료! 앱을 시작합니다.');
  } catch (e) {
    print('❌ 초기화 중 오류 발생: $e');
  }

  // 앱 실행
  runApp(const MyApp());
}
