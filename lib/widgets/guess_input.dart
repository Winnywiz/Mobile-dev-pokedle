import 'package:flutter/material.dart';

typedef OnSubmit = void Function(String value);
typedef SuggestFn = List<String> Function(String query);

class GuessInput extends StatefulWidget {
  final SuggestFn suggest;
  final OnSubmit onSubmit;
  const GuessInput({super.key, required this.suggest, required this.onSubmit});

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (t) => widget.suggest(t.text),
      fieldViewBuilder: (context, controller, focus, onFieldSubmitted) {
        return TextField(
          controller: _ctrl..text = controller.text,
          focusNode: focus,
          onSubmitted: (_) => _submit(),
          decoration: const InputDecoration(
            labelText: 'Input Pokemon',
            hintText: 'Type a Pokémon name',
          ),
        );
      },
      onSelected: (val) {
        _ctrl.text = val;
        _submit();
      },
    );
  }

  void _submit() {
    final v = _ctrl.text.trim();
    if (v.isNotEmpty) {
      widget.onSubmit(v);
      _ctrl.clear();
    }
  }
}
