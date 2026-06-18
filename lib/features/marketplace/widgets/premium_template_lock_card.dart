import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/routing/route_names.dart';

class PremiumTemplateLockCard extends StatelessWidget {
  const PremiumTemplateLockCard({super.key});
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.amber.withValues(alpha: 0.12),
    child: ListTile(
      leading: const Icon(Icons.lock_outline),
      title: const Text('Premium template'),
      subtitle: const Text('Upgrade to Premium to use this template.'),
      trailing: FilledButton(
        onPressed: () => context.pushNamed(RouteNames.upgrade),
        child: const Text('Upgrade'),
      ),
    ),
  );
}
