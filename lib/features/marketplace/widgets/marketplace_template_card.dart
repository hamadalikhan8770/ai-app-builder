import 'package:flutter/material.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_template_model.dart';
import 'package:my_first_app/features/marketplace/widgets/access_type_badge.dart';
import 'package:my_first_app/features/marketplace/widgets/difficulty_badge.dart';
import 'package:my_first_app/features/marketplace/widgets/rating_stars.dart';

class MarketplaceTemplateCard extends StatelessWidget {
  const MarketplaceTemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });
  final MarketplaceTemplateModel template;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(
                    template.isPremium ? Icons.workspace_premium : Icons.apps,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    template.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              template.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                AccessTypeBadge(accessType: template.accessType),
                DifficultyBadge(difficulty: template.difficulty),
                if (template.isFeatured)
                  const Chip(
                    label: Text('FEATURED'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            RatingStars(
              rating: template.ratingAverage,
              count: template.ratingCount,
            ),
            const SizedBox(height: 6),
            Text(
              '${template.usageCount} uses | ${template.recommendedStack}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}
