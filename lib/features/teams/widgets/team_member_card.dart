import 'package:flutter/material.dart';
import 'package:my_first_app/features/teams/models/team_member_model.dart';
import 'package:my_first_app/features/teams/widgets/team_role_badge.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    this.onChangeRole,
    this.onRemove,
  });
  final TeamMemberModel member;
  final VoidCallback? onChangeRole;
  final VoidCallback? onRemove;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(
        member.fullName ?? member.email ?? member.userId,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text('Status: ${member.status}'),
      trailing: Wrap(
        spacing: 8,
        children: [
          TeamRoleBadge(role: member.role),
          if (onChangeRole != null)
            IconButton(
              onPressed: onChangeRole,
              icon: const Icon(Icons.manage_accounts),
            ),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline),
            ),
        ],
      ),
    ),
  );
}
