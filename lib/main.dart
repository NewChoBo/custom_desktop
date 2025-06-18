import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:custom_desktop/core/services/app_initialization_service.dart';
import 'package:custom_desktop/core/app/app.dart';
import 'package:custom_desktop/features/settings/settings_window.dart';

Future<void> main(List<String> args) async {
  // 멀티 윈도우 처리
  if (args.firstOrNull == 'multi_window') {
    WidgetsFlutterBinding.ensureInitialized();

    final String arguments = args[2];
    final argMap = jsonDecode(arguments);
    final route = argMap['route'] ?? '/';

    switch (route) {
      case '/settings':
        runApp(const SettingsWindow());
        break;
      default:
        runApp(
          MaterialApp(
            home: Scaffold(body: Center(child: Text('Unknown route: $route'))),
          ),
        );
    }
    return;
  }

  // 메인 앱 초기화 및 실행
  await AppInitializationService.initialize();

  runApp(const MyApp());
}
