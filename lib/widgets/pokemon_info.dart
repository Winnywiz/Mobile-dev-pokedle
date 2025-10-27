import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonInfo extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonInfo({super.key, required this.pokemon});

  // Stage rules:
  // - no prev + has next  -> Stage 1
  // - has prev + has next -> Stage 2
  // - has prev + no next  -> Stage 3
  // - neither prev nor next (single-form lines/legendaries) -> Stage 1
  static int stageOf(Map<String, dynamic>? evo) {
    if (evo == null) return 1;
    final hasPrev = evo['prev'] != null;
    final nextList = evo['next'];
    final hasNext = nextList is List && nextList.isNotEmpty;
    if (!hasPrev && hasNext) return 1;
    if (hasPrev && hasNext) return 2;
    if (hasPrev && !hasNext) return 3;
    return 1;
  }

  // Fully evolved == no "next" evolutions in the evo map
  static bool fullyEvolved(Map<String, dynamic>? evo) {
    if (evo == null) return true;
    final nextList = evo['next'];
    final hasNext = nextList is List && nextList.isNotEmpty;
    return !hasNext;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = pokemon.imageAsset; // we stored a URL in imageAsset
    final type1 = pokemon.type.isNotEmpty ? pokemon.type[0] : 'None';
    final type2 = pokemon.type.length > 1 ? pokemon.type[1] : 'None';
    final stage = stageOf(pokemon.evolution);
    final fully = fullyEvolved(pokemon.evolution);

    final headerStyle = Theme.of(
      context,
    ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w800);
    final cellStyle = Theme.of(context).textTheme.bodyMedium;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _head('Pokémon', headerStyle, flex: 3),
                _head('Type 1', headerStyle),
                _head('Type 2', headerStyle),
                _head('Evolution Stage', headerStyle),
                _head('Fully Evolved', headerStyle),
                _head('Gen', headerStyle),
              ],
            ),
            const Divider(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Flexible(child: Text(pokemon.name, style: cellStyle)),
                    ],
                  ),
                ),
                _cell(type1, cellStyle),
                _cell(type2, cellStyle),
                _cell('$stage', cellStyle),
                _cell(fully ? 'Yes' : 'No', cellStyle),
                _cell('${pokemon.generation}', cellStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _head(String t, TextStyle s, {int flex = 1}) => Expanded(
    flex: flex,
    child: Text(t, style: s),
  );
  Widget _cell(String t, TextStyle? s, {int flex = 1}) => Expanded(
    flex: flex,
    child: Text(t, style: s),
  );
}
