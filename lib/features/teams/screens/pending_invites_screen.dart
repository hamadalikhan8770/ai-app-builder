import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/core/widgets/empty_state.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';
import 'package:my_first_app/features/teams/widgets/team_role_badge.dart';

class PendingInvitesScreen extends ConsumerWidget {
  const PendingInvitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invites = ref.watch(pendingTeamInvitesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Invites')),
      body: invites.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(pendingTeamInvitesProvider),
          child: items.isEmpty
              ? const EmptyState(
                  title: 'No pending invites',
                  message:
                      'Team invitations sent to your email will appear here.',
                  icon: Icons.mail_outline,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: items
                      .map(
                        (invite) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.mail),
                            title: Text(invite.email),
                            subtitle: Text(
                              'Expires ${invite.expiresAt.toLocal()}',
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                TeamRoleBadge(role: invite.role),
                                TextButton(
                                  onPressed: () => ref
                                      .read(
                                        teamActionControllerProvider.notifier,
                                      )
                                      .declineInvite(invite.token),
                                  child: const Text('Decline'),
                                ),
                                FilledButton(
                                  onPressed: () => ref
                                      .read(
                                        teamActionControllerProvider.notifier,
                                      )
                                      .acceptInvite(invite.token),
                                  child: const Text('Accept'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}
