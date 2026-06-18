import 'package:flutter/material.dart';

class InviteBanner extends StatelessWidget {
  const InviteBanner({super.key, required this.count, required this.onOpen});
  final int count;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        leading: const Icon(Icons.mail_outline),
        title: Text('$count pending team invite${count == 1 ? '' : 's'}'),
        trailing: FilledButton(onPressed: onOpen, child: const Text('Review')),
      ),
    );
  }
}
