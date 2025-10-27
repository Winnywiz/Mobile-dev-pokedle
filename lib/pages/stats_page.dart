import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});
  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final _store = StorageService();
  Map<String, int>? stats;

  @override
  void initState() {
    super.initState();
    _store.readStats().then((s) => setState(() => stats = s));
  }

  @override
  Widget build(BuildContext context) {
    final s = stats;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Stats')),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row('Daily Streak', s['streak']!.toString()),
                  _row('Total Guesses', s['totalPlays']!.toString()),
                  _row('Correct Guesses', s['correct']!.toString()),
                  _row('Accuracy', _pct(s['correct']!, s['totalPlays']!)),
                ],
              ),
            ),
    );
  }

  String _pct(int c, int t) =>
      t == 0 ? '—' : '${((c / t) * 100).toStringAsFixed(1)}%';

  Widget _row(String k, String v) => ListTile(
    title: Text(k, style: const TextStyle(fontWeight: FontWeight.w700)),
    trailing: Text(v),
  );
}
