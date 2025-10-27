import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonTableHeader extends StatelessWidget {
  const PokemonTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(
      context,
    ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w800);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _head('Pokémon', s, flex: 2),
          _head('Type 1', s),
          _head('Type 2', s),
          _head('Evo.\nStage', s),
          _head('Fully\nEvo.', s),
          _head('Gen.', s),
        ],
      ),
    );
  }

  Widget _head(String t, TextStyle s, {int flex = 1}) => Expanded(
    flex: flex,
    child: Center(
      child: Text(t, textAlign: TextAlign.center, style: s),
    ),
  );
}

/// A single stacked row for one guessed Pokémon
class PokemonTableRow extends StatelessWidget {
  final Pokemon p;

  /// status map: {'gen': bool, 'stage': bool, 'fully': bool, 'name': bool}
  /// (type correctness is computed here from [targetTypes] so we can show
  /// green/yellow/red per column)
  final Map<String, bool> status;

  /// Target Pokémon's types (e.g., ['Fire'] or ['Water','Flying'])
  final List<String> targetTypes;

  const PokemonTableRow({
    super.key,
    required this.p,
    required this.status,
    required this.targetTypes,
  });

  // Evo helpers (based on JSON: evolution.prev / evolution.next)
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

  static bool fullyEvolved(Map<String, dynamic>? evo) {
    if (evo == null) return true;
    final nextList = evo['next'];
    final hasNext = nextList is List && nextList.isNotEmpty;
    return !hasNext;
  }

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 80;
    const double imageSize = 44;

    final cs = Theme.of(context).colorScheme;

    // Choose explicit colors so semantics are clear:
    final Color correctColor = Colors.green.shade300;
    final Color misplacedColor =
        Colors.amber.shade300; // "included but wrong place"
    final Color wrongColor = Colors.red.shade300;

    // Normalize types
    final guessedT1 = p.type.isNotEmpty ? p.type[0] : 'None';
    final guessedT2 = p.type.length > 1 ? p.type[1] : 'None';
    final tgt = targetTypes.map((e) => e.toLowerCase()).toList(growable: false);
    final g1 = guessedT1.toLowerCase();
    final g2 = guessedT2.toLowerCase();

    // Determine match state for each type column
    Color type1Bg = wrongColor;
    Color type2Bg = wrongColor;

    if (guessedT1 != 'None') {
      final posOk = tgt.isNotEmpty && g1 == tgt[0];
      final inSet = tgt.contains(g1);
      type1Bg = posOk ? correctColor : (inSet ? misplacedColor : wrongColor);
    }

    if (guessedT2 != 'None') {
      final posOk = tgt.length > 1 && g2 == tgt.elementAt(1);
      final inSet = tgt.contains(g2);
      type2Bg = posOk ? correctColor : (inSet ? misplacedColor : wrongColor);
    }

    // Stage / Fully / Gen colors (green=match, red=mismatch as before)
    final stage = stageOf(p.evolution);
    final fully = fullyEvolved(p.evolution);

    Color okColor(bool v) => v ? correctColor : wrongColor;

    Widget pill(String text, Color bg, {int flex = 1}) => Expanded(
      flex: flex,
      child: Container(
        height: rowHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pokémon column: image on top, name below (centered), narrower width
          Expanded(
            flex: 2,
            child: Container(
              height: rowHeight,
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (p.imageAsset != null && p.imageAsset!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        p.imageAsset!,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),
          // Type 1 with green/yellow/red
          pill(guessedT1, type1Bg),

          const SizedBox(width: 8),
          // Type 2 with green/yellow/red
          pill(guessedT2, type2Bg),

          const SizedBox(width: 8),
          // Stage: green if same stage as target, else red
          pill('$stage', okColor(status['stage'] ?? false)),

          const SizedBox(width: 8),
          // Fully evolved: green if same as target, else red
          pill(fully ? 'Yes' : 'No', okColor(status['fully'] ?? false)),

          const SizedBox(width: 8),
          // Gen: green if same as target, else red
          pill('${p.generation}', okColor(status['gen'] ?? false)),
        ],
      ),
    );
  }
}
