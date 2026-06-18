import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/features/marketplace/providers/marketplace_providers.dart';

class MarketplaceReviewScreen extends ConsumerStatefulWidget {
  const MarketplaceReviewScreen({super.key, required this.templateId});
  final String templateId;
  @override
  ConsumerState<MarketplaceReviewScreen> createState() =>
      _MarketplaceReviewScreenState();
}

class _MarketplaceReviewScreenState
    extends ConsumerState<MarketplaceReviewScreen> {
  int rating = 5;
  final text = TextEditingController();
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceActionControllerProvider);
    ref.listen(marketplaceActionControllerProvider, (_, next) {
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
      appBar: AppBar(title: const Text('Write Review')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Rating', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => rating = i),
                  icon: Icon(
                    i <= rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: text,
            decoration: const InputDecoration(
              labelText: 'Review',
              border: OutlineInputBorder(),
            ),
            minLines: 4,
            maxLines: 6,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: state.isLoading
                ? null
                : () => ref
                      .read(marketplaceActionControllerProvider.notifier)
                      .submitReview(
                        widget.templateId,
                        rating,
                        text.text.trim(),
                      ),
            icon: const Icon(Icons.send),
            label: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
