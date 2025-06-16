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

## 🤝 Contributing

This is a personal project, but suggestions and feedback are welcome!

## 📄 License

Private project - All rights reserved.