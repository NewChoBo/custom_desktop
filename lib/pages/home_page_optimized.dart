import 'package:custom_desktop/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_desktop/services/window_service.dart';
import 'package:custom_desktop/services/tray_service.dart';
import 'package:custom_desktop/services/log_service.dart';
import 'package:custom_desktop/services/theme_service.dart';
import 'package:custom_desktop/utils/constants.dart';

/// 홈 페이지 - 앱의 메인 화면
///
/// **StatelessWidget 기반 성능 최적화 전략:**
/// 1. **불변 객체**: StatelessWidget은 불변 객체로 메모리 효율성이 높음
/// 2. **빠른 리빌드**: build 메서드만 호출되어 State 라이프사이클 오버헤드 없음
/// 3. **Static 메서드**: 인스턴스 메서드 오버헤드 제거
/// 4. **Const Constructor**: 위젯 트리 최적화
/// 5. **메서드 분리**: 큰 위젯을 작은 단위로 분리하여 재사용성과 성능 향상
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme 정보를 한 번만 가져와 재사용 (Theme.of() 호출 최소화)
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, theme, colorScheme),
      body: _buildBody(context, theme, colorScheme),
    );
  }

  /// 앱바 생성 (성능 최적화를 위해 별도 메서드로 분리)
  static PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: const Text(
        AppConstants.homeTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: const Icon(Icons.palette),
          tooltip: '테마 변경',
          onSelected: (String themeName) async {
            LogService.instance.userAction('테마 변경: $themeName');
            await ThemeService.instance.changeTheme(themeName);
            _showRestartDialog(context, themeName);
          },
          itemBuilder: (BuildContext context) {
            return ThemeService.instance.availableThemes.entries
                .map(
                  (MapEntry<String, AppTheme> entry) => PopupMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: entry.value.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(entry.value.name),
                        if (entry.key ==
                            ThemeService.instance.selectedThemeName)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.check, size: 16),
                          ),
                      ],
                    ),
                  ),
                )
                .toList();
          },
        ),
      ],
    );
  }

  /// 메인 바디 생성 (성능 최적화를 위해 별도 메서드로 분리)
  static Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.surface.withValues(alpha: 0.3),
            colorScheme.primary.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          // 오버플로우 방지
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              // 앱 로고
              Icon(
                Icons.desktop_windows,
                size: 100,
                color: theme.iconTheme.color,
              ),
              const SizedBox(height: 20),

              // 환영 메시지
              Text(
                '🖥️ Custom Desktop App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                '시스템 트레이에서 앱을 제어하세요',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 현재 테마 정보 표시
              _buildThemeInfoCard(context, theme, colorScheme),
              const SizedBox(height: 40),

              // 버튼들
              _buildActionButtons(context, colorScheme),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 테마 정보 카드 (성능 최적화를 위해 별도 위젯으로 분리)
  static Widget _buildThemeInfoCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            '현재 테마: ${ThemeService.instance.currentTheme?.name ?? "기본"}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            // Row 대신 Wrap 사용으로 반응형 개선
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: <Widget>[
              _buildColorBox(context, '주색상', colorScheme.primary),
              _buildColorBox(context, '배경색', theme.scaffoldBackgroundColor),
              _buildColorBox(context, '표면색', colorScheme.surface),
            ],
          ),
        ],
      ),
    );
  }

  /// 액션 버튼들 (성능 최적화를 위해 별도 위젯으로 분리)
  static Widget _buildActionButtons(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Wrap(
      // Row 대신 Wrap 사용으로 반응형 개선
      spacing: 20,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: <Widget>[
        // 창 숨기기 버튼
        ElevatedButton.icon(
          onPressed: () {
            LogService.instance.userAction('창 숨기기 버튼 클릭');
            WindowService.instance.hideWindow();
          },
          icon: const Icon(Icons.visibility_off),
          label: const Text('창 숨기기'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
        // 앱 종료 버튼
        ElevatedButton.icon(
          onPressed: () {
            LogService.instance.userAction('앱 종료 버튼 클릭');
            _showExitDialog(context);
          },
          icon: const Icon(Icons.exit_to_app),
          label: const Text('앱 종료'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  /// 색상 박스 위젯 (static 메서드로 최적화)
  static Widget _buildColorBox(
    BuildContext context,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  /// 종료 확인 다이얼로그 (static 메서드로 최적화)
  static void _showExitDialog(BuildContext context) {
    LogService.instance.userAction('종료 확인 다이얼로그 표시');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);

        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            '앱 종료',
            style: TextStyle(color: theme.textTheme.titleLarge?.color),
          ),
          content: Text(
            '정말로 앱을 종료하시겠습니까?',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                LogService.instance.userAction('종료 취소');
                Navigator.of(dialogContext).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                LogService.instance.userAction('종료 확인');
                Navigator.of(dialogContext).pop();
                TrayService.instance.dispose();
                WindowService.instance.closeApp();
              },
              child: const Text('종료', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// 재시작 안내 다이얼로그 (static 메서드로 최적화)
  static void _showRestartDialog(BuildContext context, String themeName) {
    final String? selectedThemeName =
        ThemeService.instance.availableThemes[themeName]?.name;

    LogService.instance.userAction('재시작 안내 다이얼로그 표시');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);

        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Row(
            children: <Widget>[
              const Icon(Icons.palette, size: 20),
              const SizedBox(width: 8),
              Text(
                '테마 변경',
                style: TextStyle(color: theme.textTheme.titleLarge?.color),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '테마가 "$selectedThemeName"로 변경되었습니다.',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '새 테마를 적용하려면 앱을 재시작해주세요.',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                LogService.instance.userAction('재시작 안내 확인');
                Navigator.of(dialogContext).pop();
              },
              child: const Text('확인'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                LogService.instance.userAction('앱 재시작 요청');
                Navigator.of(dialogContext).pop();
                TrayService.instance.dispose();
                WindowService.instance.closeApp();
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('지금 재시작'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}
