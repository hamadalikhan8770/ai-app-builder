import 'package:flutter/material.dart';

class TeamRoleBadge extends StatelessWidget {
  const TeamRoleBadge({super.key, required this.role});
  final String role;
  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      'owner' => Colors.purple,
      'admin' => Colors.blue,
      'editor' => Colors.green,
      _ => Colors.grey,
    };
    return Chip(
      label: Text(role.toUpperCase()),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w800),
    );
  }
}
