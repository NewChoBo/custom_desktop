# 🎯 Custom Desktop Icons

Modern cross-platform desktop icon management tool with Steam integration.

## ✨ Features

- 🎮 Steam integration for gaming icons
- 🖥️ Cross-platform support (Windows, macOS, Linux)
- ⚡ Fast and lightweight Electron app
- 🎨 Modern, beautiful UI with React
- 🔧 TypeScript for type safety
- ⚙️ Vite for fast development

## 🚀 Tech Stack

- **Frontend**: React 19 + TypeScript
- **Desktop**: Electron 36
- **Build Tool**: Vite 6
- **Styling**: CSS3 with modern features
- **Package Manager**: npm

## 📦 Installation

```bash
# Clone the repository
git clone <repository-url>
cd custom_desktop

# Install dependencies
npm install

# Start development server
npm run dev
```

## 🔧 Development Scripts

```bash
# Development mode (React + Electron with hot reload)
npm run dev

# Build React app
npm run build:vite

# Build Electron app
npm run build:electron

# Build entire project
npm run build
```

## 📁 Project Structure

```
custom_desktop/
├── electron/          # Electron main process
│   ├── main.ts        # Main process entry
│   ├── preload.ts     # Preload script
│   └── tsconfig.json  # Electron TypeScript config
├── src/               # React app source
│   ├── App.tsx        # Main React component
│   ├── App.css        # Component styles
│   ├── main.tsx       # React entry point
│   └── index.css      # Global styles
├── index.html         # HTML template
├── package.json       # Dependencies and scripts
├── tsconfig.json      # TypeScript configuration
└── vite.config.ts     # Vite configuration
```

## 🎯 Development Goals

- [x] Basic React + Electron setup
- [x] TypeScript integration
- [x] Modern UI with animations
- [x] Development environment optimization
- [ ] Steam integration
- [ ] Icon management features
- [ ] Cross-platform packaging
- [ ] Auto-updater integration

## AI Development with GitHub Copilot

This project is optimized for GitHub Copilot development. Here are some tips:

### 🎯 Copilot Context

- **Project Type**: Electron + React + TypeScript desktop application
- **Main Purpose**: Desktop icon management with Steam integration
- **Key Technologies**: Electron 36, React 19, TypeScript 5.8, Vite 6

### 💡 Copilot Usage Tips

1. **File Context**: Keep relevant imports and type definitions visible
2. **Comments**: Use descriptive comments to guide Copilot suggestions
3. **Naming**: Use clear, descriptive variable and function names
4. **Patterns**: Follow established patterns in the codebase

### 🔧 Copilot Chat Commands

```
# In VS Code, use Ctrl+Shift+I to open Copilot Chat and try:
/explain - Explain selected code
/fix - Fix bugs in selected code
/tests - Generate unit tests
/doc - Generate documentation
```

### 📁 Key Directories for Copilot Context

- `src/` - React frontend components
- `electron/` - Electron main and preload scripts
- `.vscode/` - VS Code workspace configuration

## 📝 Commit Message Format

This project follows **Conventional Commits** specification:

```
<type>(<scope>): <description>

[optional body]
[optional footer(s)]
```

### Commit Types

- **feat(scope)**: New feature
- **fix(scope)**: Bug fix
- **docs**: Documentation changes
- **chore**: Build process, tool changes
- **refactor**: Code refactoring (no functionality change)
- **test**: Adding/modifying tests
- **hotfix**: Critical bug fix

### Examples

```bash
feat(config): add flexible window positioning system
fix(ui): resolve scrollbar visibility issues
docs(readme): update configuration examples
chore(deps): update electron to v36
refactor(main): simplify window creation logic
test(config): add unit tests for config loader
hotfix(tray): fix tray icon display issue
```

### Common Scopes

- `ui`, `config`, `main`, `tray`, `build`, `docs`, `test`, `deps`

## 🤝 Contributing

This is a personal project, but suggestions and feedback are welcome!

## 📄 License

Private project - All rights reserved.
