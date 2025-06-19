import 'package:flutter/material.dart';
import 'package:custom_desktop/core/services/app_initialization_service.dart';
import 'package:custom_desktop/core/app/app.dart';

Future<void> main() async {
  await AppInitializationService.initialize();
  runApp(const MyApp());
}
