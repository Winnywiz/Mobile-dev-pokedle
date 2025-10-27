import 'package:flutter/material.dart';

class FeedbackRow extends StatelessWidget {
  final Map<String, bool> status; // name/type/gen
  const FeedbackRow({super.key, required this.status});

  Color _box(bool ok, ColorScheme cs) =>
      ok ? cs.tertiaryContainer : cs.errorContainer;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: _tile('Name', _box(status['name'] ?? false, cs))),
        const SizedBox(width: 8),
        Expanded(child: _tile('Type', _box(status['type'] ?? false, cs))),
        const SizedBox(width: 8),
        Expanded(child: _tile('Gen', _box(status['gen'] ?? false, cs))),
      ],
    );
  }

  Widget _tile(String label, Color bg) => Container(
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}
