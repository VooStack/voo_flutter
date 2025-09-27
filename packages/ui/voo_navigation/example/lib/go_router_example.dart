import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const VooNavigationGoRouterApp());
}

class VooNavigationGoRouterApp extends StatelessWidget {
  const VooNavigationGoRouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create navigation using the builder pattern
    final navigationBuilder = VooNavigationBuilder.materialYou(
      context: context,
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    )
      ..selectedId('dashboard')
      ..enableAnimations(true)
      ..animationDuration(const Duration(milliseconds: 350))
      ..animationCurve(Curves.easeInOutCubicEmphasized)
      ..railLabelType(NavigationRailLabelType.selected)
      ..useExtendedRail(true)
      ..showNavigationRailDivider(true)
      ..centerAppBarTitle(false)
      ..enableHapticFeedback(true)
      ..showNotificationBadges(true)
      ..persistNavigationState(true)
      ..elevation(0)
      ..indicatorShape(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ));

    // Add navigation items
    navigationBuilder
      ..addItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        route: '/dashboard',
        tooltip: 'View your dashboard',
        badgeCount: 3,
      )
      ..addItem(
        id: 'analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        route: '/analytics',
        tooltip: 'View analytics',
        showDot: true,
        badgeColor: Colors.green,
      )
      ..addItem(
        id: 'projects',
        label: 'Projects',
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder,
        route: '/projects',
        tooltip: 'Manage projects',
        badgeText: 'NEW',
        badgeColor: Colors.orange,
      )
      ..addSection(
        label: 'Communication',
        id: 'communication',
        isExpanded: true,
        children: [
          VooNavigationItem(
            id: 'messages',
            label: 'Messages',
            icon: Icons.message_outlined,
            selectedIcon: Icons.message,
            route: '/messages',
            badgeCount: 12,
          ),
          VooNavigationItem(
            id: 'notifications',
            label: 'Notifications',
            icon: Icons.notifications_outlined,
            selectedIcon: Icons.notifications,
            route: '/notifications',
            badgeCount: 5,
          ),
          VooNavigationItem(
            id: 'email',
            label: 'Email',
            icon: Icons.email_outlined,
            selectedIcon: Icons.email,
            route: '/email',
            showDot: true,
          ),
        ],
      )
      ..addDivider()
      ..addItem(
        id: 'calendar',
        label: 'Calendar',
        icon: Icons.calendar_today_outlined,
        selectedIcon: Icons.calendar_today,
        route: '/calendar',
        tooltip: 'View calendar',
      )
      ..addItem(
        id: 'team',
        label: 'Team',
        icon: MdiIcons.accountGroupOutline,
        selectedIcon: MdiIcons.accountGroup,
        route: '/team',
        tooltip: 'Manage team',
      )
      ..addItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: '/settings',
        tooltip: 'App settings',
      )
      ..addItem(
        id: 'help',
        label: 'Help & Support',
        icon: Icons.help_outline,
        selectedIcon: Icons.help,
        route: '/help',
        tooltip: 'Get help',
      );

    // Add custom drawer header
    navigationBuilder.drawerHeader(
      Container(
        height: 200,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6750A4),
              Color(0xFF625B71),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rocket_launch,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'VooNavigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'with go_router',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Add custom drawer footer
    navigationBuilder.drawerFooter(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF6750A4),
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {},
              tooltip: 'Logout',
            ),
          ],
        ),
      ),
    );

    // Add floating action button
    navigationBuilder.floatingActionButton(
      FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Create'),
        icon: const Icon(Icons.add),
        elevation: 8,
      ),
    );

    // Add pages with custom content
    navigationBuilder
      ..addPage(
        id: 'dashboard',
        path: '/dashboard',
        page: const DashboardPage(),
      )
      ..addPage(
        id: 'analytics',
        path: '/analytics',
        page: const AnalyticsPage(),
      )
      ..addPage(
        id: 'projects',
        path: '/projects',
        page: const ProjectsPage(),
      )
      ..addPage(
        id: 'messages',
        path: '/messages',
        page: const MessagesPage(),
      )
      ..addPage(
        id: 'notifications',
        path: '/notifications',
        page: const NotificationsPage(),
      )
      ..addPage(
        id: 'email',
        path: '/email',
        page: const EmailPage(),
      )
      ..addPage(
        id: 'calendar',
        path: '/calendar',
        page: const CalendarPage(),
      )
      ..addPage(
        id: 'team',
        path: '/team',
        page: const TeamPage(),
      )
      ..addPage(
        id: 'settings',
        path: '/settings',
        page: const SettingsPage(),
      )
      ..addPage(
        id: 'help',
        path: '/help',
        page: const HelpPage(),
      );

    // Build the router
    final router = navigationBuilder.buildRouter(
      initialLocation: '/dashboard',
      debugLogDiagnostics: true,
    );

    // Build config for theme
    final config = navigationBuilder.buildConfig();

    return MaterialApp.router(
      title: 'VooNavigation with go_router',
      theme: config.theme ??
          ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Example pages with beautiful Material You design

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s your dashboard overview',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          _buildMetricsGrid(context),
          const SizedBox(height: 32),
          _buildActivityChart(context),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    final metrics = [
      ('Revenue', '\$12,345', Icons.trending_up, Colors.green),
      ('Users', '1,234', Icons.people, Colors.blue),
      ('Orders', '567', Icons.shopping_cart, Colors.orange),
      ('Growth', '+23%', Icons.insights, Colors.purple),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          elevation: 0,
          color: Theme.of(context)
              .colorScheme
              .surfaceContainer
              .withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      metric.$3,
                      color: metric.$4,
                      size: 32,
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.$2,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      metric.$1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer.withValues(alpha: .5),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Chart placeholder',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Analytics',
      subtitle: 'View your performance metrics',
      icon: Icons.analytics,
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Projects',
      subtitle: 'Manage your projects',
      icon: Icons.folder,
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Messages',
      subtitle: '12 new messages',
      icon: Icons.message,
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Notifications',
      subtitle: '5 unread notifications',
      icon: Icons.notifications,
    );
  }
}

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Email',
      subtitle: 'Check your inbox',
      icon: Icons.email,
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Calendar',
      subtitle: 'View your schedule',
      icon: Icons.calendar_today,
    );
  }
}

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Team',
      subtitle: 'Manage your team members',
      icon: MdiIcons.accountGroup,
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Settings',
      subtitle: 'Configure app preferences',
      icon: Icons.settings,
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      context: context,
      title: 'Help & Support',
      subtitle: 'Get assistance',
      icon: Icons.help,
    );
  }
}

// Helper function to build consistent page content
Widget _buildPageContent({
  required BuildContext context,
  required String title,
  required String subtitle,
  required IconData icon,
}) {
  final theme = Theme.of(context);

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.explore),
            label: const Text('Explore Features'),
          ),
        ],
      ),
    ),
  );
}
