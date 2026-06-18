import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/core/widgets/empty_state.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';

class ShareProjectScreen extends ConsumerStatefulWidget {
  const ShareProjectScreen({super.key, required this.projectId});
  final String projectId;
  @override
  ConsumerState<ShareProjectScreen> createState() => _ShareProjectScreenState();
}

class _ShareProjectScreenState extends ConsumerState<ShareProjectScreen> {
  String? _teamId;
  String _permission = 'view';
  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(myTeamsProvider);
    final state = ref.watch(teamActionControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Share Project')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          teams.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (items) {
              if (items.isEmpty)
                return const EmptyState(
                  title: 'No teams',
                  message: 'Create a team before sharing projects.',
                  icon: Icons.groups,
                );
              _teamId ??= items.first.id;
              return Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _teamId,
                    decoration: const InputDecoration(
                      labelText: 'Team',
                      border: OutlineInputBorder(),
                    ),
                    items: items
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _teamId = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _permission,
                    decoration: const InputDecoration(
                      labelText: 'Permission',
                      border: OutlineInputBorder(),
                    ),
                    items: ['view', 'edit', 'manage']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) => setState(() => _permission = v ?? 'view'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.isLoading || _teamId == null
                        ? null
                        : () => ref
                              .read(teamActionControllerProvider.notifier)
                              .shareProject(
                                widget.projectId,
                                _teamId!,
                                _permission,
                              ),
                    icon: const Icon(Icons.share),
                    label: const Text('Share with Team'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Existing shares will appear after Supabase project_shares is connected.',
          ),
        ],
      ),
    );
  }
}
