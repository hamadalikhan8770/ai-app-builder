import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyUsageChart extends StatelessWidget {
  const DailyUsageChart({super.key, required this.rows});
  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty)
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('No daily reports yet.'),
        ),
      );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Usage',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            for (final row in rows.take(14))
              ListTile(
                dense: true,
                title: Text(_date(row['report_date'])),
                subtitle: Text(
                  'Active: ${row['active_users'] ?? 0} • AI: ${row['ai_generations'] ?? 0} • Exports: ${row['pdf_exports'] ?? 0}',
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _date(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    return date == null
        ? value?.toString() ?? '-'
        : DateFormat('MMM d, yyyy').format(date);
  }
}
