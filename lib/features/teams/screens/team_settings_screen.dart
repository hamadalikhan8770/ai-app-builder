import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';

class TeamSettingsScreen extends ConsumerWidget {
  const TeamSettingsScreen({super.key, required this.teamId});
  final String teamId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamByIdProvider(teamId));
    return Scaffold(
      appBar: AppBar(title: const Text('Team Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          team.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (t) => t == null
                ? const Text('Team not found')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(t.description ?? 'No description'),
                      const SizedBox(height: 24),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Leave team'),
                          subtitle: const Text(
                            'Owners must transfer ownership before leaving.',
                          ),
                          onTap: () async {
                            final user = ref.read(currentUserProvider);
                            if (user != null) {
                              await ref
                                  .read(teamActionControllerProvider.notifier)
                                  .removeMember(teamId, user.id);
                              if (context.mounted) context.go('/teams');
                            }
                          },
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.swap_horiz),
                          title: Text('Transfer ownership'),
                          subtitle: Text(
                            'Placeholder for ownership transfer flow.',
                          ),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Delete team'),
                          subtitle: Text(
                            'Placeholder; use Edge Function in production to soft-delete safely.',
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
