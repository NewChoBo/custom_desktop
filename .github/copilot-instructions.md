## GitHub Copilot 지침서: Custom Desktop App (Flutter Desktop)

### 1. 목적

* Clean Architecture + Feature‑First 기반 Custom Desktop App 개발에 Copilot 활용 최적화
* 기존 코드 구조, DI 컨테이너, 모듈 패턴을 유지하면서 자동완성 제안을 안정적으로 적용
* 코드 포맷(들여쓰기·새 줄 등)과 절대 경로(import) 스타일을 보존

### 2. 프로젝트 개요 & 개발 환경

* **레포지토리**: NewChoBo/custom\_desktop
* **아키텍처**: Clean Architecture + Feature‑First
* **Flutter SDK**: ≥3.7
* **IDE**: VS Code 또는 JetBrains (Copilot 플러그인 최신)
* **지원 플랫폼**: Windows, macOS, Linux
* **주요 패키지**:

  * `window_manager: ^0.5.0` (창 크기·위치·alwaysOnTop 제어)
  * `tray_manager: ^0.5.0` (시스템 트레이 아이콘·메뉴)
  * (필요 시) `flutter_acrylic`, `desktop_drop`, `hotkey_manager` 등
* **코드 스타일**: 2-space 들여쓰기, absolute import (`package:custom_desktop/...`)
* **포맷·린트**: `analysis_options.yaml` 규칙 준수, `format on save` 활성화

### 3. 코드베이스 구조

```
lib/
 ├─ main.dart                   # 진입점
 ├─ core/                       # 앱 전역 공통
 │   ├─ app/app.dart            # MainApp 위젯
 │   ├─ constants/app_constants.dart
 │   ├─ di/injection.dart       # GetIt DI 설정
 │   ├─ services/app_initialization_service.dart
 │   └─ utils/platform_utils.dart
 ├─ shared/                     # 재사용 컴포넌트
 │   ├─ widgets/
 │   ├─ models/
 │   └─ extensions/
 └─ features/                   # Feature‑First 모듈
     ├─ window_management/
     ├─ system_tray/
     └─ home/
```

> **Import 예시**
>
> ```dart
> import 'package:custom_desktop/core/constants/app_constants.dart';
> import 'package:custom_desktop/features/window_management/domain/usecases/window_usecases.dart';
> ```

### 4. Copilot 프롬프트 전략

1. **모듈별 맥락 제공**: 기능별 폴더 구조 상단에 주석으로 모듈 역할과 경로 명시

   ```dart
   /// Window Management Feature
   /// - UseCases: window_management/domain/usecases
   /// - Repository: window_management/data
   // Copilot: 위 모듈 구조에 맞춰 usecase 구현 메서드를 작성해주세요.
   ```
2. **DI 컨테이너 참조**: `core/di/injection.dart`를 미리 불러온 상태에서 서비스·리포지토리 등록 요청

   ```dart
   // TODO [Copilot]: GetIt에 WindowRepositoryImpl을 등록해주세요
   final getIt = GetIt.instance;
   ```
3. **절대 import 강조**: Copilot에게 항상 `package:` 경로를 사용하도록 주석 지시

   ```dart
   // FIXME [Copilot]: 상대경로 대신 package:custom_desktop/ 경로로 수정해주세요
   ```
4. **작업 분할**: 복합 기능은 단계별로 세분화

   * Settings 저장 함수 구현 → JSON 직렬화 적용 → 에러 처리 로깅 추가

### 5. 주석 & 태그 패턴

* `// TODO [Copilot]:` 신규 기능 작성 요청
* `// FIXME [Copilot]:` 잘못된 제안 수정 요청
* `// EXAMPLE [Copilot]:` 사용 예시 코드 생성 요청
* `// DO NOT MODIFY BELOW`: 핵심 로직 블록 보호

### 6. Copilot 설정 팁

