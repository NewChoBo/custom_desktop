import 'package:custom_desktop/features/system_tray/domain/entities/system_tray_entity.dart';
import 'package:custom_desktop/features/system_tray/domain/repositories/system_tray_repository.dart';

/// 시스템 트레이 초기화 UseCase
class InitializeSystemTrayUseCase {
  final SystemTrayRepository repository;
  
  InitializeSystemTrayUseCase(this.repository);
  
  Future<void> call() async {
    await repository.initialize();
  }
}

/// 트레이 아이콘 설정 UseCase
class SetTrayIconUseCase {
  final SystemTrayRepository repository;
  
  SetTrayIconUseCase(this.repository);
  
  Future<void> call(String iconPath) async {
    await repository.setIcon(iconPath);
  }
}

/// 트레이 컨텍스트 메뉴 설정 UseCase
class SetTrayContextMenuUseCase {
  final SystemTrayRepository repository;
  
  SetTrayContextMenuUseCase(this.repository);
  
  Future<void> call(List<SystemTrayMenuEntity> menuItems) async {
    await repository.setContextMenu(menuItems);
  }
}

/// 트레이 메뉴 팝업 UseCase
class PopUpTrayMenuUseCase {
  final SystemTrayRepository repository;
  
  PopUpTrayMenuUseCase(this.repository);
  
  Future<void> call() async {
    await repository.popUpContextMenu();
  }
}
