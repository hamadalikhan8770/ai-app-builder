import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';
import 'package:my_first_app/features/teams/widgets/team_activity_timeline.dart';
import 'package:my_first_app/routing/route_names.dart';

class TeamDetailScreen extends ConsumerWidget {
  const TeamDetailScreen({super.key, required this.teamId});
  final String teamId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamByIdProvider(teamId));
    final members = ref.watch(teamMembersProvider(teamId));
    final projects = ref.watch(sharedProjectsProvider(teamId));
    final activity = ref.watch(teamActivityProvider(teamId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Detail'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(
              RouteNames.teamSettings,
              pathParameters: {'id': teamId},
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(teamByIdProvider(teamId));
          ref.invalidate(teamMembersProvider(teamId));
          ref.invalidate(sharedProjectsProvider(teamId));
          ref.invalidate(teamActivityProvider(teamId));
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            team.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(message: e.toString()),
              data: (t) => t == null
                  ? const Text('Team not found')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(t.description ?? 'No description'),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () => context.pushNamed(
                                RouteNames.teamMembers,
                                pathParameters: {'id': teamId},
                              ),
                              icon: const Icon(Icons.people),
                              label: const Text('Members'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => context.pushNamed(
                                RouteNames.inviteMember,
                                pathParameters: {'id': teamId},
                              ),
                              icon: const Icon(Icons.person_add),
                              label: const Text('Invite'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            members.when(
              data: (m) => Text(
                '${m.length} member${m.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
            const SizedBox(height: 20),
            Text(
              'Shared Projects',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            projects.when(
              data: (p) => p.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No team projects yet.'),
                      ),
                    )
                  : Column(
                      children: p
                          .map(
                            (project) => Card(
                              child: ListTile(
                                leading: const Icon(Icons.folder),
                                title: Text(project.name),
                                subtitle: Text(project.visibility),
                              ),
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
            const SizedBox(height: 20),
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            activity.when(
              data: (logs) => TeamActivityTimeline(logs: logs),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
          ],
        ),
      ),
    );
  }
}
