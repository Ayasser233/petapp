# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Aleefy**, a Flutter mobile application for pet care services (veterinary clinics, appointments, pet management, vaccination tracking). The app supports Arabic (RTL) and English languages with full localization.

- **Package**: `com.aleefy.petapp`
- **SDK**: Dart 3.4.1+, Flutter 3.22.1+
- **State Management**: Mix of GetX, Provider, and Bloc (migration in progress)
- **Architecture**: Clean Architecture for newer features (appointments, vaccination), traditional MVC for legacy features

## Build Commands

### Development
```bash
flutter clean                    # Clean build artifacts
flutter pub get                  # Install dependencies
flutter run                      # Run on connected device/emulator
flutter test                     # Run unit/widget tests
flutter analyze                  # Static code analysis
```

### Android APKs
```bash
# Development APK (uses dev API)
./build_dev_apk.sh

# Production APK (uses prod API)
./build_prod_apk.sh

# Build both flavors at once
./build_both_apks.sh
```

### iOS
```bash
# Build for iOS simulator
flutter build ios --simulator

# Build for physical device (requires code signing)
flutter build ios --release
```

### Build Flavors
The app uses product flavors to manage environments:
- **dev**: Uses `https://api-dev.aleefy-app.com/api/v1`, applicationId `com.aleefy.petapp.dev`
- **prod**: Uses `https://api.aleefy-app.com/api/v1`, applicationId `com.aleefy.petapp`

Build with specific flavor:
```bash
flutter build apk --release --flavor prod --dart-define=ENVIRONMENT=prod
flutter build apk --release --flavor dev --dart-define=ENVIRONMENT=dev
```

### App Icons
```bash
flutter pub run flutter_launcher_icons:main
```

## Architecture

### Dependency Injection
- Uses `get_it` service locator pattern (`lib/di/service_locator.dart`)
- All services, repositories, and use cases are registered in `setupServiceLocator()`
- Access with `sl<T>()` or `Get.find<T>()` for GetX-registered services

### Core Services ([lib/core/services/](lib/core/services/))
- **AuthService**: Authentication state management (authenticated/guest/unauthenticated)
- **ApiClient**: HTTP client wrapper with error handling and token injection
- **TokenService**: JWT token storage and refresh logic
- **ConnectivityService**: Network connectivity monitoring
- **LocationService**: GPS location and geocoding
- **NotificationService**: FCM push notifications
- **PointsService**: User loyalty points management
- **ImageCacheService**: Custom image caching

### Clean Architecture Pattern
Newer features (appointments, vaccination) follow clean architecture:
```
feature/
├── data/
│   ├── datasources/       # API/remote data sources
│   ├── models/            # DTOs for API responses
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business domain models
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic (one per action)
└── presentation/
    ├── cubit/             # State management (Bloc)
    ├── screens/           # UI screens
    └── widgets/           # Reusable widgets
```

When adding new features, follow this pattern for consistency.

### Legacy Features
Older features (pet, profile, vets) use GetX controllers directly with service layers. These are gradually being migrated.

## Key Integrations

### Firebase
- **FCM**: Push notifications ([`NotificationService`](lib/core/services/notification_service.dart))
- **Analytics**: Configured in `firebase_options.dart`
- Build configuration includes Google Services plugin

### Social Auth
- Google Sign-In: `google_sign_in` package
- Sign in with Apple: `sign_in_with_apple` package
- Facebook SDK: `facebook_app_events` for analytics

### 3D Models
The app includes 3D pet model viewers using `flutter_cube` package with custom rotation controls (90° increments only, no free movement). See [3D_MODEL_FIXED_ROTATION.md](.github/3D_MODEL_FIXED_ROTATION.md) for implementation details.

## Localization

- Full Arabic RTL support with custom numeral conversion
- Localizations in [lib/core/localization/app_localizations.dart](lib/core/localization/app_localizations.dart)
- Always test both LTR (English) and RTL (Arabic) layouts
- Font: Tajawal (Arabic font with multiple weights)

## Authentication Flow

1. **Splash**: Network connectivity check + Firebase init
2. **Onboarding**: First-time user intro slides
3. **Auth**: Login/Register with "Skip Login" option (guest mode)
4. **Home**: Main app with protected routes via [`AuthMiddleware`](lib/core/middleware/auth_middleware.dart)

Guest users can browse clinics but cannot:
- Add/manage pets
- Book appointments
- Access profile/vouchers

## API Configuration

All API endpoints defined in [`ApiConstants`](lib/core/utils/api_constants.dart). Environment is set via `--dart-define=ENVIRONMENT=<dev|prod>` at build time.

## Common Patterns

### Adding a New Feature Screen
1. Create feature folder under `lib/features/`
2. Follow clean architecture structure (see above)
3. Register dependencies in `service_locator.dart`
4. Add route in [`AppRoutes`](lib/core/utils/app_routes.dart)
5. Use Bloc Cubit for state management (preferred over GetX)

### Error Handling
All API errors flow through [`ErrorHandlerService`](lib/core/services/error_handler_service.dart) which handles:
- Network connectivity issues
- 401/403 auth errors (auto token refresh)
- 500 server errors
- Custom API error messages

### Navigation
- Uses GetX routing (`Get.to()`, `Get.off()`, `Get.toNamed()`)
- Routes defined centrally in [`AppRoutes.getPages`](lib/core/routes/routes.dart)
- Protected routes use [`authMiddleware`](lib/core/middleware/auth_middleware.dart)

## Testing

Test files located in [`test/`](test/) directory. Run with:
```bash
flutter test                    # All tests
flutter test test/widget_test.dart  # Specific file
```

## Android-Specific Notes

- Min SDK: 24 (Android 7.0+)
- Target SDK: 35
- Uses 16KB page size support for newer Android devices
- ProGuard enabled for release builds
- Bundle splits enabled for APK size optimization

## iOS-Specific Notes

- Deployment target: iOS 15.6+
- CocoaPods for dependency management
- Requires code signing for release builds
- Entitlements configured in `Runner.entitlements`

## Workflow

The app uses GitHub Actions for CI/CD (`.github/workflows/build.yml`) which:
- Runs tests on every push
- Builds debug/release APKs
- Can be triggered manually via workflow_dispatch
