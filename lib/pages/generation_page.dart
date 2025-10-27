import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/game_provider.dart';
import '../widgets/generation_filter.dart';
import '../widgets/primary_button.dart';
import 'game_page.dart';

class GenerationPage extends StatelessWidget {
  const GenerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Hero(
          tag: 'logo',
          child: Material(color: Colors.transparent, child: Text('Generation')),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GenerationFilter(
                    selected: gp.selectedGens,
                    onChanged: (s) => context.read<GameProvider>().setGens(s),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'PLAY',
                      onTap: () {
                        Navigator.of(
                          context,
                        ).push(slideFadeRoute(const GamePage()));
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'CLOSE',
                      filled: false,
                      onTap: () => Navigator.pop(context),
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
