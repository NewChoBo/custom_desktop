import 'package:flutter/material.dart';
import 'package:custom_desktop/features/home/presentation/pages/home_page.dart';
import 'package:custom_desktop/core/constants/app_constants.dart';

/// 메인 앱 위젯
/// 앱의 전체적인 테마와 라우팅을 관리
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // 전체 앱 배경을 투명하게 설정
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomePage(title: AppConstants.homeTitle),
      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,
    );
  }
}
