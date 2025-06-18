import 'package:custom_desktop/features/window_management/data/datasources/window_manager_datasource.dart';
import 'package:custom_desktop/features/window_management/data/repositories/window_repository_impl.dart';
import 'package:custom_desktop/features/window_management/domain/repositories/window_repository.dart';
import 'package:custom_desktop/features/window_management/domain/usecases/window_usecases.dart';
import 'package:custom_desktop/features/system_tray/data/datasources/system_tray_datasource.dart';
import 'package:custom_desktop/features/system_tray/data/repositories/system_tray_repository_impl.dart';
import 'package:custom_desktop/features/system_tray/domain/repositories/system_tray_repository.dart';
import 'package:custom_desktop/features/system_tray/domain/usecases/system_tray_usecases.dart';

/// 의존성 주입 컨테이너
class DependencyInjection {
  static DependencyInjection? _instance;
  static DependencyInjection get instance => _instance ??= DependencyInjection._();
  
  DependencyInjection._();
    // Data Sources
  late final WindowManagerDataSource _windowManagerDataSource;
  late final SystemTrayDataSource _systemTrayDataSource;
  
  // Repositories
  late final WindowRepository _windowRepository;
  late final SystemTrayRepository _systemTrayRepository;
  
  // Use Cases
  late final InitializeWindowUseCase _initializeWindowUseCase;
  late final ShowWindowUseCase _showWindowUseCase;
  late final HideWindowUseCase _hideWindowUseCase;
  late final ToggleWindowUseCase _toggleWindowUseCase;
  late final CloseAppUseCase _closeAppUseCase;
  
  late final InitializeSystemTrayUseCase _initializeSystemTrayUseCase;
  late final SetTrayIconUseCase _setTrayIconUseCase;
  late final SetTrayContextMenuUseCase _setTrayContextMenuUseCase;
  late final PopUpTrayMenuUseCase _popUpTrayMenuUseCase;
    /// 의존성 초기화
  void initialize() {
    // Data Sources
    _windowManagerDataSource = WindowManagerDataSource();
    _systemTrayDataSource = SystemTrayDataSource();
    
    // Repositories
    _windowRepository = WindowRepositoryImpl(_windowManagerDataSource);
    _systemTrayRepository = SystemTrayRepositoryImpl(_systemTrayDataSource);
    
    // Use Cases
    _initializeWindowUseCase = InitializeWindowUseCase(_windowRepository);
    _showWindowUseCase = ShowWindowUseCase(_windowRepository);
    _hideWindowUseCase = HideWindowUseCase(_windowRepository);
    _toggleWindowUseCase = ToggleWindowUseCase(_windowRepository);
    _closeAppUseCase = CloseAppUseCase(_windowRepository);
    
    _initializeSystemTrayUseCase = InitializeSystemTrayUseCase(_systemTrayRepository);
    _setTrayIconUseCase = SetTrayIconUseCase(_systemTrayRepository);
    _setTrayContextMenuUseCase = SetTrayContextMenuUseCase(_systemTrayRepository);
    _popUpTrayMenuUseCase = PopUpTrayMenuUseCase(_systemTrayRepository);
  }
    // Getters
  WindowManagerDataSource get windowManagerDataSource => _windowManagerDataSource;
  SystemTrayDataSource get systemTrayDataSource => _systemTrayDataSource;
  WindowRepository get windowRepository => _windowRepository;
  SystemTrayRepository get systemTrayRepository => _systemTrayRepository;
  InitializeWindowUseCase get initializeWindowUseCase => _initializeWindowUseCase;
  ShowWindowUseCase get showWindowUseCase => _showWindowUseCase;
  HideWindowUseCase get hideWindowUseCase => _hideWindowUseCase;
  ToggleWindowUseCase get toggleWindowUseCase => _toggleWindowUseCase;
  CloseAppUseCase get closeAppUseCase => _closeAppUseCase;
  InitializeSystemTrayUseCase get initializeSystemTrayUseCase => _initializeSystemTrayUseCase;
  SetTrayIconUseCase get setTrayIconUseCase => _setTrayIconUseCase;
  SetTrayContextMenuUseCase get setTrayContextMenuUseCase => _setTrayContextMenuUseCase;
  PopUpTrayMenuUseCase get popUpTrayMenuUseCase => _popUpTrayMenuUseCase;
}
