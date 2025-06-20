# 🖥️ Custom Desktop App

**초심자 친화적인** Flutter 데스크톱 애플리케이션

## ✨ 특징

- 🎯 **단순하고 이해하기 쉬운 구조** - 복잡한 아키텍처 없이 직관적
- 🖥️ **데스크톱 특화 기능** - 창 관리, 시스템 트레이 지원
- 🎨 **투명 배경** - 시스템과 자연스럽게 블렌딩
- 📱 **트레이 통합** - 백그라운드에서 실행, 트레이에서 제어

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
```

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
