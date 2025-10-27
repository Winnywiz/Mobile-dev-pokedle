import 'package:flutter/material.dart';

class GenerationFilter extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;
  const GenerationFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final gens = List<int>.generate(9, (i) => i + 1);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gens.length,
      itemBuilder: (_, i) {
        final g = gens[i];
        final checked = selected.contains(g);
        return CheckboxListTile(
          dense: true,
          title: Text('Generation $g'),
          value: checked,
          onChanged: (v) {
            final next = Set<int>.from(selected);
            (v ?? false) ? next.add(g) : next.remove(g);
            if (next.isEmpty) next.add(g);
            onChanged(next);
          },
        );
      },
    );
  }
}
