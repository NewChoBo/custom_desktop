import 'package:flutter/widgets.dart';
import 'package:custom_desktop/core/di/injection.dart';
import 'package:custom_desktop/features/system_tray/presentation/providers/system_tray_event_handler.dart';

class AppInitializationService {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    DependencyInjection.instance.initialize();

    await DependencyInjection.instance.initializeWindowUseCase();
    await DependencyInjection.instance.initializeSystemTrayUseCase();

    SystemTrayEventHandler.instance.initialize();
  }

  static void dispose() {
    DependencyInjection.instance.systemTrayRepository.dispose();
    SystemTrayEventHandler.instance.dispose();
  }
}
