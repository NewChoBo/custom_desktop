# Release Checklist

## Pre-Release Preparation

### ✅ Code Quality
- [ ] All TypeScript compilation errors resolved
- [ ] All linting issues fixed
- [ ] Code formatting with Prettier applied
- [ ] All tests passing (when implemented)

### ✅ Build Testing
- [ ] Local build successful (`npm run build`)
- [ ] Development mode working (`npm run dev`)
- [ ] Electron app launches correctly
- [ ] All main features functional

### ✅ Configuration
- [ ] `package.json` version updated
- [ ] `config/window-config.json` has correct defaults
- [ ] Build configuration in `package.json` is correct
- [ ] Icon files exist in `assets/` directory

### ✅ Documentation
- [ ] README.md updated with latest features
- [ ] CHANGELOG.md updated (if exists)
- [ ] Build instructions verified

## Release Process

### 🏷️ GitHub Release (Automated)

1. **Create and Push Tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Monitor GitHub Actions**:
   - Check Actions tab for build progress
   - Verify builds complete for all platforms
   - Check for any build failures

3. **Verify Release**:
   - Check Releases page for new release
   - Verify all platform binaries are attached
   - Test download links

### 🔧 Manual Release (if needed)

1. **Build Locally**:
   ```bash
   npm run dist
   ```

2. **Test Distribution**:
   - Install and test the built packages
   - Verify all features work in production build

3. **Create GitHub Release**:
   - Go to Releases → Create new release
   - Upload built files from `release/` directory
   - Write release notes

## Post-Release

### ✅ Verification
- [ ] Download and install from GitHub releases
- [ ] Test main functionality
- [ ] Check system tray integration
- [ ] Verify settings GUI works
- [ ] Test window positioning and sizing
- [ ] Verify multi-monitor support

### ✅ Distribution
- [ ] Update any external documentation
- [ ] Announce release (if applicable)
- [ ] Monitor for user feedback/issues

## Platform-Specific Notes

### Windows
- `.exe` installer with NSIS
- Portable `.exe` version
- Both x64 and x86 architectures

### macOS
- `.dmg` disk image
- Code signing (requires developer certificate)
- Both Intel and Apple Silicon support

### Linux
- `.AppImage` portable version
- `.deb` package for Debian/Ubuntu
- x64 architecture

## Common Issues

### Build Failures
- Check Node.js version (should be 20+)
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`
- Check for missing dependencies
- Verify TypeScript compilation

### Distribution Issues
- Missing icon files in `assets/`
- Incorrect file paths in electron-builder config
- Platform-specific build tool issues

### Runtime Issues
- Missing config files
- Incorrect file permissions
- Antivirus false positives (Windows)
