import 'package:flutter/material.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});
  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool teamProject = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Project')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SwitchListTile(
          value: teamProject,
          onChanged: (v) => setState(() => teamProject = v),
          title: const Text('Create as team project'),
          subtitle: const Text(
            'Team projects use team_id and visibility=team.',
          ),
        ),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Project name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          minLines: 3,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {},
          child: const Text('Create Project Placeholder'),
        ),
      ],
    ),
  );
}
