# VooNavigation 🧭

A comprehensive, adaptive navigation package for Flutter that automatically adjusts to different screen sizes and platforms with Material 3 design.

## ✨ Features

- **🎯 Fully Adaptive**: Automatically switches between navigation types based on screen size
  - Bottom Navigation (< 600px)
  - Navigation Rail (600-840px)
  - Extended Navigation Rail (840-1240px)
  - Navigation Drawer (> 1240px)

- **🎨 Material 3 Design**: Full compliance with latest Material Design guidelines
- **🔔 Rich Navigation Items**: Badges, dropdowns, custom icons, tooltips
- **✨ Beautiful Animations**: Smooth transitions with customizable duration and curves
- **🛠️ Extensive Customization**: Colors, shapes, elevations, headers, footers
- **♿ Accessibility**: Full semantic labels and focus management
- **📱 Platform Agnostic**: Works seamlessly across all platforms

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_navigation:
    path: packages/ui/voo_navigation  # For local development
```

## 🚀 Quick Start

```dart
import 'package:voo_navigation/voo_navigation.dart';

// Define navigation items
final navigationItems = [
  VooNavigationItem(
    id: 'home',
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    route: '/home',
    badgeCount: 3,  // Shows badge with count
  ),
  VooNavigationItem(
    id: 'search',
    label: 'Search',
    icon: Icons.search,
    route: '/search',
    showDot: true,  // Shows notification dot
    badgeColor: Colors.red,
  ),
];

// Create configuration
final config = VooNavigationConfig(
  items: navigationItems,
  selectedId: 'home',
  enableAnimations: true,
  enableHapticFeedback: true,
  onNavigationItemSelected: (itemId) {
    // Handle navigation
  },
);

// Build adaptive scaffold
@override
Widget build(BuildContext context) {
  return VooAdaptiveScaffold(
    config: config,
    body: YourContentWidget(),
  );
}
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
  
  // Colors
  backgroundColor: Colors.white,
  navigationBackgroundColor: Colors.grey[50],
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  indicatorColor: Colors.blue.withOpacity(0.1),
  
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

All transitions are animated by default:

- Navigation type changes
- Item selection
- Badge updates
- Drawer/rail expansion
- FAB position changes

Control animations:

```dart
VooNavigationConfig(
  enableAnimations: false,  // Disable all animations
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.elasticOut,
)
```

## 📱 Example App

Check out the example app for a complete demonstration:

```bash
cd packages/ui/voo_navigation/example
flutter run
```

## 🏗️ Architecture

The package follows clean architecture principles:

```
lib/
├── src/
│   ├── domain/
│   │   └── entities/        # Core business entities
│   ├── data/
│   │   └── models/          # Data models
│   └── presentation/
│       ├── organisms/        # Complex components
│       ├── molecules/        # Composite components
│       ├── atoms/           # Basic components
│       └── utils/           # Utilities
```

## 🧪 Testing

Run tests:

```bash
flutter test
```

## 📝 License

This package is part of the VooFlutter ecosystem.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in `rules.md`.

## 🐛 Issues

Report issues on the [GitHub repository](https://github.com/VooFlutter/voo_navigation).

---

Built with ❤️ by the VooFlutter team