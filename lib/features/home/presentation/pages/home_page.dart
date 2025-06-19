import 'package:flutter/material.dart';

/// 홈 화면 위젯
/// 메인 UI 컴포넌트를 담당
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경을 50% 투명하게 설정
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      appBar: AppBar(
        // AppBar를 80% 투명하게 설정 (20% 불투명도)
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        // AppBar 그림자 제거
        elevation: 0,
        // 시스템 오버레이 스타일 설정
        foregroundColor: Colors.white,
      ),
      body: Container(
        // 배경 그라데이션 효과 추가
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.deepPurple.withValues(alpha: 0.3), // 30% 불투명 보라색
              Colors.blue.withValues(alpha: 0.2), // 20% 불투명 파란색
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.8), // 80% 불투명
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
