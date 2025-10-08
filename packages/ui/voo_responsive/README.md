# VooResponsive

A comprehensive responsive design system for Flutter applications, providing breakpoints, responsive builders, and adaptive layouts.

## Features

### ✅ Currently Available
- 🎯 Breakpoint-based responsive system with `ScreenInfo`
- 📱 Mobile-first design approach with device type detection
- 🔧 `VooResponsiveBuilder` for adaptive UI
- 📊 Screen size utilities and extensions
- 🔄 Orientation detection
- 💾 Type-safe responsive values with `ResponsiveValue<T>`
- 🎨 Integration with VooTokens design system
- ⚡ Performance optimized with LayoutBuilder

### 🚧 Planned Features
- Responsive layouts (Row, Column, Grid, Wrap)
- Breakpoint and orientation builders
- Helper widgets (Visibility, Padding, Text, Gap)
- Responsive scaffold and layout components
- Responsive theming support

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_responsive:
    path: packages/ui/voo_responsive
```

## Usage

### VooResponsiveBuilder

Build different widgets based on screen size information:

```dart
import 'package:voo_responsive/voo_responsive.dart';

VooResponsiveBuilder(
  builder: (context, screenInfo) {
    if (screenInfo.isMobileLayout) {
      return MobileLayout();
    } else if (screenInfo.isTabletLayout) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### ScreenInfo

Access comprehensive screen information:

```dart
VooResponsiveBuilder(
  builder: (context, screenInfo) {
    return Column(
      children: [
        Text('Device Type: ${screenInfo.deviceType}'),
        Text('Screen Size: ${screenInfo.screenSize}'),
        Text('Orientation: ${screenInfo.orientation}'),
        Text('Width: ${screenInfo.width}px'),
        Text('Height: ${screenInfo.height}px'),
        Text('Is Mobile: ${screenInfo.isMobileLayout}'),
        Text('Is Tablet: ${screenInfo.isTabletLayout}'),
        Text('Is Desktop: ${screenInfo.isDesktopLayout}'),
      ],
    );
  },
)
```

### ResponsiveValue

Define type-safe responsive values that adapt to screen size:

```dart
// Define responsive padding
final padding = ResponsiveValue<double>(
  mobile: 8,
  tablet: 16,
  desktop: 24,
  widescreen: 32,
);

// Use in widget
VooResponsiveBuilder(
  builder: (context, screenInfo) {
    return Padding(
      padding: EdgeInsets.all(
        padding.getValueForWidth(screenInfo.width),
      ),
      child: content,
    );
  },
)
```

### Responsive Extensions

Use convenient extensions on BuildContext:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return MobileView();
    } else if (context.isTablet) {
      return TabletView();
    } else {
      return DesktopView();
    }
  }
}
```

### VooResponsiveController

Access responsive tokens and screen info via controller:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VooResponsiveController(),
      child: Builder(
        builder: (context) {
          final controller = context.watch<VooResponsiveController>();
          controller.updateScreenInfo(context);

          return MaterialApp(
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}
```

## Breakpoint System

Default breakpoints:

| Breakpoint | Range (px) |
|------------|------------|
| Mobile     | 0 - 599    |
| Tablet     | 600 - 1023 |
| Desktop    | 1024 - 1439|
| Widescreen | 1440+      |

## Core Components

### Available Now

#### Builders
- **`VooResponsiveBuilder`** - Build different widgets based on screen information
  - Provides access to `ScreenInfo` with device type, screen size, and orientation
  - Uses `LayoutBuilder` for efficient responsive updates

#### Entities
- **`ScreenInfo`** - Comprehensive screen information
  - Device type (mobile, tablet, desktop, widescreen)
  - Screen size (extraSmall, small, medium, large, extraLarge)
  - Orientation (portrait, landscape)
  - Width, height, pixel ratio
  - Safe area padding
  - Layout type helpers (isMobileLayout, isTabletLayout, isDesktopLayout)

- **`ResponsiveValue<T>`** - Type-safe responsive values
  - Define different values for each breakpoint
  - Automatic value selection based on screen width
  - Fallback to mobile value if specific breakpoint not defined

- **`Breakpoint`** - Breakpoint configuration
  - Define custom breakpoints with min/max width
  - Named breakpoints for easy reference

