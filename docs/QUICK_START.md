# 🚀 lynshae_app 快速开始指南

> 5 分钟快速启动项目

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
