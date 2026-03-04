@echo off
chcp 65001 >nul

REM 🚀 lynshae_app 快速启动脚本 (Windows 版本)
REM 用于快速配置开发环境和运行项目

setlocal enabledelayedexpansion

REM 项目信息
set PROJECT_NAME=lynshae_app
set PROJECT_VERSION=1.0.0

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║              🐕 lynshae_app 快速启动                     ║
echo ║                                                          ║
echo ║              智能机器狗配套 Flutter APP                  ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

REM 检测参数
set USE_MIRROR=false
set NO_RUN=false
set DO_CLEAN=false

:parse_args
if "%~1"=="" goto :end_parse_args
if /i "%~1"=="--help" goto :show_help
if /i "%~1"=="-h" goto :show_help
if /i "%~1"=="--mirror" set USE_MIRROR=true & shift & goto :parse_args
if /i "%~1"=="-m" set USE_MIRROR=true & shift & goto :parse_args
if /i "%~1"=="--no-run" set NO_RUN=true & shift & goto :parse_args
if /i "%~1"=="-n" set NO_RUN=true & shift & goto :parse_args
if /i "%~1"=="--clean" set DO_CLEAN=true & shift & goto :parse_args
if /i "%~1"=="-c" set DO_CLEAN=true & shift & goto :parse_args
echo ❌ 未知选项：%~1
goto :show_help
:end_parse_args

REM 检查 Flutter
echo ⏳ 检查 Flutter 环境...
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo ❌ Flutter 未安装
    echo 📖 安装指南：https://flutter.dev/docs/get-started/install/windows
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('flutter --version') do (
    set FLUTTER_VERSION=%%i
    goto :found_flutter
)
:found_flutter
echo ✅ Flutter 已安装：%FLUTTER_VERSION%
echo.

REM 检查 Android
echo ⏳ 检查 Android 环境...
where adb >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  Android SDK 未检测到（可选）
) else (
    echo ✅ Android SDK 已安装
)
echo.

REM 配置镜像
if "%USE_MIRROR%"=="true" (
    echo 📦 配置国内镜像...
    set PUB_HOSTED_URL=https://pub.flutter-io.cn
    set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
    echo ✅ 镜像配置完成
    echo.
) else (
    set /p "USE_MIRROR_INPUT=🌏 是否使用国内镜像加速？(Y/N): "
    if /i "!USE_MIRROR_INPUT!"=="Y" (
        echo 📦 配置国内镜像...
        set PUB_HOSTED_URL=https://pub.flutter-io.cn
        set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
        echo ✅ 镜像配置完成
        echo.
    )
)

REM 清理
if "%DO_CLEAN%"=="true" (
    echo 🧹 清理项目...
    flutter clean
    if exist "build" rmdir /s /q build
    echo ✅ 清理完成
    echo.
)

REM 安装依赖
echo 📦 安装项目依赖...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)
echo ✅ 依赖安装完成
echo.

REM 检查项目
echo ⏳ 检查项目配置...
call flutter analyze
if %errorlevel% neq 0 (
    echo ⚠️  项目存在一些问题，但不影响运行
) else (
    echo ✅ 项目配置正常
)
echo.

REM 查看设备
echo 📱 可用设备列表:
call flutter devices
echo.

REM 运行项目
if "%NO_RUN%"=="true" (
    goto :skip_run
)

set /p "RUN_PROJECT=🚀 是否立即运行项目？(Y/N): "
if /i "!RUN_PROJECT!"=="Y" (
    echo 🚀 启动项目...
    call flutter run
)

:skip_run
echo.
echo ✅ 启动完成！
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║  📖 更多文档请查看:                                      ║
echo ║     - DEPLOYMENT_GUIDE.md ^(完整部署指南^)               ║
echo ║     - docs\ ^(项目文档^)                                 ║
echo ║                                                          ║
echo ║  🌐 官方网站：https://lynshae.dev                       ║
echo ║  📧 技术支持：support@lynshae.dev                       ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

pause
goto :eof

:show_help
echo.
echo 用法：%~nx0 [选项]
echo.
echo 选项:
echo   --help, -h          显示帮助信息
echo   --mirror, -m        使用国内镜像
echo   --no-run, -n        安装依赖后不运行项目
echo   --clean, -c         清理后重新安装
echo.
echo 示例:
echo   %~nx0               快速启动
echo   %~nx0 -m            使用国内镜像
echo   %~nx0 -c            清理后重新安装
echo   %~nx0 -m -n         使用国内镜像，不运行项目
echo.
pause
goto :eof
