# Voo Design System Documentation

The Voo Design System is a modern, flexible design language inspired by Discord and GitHub's clean, professional aesthetics. It provides a comprehensive set of design tokens and components that can be used alongside or instead of Material Design.

## Table of Contents
- [Overview](#overview)
- [Design Philosophy](#design-philosophy)
- [Getting Started](#getting-started)
- [Design Tokens](#design-tokens)
- [Components](#components)
- [Theming](#theming)
- [Migration Guide](#migration-guide)

## Overview

The Voo Design System offers:
- **Dual Design System Support**: Choose between Material Design and Voo Design
- **Modern Aesthetics**: Inspired by Discord and GitHub's design languages
- **Dark Mode First**: Built with dark mode as a primary consideration
- **Comprehensive Tokens**: Complete color, typography, spacing, and animation systems
- **Type-Safe**: Fully typed design tokens for better developer experience
- **Adaptive**: Automatically adapts components based on the selected design system

## Design Philosophy

### Core Principles

1. **Clarity**: Clean, uncluttered interfaces that focus on content
2. **Consistency**: Predictable patterns and behaviors across all components
3. **Accessibility**: WCAG 2.1 AA compliant with focus on readability
4. **Performance**: Lightweight, optimized components with smooth animations
5. **Flexibility**: Adaptable to different brand requirements

### Visual Language

- **Geometric Shapes**: Clean lines and consistent border radii
- **Subtle Shadows**: Depth through subtle elevation rather than heavy shadows
- **Vibrant Accents**: Strategic use of color for important actions
- **Readable Typography**: Clear hierarchy with optimal line heights

## Getting Started

### Installation

The design system is included in the `voo_ui_core` package:

```yaml
dependencies:
  voo_ui_core: ^0.1.0
```

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Choose your design system
    final designSystem = VooDesignSystem(isDarkMode: true);
    // Or use Material: MaterialDesignSystem()
    
    return DesignSystemProvider(
      designSystem: designSystem,
      systemType: DesignSystemType.voo,
      child: MaterialApp(
        theme: designSystem.toThemeData(isDark: false),
        darkTheme: designSystem.toThemeData(isDark: true),
        home: MyHomePage(),
      ),
    );
  }
}
```

### Accessing Design Tokens

```dart
// In your widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access design tokens
    final colors = context.designColors;
    final typography = context.designTypography;
    final spacing = context.designSpacing;
    
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: context.designRadius.card,
      ),
      child: Text(
        'Hello, World!',
        style: typography.headlineMedium.copyWith(
          color: colors.onSurface,
        ),
      ),
    );
  }
}
```

## Design Tokens

### Color System

The Voo color system is semantic and adaptive:

#### Light Theme Colors
```dart
// Primary (GitHub-inspired blue)
primary: #0969DA
onPrimary: #FFFFFF
primaryContainer: #DDF4FF
onPrimaryContainer: #0550AE

// Secondary (Discord-inspired purple)
secondary: #5865F2
onSecondary: #FFFFFF
secondaryContainer: #E3E5FF
onSecondaryContainer: #4752C4

// Success (Green)
success: #1F883D
onSuccess: #FFFFFF
successContainer: #DDFBE2
onSuccessContainer: #116329

// Error (Red)
error: #CF222E
onError: #FFFFFF
errorContainer: #FFEBE9
onErrorContainer: #A40E26

// Surface (Clean whites)
surface: #FFFFFF
onSurface: #1C2128
surfaceVariant: #F6F8FA
onSurfaceVariant: #656D76
```

#### Dark Theme Colors (Discord-inspired)
```dart
// Primary (Discord Blurple)
primary: #5865F2
onPrimary: #FFFFFF
primaryContainer: #4752C4
onPrimaryContainer: #E3E5FF

// Surface (Discord dark backgrounds)
surface: #313338
onSurface: #DBDEE1
surfaceVariant: #2B2D31
onSurfaceVariant: #B5BAC1
background: #1E1F22
```

### Typography Scale

Based on Inter font family with clear hierarchy:

```dart
// Display (57/45/36px)
displayLarge: 57px, weight: 300
displayMedium: 45px, weight: 400
displaySmall: 36px, weight: 400

// Headlines (32/28/24px)
headlineLarge: 32px, weight: 600
headlineMedium: 28px, weight: 600
headlineSmall: 24px, weight: 600

// Titles (22/16/14px)
titleLarge: 22px, weight: 600
titleMedium: 16px, weight: 600
titleSmall: 14px, weight: 600

// Body (16/14/12px)
bodyLarge: 16px, weight: 400
bodyMedium: 14px, weight: 400
bodySmall: 12px, weight: 400

// Labels (14/12/11px)
labelLarge: 14px, weight: 500
labelMedium: 12px, weight: 500
labelSmall: 11px, weight: 500

// Special
code: JetBrains Mono, 14px
button: 14px, weight: 600
```

### Spacing System

8-point grid system:

```dart
xxs: 2px   // Tight spacing
xs:  4px   // Extra small
sm:  8px   // Small (base unit)
md:  16px  // Medium (2x base)
lg:  24px  // Large (3x base)
xl:  32px  // Extra large (4x base)
xxl: 48px  // 2x extra large (6x base)
xxxl: 64px // 3x extra large (8x base)

// Component spacing
buttonPadding: 12px
cardPadding: 16px
inputPadding: 12px
dialogPadding: 24px
```

### Border Radius

Consistent corner radius system:

```dart
none: 0px    // Sharp corners
xs:   2px    // Subtle rounding
sm:   4px    // Small radius
md:   8px    // Medium radius (default)
lg:   12px   // Large radius
xl:   16px   // Extra large
xxl:  24px   // 2x extra large
full: 9999px // Pill shape

// Component radii
button: 8px
card: 12px
input: 8px
dialog: 16px
chip: full
```

### Elevation & Shadows

Subtle elevation system:

```dart
level0: 0  // No elevation
level1: 1  // Slight elevation
level2: 2  // Card elevation
level3: 4  // Raised elevation
level4: 8  // Modal elevation
level5: 16 // Highest elevation

// Shadow examples
shadow1: 0px 1px 2px rgba(0,0,0,0.05)
shadow2: 0px 2px 4px rgba(0,0,0,0.08)
shadow3: 0px 4px 8px rgba(0,0,0,0.12)
```

### Animation Timing

Smooth, responsive animations:

```dart
durationInstant: 50ms   // Instant feedback
durationFast: 150ms     // Quick transitions
durationNormal: 250ms   // Standard animations
durationSlow: 400ms     // Deliberate animations
durationSlowest: 600ms  // Complex animations

// Curves
curveEaseInOut // Standard easing
curveBounce    // Playful bounce
curveElastic   // Elastic effect
```

## Components

### Buttons

Five button variants with consistent styling:

```dart
// Primary Button - Main actions
ElevatedButton(
  style: context.componentStyles.primaryButton,
  onPressed: () {},
  child: Text('Primary Action'),
)

// Secondary Button - Secondary actions
FilledButton(
  style: context.componentStyles.secondaryButton,
  onPressed: () {},
  child: Text('Secondary'),
)

// Tertiary Button - Outlined variant
OutlinedButton(
  style: context.componentStyles.tertiaryButton,
  onPressed: () {},
  child: Text('Tertiary'),
)

// Ghost Button - Minimal style
TextButton(
  style: context.componentStyles.ghostButton,
  onPressed: () {},
  child: Text('Ghost'),
)

// Danger Button - Destructive actions
ElevatedButton(
  style: context.componentStyles.dangerButton,
  onPressed: () {},
  child: Text('Delete'),
)
```

### Form Inputs

Consistent input styling:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
    prefixIcon: Icon(Icons.person),
  ),
)
```

### Cards

Clean card design with subtle elevation:

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(context.designSpacing.cardPadding),
    child: Column(
      children: [
        Text('Card Title', style: context.designTypography.titleMedium),
        SizedBox(height: context.designSpacing.sm),
        Text('Card content goes here', style: context.designTypography.bodyMedium),
      ],
    ),
  ),
)
```

### Chips

Versatile chip components:

```dart
Chip(
  label: Text('Filter'),
  onDeleted: () {},
  avatar: Icon(Icons.filter_list, size: context.designIcons.sizeSm),
)
```

## Theming

### Creating Custom Themes

Extend the design system with your brand:

```dart
class MyBrandDesignSystem extends VooDesignSystem {
  @override
  DesignColorTokens get colors => MyBrandColors();
  
