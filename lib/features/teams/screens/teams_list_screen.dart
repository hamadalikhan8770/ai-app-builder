import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/empty_state.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';
import 'package:my_first_app/features/teams/widgets/invite_banner.dart';
import 'package:my_first_app/features/teams/widgets/team_card.dart';
import 'package:my_first_app/routing/route_names.dart';

class TeamsListScreen extends ConsumerWidget {
  const TeamsListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(myTeamsProvider);
    final invites = ref.watch(pendingTeamInvitesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.pendingInvites),
            icon: const Icon(Icons.mail_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.createTeam),
        icon: const Icon(Icons.add),
        label: const Text('Create Team'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myTeamsProvider);
          ref.invalidate(pendingTeamInvitesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            invites.when(
              data: (v) => InviteBanner(
                count: v.length,
                onOpen: () => context.pushNamed(RouteNames.pendingInvites),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            teams.when(
              loading: () => const LoadingView(message: 'Loading teams...'),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(myTeamsProvider),
              ),
              data: (items) => items.isEmpty
                  ? const EmptyState(
                      title: 'No teams yet',
                      message:
                          'Create a workspace to collaborate on app projects.',
                      icon: Icons.groups_outlined,
                    )
                  : Column(
                      children: items
                          .map(
                            (team) => TeamCard(
                              team: team,
                              onTap: () => context.pushNamed(
                                RouteNames.teamDetail,
                                pathParameters: {'id': team.id},
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
