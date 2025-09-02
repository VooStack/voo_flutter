import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

// ============================================================================
// COMPLETE ADAPTIVE SCAFFOLD PREVIEWS
// ============================================================================

/// Adaptive scaffold that changes navigation type based on screen size
class AdaptiveScaffoldPreview extends StatefulWidget {
  const AdaptiveScaffoldPreview({super.key});

  @override
  State<AdaptiveScaffoldPreview> createState() => _AdaptiveScaffoldPreviewState();
}

class _AdaptiveScaffoldPreviewState extends State<AdaptiveScaffoldPreview> {
  String _selectedId = 'home';

  @override
  Widget build(BuildContext context) {
    final navigationItems = [
      const VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        route: '/home',
        badgeCount: 5,
      ),
      const VooNavigationItem(
        id: 'search',
        label: 'Search',
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        route: '/search',
      ),
      const VooNavigationItem(
        id: 'favorites',
        label: 'Favorites',
        icon: Icons.favorite_outline,
        selectedIcon: Icons.favorite,
        route: '/favorites',
        showDot: true,
        badgeColor: Colors.red,
      ),
      const VooNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        route: '/profile',
        badgeText: 'NEW',
      ),
      const VooNavigationItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        children: [
          VooNavigationItem(
            id: 'general',
            label: 'General',
            icon: Icons.tune,
            route: '/settings/general',
          ),
          VooNavigationItem(
            id: 'privacy',
            label: 'Privacy',
            icon: Icons.lock_outline,
            route: '/settings/privacy',
          ),
          VooNavigationItem(
            id: 'notifications',
            label: 'Notifications',
            icon: Icons.notifications_outlined,
            route: '/settings/notifications',
          ),
        ],
      ),
    ];

    final config = VooNavigationConfig(
      items: navigationItems,
      selectedId: _selectedId,
      appBarTitle: const Text('Adaptive Navigation Demo'),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      onNavigationItemSelected: (itemId) {
        setState(() {
          _selectedId = itemId;
        });
      },
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: VooAdaptiveScaffold(
        config: config,
        body: _buildBody(_selectedId),
      ),
    );
  }

  Widget _buildBody(String selectedId) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForId(selectedId),
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Selected: ${selectedId.toUpperCase()}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Resize the window to see adaptive navigation:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Small screens: Bottom Navigation'),
                  Text('• Medium screens: Navigation Rail'),
                  Text('• Large screens: Navigation Drawer'),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  IconData _getIconForId(String id) {
    switch (id) {
      case 'home':
        return Icons.home;
      case 'search':
        return Icons.search;
      case 'favorites':
        return Icons.favorite;
      case 'profile':
        return Icons.person;
      case 'settings':
      case 'general':
      case 'privacy':
      case 'notifications':
        return Icons.settings;
      default:
        return Icons.dashboard;
    }
  }
}

/// Forced navigation type scaffold preview
class ForcedNavigationTypePreview extends StatefulWidget {
  const ForcedNavigationTypePreview({super.key});

  @override
  State<ForcedNavigationTypePreview> createState() => _ForcedNavigationTypePreviewState();
}

class _ForcedNavigationTypePreviewState extends State<ForcedNavigationTypePreview> {
  String _selectedId = 'dashboard';
  VooNavigationType _forcedType = VooNavigationType.bottomNavigation;

  @override
  Widget build(BuildContext context) {
    final navigationItems = [
      const VooNavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        route: '/dashboard',
      ),
      const VooNavigationItem(
        id: 'analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        route: '/analytics',
        badgeCount: 3,
      ),
      const VooNavigationItem(
        id: 'reports',
        label: 'Reports',
        icon: Icons.assessment_outlined,
        selectedIcon: Icons.assessment,
        route: '/reports',
      ),
      const VooNavigationItem(
        id: 'team',
        label: 'Team',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        route: '/team',
      ),
    ];

