import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';
import 'package:my_first_app/features/teams/widgets/team_member_card.dart';
import 'package:my_first_app/routing/route_names.dart';

class TeamMembersScreen extends ConsumerWidget {
  const TeamMembersScreen({super.key, required this.teamId});
  final String teamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(teamMembersProvider(teamId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(
              RouteNames.inviteMember,
              pathParameters: {'id': teamId},
            ),
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: members.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(teamMembersProvider(teamId)),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: items
                .map(
                  (member) => TeamMemberCard(
                    member: member,
                    onChangeRole: () =>
                        _changeRole(context, ref, member.userId),
                    onRemove: () => _remove(context, ref, member.userId),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _changeRole(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Change role'),
        children: ['admin', 'editor', 'viewer']
            .map(
              (role) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, role),
                child: Text(role),
              ),
            )
            .toList(),
      ),
    );
    if (selectedRole != null) {
      await ref
          .read(teamActionControllerProvider.notifier)
          .updateMemberRole(teamId, userId, selectedRole);
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(teamActionControllerProvider.notifier)
          .removeMember(teamId, userId);
    }
  }
}
