# Pokedle

A Flutter-based guessing game inspired by Wordle but with Pokémon! This app uses Provider for state management, dynamic theming, and local storage.

## 📱 Overview

Pokedle is a mobile game where players guess a Pokémon based on clues. The project includes a modular architecture with providers, repository services, theme management, and asset-based Pokémon data.

## 🚀 Features

* MultiProvider architecture
* Game logic handled by `GameProvider`
* Persistent theme mode using `ThemeController`
* Pokémon data loaded via `PokemonRepository`
* Local storage support via `StorageService`
* Light, Dark, and System theme modes
* JSON-based Pokémon dataset

## ▶️ Running the App

```
flutter pub get
flutter run
```

## 🧪 Testing

```
flutter test
```
