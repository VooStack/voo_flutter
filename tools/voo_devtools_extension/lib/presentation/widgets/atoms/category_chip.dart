import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Atomic component for displaying categories with consistent styling
class CategoryChip extends StatelessWidget {
  final String category;
  final Color? color;
  final bool compact;

  const CategoryChip({
    super.key,
    required this.category,
    this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? _getCategoryColor(category);

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(color: chipColor.withValues(alpha: 0.3), width: 1),
        ),
        child: Text(
          category,
          style: theme.textTheme.labelSmall?.copyWith(
            color: chipColor,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            chipColor.withValues(alpha: 0.1),
            chipColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: chipColor.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getCategoryIcon(category), size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            category,
            style: theme.textTheme.labelMedium?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'system':
        return Colors.blue;
      case 'network':
        return Colors.teal;
      case 'database':
        return Colors.deepPurple;
      case 'analytics':
        return Colors.indigo;
      case 'performance':
        return Colors.orange;
      case 'ui':
        return Colors.pink;
      case 'navigation':
        return Colors.green;
      case 'storage':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'system':
        return Icons.settings_outlined;
      case 'network':
        return Icons.wifi_outlined;
      case 'database':
        return Icons.storage_outlined;
      case 'analytics':
        return Icons.analytics_outlined;
      case 'performance':
        return Icons.speed_outlined;
      case 'ui':
        return Icons.palette_outlined;
      case 'navigation':
        return Icons.navigation_outlined;
      case 'storage':
        return Icons.folder_outlined;
      default:
        return Icons.label_outlined;
    }
  }
}
