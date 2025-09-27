import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for navigation rail
class VooRailDefaultHeader extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooRailDefaultHeader({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.lg,
        spacing.md,
        spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.vooSize.avatarSmall,
            height: context.vooSize.avatarSmall,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius.md),
            ),
            child: Icon(
              Icons.dashboard,
              color: theme.colorScheme.primary,
              size: context.vooSize.checkboxSize,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            _getTitle(),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    if (config.appBarTitle != null && config.appBarTitle is Text) {
      return ((config.appBarTitle! as Text).data ?? 'Navigation');
    }
    return 'Navigation';
  }
}
