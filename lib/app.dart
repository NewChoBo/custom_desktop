import 'package:flutter/material.dart';
import 'package:custom_desktop/pages/home_page.dart';
import 'package:custom_desktop/utils/constants.dart';

/// 메인 앱 위젯 - 앱의 기본 설정을 담당
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      // 어두운 테마로 설정
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      // 홈 페이지 설정
      home: const HomePage(),
      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,
    );
  }
}
