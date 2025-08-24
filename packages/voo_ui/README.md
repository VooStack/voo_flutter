# Voo UI

A comprehensive UI component library for Voo packages featuring a powerful design system and Material Design components. This package provides reusable, well-designed components that ensure consistency across all Voo Flutter applications.

## Features

- **VooDesignSystem**: Context-based design system for consistent spacing, sizing, and theming
- **Material Design Components**: Complete set of Material Design components with Voo styling
- **Feature-Based Architecture**: Components organized by their functional purpose
- **Consistent Design System**: Centralized foundations for colors, spacing, and typography
- **Material 3 Ready**: Built with Material Design 3 principles
- **Dark Mode Support**: All components work seamlessly in light and dark themes
- **Highly Customizable**: Components accept various configuration options

## Installation

Add `voo_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_ui: ^0.1.0
```

## Quick Start

### Using VooMaterialApp

Wrap your app with `VooMaterialApp` to automatically inject the VooDesignSystem:

```dart
import 'package:voo_ui/voo_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VooMaterialApp(
      title: 'My Voo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Optional: Customize the design system
      designSystem: VooDesignSystemData(
        spacingUnit: 8.0,
        radiusUnit: 4.0,
      ),
      home: MyHomePage(),
    );
  }
}
```

### Using VooMaterialApp.router

For apps using declarative routing:

```dart
VooMaterialApp.router(
  title: 'My Voo App',
  routerConfig: myRouterConfig,
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
)
```

## VooDesignSystem

The VooDesignSystem provides context-based access to spacing, sizing, and animation values throughout your app.

### Accessing the Design System

```dart
// Get the design system from context
final design = context.vooDesign;

// Use spacing values
Container(
  padding: EdgeInsets.all(design.spacingMd),
  margin: EdgeInsets.symmetric(horizontal: design.spacingLg),
)

// Use radius values
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(design.radiusMd),
  ),
)

// Use animation values
AnimatedContainer(
  duration: design.animationDuration,
  curve: design.animationCurve,
)
```

### Design System Properties

#### Spacing Values
- `spacingXs`: Extra small spacing (4.0)
- `spacingSm`: Small spacing (8.0)
- `spacingMd`: Medium spacing (12.0)
- `spacingLg`: Large spacing (16.0)
- `spacingXl`: Extra large spacing (24.0)
- `spacingXxl`: 2x extra large spacing (32.0)
- `spacingXxxl`: 3x extra large spacing (48.0)

#### Radius Values
- `radiusXs`: Extra small radius (2.0)
- `radiusSm`: Small radius (4.0)
- `radiusMd`: Medium radius (8.0)
- `radiusLg`: Large radius (12.0)
- `radiusXl`: Extra large radius (16.0)
- `radiusXxl`: 2x extra large radius (24.0)
- `radiusFull`: Full radius for circles (999.0)

#### Component Sizes
- `iconSizeSm`: Small icon (16.0)
- `iconSizeMd`: Medium icon (20.0)
- `iconSizeLg`: Large icon (24.0)
- `iconSizeXl`: Extra large icon (32.0)
- `iconSizeXxl`: 2x extra large icon (48.0)

#### Component Heights
- `buttonHeight`: Standard button height (40.0)
- `inputHeight`: Standard input height (48.0)
- `appBarHeight`: Standard app bar height (56.0)
- `filterBarHeight`: Filter bar height (56.0)
- `listTileHeight`: List tile height (72.0)
- `headerHeight`: Page header height (80.0)

#### Animation
- `animationDuration`: Standard animation (300ms)
- `animationDurationFast`: Fast animation (150ms)
- `animationDurationSlow`: Slow animation (500ms)
- `animationCurve`: Standard curve (Curves.easeInOut)

## Components

### App Components

#### VooMaterialApp
A wrapper around MaterialApp that injects the VooDesignSystem.

```dart
VooMaterialApp(
  title: 'My App',
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  designSystem: VooDesignSystemData.custom(
    spacingUnit: 10.0,
    radiusUnit: 5.0,
  ),
  home: HomePage(),
)
```

### Navigation Components

#### VooAppBar
An enhanced AppBar with design system integration.

