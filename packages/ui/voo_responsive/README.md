# VooResponsive

A comprehensive responsive design system for Flutter applications, providing breakpoints, responsive builders, and adaptive layouts.

## Features

- 🎯 Breakpoint-based responsive system
- 📱 Mobile-first design approach
- 🔧 Responsive builders for adaptive UI
- 📐 Responsive layouts (Row, Column, Grid, Wrap)
- 🎨 Integration with design token system
- 🔄 Orientation-aware building
- 📊 Screen size utilities
- ⚡ Performance optimized

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_responsive:
    path: packages/ui/voo_responsive
```

## Usage

### Basic Responsive Builder

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

### Breakpoint Builder

```dart
VooBreakpointBuilder(
  mobile: (context) => MobileView(),
  tablet: (context) => TabletView(),
  desktop: (context) => DesktopView(),
  widescreen: (context) => WidescreenView(),
)
```

### Responsive Visibility

```dart
VooResponsiveVisibility(
  visibleOn: [DeviceType.mobile, DeviceType.tablet],
  child: MobileOnlyWidget(),
)
```

### Responsive Grid

```dart
VooResponsiveGrid(
  children: items,
  config: ResponsiveGridConfig(
    mobileColumns: 2,
    tabletColumns: 3,
    desktopColumns: 4,
    widescreenColumns: 6,
  ),
)
```

### Using Responsive Controller

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = VooResponsiveController.of(context);

    return Container(
      padding: EdgeInsets.all(
        controller.value(
          mobile: 8,
          tablet: 16,
          desktop: 24,
        ),
      ),
      child: content,
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

## Components

### Builders
- `VooResponsiveBuilder` - Build widgets based on screen info
- `VooBreakpointBuilder` - Build based on specific breakpoints
- `VooOrientationBuilder` - Build based on device orientation

### Layouts
- `VooResponsiveRow` - Adaptive row layout
- `VooResponsiveColumn` - Adaptive column layout
- `VooResponsiveGrid` - Responsive grid system
- `VooResponsiveWrap` - Adaptive wrap layout

### Utilities
- `VooResponsiveVisibility` - Show/hide widgets responsively
- `VooResponsivePadding` - Adaptive padding
- `VooResponsiveText` - Responsive text scaling
- `VooResponsiveGap` - Adaptive spacing

## Configuration

```dart
VooResponsive.configure(
  config: ResponsiveConfig(
    breakpoints: [
      Breakpoint(name: 'xs', minWidth: 0, maxWidth: 479),
      Breakpoint(name: 'sm', minWidth: 480, maxWidth: 767),
      Breakpoint(name: 'md', minWidth: 768, maxWidth: 1023),
      Breakpoint(name: 'lg', minWidth: 1024, maxWidth: 1279),
      Breakpoint(name: 'xl', minWidth: 1280),
    ],
    enableAdaptiveLayout: true,
    enableOrientationChanges: true,
  ),
)
```

## Integration with VooTokens

VooResponsive integrates seamlessly with the VooTokens design system:

```dart
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

VooResponsiveBuilder(
  builder: (context, screenInfo) {
    final tokens = Theme.of(context).extension<VooTokensThemeExtension>()!;

    return Container(
      padding: EdgeInsets.all(
        screenInfo.isMobileLayout
          ? tokens.spacing.xs
          : tokens.spacing.md,
      ),
      child: content,
    );
  },
)
```

## Testing

```dart
testWidgets('Responsive builder adapts to screen size', (tester) async {
  // Test mobile size
  tester.binding.window.physicalSizeTestValue = Size(400, 800);

  await tester.pumpWidget(
    MaterialApp(
      home: VooResponsiveBuilder(
        builder: (context, screenInfo) {
          return Text(screenInfo.deviceType.toString());
        },
      ),
    ),
  );

  expect(find.text('DeviceType.mobile'), findsOneWidget);
});
```

## Best Practices

1. **Mobile-First**: Start with mobile layout and enhance for larger screens
2. **Content Priority**: Prioritize content based on screen size
3. **Touch Targets**: Ensure adequate touch target sizes (minimum 44x44)
4. **Font Scaling**: Use responsive text scaling for readability
5. **Performance**: Minimize rebuilds on screen size changes

## License

MIT License - see [LICENSE](LICENSE) file for details.