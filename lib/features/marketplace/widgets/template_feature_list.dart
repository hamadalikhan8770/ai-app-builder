import 'package:flutter/material.dart';

class TemplateFeatureList extends StatelessWidget {
  const TemplateFeatureList({super.key, required this.features});
  final List<String> features;
  @override
  Widget build(BuildContext context) => Column(
    children: features
        .map(
          (feature) => ListTile(
            dense: true,
            leading: const Icon(Icons.check_circle_outline),
            title: Text(feature),
          ),
        )
        .toList(),
  );
}
