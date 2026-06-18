import 'package:flutter/material.dart';

class TemplateUsageTable extends StatelessWidget {
  const TemplateUsageTable({super.key, required this.rows});
  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty)
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('No template usage yet.'),
        ),
      );
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Template')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Success')),
            DataColumn(label: Text('Failed')),
          ],
          rows: rows
              .map(
                (row) => DataRow(
                  cells: [
                    DataCell(
                      Text(row['template_title']?.toString() ?? 'Unknown'),
                    ),
                    DataCell(Text(row['output_type']?.toString() ?? '-')),
                    DataCell(Text(row['generation_count']?.toString() ?? '0')),
                    DataCell(Text(row['success_count']?.toString() ?? '0')),
                    DataCell(Text(row['failure_count']?.toString() ?? '0')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
