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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
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
        child: const Center(),
      ),
    );
  }
}