```dart
Scaffold(
  appBar: VooAppBar(
    title: Text('Page Title'),
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
    ],
  ),
)
```

For sliver usage:
```dart
CustomScrollView(
  slivers: [
    VooAppBar.sliver(
      title: Text('Sliver Title'),
      floating: true,
      pinned: true,
    ),
    // Other slivers...
  ],
)
```

### Input Components

#### VooTextField
A comprehensive text field with built-in design system styling.

```dart
VooTextField(
  label: 'Email',
  hint: 'Enter your email',
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  onChanged: (value) {
    // Handle change
  },
  error: validationError,
)
```

#### VooDropdown
A generic dropdown component with custom item rendering.

```dart
VooDropdown<String>(
  label: 'Select Option',
  value: selectedValue,
  items: [
    VooDropdownItem(
      value: 'option1',
      label: 'Option 1',
      icon: Icons.looks_one,
    ),
    VooDropdownItem(
      value: 'option2',
      label: 'Option 2',
      subtitle: 'Description',
    ),
  ],
  onChanged: (value) {
    setState(() {
      selectedValue = value;
    });
  },
)
```

#### VooButton
Material Design buttons with multiple variants and sizes.

```dart
// Elevated button
VooButton(
  child: Text('Save'),
  variant: VooButtonVariant.elevated,
  size: VooButtonSize.large,
  icon: Icons.save,
  onPressed: () {},
)

// Outlined button
VooButton(
  child: Text('Cancel'),
  variant: VooButtonVariant.outlined,
  onPressed: () {},
)

// Text button
VooButton(
  child: Text('Learn More'),
  variant: VooButtonVariant.text,
  onPressed: () {},
)

// Tonal button
VooButton(
  child: Text('Add to Cart'),
  variant: VooButtonVariant.tonal,
  loading: isLoading,
  onPressed: () {},
)
```

#### VooIconButton
Icon buttons with tooltip support.

```dart
VooIconButton(
  icon: Icons.favorite,
  tooltip: 'Add to favorites',
  onPressed: () {},
  selected: isFavorite,
  selectedColor: Colors.red,
)
```

#### VooSearchBar
A search input with clear functionality.

```dart
VooSearchBar(
  hintText: 'Search items...',
  onSearchChanged: (value) {
    // Handle search
  },
  onClear: () {
    // Handle clear
  },
)
```

### Display Components

#### VooCard
Material Design cards with interaction support.

```dart
VooCard(
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content'),
    ],
  ),
  onTap: () {},
  selected: isSelected,
  elevation: 4,
)
```

#### VooContentCard
Structured cards with header, content, and footer sections.

```dart
VooContentCard(
  header: Text('Card Header'),
  content: Text('Main content goes here'),
  footer: Text('Footer information'),
  actions: [
    TextButton(
      child: Text('Action 1'),
      onPressed: () {},
    ),
    TextButton(
      child: Text('Action 2'),
      onPressed: () {},
    ),
  ],
  dividerBetweenHeaderAndContent: true,
)
```

#### VooListTile
Enhanced list tiles with selection support.

```dart
VooListTile(
  title: Text('Item Title'),
  subtitle: Text('Item description'),
  leading: Icon(Icons.folder),
  trailing: Icon(Icons.arrow_forward),
  isSelected: isSelected,
  onTap: () {},
)
```

#### VooTimestamp
Formatted timestamp display.

```dart
VooTimestamp(
  timestamp: DateTime.now().subtract(Duration(minutes: 5)),
  style: TextStyle(fontSize: 12),
)
```

### Layout Components

#### VooContainer
A container with built-in design system spacing.

```dart
VooContainer(
  paddingSize: VooSpacingSize.lg,
  marginSize: VooSpacingSize.md,
  borderRadiusSize: VooSpacingSize.md,
  color: Theme.of(context).colorScheme.surface,
  elevation: 2,
  child: Text('Content'),
)
```

With animation:
```dart
VooContainer(
  animate: true,
  animationDuration: Duration(milliseconds: 500),
  width: isExpanded ? 200 : 100,
  child: Text('Animated content'),
)
```

#### VooResponsiveContainer
Responsive container with max/min constraints.