* **Suggestion Delay**: 100ms
* **Inline Suggestions**: 켜기
* **Format on Save**: 켜기 (`editor.formatOnSave: true`)
* **Analysis Options**: `analysis_options.yaml` 활성화하여 린트 오류 수집
* **Custom Instructions**:

  * `.github/copilot-instructions.md`에 "Maintain Clean Architecture layers and absolute imports" 등 명시
  * 팀원 합의 하에 공유

### 6.1. Flutter Lint 설정 (analysis\_options.yaml)

Flutter 프로젝트 전반에 걸친 일관된 코드 스타일과 품질 관리를 위해 `analysis_options.yaml` 파일을 루트에 추가하세요. 예시:

```yaml
include: package:flutter_lints/flutter.yaml

enable-experiment:
  - non-nullable

linter:
  rules:
    # Flutter 스타일 권장
    avoid_print: true               # console print 금지
    prefer_const_constructors: true # const 생성자 사용 권장
    prefer_final_fields: true       # 불변 필드 우선 사용
    prefer_single_quotes: true      # 작은따옴표 사용

    # Clean Architecture 유도
    unused_import: true             # 사용하지 않는 import 금지
    avoid_relative_lib_imports: true# 상대경로 import 금지
    file_names: snake_case          # 파일명은 snake_case
    always_specify_types: true      # 제네릭 등 타입 명시
    library_prefixes: true          # import 시 prefix 사용 권장 (e.g., core_)

analyzer:
  exclude:
    - "**/*.g.dart"  # 코드 생성 파일 제외
    - "**/build/**"
    - "**/*.freezed.dart"
```

> **주의**: 위 설정을 적용한 후 `flutter analyze`와 `format on save`가 정상 작동하는지 확인하고, 팀원에게 변경 사항을 공유하세요.

### 7. 자주 발생 문제 & 해결 자주 발생 문제 & 해결

| 문제             | 원인                         | 해결 방법                                              |
| -------------- | -------------------------- | -------------------------------------------------- |
| 블록 내부 들여쓰기 깨짐  | Copilot 제안 포맷과 프로젝트 규칙 불일치 | 저장 시 자동 포맷, 줄 끝 주석(`// DO NOT MODIFY`) 으로 보호       |
| 상대경로 import 추가 | Copilot이 컨텍스트 부족           | 주석으로 절대경로 지시, Custom Instructions에 import 규칙 등록    |
| DI 컨테이너 누락     | 모듈 인식 부족                   | `// TODO [Copilot]: injection.dart 참조 후 등록` 명시     |
| 불필요한 로직 변경     | 광범위 프롬프트 사용                | 타겟 함수/위젯만 작은 단위로 요청, `// DO NOT MODIFY` 주석으로 경계 설정 |

### 8. 프로젝트별 예시 프롬프트

1. **Window UseCase 추가**

   ```dart
   // TODO [Copilot]: features/window_management/domain/usecases/window_usecases.dart에
   // - maximizeWindow() 구현
   // - minimizeWindow() 구현
   ```
2. **System Tray 메뉴**

   ```dart
   // EXAMPLE [Copilot]: tray_manager를 사용해 'Quit' 메뉴 추가 예시 코드 작성
   ```
3. **Home Page 위젯**

   ```dart
   /// Home Page UI
   /// - 앱 로고, 최근 아이콘 리스트, 설정 버튼
   // Copilot: UI 레이아웃 위젯 코드 완성
   ```

### 9. 팀 협업 시 지침 파일

* `.github/copilot-instructions.md` 생성
* 주요 규칙:

  1. Clean Architecture 레이어 구조 준수
  2. 절대 import 사용
  3. 핵심 로직 블록은 `// DO NOT MODIFY`로 보호
  4. 신규 코드에는 단위 테스트 주석 요청
* **재사용 프롬프트**: `prompts/window_setup.md`, `prompts/tray_menu.md` 등으로 템플릿화

---

*이 지침서는 Custom Desktop App 레포지토리 구조와 정책에 맞추어 Copilot 활용을 최적화하기 위해 작성되었습니다.*