#### Enums
- **`DeviceType`** - mobile, tablet, desktop, widescreen, watch, tv, custom
- **`OrientationType`** - portrait, landscape
- **`ScreenSize`** - extraSmall, small, medium, large, extraLarge

#### Extensions
- **`ResponsiveExtensions`** on `BuildContext`
  - `screenWidth` / `screenHeight` - Quick access to dimensions
  - `isMobile` / `isTablet` / `isDesktop` / `isWidescreen` - Breakpoint checks

#### State Management
- **`VooResponsiveController`** - Controller for managing responsive state
  - Updates screen info on layout changes
  - Provides access to responsive tokens from VooTokens

### Coming Soon

The following components are planned but not yet implemented:

- `VooBreakpointBuilder` - Build based on specific breakpoints
- `VooOrientationBuilder` - Build based on device orientation
- `VooResponsiveRow` / `VooResponsiveColumn` - Adaptive flex layouts
- `VooResponsiveGrid` - Responsive grid system
- `VooResponsiveWrap` - Adaptive wrap layout
- `VooResponsiveVisibility` - Show/hide widgets by breakpoint
- `VooResponsivePadding` - Adaptive padding widget
- `VooResponsiveText` - Responsive text scaling
- `VooResponsiveGap` - Adaptive spacing widget
- `VooResponsiveLayout` - Advanced layout orchestration
- `VooResponsiveScaffold` - Adaptive scaffold
- `ResponsiveTheme` - Responsive theming support

## Configuration

### Custom Breakpoints

You can define custom breakpoints using the `Breakpoint` class:

```dart
const customBreakpoint = Breakpoint(
  name: 'custom',
  minWidth: 768,
  maxWidth: 1024,
);
```

### Responsive Configuration

Use `ResponsiveConfig` to define your app's responsive behavior:

```dart
const config = ResponsiveConfig(
  defaultBreakpoints: [
    Breakpoint(name: 'mobile', minWidth: 0, maxWidth: 599),
    Breakpoint(name: 'tablet', minWidth: 600, maxWidth: 1023),
    Breakpoint(name: 'desktop', minWidth: 1024, maxWidth: 1439),
    Breakpoint(name: 'widescreen', minWidth: 1440),
  ],
);
```

Note: Global configuration API is coming in a future release.

## Integration with VooTokens

VooResponsive integrates seamlessly with the VooTokens design system. The `VooResponsiveController` automatically provides access to responsive tokens:

```dart
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

// Using ResponsiveTokens with VooResponsiveBuilder
VooResponsiveBuilder(
  builder: (context, screenInfo) {
    // Get responsive tokens based on screen width
    final tokens = ResponsiveTokens.forScreenWidth(
      screenInfo.width,
      isDark: Theme.of(context).brightness == Brightness.dark,
    );

    return Container(
      padding: EdgeInsets.all(tokens.spacing.medium),
      child: Text(
        'Responsive Content',
        style: TextStyle(fontSize: tokens.typography.bodyLarge.fontSize),
      ),
    );
  },
)

// Using VooResponsiveController for centralized token management
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VooResponsiveController(),
      child: Consumer<VooResponsiveController>(
        builder: (context, controller, _) {
          controller.updateScreenInfo(context);

          return MaterialApp(
            home: Builder(
              builder: (context) {
                final responsiveTokens = controller.responsiveTokens;
                return Container(
                  padding: EdgeInsets.all(responsiveTokens?.spacing.medium ?? 16),
                  child: MyHomePage(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

## Testing

Test responsive behavior at different screen sizes:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_responsive/voo_responsive.dart';

void main() {
  testWidgets('VooResponsiveBuilder provides correct screen info', (tester) async {
    // Set mobile screen size
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      MaterialApp(
        home: VooResponsiveBuilder(
          builder: (context, screenInfo) {
            return Column(
              children: [
                Text('Device: ${screenInfo.deviceType}'),
                Text('Is Mobile: ${screenInfo.isMobileLayout}'),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('Device: DeviceType.mobile'), findsOneWidget);
    expect(find.text('Is Mobile: true'), findsOneWidget);

    // Test tablet size
    await tester.binding.setSurfaceSize(const Size(768, 1024));
    await tester.pumpAndSettle();

    expect(find.text('Device: DeviceType.tablet'), findsOneWidget);
    expect(find.text('Is Mobile: false'), findsOneWidget);
  });

  test('ResponsiveValue returns correct value for width', () {
    final value = ResponsiveValue<double>(
      mobile: 8,
      tablet: 16,
      desktop: 24,
      widescreen: 32,
    );

    expect(value.getValueForWidth(400), 8);   // Mobile
    expect(value.getValueForWidth(768), 16);  // Tablet
    expect(value.getValueForWidth(1200), 24); // Desktop
    expect(value.getValueForWidth(1600), 32); // Widescreen
  });

  test('ScreenInfo detects device type correctly', () {
    expect(ScreenInfo._getDeviceType(400), DeviceType.mobile);
    expect(ScreenInfo._getDeviceType(768), DeviceType.tablet);
    expect(ScreenInfo._getDeviceType(1200), DeviceType.desktop);
    expect(ScreenInfo._getDeviceType(1600), DeviceType.widescreen);
  });
}
```

