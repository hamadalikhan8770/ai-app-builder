import 'package:flutter/material.dart';

class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({super.key, required this.difficulty});
  final String difficulty;
  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      'advanced' => Colors.redAccent,
      'intermediate' => Colors.orange,
      _ => Colors.blue,
    };
    return Chip(
      label: Text(difficulty.toUpperCase()),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w800),
    );
  }
}
