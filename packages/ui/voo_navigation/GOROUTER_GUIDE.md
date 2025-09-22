# VooNavigation with go_router Integration

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Create navigation with Material You theme
    final navigationBuilder = VooNavigationBuilder.materialYou(
      context: context,
      seedColor: Colors.deepPurple,
    )
      ..addItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        route: '/home',
      )
      ..addItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        route: '/profile',
      );

    // 2. Add pages
    navigationBuilder
      ..addPage(id: 'home', path: '/home', page: HomePage())
      ..addPage(id: 'profile', path: '/profile', page: ProfilePage());

    // 3. Build router
    final router = navigationBuilder.buildRouter(
      initialLocation: '/home',
    );

    // 4. Use with MaterialApp.router
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```

## Key Features

### 🎨 Material You Design by Default
- Beautiful out-of-the-box theme with Material 3 design
- Adaptive navigation that switches between:
  - Bottom Navigation (mobile < 600px)
  - Navigation Rail (tablet 600-1240px)
  - Navigation Drawer (desktop > 1240px)

### 🚀 Developer-Friendly API
- Fluent builder pattern for easy configuration
- Automatic route generation from navigation items
- Built-in page transitions and animations
- Type-safe navigation with go_router

### ✨ Rich Navigation Features
- Badge support (counts, dots, custom text)
- Sections with expandable groups
- Custom headers and footers
- Haptic feedback
- Smooth animations

## Advanced Usage

### Custom Transitions

```dart
// Fade transition
VooNavigationRoute.fade(
  id: 'settings',
  path: '/settings',
  builder: (context, state) => SettingsPage(),
);

// Slide transition
VooNavigationRoute.slide(
  id: 'details',
  path: '/details',
  builder: (context, state) => DetailsPage(),
);

// Scale transition
VooNavigationRoute.scale(
  id: 'modal',
  path: '/modal',
  builder: (context, state) => ModalPage(),
);
```

### Navigation with Badges

```dart
VooNavigationBuilder()
  ..addItem(
    id: 'notifications',
    label: 'Notifications',
    icon: Icons.notifications_outlined,
    badgeCount: 12,  // Shows "12"
  )
  ..addItem(
    id: 'messages',
    label: 'Messages',
    icon: Icons.message_outlined,
    showDot: true,  // Shows a dot
    badgeColor: Colors.red,
  )
  ..addItem(
    id: 'updates',
    label: 'Updates',
    icon: Icons.update,
    badgeText: 'NEW',  // Shows custom text
    badgeColor: Colors.orange,
  );
```

### Grouped Navigation

```dart
VooNavigationBuilder()
  ..addSection(
    label: 'Communication',
    children: [
      VooNavigationItem(
        id: 'chat',
        label: 'Chat',
        icon: Icons.chat,
        route: '/chat',
      ),
      VooNavigationItem(
        id: 'email',
        label: 'Email',
        icon: Icons.email,
        route: '/email',
      ),
    ],
  );
```

### Custom Drawer Header/Footer

```dart
VooNavigationBuilder()
  ..drawerHeader(
    Container(
      height: 200,
      child: UserProfile(),
    ),
  )
  ..drawerFooter(
    ListTile(
      leading: Icon(Icons.logout),
      title: Text('Logout'),
      onTap: () => signOut(),
    ),
  );
```

### Programmatic Navigation

```dart
// Using go_router directly
context.go('/settings');
context.push('/details');

// Using VooNavigation extension
context.vooNavigateTo('settings');
```

## API Reference

### VooNavigationBuilder

Factory methods:
- `VooNavigationBuilder()` - Default builder
- `VooNavigationBuilder.materialYou()` - Material You themed builder

Configuration methods:
- `addItem()` - Add navigation item
- `addSection()` - Add grouped section
- `addDivider()` - Add visual separator
- `addPage()` - Add page with route
- `selectedId()` - Set initial selection
- `theme()` - Custom theme
- `enableAnimations()` - Toggle animations
- `enableHapticFeedback()` - Toggle haptics
- `floatingActionButton()` - Set FAB

Build methods:
- `buildConfig()` - Get VooNavigationConfig
- `buildRouter()` - Get configured GoRouter

### VooNavigationRoute

Factory constructors:
- `VooNavigationRoute.material()` - Material page transition
- `VooNavigationRoute.fade()` - Fade transition
- `VooNavigationRoute.slide()` - Slide transition
- `VooNavigationRoute.scale()` - Scale transition
- `VooNavigationRoute.custom()` - Custom transition

### VooGoRouter

Static methods:
- `VooGoRouter.create()` - Create with routes
- `VooGoRouter.fromNavigationItems()` - Auto-generate routes
- `VooGoRouter.simple()` - Simple page mapping

### VooNavigationShell

The shell widget that wraps your content and provides:
- Automatic route synchronization
- Animated content transitions
- State preservation
- Navigation callbacks

## Best Practices

1. **Use Material You theme** for consistent, beautiful design
2. **Group related items** in sections for better organization
3. **Add badges** for important notifications
4. **Provide tooltips** for accessibility
5. **Use semantic labels** for screen readers
6. **Enable haptic feedback** for better UX
7. **Keep navigation items under 7** for cognitive load

## Migration from Standard Navigation

Before:
```dart
Navigator.pushNamed(context, '/settings');
```

After:
```dart
context.go('/settings');  // With go_router
```

Before:
```dart
BottomNavigationBar(
  items: [...],
  onTap: (index) {...},
)
```

After:
```dart
VooNavigationBuilder()
  ..addItem(...)
  ..buildRouter()
```

## Performance Tips

- Routes are lazy-loaded by default
- Animations are hardware-accelerated
- State is preserved during navigation
- Responsive breakpoints are optimized
- Badge updates are debounced

## Troubleshooting

**Issue:** Navigation doesn't update on route change
**Solution:** Ensure routes match navigation item paths

**Issue:** Animations are janky
**Solution:** Check if `enableAnimations` is true

**Issue:** Badges not showing
**Solution:** Verify `showNotificationBadges` is enabled

**Issue:** Custom pages not loading
**Solution:** Ensure `addPage()` is called with correct path