  @override
  DesignTypographyTokens get typography => MyBrandTypography();
}

class MyBrandColors extends VooLightColors {
  @override
  Color get primary => const Color(0xFF00796B); // Custom teal
  
  @override
  Color get secondary => const Color(0xFFFF6F00); // Custom orange
}
```

### Dynamic Theming

Switch themes at runtime:

```dart
class ThemeManager extends ChangeNotifier {
  DesignSystemType _currentSystem = DesignSystemType.voo;
  bool _isDarkMode = false;
  
  DesignSystem get designSystem {
    switch (_currentSystem) {
      case DesignSystemType.voo:
        return VooDesignSystem(isDarkMode: _isDarkMode);
      case DesignSystemType.material:
        return MaterialDesignSystem(isDarkMode: _isDarkMode);
    }
  }
  
  void switchSystem(DesignSystemType system) {
    _currentSystem = system;
    notifyListeners();
  }
  
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
```

## Migration Guide

### From Material to Voo

1. **Update imports**:
```dart
// Before
import 'package:flutter/material.dart';

// After
import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
```

2. **Wrap app with DesignSystemProvider**:
```dart
// Before
MaterialApp(
  theme: ThemeData(),
  home: MyHomePage(),
)

// After
DesignSystemProvider(
  designSystem: VooDesignSystem(),
  systemType: DesignSystemType.voo,
  child: MaterialApp(
    theme: VooDesignSystem().toThemeData(),
    home: MyHomePage(),
  ),
)
```

3. **Update component usage**:
```dart
// Before
Theme.of(context).colorScheme.primary

// After
context.designColors.primary
```

### Supporting Both Systems

Allow users to choose their preferred design system:

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<DesignSystemType>(
          title: Text('Material Design'),
          value: DesignSystemType.material,
          groupValue: context.designSystemType,
          onChanged: (value) {
            // Switch to Material
          },
        ),
        RadioListTile<DesignSystemType>(
          title: Text('Voo Design'),
          value: DesignSystemType.voo,
          groupValue: context.designSystemType,
          onChanged: (value) {
            // Switch to Voo
          },
        ),
      ],
    );
  }
}
```

## Best Practices

### Do's
- ✅ Use semantic color tokens (primary, error, success)
- ✅ Follow the spacing grid (multiples of 8)
- ✅ Maintain consistent border radius
- ✅ Use the typography scale for text hierarchy
- ✅ Test in both light and dark modes

### Don'ts
- ❌ Hard-code color values
- ❌ Create custom spacing values
- ❌ Mix design systems in the same screen
- ❌ Override system animations without reason
- ❌ Ignore accessibility guidelines

## Examples

### Complete Form Example

```dart
class VooFormExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = context.designSystem;
    final colors = context.designColors;
    final spacing = context.designSpacing;
    
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: context.designTypography.headlineMedium,
          ),
          SizedBox(height: spacing.lg),
          
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: spacing.md),
          
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: spacing.lg),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: context.componentStyles.primaryButton,
              onPressed: () {},
              child: Text('Sign Up'),
            ),
          ),
          SizedBox(height: spacing.sm),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: context.componentStyles.tertiaryButton,
              onPressed: () {},
              child: Text('Already have an account?'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Dashboard Card Example

```dart
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  
  const DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final colors = context.designColors;
    final typography = context.designTypography;
    final spacing = context.designSpacing;
    final radius = context.designRadius;
    
    return Card(
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: (color ?? colors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(radius.md),
              ),
              child: Icon(
                icon,
                color: color ?? colors.primary,
                size: context.designIcons.sizeXl,
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.labelMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    value,
                    style: typography.headlineSmall.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Resources

- [Design Tokens Reference](./tokens.md)
- [Component Gallery](./components.md)
- [Accessibility Guidelines](./accessibility.md)
- [Migration Checklist](./migration.md)

## Contributing

We welcome contributions to the Voo Design System! Please see our [contribution guidelines](../CONTRIBUTING.md) for more information.

## License

The Voo Design System is licensed under the MIT License. See [LICENSE](../LICENSE) for details.