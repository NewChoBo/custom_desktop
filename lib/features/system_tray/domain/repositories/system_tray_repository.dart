import 'package:custom_desktop/features/system_tray/domain/entities/system_tray_entity.dart';

/// 시스템 트레이 리포지터리 인터페이스
abstract class SystemTrayRepository {
  /// 시스템 트레이 초기화
  Future<void> initialize();

  /// 트레이 아이콘 설정
  Future<void> setIcon(String iconPath);

  /// 트레이 툴팁 설정
  Future<void> setTooltip(String tooltip);

  /// 컨텍스트 메뉴 설정
  Future<void> setContextMenu(List<SystemTrayMenuEntity> menuItems);

  /// 컨텍스트 메뉴 팝업
  Future<void> popUpContextMenu();

  /// 리소스 정리
  void dispose();
}
