# VooNavigation 🧭

[![Version](https://img.shields.io/badge/version-0.0.6-blue)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![Material 3](https://img.shields.io/badge/Material%203-compliant-green)](https://m3.material.io)

A comprehensive, adaptive navigation package for Flutter that automatically adjusts to different screen sizes and platforms with Material 3 design. Features a modern, production-ready UI inspired by leading SaaS applications like Notion, Linear, and Figma.

## ✨ Features

- **🎯 Fully Adaptive**: Automatically switches between navigation types based on screen size
  - Bottom Navigation (< 600px)
  - Navigation Rail (600-840px)
  - Extended Navigation Rail (840-1240px)
  - Navigation Drawer (> 1240px)

- **🎨 Modern Dark Theme**: Professional dark sidebar design with sophisticated color palette
- **🚀 go_router Integration**: Native integration with StatefulNavigationShell
- **🔔 Rich Navigation Items**: Badges, dropdowns, custom icons, tooltips
- **✨ Smooth Animations**: AnimatedSwitcher for icon transitions, micro-interactions
- **💎 Production Ready**: Battle-tested UI matching modern SaaS applications
- **🛠️ Extensive Customization**: Colors, shapes, elevations, headers, footers
- **♿ Accessibility**: Full semantic labels and focus management
- **📱 Platform Agnostic**: Works seamlessly across all platforms

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_navigation: ^0.0.6
  # Or for local development:
  # voo_navigation:
  #   path: packages/ui/voo_navigation
```

## 🚀 Quick Start

### With go_router (Recommended)

```dart
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/voo_navigation.dart';

// 1. Define your router with StatefulShellRoute
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Pass the navigation shell to your scaffold
        return ScaffoldWithNavigation(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomePage(),
              routes: [
                // Nested routes
                GoRoute(
                  path: 'details',
                  builder: (context, state) => HomeDetailsPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// 2. Create your navigation scaffold
class ScaffoldWithNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavigation({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final items = [
      VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        badgeCount: 3,
      ),
      VooNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
      ),
    ];

    return VooAdaptiveScaffold(
      config: VooNavigationConfig(
        items: items,
        selectedId: items[navigationShell.currentIndex].id,
        onNavigationItemSelected: (itemId) {
          final index = items.indexWhere((item) => item.id == itemId);
          if (index != -1) {
            navigationShell.goBranch(index);
          }
        },
      ),
      body: navigationShell,  // Pass the shell as body
    );
  }
}

// 3. Use with MaterialApp.router
MaterialApp.router(
  routerConfig: router,
)
```

## 🎯 Navigation Types

### Bottom Navigation (Mobile)
Automatically used on screens < 600px wide. Perfect for mobile devices.

### Navigation Rail (Tablet)
Used on screens 600-840px. Ideal for tablets in portrait mode.

### Extended Navigation Rail (Small Laptop)
Used on screens 840-1240px. Shows labels alongside icons.

### Navigation Drawer (Desktop)
Used on screens > 1240px. Full-featured drawer with sections and headers.

## 🛠️ Customization

### Navigation Items

```dart
VooNavigationItem(
  id: 'unique_id',
  label: 'Display Label',
  icon: Icons.icon_outlined,
  selectedIcon: Icons.icon,  // Optional different icon when selected
  
  // Badges
  badgeCount: 5,              // Shows "5"
  badgeText: 'NEW',           // Custom badge text
  showDot: true,              // Simple notification dot
  badgeColor: Colors.red,     // Custom badge color
  
  // Navigation
  route: '/route',            // Route to navigate to
  destination: CustomWidget(), // Or custom widget
  onTap: () {},               // Custom callback
  
  // Customization
  tooltip: 'Custom tooltip',
  iconColor: Colors.blue,
  selectedIconColor: Colors.green,
  labelStyle: TextStyle(...),
  isEnabled: true,
  isVisible: true,
  sortOrder: 0,
  
  // Children for sections
  children: [...],            // Nested items for dropdowns
  isExpanded: true,           // Start expanded
)
```

### Configuration Options

```dart
VooNavigationConfig(
  // Core
  items: [...],
  selectedId: 'current_id',
  
  // Behavior
  isAdaptive: true,           // Auto-adapt to screen size
  forcedNavigationType: NavigationType.rail,  // Override adaptive
  
  // Animation
  enableAnimations: true,
  animationDuration: Duration(milliseconds: 300),
  animationCurve: Curves.easeInOut,
  
  // Appearance
  railLabelType: NavigationRailLabelType.selected,
  useExtendedRail: true,
  showNavigationRailDivider: true,
  centerAppBarTitle: false,
  
  // Colors (v0.0.5 defaults to modern dark theme)
  backgroundColor: Colors.white,
  navigationBackgroundColor: Color(0xFF1F2937), // Professional dark gray
  selectedItemColor: Theme.of(context).colorScheme.primary,
  unselectedItemColor: Colors.white.withValues(alpha: 0.8),
  indicatorColor: Colors.primary.withValues(alpha: 0.12),
  
  // Custom Widgets
  drawerHeader: CustomHeader(),
  drawerFooter: CustomFooter(),
  appBarLeading: CustomLeading(),
  appBarActions: [...],
  floatingActionButton: FAB(),
  
  // Callbacks
  onNavigationItemSelected: (itemId) {...},
)
```

## 📱 Responsive Breakpoints

The package uses Material 3 breakpoints by default:

| Breakpoint | Width | Navigation Type |
|------------|-------|----------------|
| Compact | < 600px | Bottom Navigation |
| Medium | 600-840px | Navigation Rail |
| Expanded | 840-1240px | Extended Rail |
| Large | 1240-1440px | Navigation Drawer |
| Extra Large | > 1440px | Navigation Drawer |

You can customize breakpoints:

```dart
VooNavigationConfig(
  breakpoints: [
    VooBreakpoint(
      minWidth: 0,
      maxWidth: 500,
      navigationType: VooNavigationType.bottomNavigation,
      columns: 4,
      margin: EdgeInsets.all(16),
      gutter: 8,
    ),
    // Add more custom breakpoints
  ],
)
```

## 🎨 Theming

The package fully integrates with your app's theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    navigationBarTheme: NavigationBarThemeData(...),
    navigationRailTheme: NavigationRailThemeData(...),
    drawerTheme: DrawerThemeData(...),
  ),
)
```

## 🔔 Badges & Notifications

Show badges on navigation items:

```dart
// Count badge
VooNavigationItem(
  badgeCount: 10,  // Shows "10"
)

// Custom text badge
VooNavigationItem(
  badgeText: 'NEW',
  badgeColor: Colors.orange,
)

// Simple dot indicator
VooNavigationItem(
  showDot: true,
  badgeColor: Colors.red,
)
```

## 📂 Sections & Groups

Organize items into sections:

```dart
VooNavigationItem.section(
  label: 'Communication',
  children: [
    VooNavigationItem(id: 'messages', ...),
    VooNavigationItem(id: 'email', ...),
  ],
  isExpanded: true,
)
```

## 🎭 Animations

All transitions are animated by default (enhanced in v0.0.5):

- Navigation type changes with smooth transitions
- Item selection with AnimatedSwitcher (200ms)
- Badge updates with scale animations
- Drawer/rail expansion with easing curves
- FAB position changes with Material 3 motion
- Icon transitions between selected/unselected states
- Hover effects with subtle opacity changes (5% overlay)

Control animations:

```dart
VooNavigationConfig(
  enableAnimations: false,  // Disable all animations
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.elasticOut,
)
```

## 📱 Example App

Check out the example apps for complete demonstrations:

```bash
cd packages/ui/voo_navigation/example

# Run the main example
flutter run

# Run the modern dashboard example (v0.0.5)
flutter run lib/modern_dashboard_example.dart

# Run the go_router integration example
flutter run lib/go_router_example.dart
```

## 🏗️ Architecture

The package follows clean architecture with Atomic Design Pattern:

```
lib/
├── src/
│   ├── domain/
│   │   └── entities/        # Core business entities
│   │       ├── navigation_config.dart
│   │       ├── navigation_item.dart
│   │       ├── navigation_route.dart  # go_router integration (v0.0.4+)
│   │       └── navigation_type.dart
│   └── presentation/
│       ├── organisms/        # Complex components
│       │   ├── voo_adaptive_scaffold.dart
│       │   ├── voo_adaptive_navigation_rail.dart
│       │   └── voo_adaptive_navigation_drawer.dart
│       ├── molecules/        # Composite components
│       ├── atoms/           # Basic components
│       └── utils/           # Animation utilities
```

## 🧪 Testing

Run tests:

```bash
flutter test
```

## 📝 License

This package is part of the VooFlutter ecosystem.

## 📊 Version History

- **0.0.6** - Updated go_router dependency to ^16.2.2
- **0.0.5** - Visual design overhaul, UX improvements, bug fixes
- **0.0.4** - go_router integration, Material You support
- **0.0.3** - Package maintenance
- **0.0.2** - Animation enhancements, badge system refinements
- **0.0.1** - Initial release

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in `rules.md`.

## 🆕 What's New in v0.0.5

### Visual Design Overhaul
- Professional dark sidebar design (#1F2937 light, #1A1D23 dark)
- Selection states with primary color at 12% opacity
- Subtle borders and improved shadows
- Reduced hover effects to 5% white overlay

### UX Improvements
- AnimatedSwitcher for smooth icon transitions (200ms)
- Better visual hierarchy with theme-aware colors
- Optimized typography (600 weight selected, 400 unselected)
- Enhanced micro-animations for state changes

### Bug Fixes
- Fixed RenderFlex overflow in bottom navigation
- Resolved window.dart assertion errors in web platform
- Corrected padding and margin calculations
- Fixed icon sizes to prevent overflow (20-22px range)

## 🐛 Issues

Report issues on the [GitHub repository](https://github.com/VooFlutter/voo_navigation).

---

Built with ❤️ by the VooFlutter team