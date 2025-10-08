import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';

/// App bar title widget with animated transitions
class VooAppBarTitle extends StatelessWidget {
  /// Selected navigation item
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig? config;

  const VooAppBarTitle({super.key, required this.item, this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Try to get custom title from builder
    final customTitle = config?.appBarTitleBuilder?.call(item.id);
    if (customTitle != null) {
      return customTitle;
    }

    return AnimatedSwitcher(
      duration: context.vooAnimation.durationNormal,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Text(
        item.label,
        key: ValueKey(item.id),
        style: theme.appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge,
      ),
    );
  }
}
