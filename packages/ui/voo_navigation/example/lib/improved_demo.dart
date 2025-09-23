import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

/// Demonstrates the improved navigation rail with better visual design
class ImprovedNavigationDemo extends StatefulWidget {
  const ImprovedNavigationDemo({super.key});

  @override
  State<ImprovedNavigationDemo> createState() => _ImprovedNavigationDemoState();
}

class _ImprovedNavigationDemoState extends State<ImprovedNavigationDemo> {
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
      ),
      const VooNavigationItem(
        id: 'explore',
        label: 'Explore',
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        route: '/explore',
        badgeCount: 3,
        badgeColor: Colors.red,
      ),
      const VooNavigationItem(
        id: 'library',
        label: 'Library',
        icon: Icons.library_books_outlined,
        selectedIcon: Icons.library_books,
        route: '/library',
      ),
      const VooNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        route: '/profile',
        showDot: true,
        badgeColor: Colors.red,
      ),
    ];

    final config = VooNavigationConfig(
      items: navigationItems,
      selectedId: _selectedId,
      enableAnimations: true,
      enableHapticFeedback: true,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOutCubic,
      navigationBackgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
      onNavigationItemSelected: (id) {
        setState(() {
          _selectedId = id;
        });
      },
    );

    return MaterialApp(
      title: 'Improved Navigation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: VooAdaptiveScaffold(
        config: config,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContent(_selectedId),
        ),
      ),
    );
  }

  Widget _buildContent(String selectedId) {
    return Container(
      key: ValueKey(selectedId),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForId(selectedId),
              size: 120,
              color: Theme.of(context).colorScheme.primary.withAlpha(102),
            ),
            const SizedBox(height: 24),
            Text(
              _getTitleForId(selectedId),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Navigation Rail - ${_getLayoutType()}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You are on the $_selectedId page'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Show Info'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForId(String id) {
    switch (id) {
      case 'home':
        return Icons.home;
      case 'explore':
        return Icons.explore;
      case 'library':
        return Icons.library_books;
      case 'profile':
        return Icons.person;
      default:
        return Icons.home;
    }
  }

  String _getTitleForId(String id) {
    switch (id) {
      case 'home':
        return 'Welcome Home';
      case 'explore':
        return 'Explore Content';
      case 'library':
        return 'Your Library';
      case 'profile':
        return 'Your Profile';
      default:
        return 'Navigation Demo';
    }
  }

  String _getLayoutType() {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 'Mobile';
    } else if (width < 840) {
      return 'Compact';
    } else if (width < 1240) {
      return 'Extended';
    } else {
      return 'Desktop';
    }
  }
}
