import 'dart:ui';

import 'package:custom_desktop/features/window_management/domain/entities/window_entity.dart';
import 'package:custom_desktop/features/window_management/domain/repositories/window_repository.dart';
import 'package:custom_desktop/features/window_management/data/datasources/window_manager_datasource.dart';

/// 윈도우 리포지터리 구현체
class WindowRepositoryImpl implements WindowRepository {
  final WindowManagerDataSource dataSource;

  WindowRepositoryImpl(this.dataSource);

  @override
  Future<void> initialize() async {
    await dataSource.initialize();
  }

  @override
  Future<void> show() async {
    await dataSource.show();
  }

  @override
  Future<void> hide() async {
    await dataSource.hide();
  }

  @override
  Future<void> toggle() async {
    final bool isCurrentlyVisible = await dataSource.isVisible();
    if (isCurrentlyVisible) {
      await dataSource.hide();
    } else {
      await dataSource.show();
    }
  }

  @override
  Future<void> close() async {
    await dataSource.close();
  }

  @override
  Future<WindowEntity> getWindowState() async {
    final bool isVisible = await dataSource.isVisible();
    final Size size = await dataSource.getSize();
    final Offset position = await dataSource.getPosition();

    return WindowEntity(
      isVisible: isVisible,
      isFocused: isVisible, // 간단한 구현
      isMinimized: false, // 간단한 구현
      width: size.width,
      height: size.height,
      x: position.dx,
      y: position.dy,
    );
  }

  @override
  Future<bool> isVisible() async {
    return await dataSource.isVisible();
  }

  @override
  Future<void> focus() async {
    await dataSource.focus();
  }

  @override
  Future<void> minimize() async {
    await dataSource.minimize();
  }

  @override
  Future<void> maximize() async {
    await dataSource.maximize();
  }
}
