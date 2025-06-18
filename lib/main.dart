import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 윈도우 관리자 설정
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden, // 타이틀 바 숨기기
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Desktop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // 전체 앱 배경을 투명하게 설정
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const MyHomePage(title: 'Custom Desktop'),
      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경을 50% 투명하게 설정
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      appBar: AppBar(
        // AppBar를 80% 투명하게 설정 (20% 불투명도)
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
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
            colors: [
              Colors.deepPurple.withValues(alpha: 0.3),  // 30% 불투명 보라색
              Colors.blue.withValues(alpha: 0.2),        // 20% 불투명 파란색
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
