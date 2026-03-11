# 🚀 lynshae_app 快速开始指南

> 5 分钟快速启动项目

---

## 📱 在 Android 模拟器中运行（详细教程）

### 步骤 1: 检查 Flutter 环境

```bash
flutter doctor
```

确保以下项目已勾选：
- ✅ Flutter SDK
- ✅ Android toolchain
- ✅ Android Studio / Xcode

### 步骤 2: 查看可用模拟器

```bash
flutter emulators
```

输出示例：
```
2 available emulators:

Id                    • Name                  • Manufacturer • Platform
apple_ios_simulator   • iOS Simulator         • Apple        • ios
Medium_Phone_API_36.1 • Medium Phone API 36.1 • Generic      • android
```

### 步骤 3: 启动 Android 模拟器

```bash
# 启动指定模拟器（使用你的模拟器 ID）
flutter emulators --launch Medium_Phone_API_36.1
```

**或者**在 Android Studio 中启动：
1. 打开 Android Studio
2. 点击 "Device Manager"
3. 选择虚拟设备，点击启动按钮

### 步骤 4: 确认模拟器已连接

等待模拟器完全启动后，运行：

```bash
flutter devices
```

应该能看到类似输出：
```
Found 2 connected devices:
  sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 16 (API 36) (emulator)
  macOS (desktop)             • macos         • darwin-arm64  • macOS 26.3 ...
```

### 步骤 5: 运行应用

```bash
# 在模拟器上运行 Flutter 应用
flutter run -d emulator-5554
```

**常用运行选项：**
```bash
# 调试模式（支持热重载）
flutter run -d emulator-5554 --debug

# 发布模式（测试性能）
flutter run -d emulator-5554 --release

# 显示详细日志
flutter run -d emulator-5554 --verbose
```

### 步骤 6: 开发快捷键

应用运行后，在终端中可以使用：

| 按键 | 功能 |
|------|------|
| `r` | 热重载（Hot Reload） |
| `R` | 热重启（Hot Restart） |
| `q` | 退出应用 |
| `h` | 显示帮助 |

### 常见问题

#### 模拟器启动失败

```bash
# 检查模拟器状态
flutter emulators

# 如果模拟器损坏，创建新模拟器
flutter emulators --create [--name my_emulator]
```

#### 设备未识别

```bash
# 重启 ADB 服务
adb kill-server
adb start-server

# 重新检查设备
flutter devices
```

#### 构建失败

```bash
# 清理并重新构建
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run -d emulator-5554
```

#### 模拟器运行缓慢

1. **启用硬件加速**：
   - 打开 Android Studio → SDK Manager
   - 安装 "Android Emulator Hypervisor Driver"

2. **增加模拟器内存**：
   - Device Manager → 编辑设备 → 显示高级设置
   - 增加 RAM 到 2048 MB 或更高

3. **使用冷启动**：
   ```bash
   flutter emulators --launch Medium_Phone_API_36.1 --cold
   ```

---

## ⚡ 最快速启动（推荐）

### 使用启动脚本

**macOS/Linux:**
```bash
# 1. 克隆项目
git clone https://github.com/your-username/lynshae_app.git
cd lynshae_app

# 2. 运行启动脚本
chmod +x scripts/start.sh
./scripts/start.sh
```

**Windows:**
```batch
# 1. 克隆项目
git clone https://github.com/your-username/lynshae_app.git
cd lynshae_app

# 2. 运行启动脚本
scripts\start.bat
```

启动脚本会自动：
- ✅ 检查 Flutter 环境
- ✅ 安装项目依赖
- ✅ 检查项目配置
- ✅ 列出可用设备
- ✅ 启动应用

---

## 📋 手动启动步骤

### 步骤 1: 确认 Flutter 已安装

```bash
flutter --version
flutter doctor
```

如果未安装，请查看 [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) 的完整安装教程。

### 步骤 2: 克隆项目

```bash
git clone https://github.com/your-username/lynshae_app.git
cd lynshae_app
```

### 步骤 3: 配置国内镜像（中国大陆用户）

**macOS/Linux:**
```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

**Windows (PowerShell):**
```powershell
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

### 步骤 4: 安装依赖

```bash
flutter pub get
```

### 步骤 5: 查看可用设备

```bash
flutter devices
```

### 步骤 6: 运行项目

```bash
# 直接运行（会自动选择设备）
flutter run

# 指定设备运行
flutter run -d <device_id>

# 调试模式
flutter run --debug

# 发布模式
flutter run --release
```

---

## 🎯 常用命令

```bash
# 获取依赖
flutter pub get

# 代码检查
flutter analyze

# 格式化代码
dart format .

# 清理构建
flutter clean

# 重新安装依赖
flutter clean && flutter pub get

# 查看日志
flutter logs
```

---

## 📱 运行到不同平台

### Android

```bash
# 使用模拟器
flutter run

# 使用真机
# 1. 开启 USB 调试
# 2. 连接设备
# 3. 运行
flutter run

# 构建 APK
flutter build apk --release
```

### iOS (仅 macOS)

```bash
# 使用模拟器
flutter run

# 使用真机
flutter run -d <device_id>

# 构建
flutter build ios --release
```

### macOS

```bash
# 运行
flutter run -d macos

# 构建
flutter build macos --release
```

---

## 🐛 遇到问题？

### 依赖安装失败

```bash
flutter clean
flutter pub cache clean
flutter pub get
```

### 构建失败

```bash
# Android
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get

# iOS
cd ios && pod deintegrate && pod install && cd ..
flutter clean
flutter pub get
```

### 热重载不工作

- 确保使用 `flutter run` 启动
- 按 `r` 键手动热重载
- 按 `R` 键热重启

### 更多问题

查看 [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) 的常见问题排查章节。

---

## 📚 下一步

- 📖 阅读 [完整部署指南](DEPLOYMENT_GUIDE.md)
- 📋 查看 [项目文档](docs/)
- 🎨 了解 [开发指南](docs/DEVELOPMENT_GUIDE.md)
- 🔌 研究 [蓝牙协议](docs/BLUETOOTH_PROTOCOL.md)

---

## 🆘 获取帮助

- 📧 邮箱：support@lynshae.dev
- 💬 Discord: [加入社区](https://discord.gg/lynshae)
- 🐛 Issues: [提交问题](https://github.com/lynshae/lynshae_app/issues)

---

*祝您开发愉快！* 🎉