## Best Practices

1. **Mobile-First Design**: Start with mobile layout and enhance for larger screens
   ```dart
   VooResponsiveBuilder(
     builder: (context, screenInfo) {
       // Define mobile layout first
       Widget content = MobileLayout();

       // Enhance for larger screens
       if (screenInfo.isTabletLayout) {
         content = TabletLayout();
       } else if (screenInfo.isDesktopLayout) {
         content = DesktopLayout();
       }

       return content;
     },
   )
   ```

2. **Use ResponsiveValue for Scalable Design**: Define responsive values for consistent scaling
   ```dart
   final spacing = ResponsiveValue<double>(
     mobile: 8,
     tablet: 12,
     desktop: 16,
     widescreen: 20,
   );
   ```

3. **Leverage Context Extensions**: Use extensions for quick breakpoint checks
   ```dart
   if (context.isMobile) {
     // Mobile-specific logic
   }
   ```

4. **Test Across Breakpoints**: Always test your responsive layouts at each breakpoint
5. **Consider Touch Targets**: Ensure minimum 44x44 touch targets on mobile
6. **Optimize Performance**: `VooResponsiveBuilder` uses `LayoutBuilder` for efficient updates

## API Reference

### ScreenInfo Properties

| Property | Type | Description |
|----------|------|-------------|
| `width` | `double` | Screen width in logical pixels |
| `height` | `double` | Screen height in logical pixels |
| `pixelRatio` | `double` | Device pixel ratio |
| `orientation` | `OrientationType` | Portrait or landscape |
| `deviceType` | `DeviceType` | Current device type |
| `screenSize` | `ScreenSize` | Current screen size category |
| `safeAreaPadding` | `EdgeInsets` | Safe area insets |
| `textScaler` | `TextScaler` | System text scaling |
| `brightness` | `Brightness` | System brightness (light/dark) |
| `isMobileLayout` | `bool` | True if mobile device |
| `isTabletLayout` | `bool` | True if tablet device |
| `isDesktopLayout` | `bool` | True if desktop or widescreen |
| `isPortrait` | `bool` | True if portrait orientation |
| `isLandscape` | `bool` | True if landscape orientation |
| `aspectRatio` | `double` | Width / height ratio |

## Current Status & Roadmap

### Version 0.1.4 (Current)

**Implemented:**
- ✅ Core responsive system with ScreenInfo
- ✅ VooResponsiveBuilder widget
- ✅ ResponsiveValue for type-safe responsive values
- ✅ Device type and screen size detection
- ✅ Orientation detection
- ✅ Context extensions for quick breakpoint checks
- ✅ VooTokens integration via VooResponsiveController
- ✅ Comprehensive breakpoint system

**In Progress:**
- 🚧 Additional responsive widgets (Grid, Row, Column, Wrap)
- 🚧 Helper widgets (Visibility, Padding, Text, Gap)
- 🚧 Specialized builders (Breakpoint, Orientation)
- 🚧 Adaptive scaffold and layout components

### Future Enhancements

- Custom breakpoint configuration system
- Advanced responsive animations
- Foldable device support
- Dynamic island/notch detection
- Platform-specific responsive behaviors
- Responsive state persistence
- Enhanced DevTools integration

## Contributing

Contributions are welcome! This package is part of the VooFlutter ecosystem. Please follow the contribution guidelines in the main repository.

## Support

For issues, feature requests, or questions:
- Open an issue on [GitHub](https://github.com/voostack/voo_flutter/issues)
- Check the [documentation](https://github.com/voostack/voo_flutter)

## License

MIT License - see [LICENSE](LICENSE) file for details.