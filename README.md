# Custom Desktop App

A Flutter desktop application built with Clean Architecture and Feature-First approach.

## 🏗️ Architecture

This project follows **Clean Architecture + Feature-First** pattern for better maintainability, testability, and scalability.

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # App-wide common elements
│   ├── app/
│   │   └── app.dart            # Main app widget
│   ├── constants/
│   │   └── app_constants.dart  # App constants
│   ├── di/
│   │   └── injection.dart      # Dependency injection container
│   ├── services/
│   │   └── app_initialization_service.dart
│   └── utils/
│       └── platform_utils.dart # Platform utilities
├── shared/                      # Shared components (widgets, models, extensions)
│   ├── widgets/                # Reusable UI components
│   ├── models/                 # Shared data models
│   └── extensions/             # Dart extensions
└── features/                    # Feature-based modules
    ├── window_management/       # Window management feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── window_manager_datasource.dart
    │   │   └── repositories/
    │   │       └── window_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── window_entity.dart
    │   │   ├── repositories/
    │   │   │   └── window_repository.dart
    │   │   └── usecases/
    │   │       └── window_usecases.dart
    │   └── presentation/
    │       ├── pages/
    │       ├── widgets/
    │       └── providers/
    ├── system_tray/            # System tray feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── system_tray_datasource.dart
    │   │   └── repositories/
    │   │       └── system_tray_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── system_tray_entity.dart
    │   │   ├── repositories/
    │   │   │   └── system_tray_repository.dart
    │   │   └── usecases/
    │   │       └── system_tray_usecases.dart
    │   └── presentation/
    │       └── providers/
    │           └── system_tray_event_handler.dart
    └── home/                   # Home screen feature
        ├── data/
        ├── domain/
        └── presentation/
            └── pages/
                └── home_page.dart
```

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
