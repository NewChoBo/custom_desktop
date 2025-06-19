import 'package:flutter/widgets.dart';
import 'package:custom_desktop/core/di/injection.dart';
import 'package:custom_desktop/features/system_tray/presentation/providers/system_tray_event_handler.dart';

/// 앱 초기화 서비스
/// 앱 시작 시 필요한 모든 서비스를 초기화
class AppInitializationService {
  /// 앱 초기화
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 의존성 주입 초기화
    DependencyInjection.instance.initialize();

    // 윈도우 관리자 초기화
    await DependencyInjection.instance.initializeWindowUseCase();
    // 시스템 트레이 초기화
    await DependencyInjection.instance.initializeSystemTrayUseCase();

    // 시스템 트레이 이벤트 핸들러 초기화
    SystemTrayEventHandler.instance.initialize();
  }

  /// 앱 종료 시 정리 작업
  static void dispose() {
    DependencyInjection.instance.systemTrayRepository.dispose();
    SystemTrayEventHandler.instance.dispose();
  }
}
