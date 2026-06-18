import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/features/analytics/models/analytics_event_model.dart';

class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({super.key, required this.events});
  final List<AnalyticsEventModel> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('No recent activity yet.'),
        ),
      );
    }
    return Column(
      children: events.map((event) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const Icon(Icons.timeline_rounded),
            title: Text(
              event.eventName.replaceAll('_', ' '),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              '${event.eventCategory} • ${DateFormat('MMM d, h:mm a').format(event.createdAt)}',
            ),
          ),
        );
      }).toList(),
    );
  }
}
