import 'package:tray_manager/tray_manager.dart';
import 'package:custom_desktop/features/system_tray/domain/entities/system_tray_entity.dart';
import 'package:custom_desktop/features/system_tray/domain/repositories/system_tray_repository.dart';
import 'package:custom_desktop/features/system_tray/data/datasources/system_tray_datasource.dart';

/// 시스템 트레이 리포지터리 구현체
class SystemTrayRepositoryImpl implements SystemTrayRepository {
  final SystemTrayDataSource dataSource;

  SystemTrayRepositoryImpl(this.dataSource);

  @override
  Future<void> initialize() async {
    await dataSource.initialize();
  }

  @override
  Future<void> setIcon(String iconPath) async {
    await dataSource.setIcon(iconPath);
  }

  @override
  Future<void> setTooltip(String tooltip) async {
    await dataSource.setTooltip(tooltip);
  }

  @override
  Future<void> setContextMenu(List<SystemTrayMenuEntity> menuItems) async {
    final List<MenuItem> trayMenuItems = menuItems.map((
      SystemTrayMenuEntity item,
    ) {
      if (item.isSeparator) {
        return MenuItem.separator();
      } else {
        return MenuItem(key: item.key, label: item.label);
      }
    }).toList();

    await dataSource.setContextMenu(trayMenuItems);
  }

  @override
  Future<void> popUpContextMenu() async {
    await dataSource.popUpContextMenu();
  }

  @override
  void dispose() {
    dataSource.dispose();
  }
}
