import 'package:flutter/material.dart';
import 'package:custom_desktop/services/window_service.dart';
import 'package:custom_desktop/services/tray_service.dart';
import 'package:custom_desktop/utils/constants.dart';

/// 홈 페이지 - 앱의 메인 화면
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      // 커스텀 앱바 (드래그 가능)
      appBar: AppBar(
        title: const Text(
          AppConstants.homeTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.3),
        elevation: 0,
        centerTitle: true,
      ),
      // 메인 컨텐츠
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.deepPurple.withValues(alpha: 0.3),
              Colors.blue.withValues(alpha: 0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 앱 로고
              const Icon(
                Icons.desktop_windows,
                size: 100,
                color: Colors.white70,
              ),
              const SizedBox(height: 20),

              // 환영 메시지
              const Text(
                '🖥️ Custom Desktop App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                '시스템 트레이에서 앱을 제어하세요',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              // 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 창 숨기기 버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      WindowService.instance.hideWindow();
                    },
                    icon: const Icon(Icons.visibility_off),
                    label: const Text('창 숨기기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.withValues(alpha: 0.8),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // 앱 종료 버튼
                  ElevatedButton.icon(
                    onPressed: () {
                      _showExitDialog();
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('앱 종료'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.8),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 종료 확인 다이얼로그
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('앱 종료', style: TextStyle(color: Colors.white)),
          content: const Text(
            '정말로 앱을 종료하시겠습니까?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                TrayService.instance.dispose();
                WindowService.instance.closeApp();
              },
              child: const Text('종료', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
