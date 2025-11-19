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

class PokemonTableRow extends StatelessWidget {
  final Pokemon p;
  final Map<String, bool> status;

  /// Target Pokémon’s types (e.g. ["Water"], ["Rock","Ground"])
  final List<String> targetTypes;

  const PokemonTableRow({
    super.key,
    required this.p,
    required this.status,
    required this.targetTypes,
  });

  // Evolution helpers
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

    final Color correctColor = Colors.green.shade300;
    final Color misplacedColor = Colors.yellow.shade300;
    final Color wrongColor = Colors.red.shade300;

    // Guess types & whether they exist
    final hasGuessT1 = p.type.isNotEmpty;
    final hasGuessT2 = p.type.length > 1;
    final guessedT1 = hasGuessT1 ? p.type[0] : 'None';
    final guessedT2 = hasGuessT2 ? p.type[1] : 'None';

    // Target types & whether it has type2
    final tgt = targetTypes.map((e) => e.toLowerCase()).toList();
    final hasTargetT1 = tgt.isNotEmpty;
    final hasTargetT2 = tgt.length > 1;

    final g1 = guessedT1.toLowerCase();
    final g2 = guessedT2.toLowerCase();

    // ---- TYPE 1 COLOR ----
    Color type1Bg = wrongColor;
    if (!hasGuessT1 && !hasTargetT1) {
      // basically never happens, but for completeness
      type1Bg = correctColor;
    } else if (hasGuessT1 && hasTargetT1) {
      final posOk = g1 == tgt[0];
      final inSet = tgt.contains(g1);
      type1Bg = posOk ? correctColor : (inSet ? misplacedColor : wrongColor);
    } else {
      // one has type1, the other doesn't
      type1Bg = wrongColor;
    }

    // ---- TYPE 2 COLOR ----
    Color type2Bg = wrongColor;

    if (!hasGuessT2 && !hasTargetT2) {
      // Target and guess are both single-type (e.g. Water / None)
      type2Bg = correctColor;
    } else if (hasGuessT2 && !hasTargetT2) {
      // Guess has extra second type, target does not
      type2Bg = wrongColor;
    } else if (!hasGuessT2 && hasTargetT2) {
      // Target has second type, guess doesn't
      type2Bg = wrongColor;
    } else {
      // Both have a real Type 2
      final posOk = g2 == tgt[1];
      final inSet = tgt.contains(g2);
      type2Bg = posOk ? correctColor : (inSet ? misplacedColor : wrongColor);
    }

    // Stage / Fully / Gen colors
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
        children: [
          // Pokémon column: image on top, name below
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
          pill(guessedT1, type1Bg),

          const SizedBox(width: 8),
          pill(guessedT2, type2Bg),

          const SizedBox(width: 8),
          pill('$stage', okColor(status['stage'] ?? false)),

          const SizedBox(width: 8),
          pill(fully ? 'Yes' : 'No', okColor(status['fully'] ?? false)),

          const SizedBox(width: 8),
          pill('${p.generation}', okColor(status['gen'] ?? false)),
        ],
      ),
    );
  }
}
