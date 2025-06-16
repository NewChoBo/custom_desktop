#!/bin/bash

# Local Build Script for Custom Desktop Icons
# This script builds the application for testing before GitHub Actions

echo "🚀 Starting local build process..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ dist-electron/ release/

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Build the application
echo "🔨 Building application..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    echo ""
    echo "📁 Build outputs:"
    echo "   - React app: dist/"
    echo "   - Electron app: dist-electron/"
    echo ""
    echo "🎯 Next steps:"
    echo "   - Test locally with: npm run dev"
    echo "   - Create distribution: npm run dist"
    echo "   - Create release tag: git tag v1.0.0 && git push origin v1.0.0"
else
    echo "❌ Build failed!"
    exit 1
fi
