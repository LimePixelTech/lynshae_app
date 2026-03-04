# 🚀 lynshae_app 从零开始部署指南

> 完整的开发环境搭建、项目部署和发布教程

**版本**: 1.0.0  
**更新时间**: 2026-03-04  
**适用平台**: Android / iOS / macOS

---

## 📋 目录

1. [系统要求](#-系统要求)
2. [开发环境搭建](#-开发环境搭建)
3. [项目克隆与配置](#-项目克隆与配置)
4. [Android 平台部署](#-android-平台部署)
5. [iOS 平台部署](#-ios-平台部署)
6. [macOS 平台部署](#-macos-平台部署)
7. [构建发布版本](#-构建发布版本)
8. [常见问题排查](#-常见问题排查)
9. [性能优化建议](#-性能优化建议)

---

## 🖥️ 系统要求

### 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| 处理器 | Intel i5 / Apple M1 | Apple M2/M3 或同级 |
| 内存 | 8 GB | 16 GB 或更高 |
| 存储 | 20 GB 可用空间 | 50 GB SSD |
| 屏幕 | 1920x1080 | 2560x1440 或更高 |

### 操作系统支持

| 平台 | 最低版本 | 推荐版本 |
|------|---------|---------|
| macOS | 10.15 (Catalina) | macOS 14+ (Sonoma) |
| Windows | Windows 10 (64-bit) | Windows 11 |
| Linux | Ubuntu 20.04 LTS | Ubuntu 22.04 LTS |

---

## 🛠️ 开发环境搭建

### 步骤 1: 安装 Git

**macOS:**
```bash
# 使用 Homebrew（推荐）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git

# 或使用 Xcode 命令行工具
xcode-select --install
```

**Windows:**
```bash
# 下载并运行安装程序
# https://gitforwindows.org/
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git

# Fedora/CentOS
sudo dnf install git
```

**验证安装:**
```bash
git --version
# 输出：git version 2.x.x
```

---

### 步骤 2: 安装 Flutter SDK

#### 方法 A: 使用包管理器（推荐 macOS）

```bash
# macOS
brew install --cask flutter

# 验证安装
flutter --version
```

#### 方法 B: 手动安装（所有平台）

**1. 下载 Flutter SDK**

```bash
# 创建开发目录
mkdir -p ~/development
cd ~/development

# 下载 Flutter（中国用户建议使用镜像）
# 方式 1: 直接下载
git clone https://github.com/flutter/flutter.git -b stable

# 方式 2: 使用国内镜像（推荐中国大陆用户）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
git clone https://github.com/flutter/flutter.git -b stable
```

**2. 配置环境变量**

**macOS/Linux:**
```bash
# 编辑配置文件
nano ~/.zshrc  # 或 ~/.bash_profile

# 添加以下内容
export PATH="$PATH:$HOME/development/flutter/bin"

# 使配置生效
source ~/.zshrc
```

**Windows:**
```powershell
# 以管理员身份打开 PowerShell
[System.Environment]::SetEnvironmentVariable(
   "PATH",
   "$env:PATH;$env:USERPROFILE\development\flutter\bin",
   "User"
)
```

**3. 验证安装**
```bash
flutter --version
flutter doctor
```

---

### 步骤 3: 安装 Android 开发环境

#### 3.1 安装 Android Studio

**macOS:**
```bash
brew install --cask android-studio
```

**Windows/Linux:**
- 访问 https://developer.android.com/studio
- 下载并安装

#### 3.2 配置 Android SDK

```bash
# 打开 Android Studio
# Tools → SDK Manager → 安装以下组件:
# - Android SDK Platform (API 36)
# - Android SDK Build-Tools
# - Android Emulator
# - Android SDK Platform-Tools
```

**命令行配置:**
```bash
# 接受 Android 许可证
flutter doctor --android-licenses

# 如果提示找不到 Java，先安装 Java
# macOS
brew install openjdk@21

# 配置 JAVA_HOME (macOS)
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' >> ~/.zshrc
source ~/.zshrc
```

#### 3.3 创建 Android 模拟器

```bash
# 在 Android Studio 中:
# Tools → Device Manager → Create Device
# 推荐配置:
# - Pixel 6
# - API 34 (Android 14)
# - RAM: 2048 MB
```

---

### 步骤 4: 安装 iOS 开发环境（仅 macOS）

#### 4.1 安装 Xcode

```bash
# 从 App Store 下载 Xcode
# 或访问 https://developer.apple.com/download/

# 安装完成后，打开一次 Xcode 接受许可协议
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

#### 4.2 安装 CocoaPods

```bash
# macOS
sudo gem install cocoapods

# 如果 gem 安装失败，使用 Homebrew
brew install cocoapods

# 验证安装
pod --version
```

#### 4.3 配置 iOS 模拟器

```bash
# 打开 Xcode
# Xcode → Settings → Components → 下载需要的 iOS 版本
```

---

### 步骤 5: 安装开发工具（可选但推荐）

#### 5.1 Visual Studio Code

```bash
# macOS
brew install --cask visual-studio-code

# Windows: 下载安装程序
# https://code.visualstudio.com/
```

**推荐插件:**
- Flutter
- Dart
- Flutter Widget Snippets
- Pubspec Assist
- Error Lens
- GitLens

#### 5.2 Android Studio 插件

打开 Android Studio:
- Settings → Plugins → 安装:
  - Flutter
  - Dart

---

## 📥 项目克隆与配置

### 步骤 1: 克隆项目

```bash
# 选择项目目录
cd ~/Projects  # 或你喜欢的任何目录

# 克隆项目
git clone https://github.com/your-username/lynshae_app.git
cd lynshae_app
```

### 步骤 2: 安装项目依赖

```bash
# 配置国内镜像（中国大陆用户）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 安装依赖
flutter pub get

# 验证依赖安装
flutter pub deps
```

### 步骤 3: 检查项目配置

```bash
# 运行 Flutter Doctor
flutter doctor -v

# 检查项目配置
flutter analyze

# 如果有任何问题，根据提示修复
```

### 步骤 4: 配置环境变量（可选）

创建 `.env` 文件用于存储配置：

```bash
# 在项目根目录创建 .env 文件
cat > .env << EOF
# API 配置
API_BASE_URL=https://api.lynshae.dev
API_VERSION=v1

# 蓝牙配置
BLUETOOTH_TIMEOUT=30000
BLUETOOTH_RETRY=3

# 功能开关
ENABLE_ANALYTICS=false
ENABLE_CRASHLYTICS=false
EOF

# 将 .env 添加到 .gitignore（如果还没有）
echo ".env" >> .gitignore
```

---

## 🤖 Android 平台部署

### 步骤 1: 配置 Android 项目

```bash
cd android

# 如果使用国内镜像，编辑 android/build.gradle
# 在 buildscript 和 allprojects  repositories 中添加:
# maven { url 'https://maven.aliyun.com/repository/google' }
# maven { url 'https://maven.aliyun.com/repository/public' }

cd ..
```

### 步骤 2: 配置 Gradle（如果需要）

```bash
# 编辑 android/gradle/wrapper/gradle-wrapper.properties
# 确保使用正确的 Gradle 版本
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip

# 如果下载慢，可以使用国内镜像:
# distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.9-all.zip
```

### 步骤 3: 运行 Android 应用

**方式 A: 使用 Android 模拟器**

```bash
# 查看可用设备
flutter devices

# 运行应用
flutter run

# 指定设备运行
flutter run -d emulator-5554

# 以调试模式运行
flutter run --debug

# 以发布模式运行
flutter run --release
```

**方式 B: 使用真机**

```bash
# 1. 在手机上开启开发者选项
# 设置 → 关于手机 → 连续点击"版本号"7 次

# 2. 开启 USB 调试
# 设置 → 开发者选项 → USB 调试 → 开启

# 3. 连接手机到电脑
# 运行 adb devices 验证连接
adb devices

# 4. 运行应用
flutter run

# 如果找不到设备，检查 USB 驱动（Windows）
# https://developer.android.com/studio/run/oem-usb
```

**方式 C: 使用 VS Code**

```bash
# 1. 打开项目
code .

# 2. 按 F5 或点击"运行和调试"
# 3. 选择 Android 设备
# 4. 应用将自动启动
```

### 步骤 4: 构建 APK

```bash
# 构建调试 APK
flutter build apk --debug

# 构建发布 APK
flutter build apk --release

# 构建分架构 APK（减小体积）
flutter build apk --split-per-abi

# 输出位置:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### 步骤 5: 构建 App Bundle（Google Play）

```bash
# 构建 App Bundle
flutter build appbundle --release

# 输出位置:
# build/app/outputs/bundle/release/app-release.aab

# 签名配置（生产环境）
# 编辑 android/app/build.gradle
```

---

## 🍎 iOS 平台部署

### 步骤 1: 配置 iOS 项目

```bash
cd ios

# 安装 CocoaPods 依赖
pod install

# 如果 pod install 失败
pod deintegrate
pod install

cd ..
```

### 步骤 2: 配置 Xcode 项目

```bash
# 打开 Xcode 项目
open ios/Runner.xcworkspace

# 在 Xcode 中配置:
# 1. 选择 Runner 项目
# 2. General → Bundle Identifier (修改为唯一标识)
# 3. Signing & Capabilities → 选择开发团队
# 4. 启用自动签名
```

### 步骤 3: 运行 iOS 应用

**方式 A: 使用 iOS 模拟器**

```bash
# 查看可用模拟器
flutter devices

# 运行应用
flutter run

# 指定模拟器
flutter run -d iPhone-15

# 以调试模式运行
flutter run --debug
```

**方式 B: 使用真机**

```bash
# 1. 在 Xcode 中配置签名
# 2. 将 iPhone 连接到 Mac
# 3. 信任开发证书
# 4. 运行应用
flutter run -d <device_id>
```

### 步骤 4: 构建 IPA

```bash
# 构建发布版本
flutter build ios --release

# 输出位置:
# build/ios/iphoneos/Runner.app

# 在 Xcode 中 Archive:
# 1. open ios/Runner.xcworkspace
# 2. Product → Archive
# 3. Distribute App
```

---

## 🖥️ macOS 平台部署

### 步骤 1: 配置 macOS 项目

```bash
cd macos

# 安装 CocoaPods 依赖
pod install

cd ..
```

### 步骤 2: 配置 Xcode 项目

```bash
# 打开 Xcode 项目
open macos/Runner.xcworkspace

# 配置签名和权限
# 1. Signing & Capabilities
# 2. Hardened Runtime (如果需要)
# 3. App Sandbox 配置
```

### 步骤 3: 运行 macOS 应用

```bash
# 运行应用
flutter run -d macos

# 以发布模式运行
flutter run -d macos --release
```

### 步骤 4: 构建 macOS App

```bash
# 构建应用
flutter build macos --release

# 输出位置:
# build/macos/Build/Products/Release/Smart Dog.app

# 创建 DMG 或 PKG（可选）
# 使用 Xcode 或第三方工具
```

---

## 📦 构建发布版本

### Android 发布

#### 1. 配置签名

**创建 Keystore:**
```bash
keytool -genkey -v -keystore ~/lynshae.keystore -alias lynshae \
  -keyalg RSA -keysize 2048 -validity 10000
```

**配置 Gradle:**

编辑 `android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            keyAlias 'lynshae'
            keyPassword 'your_password'
            storeFile file('/Users/your-username/lynshae.keystore')
            storePassword 'your_password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 2. 构建发布版本

```bash
# 构建签名 APK
flutter build apk --release

# 构建签名 App Bundle
flutter build appbundle --release
```

#### 3. 版本管理

编辑 `pubspec.yaml`:

```yaml
version: 1.0.0+1  # version+build_number
```

---

### iOS 发布

#### 1. 配置版本

编辑 `ios/Runner/Info.plist`:

```xml
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

#### 2. 构建 Archive

```bash
# 在 Xcode 中:
# 1. Product → Clean Build Folder
# 2. Product → Archive
# 3. 在 Organizer 中上传到 App Store Connect
```

#### 3. TestFlight 测试

```bash
# 上传到 App Store Connect 后
# 在 App Store Connect 中添加测试人员
# 通过 TestFlight 分发
```

---

### macOS 发布

#### 1. 公证应用（Notarization）

```bash
# 1. 导出 Developer ID 证书
# 2. 压缩应用
ditto -c -k --keepParent "build/macos/Build/Products/Release/Smart Dog.app" "Smart Dog.zip"

# 3. 提交公证
xcrun notarytool submit "Smart Dog.zip" \
  --apple-id "your-apple-id" \
  --password "your-app-specific-password" \
  --team-id "your-team-id" \
  --wait

# 4. 附加公证票据
xcrun stapler staple "build/macos/Build/Products/Release/Smart Dog.app"
```

#### 2. 创建安装包

```bash
# 使用 pkgbuild
pkgbuild --root "build/macos/Build/Products/Release/Smart Dog.app" \
  --identifier "com.lynshae.smartdog" \
  --version "1.0.0" \
  --install-location "/Applications" \
  "Smart Dog.pkg"
```

---

## 🐛 常见问题排查

### 问题 1: Flutter Doctor 报错

```bash
# 查看详细错误
flutter doctor -v

# 常见问题解决:
# 1. Android licenses not accepted
flutter doctor --android-licenses

# 2. Android SDK not found
# 在 Android Studio 中安装 Android SDK

# 3. Xcode not installed (macOS)
sudo xcode-select --install

# 4. CocoaPods not installed
sudo gem install cocoapods
```

### 问题 2: 依赖安装失败

```bash
# 清理缓存
flutter clean
flutter pub cache clean

# 重新安装依赖
flutter pub get

# 使用国内镜像（中国大陆）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter pub get
```

### 问题 3: Android 构建失败

```bash
# 清理 Gradle 缓存
cd android
./gradlew clean
cd ..

# 删除 .gradle 文件夹
rm -rf android/.gradle

# 重新构建
flutter clean
flutter pub get
flutter build apk
```

### 问题 4: iOS 构建失败

```bash
# 清理 iOS 构建
cd ios
pod deintegrate
pod install
cd ..

# 清理 Xcode 缓存
flutter clean
flutter pub get

# 重新打开 Xcode 项目
open ios/Runner.xcworkspace
# Product → Clean Build Folder
```

### 问题 5: 蓝牙权限问题

**Android:**
```xml
<!-- 确保 AndroidManifest.xml 包含以下权限 -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

**iOS:**
```xml
<!-- 确保 ios/Runner/Info.plist 包含 -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>需要使用蓝牙连接机器狗设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>需要使用蓝牙连接机器狗设备</string>
```

### 问题 6: 热重载不工作

```bash
# 确保使用调试模式启动
flutter run --debug

# 手动触发热重载
# 在终端按 r 键

# 如果仍然不行，热重启
# 在终端按 R 键

# 检查是否有状态初始化代码在 build 方法外
```

### 问题 7: 应用崩溃

```bash
# 查看日志
flutter logs

# 或使用 adb (Android)
adb logcat | grep -i flutter

# 使用 Xcode 控制台 (iOS)
# 运行应用后查看控制台输出
```

---

## ⚡ 性能优化建议

### 1. 减小应用体积

**Android:**
```bash
# 启用代码混淆和压缩
# android/app/build.gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}

# 构建分架构 APK
flutter build apk --split-per-abi
```

**iOS:**
```bash
# 在 Xcode 中配置
# Build Settings → Optimization Level → Optimize for Size
```

### 2. 优化启动速度

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 预加载必要数据
  await StorageService.initialize();
  
  runApp(SmartDogApp());
}
```

### 3. 图片优化

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
  
  # 使用多分辨率图片
  # assets/images/
  #   - logo.png
  #   - 2.0x/logo.png
  #   - 3.0x/logo.png
```

### 4. 网络优化

```dart
// 使用连接池
// 实现请求缓存
// 使用 GraphQL 或 Protocol Buffers 减少数据量
```

---

## 📊 部署检查清单

### 开发环境
- [ ] Flutter SDK 已安装并配置
- [ ] Android Studio / Xcode 已安装
- [ ] 模拟器/真机已配置
- [ ] 开发工具（VS Code）已安装
- [ ] Git 已安装并配置

### 项目配置
- [ ] 项目已克隆到本地
- [ ] 依赖已安装（flutter pub get）
- [ ] 环境变量已配置
- [ ] 代码检查通过（flutter analyze）

### Android 发布
- [ ] Keystore 已创建
- [ ] 签名配置已完成
- [ ] APK/App Bundle 已构建
- [ ] 应用已测试

### iOS 发布
- [ ] Apple Developer 账号已配置
- [ ] 证书和配置文件已创建
- [ ] Bundle ID 已配置
- [ ] Archive 已创建
- [ ] 已上传到 App Store Connect

### macOS 发布
- [ ] 开发者证书已配置
- [ ] 应用已公证（Notarization）
- [ ] 安装包已创建
- [ ] 应用已测试

---

## 📚 相关资源

### 官方文档
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)
- [Android 开发文档](https://developer.android.com/)
- [iOS 开发文档](https://developer.apple.com/)

### 社区资源
- [Flutter 中文网](https://flutter.cn/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Issues](https://github.com/lynshae/lynshae_app/issues)

### 学习教程
- [Flutter 入门教程](https://flutter.dev/docs/get-started/codelab)
- [Dart 语言教程](https://dart.dev/tutorials)
- [蓝牙开发指南](https://developer.android.com/guide/topics/connectivity/bluetooth)

---

## 🆘 获取帮助

### 技术支持渠道

- 📧 **邮箱**: support@lynshae.dev
- 💬 **Discord**: [加入社区](https://discord.gg/lynshae)
- 🐛 **Issues**: [提交问题](https://github.com/lynshae/lynshae_app/issues)
- 📖 **文档**: [完整文档](./docs/)

### 常见问题 FAQ

查看 [常见问题](#-常见问题排查) 部分，或搜索 Issue 列表。

---

## 📝 更新日志

### v1.0.0 (2026-03-04)
- ✨ 初始版本发布
- 📱 Android / iOS / macOS 平台支持
- 🔧 完整部署指南
- 🐛 常见问题解决方案

---

*祝您部署顺利！如有问题，请随时联系技术支持。*

**Last Updated**: 2026-03-04  
**Author**: lynshae Team  
**License**: MIT
