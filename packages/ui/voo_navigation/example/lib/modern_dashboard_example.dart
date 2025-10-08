import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const ModernDashboardApp());
}

class ModernDashboardApp extends StatelessWidget {
  const ModernDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B8DEE),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B8DEE),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ModernDashboard(),
    );
  }
}

class ModernDashboard extends StatefulWidget {
  const ModernDashboard({super.key});

  @override
  State<ModernDashboard> createState() => _ModernDashboardState();
}

class _ModernDashboardState extends State<ModernDashboard> {
  String _selectedId = 'dashboard';

  final List<VooNavigationItem> _navigationItems = [
    const VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    const VooNavigationItem(
      id: 'activity',
      label: 'Activity',
      icon: Icons.flash_on_outlined,
      selectedIcon: Icons.flash_on,
      route: '/activity',
      badgeCount: 10,
    ),
    const VooNavigationItem(
      id: 'tasks',
      label: 'My tasks',
      icon: Icons.task_alt_outlined,
      selectedIcon: Icons.task_alt,
      route: '/tasks',
      badgeCount: 8,
    ),
    const VooNavigationItem(
      id: 'analytics',
      label: 'Analytics',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      route: '/analytics',
    ),
    VooNavigationItem.section(
      label: 'Projects',
      id: 'projects',
      isExpanded: true,
      children: const [
        VooNavigationItem(
          id: 'project1',
          label: 'Project Alpha',
          icon: Icons.circle_outlined,
          selectedIcon: Icons.circle,
          route: '/projects/alpha',
        ),
        VooNavigationItem(
          id: 'project2',
          label: 'Project Beta',
          icon: Icons.circle_outlined,
          selectedIcon: Icons.circle,
          route: '/projects/beta',
        ),
      ],
    ),
    VooNavigationItem.section(
      label: 'Settings',
      id: 'settings',
      isExpanded: false,
      children: const [
        VooNavigationItem(
          id: 'general',
          label: 'General',
          icon: Icons.tune,
          route: '/settings/general',
        ),
        VooNavigationItem(
          id: 'domains',
          label: 'Domains',
          icon: Icons.domain,
          route: '/settings/domains',
        ),
        VooNavigationItem(
          id: 'integrations',
          label: 'Integrations',
          icon: Icons.extension,
          route: '/settings/integrations',
        ),
        VooNavigationItem(
          id: 'billing',
          label: 'Billing',
          icon: Icons.payment,
          route: '/settings/billing',
        ),
        VooNavigationItem(
          id: 'payouts',
          label: 'Payouts',
          icon: Icons.account_balance,
          route: '/settings/payouts',
        ),
      ],
    ),
    const VooNavigationItem(
      id: 'documentation',
      label: 'Documentation',
      icon: Icons.description_outlined,
      selectedIcon: Icons.description,
      route: '/documentation',
    ),
    const VooNavigationItem(
      id: 'inbox',
      label: 'Inbox',
      icon: Icons.inbox_outlined,
      selectedIcon: Icons.inbox,
      route: '/inbox',
      badgeCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      selectedItemColor: const Color(0xFF5B8DEE),
      bottomNavigationType: VooNavigationBarType.custom,
      enableAnimations: true,
      enableHapticFeedback: true,
      showNotificationBadges: true,
      groupItemsBySections: true,
      railLabelType: NavigationRailLabelType.selected,
      useExtendedRail: true,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOutCubic,
      appBarTitleBuilder: (_) => const Text('Untitled UI'),
      onNavigationItemSelected: (itemId) {
        setState(() {
          _selectedId = itemId;
        });
      },
    );

    return VooAdaptiveScaffold(
      config: config,
      body: _buildDashboardContent(context),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1B1E) : const Color(0xFFF8F9FB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to your dashboard',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track, manage and forecast your portfolio. Export reports from this page.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Portfolio Value Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$116,289.60',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '94,528.24 (+3.89%)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chart placeholder
                  Container(
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF5B8DEE).withValues(alpha: 0.2),
                          const Color(0xFF6B5EE8).withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.show_chart,
                        color: Color(0xFF5B8DEE),
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Time Period Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                for (final period in ['1d', '7d', '30d', '6m', '12m', 'max'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: period == '30d'
                            ? const Color(0xFF5B8DEE)
                            : Colors.transparent,
                        foregroundColor: period == '30d'
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(period),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Portfolio Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildPortfolioItem(
                  context,
                  'Cardano',
                  'ADA/AUD',
                  '\$2.97 AUD',
                  Icons.currency_bitcoin,
                  const Color(0xFF3B82F6),
                ),
                _buildPortfolioItem(
                  context,
                  'Ripple',
                  'XRP/AUD',
                  '\$1,516 AUD',
                  Icons.currency_exchange,
                  const Color(0xFF10B981),
                ),
                _buildPortfolioItem(
                  context,
                  'Bitcoin',
                  'BTC/AUD',
                  '\$77,603 AUD',
                  Icons.currency_bitcoin,
                  const Color(0xFFF59E0B),
                ),
                _buildPortfolioItem(
                  context,
                  'Litecoin',
                  'LTC/AUD',
                  '\$245.67 AUD',
                  Icons.currency_exchange,
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem(
    BuildContext context,
    String name,
    String pair,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  pair,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
