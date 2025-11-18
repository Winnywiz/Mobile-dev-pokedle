import 'package:flutter/material.dart';

typedef OnSubmit = void Function(String value);
typedef SuggestFn = List<String> Function(String query);

class GuessInput extends StatefulWidget {
  final SuggestFn suggest;
  final OnSubmit onSubmit;

  const GuessInput({
    super.key,
    required this.suggest,
    required this.onSubmit,
  });

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final query = value.text.trim();
        if (query.isEmpty) return const Iterable<String>.empty();
        return widget.suggest(query);
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Input Pokémon',
            hintText: 'Type a Pokémon name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onSubmitted: (_) => _submit(textEditingController, textEditingController.text),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () => onSelected(option),
                );
              }).toList(),
            ),
          ),
        );
      },
      onSelected: (String selected) {
      },
    );
  }

  void _submit(TextEditingController controller, String value) {
    final guess = value.trim();
    if (guess.isEmpty) return;
    widget.onSubmit(guess);
    controller.clear();
  }
}