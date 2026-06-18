import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/features/teams/providers/team_providers.dart';

class InviteMemberScreen extends ConsumerStatefulWidget {
  const InviteMemberScreen({super.key, required this.teamId});
  final String teamId;
  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String _role = 'viewer';
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamActionControllerProvider);
    ref.listen(teamActionControllerProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          if (mounted && Navigator.of(context).canPop()) context.pop();
        },
        error: (e, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString()))),
      );
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Member')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _role,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: [
                'admin',
                'editor',
                'viewer',
              ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => _role = v ?? 'viewer'),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate())
                        ref
                            .read(teamActionControllerProvider.notifier)
                            .inviteMember(
                              widget.teamId,
                              _email.text.trim(),
                              _role,
                            );
                    },
              icon: const Icon(Icons.send),
              label: const Text('Send Invite'),
            ),
          ],
        ),
      ),
    );
  }
}
