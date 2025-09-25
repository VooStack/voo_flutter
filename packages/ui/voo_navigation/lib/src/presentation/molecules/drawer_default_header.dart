import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for the navigation drawer
class VooDrawerDefaultHeader extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerDefaultHeader({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    return Container(
      padding: EdgeInsets.fromLTRB(spacing.lg - spacing.xs, spacing.xxl, spacing.lg - spacing.xs, spacing.lg - spacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: context.vooSize.avatarMedium,
                height: context.vooSize.avatarMedium,
                decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(context.vooRadius.md)),
                child: Icon(Icons.dashboard, color: theme.colorScheme.onSurface, size: context.vooSize.checkboxSize + 2),
              ),
              SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (config.appBarTitle != null && config.appBarTitle is Text) ? ((config.appBarTitle! as Text).data ?? 'Navigation') : 'Navigation',
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600),
                    ),
                    if (config.drawerHeader == null) Text('Welcome back', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
