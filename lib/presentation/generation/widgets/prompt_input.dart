import 'package:flutter/material.dart';

class PromptInput extends StatelessWidget {
  const PromptInput({
    super.key,
    required this.controller,
    required this.enabled,
    this.onChanged,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      enabled: enabled,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Prompt',
        hintText: 'Describe the image you want to generate',
        border: OutlineInputBorder(),
      ),
    );
  }
}
