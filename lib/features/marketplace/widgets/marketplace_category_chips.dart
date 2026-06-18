import 'package:flutter/material.dart';

class MarketplaceCategoryChips extends StatelessWidget {
  const MarketplaceCategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final String selected;
  final ValueChanged<String> onSelected;
  static const categories = [
    'all',
    'business',
    'ecommerce',
    'food_delivery',
    'booking',
    'education',
    'health',
    'fitness',
    'finance',
    'productivity',
    'social',
    'real_estate',
    'logistics',
    'ai_tools',
    'marketplace',
    'crm',
    'pos',
    'portfolio',
    'other',
  ];
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: categories
          .map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: selected == category,
                label: Text(category.replaceAll('_', ' ')),
                onSelected: (_) => onSelected(category),
              ),
            ),
          )
          .toList(),
    ),
  );
}
