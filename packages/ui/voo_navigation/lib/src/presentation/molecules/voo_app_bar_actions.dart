import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';

/// App bar actions widget that handles notifications, search, and more options
class VooAppBarActions extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig? config;

  /// Screen width for responsive behavior
  final double screenWidth;

  const VooAppBarActions({super.key, this.config, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final actions = _buildActionsList(context);

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(mainAxisSize: MainAxisSize.min, children: actions);
  }

  List<Widget> _buildActionsList(BuildContext context) {
    final theme = Theme.of(context);
    final actions = <Widget>[];

    // Add custom actions from config
    if (config?.appBarActions != null) {
      actions.addAll(config!.appBarActions!);
    }

    // Add notification bell if there are any badges
    if (config?.showNotificationBadges ?? false) {
      final totalBadgeCount = config?.items
          .where((item) => item.badgeCount != null)
          .fold<int>(0, (sum, item) => sum + item.badgeCount!);

      if (totalBadgeCount != null && totalBadgeCount > 0) {
        actions.add(
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Handle notification tap
                  if (config?.enableHapticFeedback ?? true) {
                    HapticFeedback.lightImpact();
                  }
                },
                tooltip: 'Notifications',
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(context.vooSpacing.xxs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      totalBadgeCount > 99 ? '99+' : totalBadgeCount.toString(),
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: theme.colorScheme.onError,
                        fontSize: context.vooTypography.bodySmall.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    // Add search action if configured
    if (actions.isEmpty && screenWidth > 600) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Handle search
            if (config?.enableHapticFeedback ?? true) {
              HapticFeedback.lightImpact();
            }
          },
          tooltip: 'Search',
        ),
      );
    }

    // Add more options menu
    if (actions.isNotEmpty) {
      actions.add(
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (config?.enableHapticFeedback ?? true) {
              HapticFeedback.lightImpact();
            }
            // Handle menu item selection
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help & Feedback'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
    }

    return actions;
  }
}
