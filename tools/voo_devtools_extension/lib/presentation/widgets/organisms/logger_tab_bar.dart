import 'package:flutter/material.dart';

class LoggerTabBar extends StatelessWidget {
  final TabController tabController;

  const LoggerTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: TabBar(
        isScrollable: true,
        controller: tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: theme.colorScheme.primary,
        tabs: const [
          Tab(text: 'Logs', icon: Icon(Icons.list, size: 18)),
          Tab(text: 'Network', icon: Icon(Icons.cloud_outlined, size: 18)),
          Tab(text: 'Performance', icon: Icon(Icons.speed, size: 18)),
          Tab(text: 'Analytics', icon: Icon(Icons.analytics_outlined, size: 18)),
        ],
      ),
    );
  }
}
