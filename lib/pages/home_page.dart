import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/theme_controller.dart';
import '../widgets/primary_button.dart';
import 'generation_page.dart';
import 'stats_page.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.read<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Hero(
          tag: 'logoText',
          child: Material(color: Colors.transparent, child: Text('Pokedle')),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.color_lens),
            itemBuilder: (c) => const [
              PopupMenuItem(value: 'light', child: Text('Light (sky blue)')),
              PopupMenuItem(value: 'dark', child: Text('Dark (deep blue)')),
              PopupMenuItem(value: 'system', child: Text('Follow System')),
            ],
            onSelected: (v) {
              if (v == 'light') tc.setMode(AppThemeMode.light);
              if (v == 'dark') tc.setMode(AppThemeMode.dark);
              if (v == 'system') tc.setMode(AppThemeMode.system);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'logo',
                    child: Material(
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'PLAY',
                    onTap: () => Navigator.of(
                      context,
                    ).push(slideFadeRoute(const GenerationPage())),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'ABOUT',
                    filled: false,
                    onTap: () => Navigator.of(
                      context,
                    ).push(slideFadeRoute(const AboutPage())),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'PROFILE / STATS',
                    filled: false,
                    onTap: () => Navigator.of(
                      context,
                    ).push(slideFadeRoute(const StatsPage())),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
