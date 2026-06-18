import 'package:flutter/material.dart';

class PermissionBadge extends StatelessWidget {
  const PermissionBadge({super.key, required this.permission});
  final String permission;
  @override
  Widget build(BuildContext context) {
    final color = switch (permission) {
      'manage' => Colors.purple,
      'edit' => Colors.green,
      _ => Colors.grey,
    };
    return Chip(
      label: Text(permission.toUpperCase()),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w800),
    );
  }
}
