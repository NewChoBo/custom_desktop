@echo off
echo 🚀 Starting local build process...

REM Clean previous builds
echo 🧹 Cleaning previous builds...
if exist dist rmdir /s /q dist
if exist dist-electron rmdir /s /q dist-electron
if exist release rmdir /s /q release

REM Install dependencies
echo 📦 Installing dependencies...
npm ci

REM Build the application
echo 🔨 Building application...
npm run build

if %errorlevel% == 0 (
    echo ✅ Build completed successfully!
    echo.
    echo 📁 Build outputs:
    echo    - React app: dist/
    echo    - Electron app: dist-electron/
    echo.
    echo 🎯 Next steps:
    echo    - Test locally with: npm run dev
    echo    - Create distribution: npm run dist
    echo    - Create release tag: git tag v1.0.0 && git push origin v1.0.0
) else (
    echo ❌ Build failed!
    exit /b 1
)

pause
