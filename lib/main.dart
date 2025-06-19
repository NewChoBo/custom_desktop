import 'package:flutter/material.dart';
import 'package:custom_desktop/core/services/app_initialization_service.dart';
import 'package:custom_desktop/core/app/app.dart';

Future<void> main() async {
  // 앱 초기화
  await AppInitializationService.initialize();

  // 앱 실행
  runApp(const MyApp());
}
