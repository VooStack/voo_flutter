import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Pass the navigation shell to VooAdaptiveScaffold
          // The index is automatically managed by go_router
          return ScaffoldWithNavigation(
            navigationShell: navigationShell,
          );
        },
        branches: [
          // Dashboard branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => const DashboardDetailsPage(),
                  ),
                ],
              ),
            ],
          ),
          // Analytics branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsPage(),
                routes: [
                  GoRoute(
                    path: 'report/:id',
                    builder: (context, state) => AnalyticsReportPage(
                      reportId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Projects branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsPage(),
                routes: [
                  GoRoute(
                    path: ':projectId',
                    builder: (context, state) => ProjectDetailPage(
                      projectId: state.pathParameters['projectId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'tasks',
                        builder: (context, state) => ProjectTasksPage(
                          projectId: state.pathParameters['projectId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Messages branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/messages',
                builder: (context, state) => const MessagesPage(),
                routes: [
                  GoRoute(
                    path: 'conversation/:id',
                    builder: (context, state) => ConversationPage(
                      conversationId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Team branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/team',
                builder: (context, state) => const TeamPage(),
                routes: [
                  GoRoute(
                    path: 'member/:memberId',
                    builder: (context, state) => TeamMemberPage(
                      memberId: state.pathParameters['memberId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Settings branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfileSettingsPage(),
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (context, state) => const SecuritySettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VooNavigation with StatefulShellRoute',
      theme: ThemeData(
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
      routerConfig: _router,
    );
  }
}

class ScaffoldWithNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavigation({
    super.key,
    required this.navigationShell,
  });

  @override
  State<ScaffoldWithNavigation> createState() => _ScaffoldWithNavigationState();
}

class _ScaffoldWithNavigationState extends State<ScaffoldWithNavigation> {
  late final List<VooNavigationItem> _navigationItems;

  @override
  void initState() {
    super.initState();
    _navigationItems = [
      VooNavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        tooltip: 'View your dashboard',
        badgeCount: 3,
      ),
      VooNavigationItem(
        id: 'analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        tooltip: 'View analytics',
        showDot: true,
        badgeColor: Colors.green,
      ),
      VooNavigationItem(
        id: 'projects',
        label: 'Projects',
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder,
        tooltip: 'Manage projects',
        badgeText: 'NEW',
        badgeColor: Colors.orange,
      ),
      VooNavigationItem(
        id: 'messages',
        label: 'Messages',
        icon: Icons.message_outlined,
        selectedIcon: Icons.message,
        badgeCount: 12,
      ),
      VooNavigationItem(
        id: 'team',
        label: 'Team',
        icon: MdiIcons.accountGroupOutline,
        selectedIcon: MdiIcons.accountGroup,
        tooltip: 'Manage team',
      ),
      VooNavigationItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        tooltip: 'App settings',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return VooAdaptiveScaffold(
      config: VooNavigationConfig(
        items: _navigationItems,
        selectedId: _navigationItems[widget.navigationShell.currentIndex].id,
        onNavigationItemSelected: (itemId) {
          final index = _navigationItems.indexWhere((item) => item.id == itemId);
          if (index != -1) {
            // Use go_router's navigation shell to switch branches
            widget.navigationShell.goBranch(
              index,
              // Optional: Navigate to the initial location of the branch when tapping
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          }
        },
        appBarTitle: Text(_navigationItems[widget.navigationShell.currentIndex].label),
        enableAnimations: true,
        enableHapticFeedback: true,
        showNotificationBadges: true,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOutCubic,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('FAB pressed')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      // Pass the StatefulNavigationShell directly as the body
      body: widget.navigationShell,
    );
  }
}

// Example pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('View Dashboard Details'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/dashboard/details'),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardDetailsPage extends StatelessWidget {
  const DashboardDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Details')),
      body: const Center(
        child: Text('Dashboard Details Page'),
      ),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('View Report #1'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/analytics/report/1'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('View Report #2'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/analytics/report/2'),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsReportPage extends StatelessWidget {
  final String reportId;

  const AnalyticsReportPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report #$reportId')),
      body: Center(
        child: Text('Analytics Report #$reportId'),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Project Alpha'),
              subtitle: const Text('Click to view details and tasks'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/projects/alpha'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Project Beta'),
              subtitle: const Text('Click to view details and tasks'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/projects/beta'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project $projectId')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Project $projectId Details'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/projects/$projectId/tasks'),
              child: const Text('View Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectTasksPage extends StatelessWidget {
  final String projectId;

  const ProjectTasksPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$projectId Tasks')),
      body: Center(
        child: Text('Tasks for Project $projectId'),
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Messages',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('John Doe'),
              subtitle: const Text('Hey, how are you?'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/messages/conversation/john'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Jane Smith'),
              subtitle: const Text('Meeting tomorrow at 3pm'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/messages/conversation/jane'),
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationPage extends StatelessWidget {
  final String conversationId;

  const ConversationPage({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $conversationId')),
      body: Center(
        child: Text('Conversation with $conversationId'),
      ),
    );
  }
}

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Alice Johnson'),
              subtitle: const Text('Developer'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/team/member/alice'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Bob Wilson'),
              subtitle: const Text('Designer'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/team/member/bob'),
            ),
          ),
        ],
      ),
    );
  }
}

class TeamMemberPage extends StatelessWidget {
  final String memberId;

  const TeamMemberPage({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Member: $memberId')),
      body: Center(
        child: Text('Profile for $memberId'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Profile Settings'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/settings/profile'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Security Settings'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.go('/settings/security'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: const Center(
        child: Text('Profile Settings Page'),
      ),
    );
  }
}

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Settings')),
      body: const Center(
        child: Text('Security Settings Page'),
      ),
    );
  }
}
