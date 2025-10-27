import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import '../services/pokemon_repository.dart';
import '../services/storage_service.dart';

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class GameProvider with ChangeNotifier {
  final PokemonRepository repo;
  final StorageService storage;

  GameProvider({required this.repo, required this.storage});
  
  List<Pokemon> _all = [];
  Set<int> selectedGens = {1, 2, 3, 4, 5, 6, 7, 8, 9};

  Pokemon? target;
  bool isLoading = false;
  final List<String> guesses = [];
  bool get victory =>
      target != null && guesses.isNotEmpty && _isCorrect(guesses.last);
  int get totalGuesses => guesses.length;

  Pokemon? findByName(String name) {
    final q = name.trim().toLowerCase();
    return pool.where((p) => p.name.toLowerCase() == q).firstOrNull;
  }
  
  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    _all = await repo.loadAll();
    _newTarget();
    isLoading = false;
    notifyListeners();
  }

  List<Pokemon> get pool =>
      _all.where((p) => selectedGens.contains(p.generation)).toList();

  void setGens(Set<int> gens) {
    selectedGens = gens;
    _newTarget();
    notifyListeners();
  }

  void _newTarget() {
    if (pool.isEmpty) {
      target = null;
      return;
    }
    target = pool[Random().nextInt(pool.length)];
    guesses.clear();
  }

  List<String> suggestions(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return pool
        .where((p) => p.name.toLowerCase().contains(q))
        .map((p) => p.name)
        .take(10)
        .toList();
  }

  Future<void> submitGuess(String name) async {
    if (target == null) return;
    final norm = name.trim();
    if (norm.isEmpty || guesses.contains(norm)) return;
    guesses.add(norm);
    if (_isCorrect(norm)) {
      await storage.bumpPlay(correct: true);
    } else {
      await storage.bumpPlay(correct: false);
    }
    notifyListeners();
  }

  bool _isCorrect(String name) =>
      target!.name.toLowerCase() == name.toLowerCase();

    Map<String, bool> feedbackFor(String name) {
    final guess = pool.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Pokemon(
        id: -1,
        name: name,
        type: const [],
        base: const {},
        generation: 0,
        evolution: null,
      ),
    );
    if (target == null || guess.id == -1) {
      return {
        'name': false,
        'type': false,
        'gen': false,
        'stage': false,
        'fully': false,
      };
    }

    bool typeOk() {
      final g = guess.type.toSet(), t = target!.type.toSet();
      return g.intersection(t).isNotEmpty;
    }

    int stageOf(Map<String, dynamic>? evo) {
      if (evo == null) return 1;
      final hasPrev = evo['prev'] != null;
      final nextList = evo['next'];
      final hasNext = nextList is List && nextList.isNotEmpty;
      if (!hasPrev && hasNext) return 1;
      if (hasPrev && hasNext) return 2;
      if (hasPrev && !hasNext) return 3;
      return 1;
    }

    bool fullyEvolved(Map<String, dynamic>? evo) {
      if (evo == null) return true;
      final nextList = evo['next'];
      final hasNext = nextList is List && nextList.isNotEmpty;
      return !hasNext;
    }

    return {
      'name': _isCorrect(name),
      'type': typeOk(),
      'gen': guess.generation == target!.generation,
      'stage': stageOf(guess.evolution) == stageOf(target!.evolution),
      'fully': fullyEvolved(guess.evolution) == fullyEvolved(target!.evolution),
    };
  }


  void replay() {
    _newTarget();
    notifyListeners();
  }
}
