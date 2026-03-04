# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter-based Smart Robot Dog Companion App** (智能机器狗配套APP) that serves as a control hub, interaction window, and bonding companion for a robotic dog device.

### Core Features

1. **Device Home** (`home_screen.dart`): Device status monitoring, mode switching (Companion/Patrol/Follow/Sleep), battery level, and smart home integration
2. **Real-time Control** (`control_screen.dart`): Virtual joystick for movement, action library (shake hands, spin, bow, sit, stand), FPV video feed, emergency stop
3. **Bonding System** (`bonding_screen.dart`): Emotional bonding progression (初识→熟悉→信赖→家人), daily quests, achievement unlocks
4. **Settings** (`settings_screen.dart`): Device management, OTA firmware updates, preferences

## Architecture

### Design System

The app uses a **blue-orange color scheme** defined in `lib/theme/app_theme.dart`:

```dart
static const Color primaryBlue = Color(0xFF2B7FFF);    // Controls, primary actions
static const Color accentOrange = Color(0xFFFF6B35);   // Warnings, secondary actions
static const Color darkBackground = Color(0xFF1A1A2E); // Dark theme base
static const Color cardBackground = Color(0xFF16213E); // Card surfaces
```

- Supports both light and dark themes via `AppTheme.lightTheme` / `AppTheme.darkTheme`
- Uses Material 3 with rounded corners (16px radius on cards)
- Dark theme is the primary design target (robotic/tech aesthetic)

### Data Models

Located in `lib/models/`:

- **`device_model.dart`**: `DeviceModel` class with `DeviceStatus` and `DeviceMode` enums
  - Status: idle, moving, executing, charging, sleeping, error
  - Modes: companion (陪伴), patrol (巡逻), follow (跟随), sleep (休眠)
  - Uses extension methods for display names and icons

- **`bonding_model.dart`**: `BondingState`, `BondingLevel`, `DailyTask` classes
  - Four bonding levels with point thresholds (0, 100, 500, 1500)
  - Progress calculation utilities

- **`action_model.dart`**: `DogAction` class for executable actions

### Screen Navigation

The app uses a `MainScreen` with bottom navigation containing 4 tabs:
- Home (设备) - `home_screen.dart`
- Control (遥控) - `control_screen.dart`
- Bonding (羁绊) - `bonding_screen.dart`
- Settings (设置) - `settings_screen.dart`

Navigation uses `Navigator.pushNamed()` with routes:
- `/control` - Real-time control screen
- `/bonding` - Bonding center

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device_id>

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Run tests
flutter test

# Run single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Clean build cache
flutter clean
```

### Android-Specific

```bash
# Run on Android emulator
flutter run -d emulator-5554

# Build release APK
flutter build apk --release

# Build app bundle
flutter build appbundle
```

## Dependencies

Key packages in `pubspec.yaml`:

- `flutter_bluetooth_serial: ^0.4.0` - Bluetooth device communication
- `wifi_scan: ^0.4.1` - WiFi device discovery
- `permission_handler: ^11.1.0` - Runtime permissions
- `flutter_joystick: ^0.2.0` - Virtual joystick widget
- `percent_indicator: ^4.2.3` - Progress indicators for bonding system
- `flutter_animate: ^4.3.0` - Animation utilities
- `go_router: ^13.0.1` - Navigation routing
- `shared_preferences: ^2.2.2` - Local storage

## Development Notes

### State Management

Currently uses simple `StatefulWidget` with `setState()`. For future scaling, consider migrating to:
- Provider + ChangeNotifier for device state
- Riverpod or BLoC for complex state

### Adding New Device Modes

1. Add enum value to `DeviceMode` in `lib/models/device_model.dart`
2. Add display name and icon in the extension
3. Add UI handling in `home_screen.dart` `_buildModeOption()`

### Adding New Actions

1. Add `DogAction` to the list in `control_screen.dart`
2. Implement execution logic in `_executeAction()`
3. Add corresponding animation/feedback

### Platform Configuration

**Android** (`android/`):
- Gradle 8.7
- Android Gradle Plugin 8.2.1
- Kotlin 1.9.20
- Min SDK 21, Target SDK 34
- Java 17 compatibility

## Linting

Uses `flutter_lints` with relaxed const rules:
- `prefer_const_constructors: false`
- `prefer_const_literals_to_create_immutables: false`

Run `flutter analyze` to check for issues.
