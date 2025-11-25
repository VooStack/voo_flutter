import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voo_navigation/voo_navigation.dart';

import 'theme_showcase_example.dart';

void main() {
  runApp(const VooNavigationExampleApp());
}

class VooNavigationExampleApp extends StatefulWidget {
  const VooNavigationExampleApp({super.key});

  @override
  State<VooNavigationExampleApp> createState() => _VooNavigationExampleAppState();
}

class _VooNavigationExampleAppState extends State<VooNavigationExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooNavigation Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F75FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F75FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: ExampleSelector(onToggleTheme: _toggleTheme),
    );
  }
}

/// Landing page to select between examples
class ExampleSelector extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const ExampleSelector({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VooNavigation Examples'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.navigation,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'VooNavigation',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Adaptive Navigation Package',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildExampleCard(
                  context,
                  title: 'Theme Showcase',
                  description: 'Explore all 4 visual theme presets: Glassmorphism, Neomorphism, Material 3 Enhanced, and Minimal Modern',
                  icon: Icons.palette,
                  isPrimary: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ThemeShowcaseExample(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildExampleCard(
                  context,
                  title: 'Full Feature Demo',
                  description: 'Complete navigation example with sections, badges, custom headers, and responsive layouts',
                  icon: Icons.dashboard,
                  isPrimary: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NavigationExample(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: isPrimary ? 4 : 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: isPrimary
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                )
              : null,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isPrimary
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPrimary
                            ? theme.colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isPrimary
                            ? theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.8)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isPrimary
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  String _selectedId = 'dashboard';

  // Create navigation items with various features
  List<VooNavigationItem> get _navigationItems => [
    VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      mobilePriority: true,
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      onTap: () {},
      tooltip: 'View your dashboard',
      badgeCount: 3,
    ),
    VooNavigationItem(
      id: 'analytics',
      label: 'Analytics',
      mobilePriority: true,
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      onTap: () {},
      tooltip: 'View analytics',
      showDot: true,
      badgeColor: Colors.green,
    ),
    VooNavigationItem(
      id: 'projects',
      label: 'Projects',
      mobilePriority: true,
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      onTap: () {},
      tooltip: 'Manage projects',
      badgeText: 'NEW',
      badgeColor: Colors.orange,
    ),
    VooNavigationItem.section(
      label: 'Communication',
      id: 'communication',
      isExpanded: true,
      children: [
        VooNavigationItem(
          id: 'messages',
          label: 'Messages',
          mobilePriority: true,
          icon: Icons.message_outlined,
          selectedIcon: Icons.message,
          onTap: () {},
          badgeCount: 12,
        ),
        VooNavigationItem(
          id: 'notifications',
          label: 'Notifications',
          icon: Icons.notifications_outlined,
          selectedIcon: Icons.notifications,
          onTap: () {},
          badgeCount: 5,
        ),
        VooNavigationItem(
          id: 'email',
          label: 'Email',
          icon: Icons.email_outlined,
          selectedIcon: Icons.email,
          onTap: () {},
          showDot: true,
        ),
      ],
    ),
    VooNavigationItem.divider(),
    VooNavigationItem(
      id: 'calendar',
      label: 'Calendar',
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      onTap: () {},
      tooltip: 'View calendar',
    ),
    VooNavigationItem(
      id: 'team',
      label: 'Team',
      icon: MdiIcons.accountGroupOutline,
      selectedIcon: MdiIcons.accountGroup,
      onTap: () {},
      tooltip: 'Manage team',
    ),
    VooNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      onTap: () {},
      tooltip: 'App settings',
    ),
    VooNavigationItem(
      id: 'help',
      label: 'Help & Support',
      icon: Icons.help_outline,
      selectedIcon: Icons.help,
      onTap: () {},
      tooltip: 'Get help',
      isEnabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Create navigation configuration
    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      isAdaptive: true,
      enableAnimations: true,
      enableHapticFeedback: true,
      showNotificationBadges: true,
      groupItemsBySections: true,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOutCubic,
      railLabelType: NavigationRailLabelType.selected,
      // Only extend rail when width > 840px, respecting responsive breakpoints
      useExtendedRail: true, // This allows extended rail, but width determines actual state
      showNavigationRailDivider: true,
      // App bar positioned alongside navigation rail (default behavior)
      // Set to false to make app bar span full width above the rail
      appBarAlongsideRail: true,
      selectedItemColor: const Color(0xFF4F75FF),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      drawerHeader: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rocket_launch,
                size: 64,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(height: 16),
              Text(
                'VooNavigation',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Adaptive Navigation System',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
        ),
      ),
      drawerFooter: LayoutBuilder(
        builder: (context, constraints) {
          // Only show footer content when there's enough width (extended rail or drawer)
          final isCompact = constraints.maxWidth < 200;

          if (isCompact) {
            // Compact footer for icon-only rail
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withAlpha((0.2 * 255).round()),
                  ),
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile tapped')),
                    );
                  },
                  tooltip: 'John Doe',
                ),
              ),
            );
          }

          // Full footer for extended rail and drawer
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withAlpha((0.2 * 255).round()),
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'John Doe',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'john.doe@example.com',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout pressed')),
                    );
                  },
                  tooltip: 'Logout',
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAB pressed')),
          );
        },
        label: const Text('Create'),
        icon: const Icon(Icons.add),
      ),
      onNavigationItemSelected: (itemId) {
        setState(() {
          _selectedId = itemId;
        });

        // Show snackbar for demonstration
        final item = _navigationItems.firstWhere((item) => item.id == itemId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${item.label}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );

    // Build adaptive scaffold
    return VooAdaptiveScaffold(
      config: config,
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final selectedItem = _navigationItems.firstWhere(
      (item) => item.id == _selectedId,
      orElse: () => _navigationItems.first,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withAlpha((0.95 * 255).round()),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        color: Colors.purple,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selectedItem.effectiveSelectedIcon,
                size: 120,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                selectedItem.label,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This is the ${selectedItem.label} page content',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildFeatureCards(context),
              const SizedBox(height: 32),
              _buildScreenSizeInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    final theme = Theme.of(context);

    final features = [
      ('Adaptive', Icons.devices, 'Automatically adjusts to screen size'),
      ('Material 3', Icons.palette, 'Follows latest Material Design'),
      ('Customizable', Icons.tune, 'Extensive customization options'),
      ('Animated', Icons.animation, 'Beautiful transitions'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: features.map((feature) {
        return Card(
          elevation: 2,
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  feature.$2,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  feature.$1,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feature.$3,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScreenSizeInfo(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    String getNavigationType() {
      if (size.width < 600) return 'Bottom Navigation';
      if (size.width < 840) return 'Navigation Rail';
      if (size.width < 1240) return 'Extended Navigation Rail';
      return 'Navigation Drawer';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.aspect_ratio,
              size: 48,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Screen Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Width: ${size.width.toStringAsFixed(0)}px',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Height: ${size.height.toStringAsFixed(0)}px',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                getNavigationType(),
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
