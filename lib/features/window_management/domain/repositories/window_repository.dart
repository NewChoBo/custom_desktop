import '../entities/window_entity.dart';

/// 윈도우 관리 기능의 리포지터리 인터페이스
abstract class WindowRepository {
  /// 윈도우 초기화
  Future<void> initialize();

  /// 윈도우 표시
  Future<void> show();

  /// 윈도우 숨기기
  Future<void> hide();

  /// 윈도우 토글 (표시/숨김 전환)
  Future<void> toggle();

  /// 앱 종료
  Future<void> close();

  /// 윈도우 상태 가져오기
  Future<WindowEntity> getWindowState();

  /// 윈도우가 보이는지 확인
  Future<bool> isVisible();

  /// 윈도우에 포커스 주기
  Future<void> focus();

  /// 윈도우 최소화
  Future<void> minimize();

  /// 윈도우 최대화
  Future<void> maximize();
}
