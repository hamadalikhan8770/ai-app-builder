import 'package:flutter/material.dart';

class AccessTypeBadge extends StatelessWidget {
  const AccessTypeBadge({super.key, required this.accessType});
  final String accessType;
  @override
  Widget build(BuildContext context) {
    final color = switch (accessType) {
      'premium' => Colors.amber.shade800,
      'admin_only' => Colors.purple,
      _ => Colors.green,
    };
    return Chip(
      label: Text(accessType.replaceAll('_', ' ').toUpperCase()),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w800),
    );
  }
}
