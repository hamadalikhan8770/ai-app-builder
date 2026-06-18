import 'package:flutter/material.dart';

class AdminMarketplaceReviewsScreen extends StatelessWidget {
  const AdminMarketplaceReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Marketplace Reviews')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin marketplace tool'),
            subtitle: Text(
              'Use Supabase admin functions to create, edit, publish, and moderate marketplace templates.',
            ),
          ),
        ),
      ],
    ),
  );
}
