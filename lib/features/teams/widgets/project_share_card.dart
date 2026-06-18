import 'package:flutter/material.dart';
import 'package:my_first_app/features/teams/models/project_share_model.dart';
import 'package:my_first_app/features/teams/widgets/permission_badge.dart';

class ProjectShareCard extends StatelessWidget {
  const ProjectShareCard({super.key, required this.share, this.onUnshare});
  final ProjectShareModel share;
  final VoidCallback? onUnshare;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.group_work_outlined),
      title: Text('Team ${share.teamId}'),
      subtitle: Text('Project ${share.projectId}'),
      trailing: Wrap(
        spacing: 8,
        children: [
          PermissionBadge(permission: share.permission),
          if (onUnshare != null)
            IconButton(onPressed: onUnshare, icon: const Icon(Icons.link_off)),
        ],
      ),
    ),
  );
}
