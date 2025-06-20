import 'package:logger/logger.dart';

/// 📝 로깅 서비스 클래스
///
/// 앱 전체에서 사용할 통합 로깅 시스템입니다.
/// 개발 중에는 콘솔에 컬러풀한 로그를 출력하고,
/// 릴리즈 모드에서는 파일로 저장할 수 있습니다.
class LogService {
  static final LogService _instance = LogService._internal();
  static LogService get instance => _instance;
  LogService._internal();

  late final Logger _logger;

  /// 로거 초기화
  void initialize() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // 호출 스택 표시 줄 수
        errorMethodCount: 8, // 에러 시 스택 표시 줄 수
        lineLength: 120, // 로그 한 줄 최대 길이
        colors: true, // 컬러 출력 활성화
        printEmojis: true, // 이모지 활성화
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 시간 표시 활성화
      ),
    );

    info('📝 로깅 서비스가 초기화되었습니다');
  }

  /// 🐛 디버그 로그 (개발 중 상세 정보)
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// ℹ️ 정보 로그 (일반적인 앱 동작)
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// ⚠️ 경고 로그 (주의가 필요한 상황)
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// ❌ 에러 로그 (오류 발생)
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 🔥 치명적 에러 로그 (심각한 오류)
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// 📊 성능 측정용 로그
  void performance(String operation, Duration duration) {
    info('⏱️ $operation 완료 (${duration.inMilliseconds}ms)');
  }

  /// 🚀 앱 시작/초기화 관련 로그
  void startup(String message) {
    info('🚀 [시작] $message');
  }

  /// 🖼️ 윈도우 관련 로그
  void window(String message) {
    info('🖼️ [윈도우] $message');
  }

  /// 🔔 트레이 관련 로그
  void tray(String message) {
    info('🔔 [트레이] $message');
  }

  /// 🎯 사용자 액션 로그
  void userAction(String action) {
    info('🎯 [사용자] $action');
  }
}
