import 'package:flutter/material.dart';

/// 테마 정보를 담는 모델 클래스
class AppTheme {
  final String name;
  final Color primaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color iconColor;

  const AppTheme({
    required this.name,
    required this.primaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.iconColor,
  });

  /// JSON에서 테마 생성
  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      name: json['name'] ?? '',
      primaryColor: Color(
        int.parse(json['primaryColor'].replaceFirst('#', '0xFF')),
      ),
      backgroundColor: Color(
        int.parse(json['backgroundColor'].replaceFirst('#', '0xFF')),
      ),
      surfaceColor: Color(
        int.parse(json['surfaceColor'].replaceFirst('#', '0xFF')),
      ),
      textColor: Color(int.parse(json['textColor'].replaceFirst('#', '0xFF'))),
      iconColor: Color(int.parse(json['iconColor'].replaceFirst('#', '0xFF'))),
    );
  }

  /// Flutter ThemeData로 변환
  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: backgroundColor.computeLuminance() > 0.5
            ? Brightness.light
            : Brightness.dark,
        surface: surfaceColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: textColor),
      ),
      iconTheme: IconThemeData(color: iconColor),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
      ),
    );
  }
}
