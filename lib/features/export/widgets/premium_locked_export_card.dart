import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/routing/route_names.dart';

class PremiumLockedExportCard extends StatelessWidget {
  const PremiumLockedExportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.workspace_premium_rounded, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              'Premium PDF Export',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'PDF export is available for Premium users. Upgrade to download and share generated app plans.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.pushNamed(RouteNames.upgrade),
              icon: const Icon(Icons.upgrade_rounded),
              label: const Text('Upgrade'),
            ),
          ],
        ),
      ),
    );
  }
}
