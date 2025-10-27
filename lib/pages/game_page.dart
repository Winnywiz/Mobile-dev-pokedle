import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../widgets/guess_input.dart';
import '../widgets/primary_button.dart';
import '../widgets/pokemon_table.dart';
import '../models/pokemon.dart';
import 'home_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    // Load data and pick a target when entering the page
    Future.microtask(() => context.read<GameProvider>().init());
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokedle')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: gp.isLoading || gp.target == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Logo ---
                        Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            height:
                                100, // adjust size as you like (80–120 works nicely)
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // --- Input directly under the logo ---
                        GuessInput(
                          suggest: gp.suggestions,
                          onSubmit: gp.submitGuess,
                        ),

                        const SizedBox(height: 12),

                        // --- Details card for most recent VALID guess ---
                        Builder(
                          builder: (context) {
                            Pokemon? last;
                            for (final g in gp.guesses.reversed) {
                              final p = gp.findByName(g);
                              if (p != null) {
                                last = p;
                                break;
                              }
                            }
                            if (last == null) return const SizedBox.shrink();
                            // Show the same “row” style as table header/rows but only for the latest item?
                            // We keep the table as the stacked list below, so here we just skip a card.
                            return const SizedBox.shrink();
                          },
                        ),

                        // --- Header (only when there is at least one valid guess) ---
                        if (gp.guesses.any(
                          (g) => gp.findByName(g) != null,
                        )) ...[
                          const SizedBox(height: 8),
                          const PokemonTableHeader(),
                          const SizedBox(height: 4),
                        ],

                        // --- Stacked table of all guesses ---
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOut,
                            child: ListView.builder(
                              key: ValueKey<int>(gp.guesses.length),
                              itemCount: gp.guesses.length,
                              itemBuilder: (context, i) {
                                final guessName = gp.guesses[i];
                                final p = gp.findByName(guessName);
                                if (p == null) return const SizedBox.shrink();

                                final status = gp.feedbackFor(guessName);

                                return TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 220),
                                  tween: Tween(begin: 0.95, end: 1),
                                  curve: Curves.easeOutBack,
                                  builder: (_, s, child) =>
                                      Transform.scale(scale: s, child: child),
                                  child: PokemonTableRow(
                                    p: p,
                                    status: status,
                                    targetTypes: gp.target?.type ?? const [],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // --- Victory banner ---
                        if (gp.victory) _victoryCard(context, gp),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _victoryCard(BuildContext context, GameProvider gp) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      child: Card(
        key: ValueKey('victory-${gp.target?.id}-${gp.totalGuesses}'),
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text(
                'VICTORY!',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text('You guessed: ${gp.target!.name}'),
              Text('Guesses: ${gp.totalGuesses}'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(label: 'REPLAY', onTap: gp.replay),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      label: 'HOME',
                      filled: false,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (_) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
