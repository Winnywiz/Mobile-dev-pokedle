# Pokedle

A Flutter-based guessing game inspired by Wordle but with Pokémon! This app uses Provider for state management, dynamic theming, and local storage with shared preferences.

## 📱 Overview

Pokedle is a mobile game where players guess a Pokémon based on clues. The project includes a modular architecture with providers, repository services, theme management, and asset-based Pokémon data.

## 🚀 Features

* Supports Android and iOS platforms
* **Game Logic** - Handled by `GameProvider` for seamless gameplay
* **Persistent Theme** - Theme mode managed by `ThemeController` with local storage
* **Pokémon Data** - Loaded via `PokemonRepository` from JSON assets
* **Local Storage** - User preferences saved using `StorageService` and `shared_preferences`
* **Theme Modes** - Light, Dark, and System theme support
* **Asset Management** - JSON-based Pokémon dataset and image assets

## 📦 Dependencies

* `flutter` - SDK ^3.9.2
* `provider` (^6.1.5+1) - State management
* `shared_preferences` (^2.5.3) - Local data persistence
* `cupertino_icons` (^1.0.8) - iOS-style icons

## ▶️ Running the App
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🧪 Testing
```bash
flutter test
```

## 🛠️ Development

This project uses:
* Flutter Lints (^6.0.0) for code quality
* Material Design for UI components
* JSON asset loading for Pokémon data
