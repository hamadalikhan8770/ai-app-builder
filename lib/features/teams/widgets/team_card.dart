import 'package:flutter/material.dart';
import 'package:my_first_app/features/teams/models/team_model.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.team, required this.onTap});
  final TeamModel team;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(team.name.isEmpty ? 'T' : team.name[0].toUpperCase()),
      ),
      title: Text(
        team.name,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text(
        team.description?.isNotEmpty == true
            ? team.description!
            : 'Plan: ${team.planType}',
      ),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}
