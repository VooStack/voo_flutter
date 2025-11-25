import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const SaasDashboardApp());
}

class SaasDashboardApp extends StatelessWidget {
  const SaasDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaaS Dashboard',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const SaasDashboard(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1), // Indigo
        brightness: Brightness.light,
        surface: const Color(0xFFFAFAFA),
        surfaceContainerLow: Colors.white,
        surfaceContainerHigh: const Color(0xFFF4F4F5),
      ),
      useMaterial3: true,
      fontFamily: 'Inter',
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF818CF8), // Lighter indigo for dark mode
        brightness: Brightness.dark,
        surface: const Color(0xFF09090B),
        surfaceContainerLow: const Color(0xFF18181B),
        surfaceContainerHigh: const Color(0xFF27272A),
      ),
      useMaterial3: true,
      fontFamily: 'Inter',
    );
  }
}

class SaasDashboard extends StatefulWidget {
  const SaasDashboard({super.key});

  @override
  State<SaasDashboard> createState() => _SaasDashboardState();
}

class _SaasDashboardState extends State<SaasDashboard> {
  String _selectedId = 'overview';
  final int _notificationCount = 3;
  bool _isRailExpanded = true;

  final List<VooNavigationItem> _navigationItems = [
    const VooNavigationItem(
      id: 'overview',
      label: 'Overview',
      icon: Icons.grid_view_rounded,
      selectedIcon: Icons.grid_view_rounded,
      route: '/overview',
      mobilePriority: true,
      sortOrder: 0,
    ),
    const VooNavigationItem(
      id: 'analytics',
      label: 'Analytics',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights,
      route: '/analytics',
      mobilePriority: true,
      sortOrder: 1,
    ),
    const VooNavigationItem(
      id: 'customers',
      label: 'Customers',
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      route: '/customers',
      badgeCount: 12,
      mobilePriority: true,
      sortOrder: 2,
    ),
    const VooNavigationItem(
      id: 'inbox',
      label: 'Inbox',
      icon: Icons.inbox_outlined,
      selectedIcon: Icons.inbox,
      route: '/inbox',
      badgeCount: 3,
      mobilePriority: true,
      sortOrder: 3,
    ),
    VooNavigationItem.section(
      label: 'Workspace',
      id: 'workspace_section',
      isExpanded: true,
      children: const [
        VooNavigationItem(
          id: 'projects',
          label: 'Projects',
          icon: Icons.folder_outlined,
          selectedIcon: Icons.folder,
          route: '/projects',
        ),
        VooNavigationItem(
          id: 'tasks',
          label: 'Tasks',
          icon: Icons.check_circle_outline_rounded,
          selectedIcon: Icons.check_circle_rounded,
          route: '/tasks',
          badgeCount: 8,
        ),
        VooNavigationItem(
          id: 'calendar',
          label: 'Calendar',
          icon: Icons.calendar_today_outlined,
          selectedIcon: Icons.calendar_today,
          route: '/calendar',
        ),
        VooNavigationItem(
          id: 'documents',
          label: 'Documents',
          icon: Icons.description_outlined,
          selectedIcon: Icons.description,
          route: '/documents',
        ),
      ],
    ),
    VooNavigationItem.section(
      label: 'Settings',
      id: 'settings_section',
      isExpanded: false,
      children: const [
        VooNavigationItem(
          id: 'general',
          label: 'General',
          icon: Icons.tune_rounded,
          route: '/settings/general',
        ),
        VooNavigationItem(
          id: 'team',
          label: 'Team',
          icon: Icons.group_outlined,
          selectedIcon: Icons.group,
          route: '/settings/team',
        ),
        VooNavigationItem(
          id: 'billing',
          label: 'Billing',
          icon: Icons.credit_card_outlined,
          selectedIcon: Icons.credit_card,
          route: '/settings/billing',
        ),
        VooNavigationItem(
          id: 'integrations',
          label: 'Integrations',
          icon: Icons.extension_outlined,
          selectedIcon: Icons.extension,
          route: '/settings/integrations',
        ),
      ],
    ),
    const VooNavigationItem(
      id: 'help',
      label: 'Help & Support',
      icon: Icons.help_outline_rounded,
      selectedIcon: Icons.help_rounded,
      route: '/help',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      selectedItemColor: theme.colorScheme.primary,

      // Enable modern features
      floatingBottomNav: true,
      floatingBottomNavMargin: 20,
      floatingBottomNavBottomMargin: 24,
      bottomNavigationType: VooNavigationBarType.custom,

      // Collapsible rail
      enableCollapsibleRail: true,
      useExtendedRail: _isRailExpanded,
      navigationRailWidth: 72,
      extendedNavigationRailWidth: 280,

      // User profile
      showUserProfile: true,
      userProfileWidget: VooUserProfileFooter(
        userName: 'Sarah Chen',
        userEmail: 'sarah@acme.com',
        status: VooUserStatus.online,
        compact: !_isRailExpanded,
        onTap: () => _showUserMenu(context),
        onSettingsTap: () => setState(() => _selectedId = 'general'),
        onLogout: () => _showLogoutDialog(context),
      ),

      // Animations
      enableAnimations: true,
      enableHapticFeedback: true,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeOutCubic,

      // Badges
      showNotificationBadges: true,
      groupItemsBySections: true,

      // Styling
      navigationBackgroundColor: isDark
          ? theme.colorScheme.surfaceContainerLow
          : theme.colorScheme.surface,

      // Custom header
      drawerHeader: _buildCustomHeader(context),

      // App bar
      appBarTitleBuilder: (_) => Row(
        children: [
          Text(
            'Acme Inc',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Pro',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      appBarActionsBuilder: (_) => [
        IconButton(
          icon: Badge(
            isLabelVisible: _notificationCount > 0,
            label: Text(_notificationCount.toString()),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () => _showNotifications(context),
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 8),
      ],

      onNavigationItemSelected: (itemId) {
        setState(() {
          _selectedId = itemId;
        });
      },
    );

    return VooAdaptiveScaffold(
      config: config,
      body: _buildContent(context),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hexagon_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              if (_isRailExpanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acme Dashboard',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'v2.4.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Collapse toggle
          if (_isRailExpanded) ...[
            const SizedBox(height: 20),

            // Search bar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.search,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Search...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '⌘K',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],

          // Collapse button
          const SizedBox(height: 12),
          VooCollapseToggle(
            isExpanded: _isRailExpanded,
            onToggle: () => setState(() => _isRailExpanded = !_isRailExpanded),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF09090B) : const Color(0xFFF4F4F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header
            Text(
              'Good morning, Sarah',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Here\'s what\'s happening with your projects today.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            // Stats cards
            _buildStatsSection(context),

            const SizedBox(height: 32),

            // Activity section
            _buildActivitySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              context,
              'Total Revenue',
              '\$45,231.89',
              '+20.1% from last month',
              Icons.attach_money_rounded,
              const Color(0xFF22C55E),
              isWide ? constraints.maxWidth / 4 - 12 : constraints.maxWidth / 2 - 8,
            ),
            _buildStatCard(
              context,
              'Subscriptions',
              '+2,350',
              '+180.1% from last month',
              Icons.people_outline_rounded,
              const Color(0xFF3B82F6),
              isWide ? constraints.maxWidth / 4 - 12 : constraints.maxWidth / 2 - 8,
            ),
            _buildStatCard(
              context,
              'Sales',
              '+12,234',
              '+19% from last month',
              Icons.shopping_cart_outlined,
              const Color(0xFFF59E0B),
              isWide ? constraints.maxWidth / 4 - 12 : constraints.maxWidth / 2 - 8,
            ),
            _buildStatCard(
              context,
              'Active Now',
              '+573',
              '+201 since last hour',
              Icons.bolt_rounded,
              const Color(0xFFEC4899),
              isWide ? constraints.maxWidth / 4 - 12 : constraints.maxWidth / 2 - 8,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    double width,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerLow
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF22C55E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerLow
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => _buildActivityItem(context, index)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final activities = [
      ('New user signed up', 'olivia@email.com', '2 min ago', Icons.person_add_outlined, const Color(0xFF22C55E)),
      ('Payment received', '\$250.00', '5 min ago', Icons.payments_outlined, const Color(0xFF3B82F6)),
      ('Project completed', 'Website redesign', '15 min ago', Icons.check_circle_outline, const Color(0xFFF59E0B)),
      ('New comment', 'on Task #234', '1 hour ago', Icons.chat_bubble_outline, const Color(0xFFEC4899)),
      ('Team member added', 'to Project Alpha', '2 hours ago', Icons.group_add_outlined, const Color(0xFF8B5CF6)),
    ];

    final activity = activities[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.$5.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(activity.$4, color: activity.$5, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.$1,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity.$2,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.$3,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have $_notificationCount new notifications'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('View Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedId = 'general');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Sign Out',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
