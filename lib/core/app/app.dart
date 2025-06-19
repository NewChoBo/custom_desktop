import 'package:flutter/material.dart';
import 'package:custom_desktop/features/home/presentation/pages/home_page.dart';
import 'package:custom_desktop/core/constants/app_constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomePage(title: AppConstants.homeTitle),
      debugShowCheckedModeBanner: false,
    );
  }
}
