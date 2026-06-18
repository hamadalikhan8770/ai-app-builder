import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/routing/route_names.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final String projectId;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Project Detail'),
      actions: [
        IconButton(
          onPressed: () => context.pushNamed(
            RouteNames.shareProject,
            pathParameters: {'id': projectId},
          ),
          icon: const Icon(Icons.ios_share),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Project $projectId',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.visibility),
            title: Text('Visibility'),
            subtitle: Text('private/team based on app_projects.visibility'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.groups),
            title: Text('Collaborators'),
            subtitle: Text(
              'Team access is enforced by Supabase RLS and Edge Functions.',
            ),
          ),
        ),
      ],
    ),
  );
}
