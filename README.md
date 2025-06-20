# 🖥️ Custom Desktop App

**초심자 친화적인** Flutter 데스크톱 애플리케이션

## ✨ 특징

- 🎯 **단순하고 이해하기 쉬운 구조** - 복잡한 아키텍처 없이 직관적
- 🖥️ **데스크톱 특화 기능** - 창 관리, 시스템 트레이 지원
- 🎨 **투명 배경** - 시스템과 자연스럽게 블렌딩
- 📱 **트레이 통합** - 백그라운드에서 실행, 트레이에서 제어

## 📁 프로젝트 구조

```
lib/
├── main.dart              # 🚀 앱 시작점 (가장 먼저 실행)
├── app.dart              # ⚙️ 앱 기본 설정 (테마, 제목 등)
├── pages/                # 📄 화면들
│   └── home_page.dart    #    └── 메인 화면
├── services/             # 🔧 핵심 기능들
│   ├── window_service.dart #    ├── 창 관리 (열기/닫기/크기조절)
│   └── tray_service.dart   #    └── 시스템 트레이 (아이콘/메뉴)
└── utils/                # 🛠️ 도구들
    └── constants.dart    #    └── 상수 모음 (텍스트, 크기 등)
```

## 🎯 각 파일의 역할

### 📱 main.dart - 앱 시작점

- Flutter 초기화
- 윈도우 서비스 설정
- 트레이 서비스 설정
- 앱 실행

### 🏠 pages/home_page.dart - 메인 화면

- 사용자가 보는 메인 UI
- 창 숨기기/종료 버튼
- 투명 배경 + 그라데이션 효과

### 🪟 services/window_service.dart - 창 관리

- 창 열기/닫기
- 창 크기/위치 설정
- 창 표시/숨기기 토글

### 🔔 services/tray_service.dart - 시스템 트레이

- 트레이 아이콘 설정
- 우클릭 메뉴 생성
- 트레이 클릭 이벤트 처리

### 📋 utils/constants.dart - 상수 관리

- 앱 제목, 창 크기
- 메뉴 텍스트들
- 파일 경로들
  │ ├── data/
  │ │ ├── datasources/
  │ │ │ └── window_manager_datasource.dart
  │ │ └── repositories/
  │ │ └── window_repository_impl.dart
  │ ├── domain/
  │ │ ├── entities/
  │ │ │ └── window_entity.dart
  │ │ ├── repositories/
  │ │ │ └── window_repository.dart
  │ │ └── usecases/
  │ │ └── window_usecases.dart
  │ └── presentation/
  │ ├── pages/
  │ ├── widgets/
  │ └── providers/
  ├── system_tray/ # System tray feature
  │ ├── data/
  │ │ ├── datasources/
  │ │ │ └── system_tray_datasource.dart
  │ │ └── repositories/
  │ │ └── system_tray_repository_impl.dart
  │ ├── domain/
  │ │ ├── entities/
  │ │ │ └── system_tray_entity.dart
  │ │ ├── repositories/
  │ │ │ └── system_tray_repository.dart
  │ │ └── usecases/
  │ │ └── system_tray_usecases.dart
  │ └── presentation/
  │ └── providers/
  │ └── system_tray_event_handler.dart
  └── home/ # Home screen feature
  ├── data/
  ├── domain/
  └── presentation/
  └── pages/
  └── home_page.dart

````

## 🚀 Features

- **Window Management**: Control window visibility, size, and position
- **System Tray Integration**: System tray icon with context menu
- **Transparent UI**: Modern glassmorphism-style interface
- **Cross-platform**: Supports Windows, macOS, and Linux

## 🛠️ Architecture Principles

### Clean Architecture Layers

1. **Domain Layer** (`domain/`)
   - Entities: Core business objects
   - Repositories: Abstract contracts for data access
   - Use Cases: Business logic implementations

2. **Data Layer** (`data/`)
   - Data Sources: External data access (APIs, local storage, etc.)
   - Repository Implementations: Concrete implementations of domain repositories

3. **Presentation Layer** (`presentation/`)
   - Pages: UI screens
   - Widgets: Reusable UI components
   - Providers: State management (ready for Riverpod integration)

### Key Benefits

- ✅ **Separation of Concerns**: Each layer has a single responsibility
- ✅ **Testability**: Easy to unit test each layer independently
- ✅ **Maintainability**: Changes in one layer don't affect others
- ✅ **Scalability**: Easy to add new features without affecting existing code
- ✅ **Dependency Inversion**: High-level modules don't depend on low-level modules

## 🔧 Import Strategy

The project uses **absolute imports** with package prefix for better maintainability:

```dart
// ✅ Good: Absolute imports
import 'package:custom_desktop/core/constants/app_constants.dart';
import 'package:custom_desktop/features/window_management/domain/entities/window_entity.dart';

// ❌ Avoid: Relative imports
import '../../../core/constants/app_constants.dart';
import '../../domain/entities/window_entity.dart';
````

## 📦 Dependencies

- `window_manager: ^0.5.0` - Window management
- `tray_manager: ^0.5.0` - System tray functionality

## 🚀 Getting Started

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd custom_desktop
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   flutter build windows  # for Windows
   flutter build macos    # for macOS
   flutter build linux    # for Linux
   ```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 🤝 Contributing

1. Follow the established architecture patterns
2. Add new features as separate modules in `features/`
3. Use absolute imports with package prefix
4. Write tests for new functionality
5. Follow Clean Architecture principles

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
