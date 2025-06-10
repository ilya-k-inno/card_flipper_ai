# Pixel Flip - Memory Card Game

An engaging and visually appealing memory card game built with Flutter. Test your memory by matching pairs of cards with dynamic images.

## Features

- 🎮 Multiple difficulty levels
- 🖼️ Dynamic card images
- 🌍 Multi-language support
- ⚡ Smooth animations and transitions
- 📱 Responsive design for mobile and tablet
- 🎨 Material Design 3 theming
- 🔄 Game state persistence
- 📊 Score tracking

## Project Structure

```
lib/
├── generated/       # Auto-generated localization files
├── l10n/            # Localization resources
├── main.dart        # Application entry point
└── src/
    ├── core/         # Core functionality and utilities
    │   ├── constants/
    │   ├── errors/
    │   ├── services/
    │   ├── theme/
    │   └── utils/
    └── features/      # Feature modules
        ├── game/      # Game logic and UI
        └── settings/  # App settings and preferences
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/card_flipper_ai.git
   cd card_flipper_ai
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle
```

### iOS
```bash
flutter build ios --release
```

## Dependencies

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Localization**: intl, flutter_localizations
- **Networking**: http
- **Persistence**: shared_preferences
- **Connectivity**: connectivity_plus
- **Utilities**: dartz, intl_utils