    final config = VooNavigationConfig(
      items: navigationItems,
      selectedId: _selectedId,
      isAdaptive: false,
      forcedNavigationType: _forcedType,
      appBarTitle: Text('Forced ${_forcedType.name} Navigation'),
      selectedItemColor: Colors.purple,
      indicatorColor: Colors.purple.shade100,
      onNavigationItemSelected: (itemId) {
        setState(() {
          _selectedId = itemId;
        });
      },
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: VooAdaptiveScaffold(
        config: config,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Select Navigation Type:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<VooNavigationType>(
                    segments: const [
                      ButtonSegment(
                        value: VooNavigationType.bottomNavigation,
                        label: Text('Bottom'),
                        icon: Icon(Icons.vertical_align_bottom),
                      ),
                      ButtonSegment(
                        value: VooNavigationType.navigationRail,
                        label: Text('Rail'),
                        icon: Icon(Icons.view_sidebar),
                      ),
                      ButtonSegment(
                        value: VooNavigationType.navigationDrawer,
                        label: Text('Drawer'),
                        icon: Icon(Icons.menu),
                      ),
                    ],
                    selected: {_forcedType},
                    onSelectionChanged: (Set<VooNavigationType> newSelection) {
                      setState(() {
                        _forcedType = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Current View: $_selectedId',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INDIVIDUAL NAVIGATION COMPONENT PREVIEWS
// ============================================================================

@Preview(name: 'Adaptive Scaffold - Full Demo')
Widget buildAdaptiveScaffoldPreview() => const AdaptiveScaffoldPreview();

@Preview(name: 'Forced Navigation Types')
Widget buildForcedNavigationPreview() => const ForcedNavigationTypePreview();

@Preview(name: 'Bottom Navigation Bar')
Widget buildBottomNavigationPreview() => _NavigationPreview(
    title: 'Bottom Navigation Bar',
    builder: (List<VooNavigationItem> items, String selectedId, void Function(String) onSelected) {
      final config = VooNavigationConfig(
        items: items,
        selectedId: selectedId,
        onNavigationItemSelected: onSelected,
      );
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bottom Navigation'),
          backgroundColor: Colors.blue.shade50,
        ),
        body: Center(
          child: Text(
            'Selected: $selectedId',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: VooAdaptiveBottomNavigation(
          config: config,
          selectedId: selectedId,
          onNavigationItemSelected: onSelected,
        ),
      );
    },
  );

@Preview(name: 'Navigation Rail - Collapsed')
Widget buildNavigationRailCollapsedPreview() => _NavigationPreview(
    title: 'Navigation Rail (Collapsed)',
    builder: (List<VooNavigationItem> items, String selectedId, void Function(String) onSelected) {
      final config = VooNavigationConfig(
        items: items,
        selectedId: selectedId,
        railLabelType: NavigationRailLabelType.none,
        onNavigationItemSelected: onSelected,
      );
      return Scaffold(
        body: Row(
          children: [
            VooAdaptiveNavigationRail(
              config: config,
              selectedId: selectedId,
              onNavigationItemSelected: onSelected,
              extended: false,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Center(
                child: Text(
                  'Selected: $selectedId',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

@Preview(name: 'Navigation Rail - Extended')
Widget buildNavigationRailExtendedPreview() => _NavigationPreview(
    title: 'Navigation Rail (Extended)',
    builder: (List<VooNavigationItem> items, String selectedId, void Function(String) onSelected) {
      final config = VooNavigationConfig(
        items: items,
        selectedId: selectedId,
        railLabelType: NavigationRailLabelType.all,
        onNavigationItemSelected: onSelected,
      );
      return Scaffold(
        body: Row(
          children: [
            VooAdaptiveNavigationRail(
              config: config,
              selectedId: selectedId,
              onNavigationItemSelected: onSelected,
              extended: true,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Center(
                child: Text(
                  'Selected: $selectedId',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

@Preview(name: 'Navigation Drawer')
Widget buildNavigationDrawerPreview() => const _NavigationDrawerPreview();

// ============================================================================
// ATOM COMPONENT PREVIEWS
// ============================================================================

@Preview(name: 'Navigation Icon')
Widget buildNavigationIconPreview() => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Icon Variations'),
        backgroundColor: Colors.teal.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Default Icons'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VooNavigationIcon(
                  icon: Icons.home_outlined,
                ),
                VooNavigationIcon(
                  icon: Icons.home,
                  isSelected: true,
                ),
                VooNavigationIcon(
                  icon: Icons.home,
                  isSelected: true,
                  selectedColor: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Custom Sizes'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VooNavigationIcon(
                  icon: Icons.settings,
                  size: 20,
                ),
                VooNavigationIcon(
                  icon: Icons.settings,
                  size: 28,
                ),
                VooNavigationIcon(
                  icon: Icons.settings,
                  size: 36,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

@Preview(name: 'Navigation Indicator')
Widget buildNavigationIndicatorPreview() => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Indicators'),
        backgroundColor: Colors.green.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Indicator Shapes'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const VooNavigationIndicator(
                  isSelected: true,
                  child: Icon(Icons.home),
                ),
                VooNavigationIndicator(
                  isSelected: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.search),
                ),
                const VooNavigationIndicator(
                  isSelected: true,
                  shape: CircleBorder(),
                  child: Icon(Icons.person),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Custom Colors'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VooNavigationIndicator(
                  isSelected: true,
                  color: Colors.purple.shade100,
                  child: const Icon(Icons.favorite, color: Colors.purple),
                ),
                VooNavigationIndicator(
                  isSelected: true,
                  color: Colors.orange.shade100,
                  child: const Icon(Icons.star, color: Colors.orange),
                ),
                VooNavigationIndicator(
                  isSelected: true,
                  color: Colors.blue.shade100,
                  child: const Icon(Icons.bookmark, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

@Preview(name: 'Navigation Label')
Widget buildNavigationLabelPreview() => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Labels'),
        backgroundColor: Colors.indigo.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Label States'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VooNavigationLabel(
                  label: 'Unselected',
                ),
                VooNavigationLabel(
                  label: 'Selected',
                  isSelected: true,
                ),
                VooNavigationLabel(
                  label: 'Disabled',
                  color: Colors.grey,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Custom Styles'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const VooNavigationLabel(
                  label: 'Bold',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VooNavigationLabel(
                  label: 'Colored',
                  style: TextStyle(color: Colors.purple.shade700),
                ),
                const VooNavigationLabel(
                  label: 'Large',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

// ============================================================================
// MOLECULE COMPONENT PREVIEWS
// ============================================================================

@Preview(name: 'Navigation Badge')
Widget buildNavigationBadgePreview() => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Badges'),
        backgroundColor: Colors.red.shade50,
      ),
      body: const _BadgeExamples(),
    ),
  );

@Preview(name: 'Navigation Item Widget')
Widget buildNavigationItemWidgetPreview() => _NavigationPreview(
    title: 'Navigation Item Widget',
    builder: (List<VooNavigationItem> items, String selectedId, void Function(String) onSelected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Navigation Items'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Standard Items'),
            ...items.take(3).map((VooNavigationItem item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Card(
                child: VooNavigationItemWidget(
                  item: item,
                  isSelected: item.id == selectedId,
                  onTap: () => onSelected(item.id),
                ),
              ),
            )),
            const SizedBox(height: 16),
            _buildSectionTitle('With Badges'),
            Card(
              child: ListTile(
                leading: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, size: 24),
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '12',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                title: const Text('Notifications'),
                subtitle: const Text('12 new notifications'),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Stack(
                  children: [
                    const Icon(Icons.update, size: 24),
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                title: const Text('Updates'),
                subtitle: const Text('New updates available'),
                onTap: () {},
              ),
            ),
          ],
        ),
      );
    },
  );

@Preview(name: 'Navigation Dropdown')
Widget buildNavigationDropdownPreview() => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Dropdown'),
        backgroundColor: Colors.deepPurple.shade50,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          VooNavigationDropdown(
            config: const VooNavigationConfig(
              items: [],
            ),
            item: const VooNavigationItem(
              id: 'products',
              label: 'Products',
              icon: Icons.shopping_bag_outlined,
              selectedIcon: Icons.shopping_bag,
              isExpanded: true,
              children: [
                VooNavigationItem(
                  id: 'electronics',
                  label: 'Electronics',
                  icon: Icons.devices,
                  route: '/products/electronics',
                ),
                VooNavigationItem(
                  id: 'clothing',
                  label: 'Clothing',
                  icon: Icons.checkroom,
                  route: '/products/clothing',
                ),
                VooNavigationItem(
                  id: 'books',
                  label: 'Books',
                  icon: Icons.menu_book,
                  route: '/products/books',
                ),
              ],
            ),
            selectedId: 'electronics',
            onItemSelected: (id) {
              debugPrint('Selected: $id');
            },
          ),
          const SizedBox(height: 16),
          VooNavigationDropdown(
            config: const VooNavigationConfig(
              items: [],
            ),
            item: const VooNavigationItem(
              id: 'account',
              label: 'Account',
              icon: Icons.account_circle_outlined,
              selectedIcon: Icons.account_circle,
              children: [
                VooNavigationItem(
                  id: 'profile',
                  label: 'Profile',
                  icon: Icons.person,
                  route: '/account/profile',
                ),
                VooNavigationItem(
                  id: 'security',
                  label: 'Security',
                  icon: Icons.security,
                  route: '/account/security',
                ),
                VooNavigationItem(
                  id: 'billing',
                  label: 'Billing',
                  icon: Icons.credit_card,
                  route: '/account/billing',
                ),
              ],
            ),
            onItemSelected: (id) {
              debugPrint('Selected: $id');
            },
          ),
        ],
      ),
    ),
  );

// ============================================================================
// CUSTOM THEMING PREVIEW
// ============================================================================

@Preview(name: 'Custom Themed Navigation')
Widget buildCustomThemedNavigationPreview() => _NavigationPreview(
    title: 'Custom Themed Navigation',
    customTheme: ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Colors.cyan,
        secondary: Colors.pinkAccent,
        surface: Color(0xFF1E1E1E),
      ),
      useMaterial3: true,
    ),
    builder: (List<VooNavigationItem> items, String selectedId, void Function(String) onSelected) {
      final config = VooNavigationConfig(
        items: items,
        selectedId: selectedId,
        appBarTitle: const Text('Dark Theme Navigation'),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        indicatorColor: Colors.cyan.withAlpha((0.2 * 255).round()),
        navigationBackgroundColor: const Color(0xFF1E1E1E),
        onNavigationItemSelected: onSelected,
      );

      return VooAdaptiveScaffold(
        config: config,
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withAlpha((0.1 * 255).round()),
                  Colors.pinkAccent.withAlpha((0.1 * 255).round()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withAlpha((0.3 * 255).round())),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.palette,
                  size: 48,
                  color: Colors.cyan,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Custom Dark Theme',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selected: $selectedId',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

// ============================================================================
// HELPER WIDGETS
// ============================================================================

/// Badge examples widget
class _BadgeExamples extends StatelessWidget {
  const _BadgeExamples();

  @override
  Widget build(BuildContext context) {
    const config = VooNavigationConfig(
      items: [],
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Badge Examples'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  const Icon(Icons.notifications, size: 32),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: VooNavigationBadge(
                      item: const VooNavigationItem(
                        id: 'notif',
                        label: 'Notifications',
                        icon: Icons.notifications,
                        badgeCount: 5,
                        route: '/notif',
                      ),
                      config: config,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const Icon(Icons.mail, size: 32),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: VooNavigationBadge(
                      item: const VooNavigationItem(
                        id: 'mail',
                        label: 'Mail',
                        icon: Icons.mail,
                        badgeText: 'NEW',
                        route: '/mail',
                      ),
                      config: config,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const Icon(Icons.message, size: 32),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: VooNavigationBadge(
                      item: const VooNavigationItem(
                        id: 'msg',
                        label: 'Messages',
                        icon: Icons.message,
                        showDot: true,
                        route: '/msg',
                      ),
                      config: config,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Custom Badge Colors'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  const Icon(Icons.check_circle, size: 32),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: VooNavigationBadge(
                      item: const VooNavigationItem(
                        id: 'check',
                        label: 'Check',
                        icon: Icons.check_circle,
                        badgeCount: 3,
                        badgeColor: Colors.green,
                        route: '/check',
                      ),
                      config: config,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const Icon(Icons.star, size: 32),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: VooNavigationBadge(
                      item: const VooNavigationItem(
                        id: 'star',
                        label: 'Star',
                        icon: Icons.star,
                        badgeCount: 7,
                        badgeColor: Colors.purple,
                        route: '/star',
                      ),
                      config: config,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const Icon(Icons.update, size: 32),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: VooNavigationBadge(
                      item: const VooNavigationItem(
                        id: 'update',
                        label: 'Update',
                        icon: Icons.update,
                        showDot: true,
                        badgeColor: Colors.blue,
                        route: '/update',
                      ),
                      config: config,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Navigation drawer preview widget
class _NavigationDrawerPreview extends StatefulWidget {
  const _NavigationDrawerPreview();

  @override
  State<_NavigationDrawerPreview> createState() => _NavigationDrawerPreviewState();
}

class _NavigationDrawerPreviewState extends State<_NavigationDrawerPreview> {
  String _selectedId = 'home';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<VooNavigationItem> _items = const [
    VooNavigationItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      route: '/home',
    ),
    VooNavigationItem(
      id: 'explore',
      label: 'Explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      route: '/explore',
      badgeCount: 3,
    ),
    VooNavigationItem(
      id: 'library',
      label: 'Library',
      icon: Icons.library_books_outlined,
      selectedIcon: Icons.library_books,
      route: '/library',
    ),
    VooNavigationItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      route: '/profile',
      showDot: true,
    ),
  ];

  Widget? _buildBadge(VooNavigationItem item) {
    if (item.showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: item.badgeColor ?? Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else if (item.badgeCount != null) {
      return Container(
        padding: const EdgeInsets.all(2),
        constraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        decoration: BoxDecoration(
          color: item.badgeColor ?? Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${item.badgeCount}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      );
    } else if (item.badgeText != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: item.badgeColor ?? Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          item.badgeText!,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Navigation Drawer'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Text(
                        'JD',
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'john@example.com',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _items.map((item) => ListTile(
                    leading: Icon(
                      item.id == _selectedId ? item.effectiveSelectedIcon : item.icon,
                      color: item.id == _selectedId ? Theme.of(context).colorScheme.primary : null,
                    ),
                    title: Text(item.label),
                    selected: item.id == _selectedId,
                    onTap: () {
                      setState(() {
                        _selectedId = item.id;
                      });
                      Navigator.of(context).pop();
                    },
                    trailing: _buildBadge(item),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Tap menu icon or swipe from left',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected: $_selectedId',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper widget for creating navigation previews
class _NavigationPreview extends StatefulWidget {
  final String title;
  final Widget Function(
    List<VooNavigationItem> items,
    String selectedId,
    void Function(String) onSelected,
  ) builder;
  final ThemeData? customTheme;

  const _NavigationPreview({
    required this.title,
    required this.builder,
    this.customTheme,
  });

  @override
  State<_NavigationPreview> createState() => _NavigationPreviewState();
}

class _NavigationPreviewState extends State<_NavigationPreview> {
  String _selectedId = 'home';

  final List<VooNavigationItem> _items = const [
    VooNavigationItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      route: '/home',
    ),
    VooNavigationItem(
      id: 'explore',
      label: 'Explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      route: '/explore',
      badgeCount: 3,
    ),
    VooNavigationItem(
      id: 'library',
      label: 'Library',
      icon: Icons.library_books_outlined,
      selectedIcon: Icons.library_books,
      route: '/library',
    ),
    VooNavigationItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      route: '/profile',
      showDot: true,
    ),
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: widget.title,
      theme: widget.customTheme ??
          ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
      home: widget.builder(
        _items,
        _selectedId,
        (id) => setState(() => _selectedId = id),
      ),
    );
}

/// Helper widget for section titles
Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );