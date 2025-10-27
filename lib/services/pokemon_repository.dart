import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/pokemon.dart';

class PokemonRepository {
  List<Pokemon>? _cache;

  Future<List<Pokemon>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/pokedex.json');
    final List data = jsonDecode(raw);
    _cache = data.map((e) => Pokemon.fromJson(e)).toList();
    return _cache!;
  }
}