```dart
VooResponsiveContainer(
  maxWidth: 1200,
  minWidth: 320,
  paddingSize: VooSpacingSize.xl,
  centerContent: true,
  child: YourContent(),
)
```

#### VooPageHeader
Page headers with icon and actions.

```dart
VooPageHeader(
  icon: Icons.dashboard,
  title: 'Dashboard',
  subtitle: 'View your application metrics',
  iconColor: Colors.blue,
  actions: [
    IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {},
    ),
  ],
)
```

### Feedback Components

#### VooEmptyState
Empty state displays for no data scenarios.

```dart
VooEmptyState(
  icon: Icons.inbox_outlined,
  title: 'No Messages',
  message: 'You have no messages at this time',
  action: ElevatedButton(
    onPressed: () {},
    child: Text('Check Again'),
  ),
)
```

#### VooStatusBadge
HTTP status code badges.

```dart
VooStatusBadge(
  statusCode: 200,
  compact: false,
)
```

## Foundations

### Colors
```dart
// Log level colors
Container(
  color: VooColors.getLogLevelColor('error'),
)

// HTTP status colors
Container(
  color: VooColors.getHttpStatusColor(404),
)

// Performance colors
Container(
  color: VooColors.getPerformanceColor(250),
)

// HTTP method colors
Container(
  color: VooColors.getHttpMethodColor('POST'),
)
```

### Typography
```dart
// Text styles
Text(
  'Code',
  style: VooTypography.getMonospaceStyle(context),
)

Text(
  'Title',
  style: VooTypography.getTitleStyle(context),
)

Text(
  'Subtitle',
  style: VooTypography.getSubtitleStyle(context),
)
```

### Theme Decorations
```dart
// Card decoration
Container(
  decoration: VooTheme.getCardDecoration(context, isSelected: true),
)

// Hover decoration
Container(
  decoration: VooTheme.getHoverDecoration(context),
)

// Surface decoration
Container(
  decoration: VooTheme.getSurfaceDecoration(context),
)
```

## Customizing the Design System

You can create a custom design system with your own values:

```dart
final customDesign = VooDesignSystemData(
  spacingUnit: 10.0,  // Base spacing unit
  radiusUnit: 5.0,     // Base radius unit
  // All other values are computed from these base units
);

// Or use the custom constructor
final customDesign = VooDesignSystemData.custom(
  spacingUnit: 10.0,
  radiusUnit: 5.0,
  buttonHeight: 44.0,
  inputHeight: 52.0,
  appBarHeight: 60.0,
  animationDuration: Duration(milliseconds: 250),
  animationCurve: Curves.easeOut,
);
```

## Architecture

The package follows a feature-based architecture for better organization and discoverability:

```
lib/src/
├── app/            # App wrappers and configuration
│   └── voo_material_app.dart
├── foundations/    # Core design system elements
│   ├── colors.dart      # Color palettes and utilities
│   ├── design_system.dart # VooDesignSystem implementation
│   ├── spacing.dart     # Spacing and sizing constants
│   ├── theme.dart       # Theme decorations and utilities
│   └── typography.dart  # Text styles and typography
├── display/        # Components for displaying content
│   ├── card.dart        # Card components
│   ├── list_tile.dart   # Enhanced list tiles
│   └── timestamp_text.dart # Time formatting
├── feedback/       # User feedback components
│   ├── empty_state.dart # Empty states
│   └── status_badge.dart # Status indicators
├── inputs/         # Input and form components
│   ├── button.dart      # Button components
│   ├── dropdown.dart    # Dropdown component
│   ├── search_bar.dart  # Search input
│   └── text_field.dart  # Text field component
├── layout/         # Layout and structural components
│   ├── container.dart   # Container components
│   └── page_header.dart # Page headers
└── navigation/     # Navigation components
    └── app_bar.dart     # App bar component
```

## Contributing

This package is part of the VooFlutter monorepo. To contribute:

1. Follow the feature-based architecture
2. Place components in the appropriate feature folder
3. Ensure components work with the VooDesignSystem
4. Ensure components work in both light and dark themes
5. Add proper documentation for new components
6. Test components thoroughly

## License

This package is part of the VooFlutter project.