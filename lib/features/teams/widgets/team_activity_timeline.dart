import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/features/teams/models/team_activity_log_model.dart';

class TeamActivityTimeline extends StatelessWidget {
  const TeamActivityTimeline({super.key, required this.logs});
  final List<TeamActivityLogModel> logs;
  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty)
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No team activity yet.'),
        ),
      );
    return Column(
      children: logs
          .map(
            (log) => Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(
                  log.action.replaceAll('_', ' '),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  DateFormat('MMM d, h:mm a').format(log.createdAt),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
