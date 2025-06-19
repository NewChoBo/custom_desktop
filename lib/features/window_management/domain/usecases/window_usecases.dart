import 'package:custom_desktop/features/window_management/domain/repositories/window_repository.dart';

/// 윈도우 표시 UseCase
class ShowWindowUseCase {
  final WindowRepository repository;

  ShowWindowUseCase(this.repository);

  Future<void> call() async {
    await repository.show();
  }
}

/// 윈도우 숨기기 UseCase
class HideWindowUseCase {
  final WindowRepository repository;

  HideWindowUseCase(this.repository);

  Future<void> call() async {
    await repository.hide();
  }
}

/// 윈도우 토글 UseCase
class ToggleWindowUseCase {
  final WindowRepository repository;

  ToggleWindowUseCase(this.repository);

  Future<void> call() async {
    await repository.toggle();
  }
}

/// 앱 종료 UseCase
class CloseAppUseCase {
  final WindowRepository repository;

  CloseAppUseCase(this.repository);

  Future<void> call() async {
    await repository.close();
  }
}

/// 윈도우 초기화 UseCase
class InitializeWindowUseCase {
  final WindowRepository repository;

  InitializeWindowUseCase(this.repository);

  Future<void> call() async {
    await repository.initialize();
  }
}
