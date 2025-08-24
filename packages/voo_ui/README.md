# Voo UI

A comprehensive UI component library for Voo packages using feature-based architecture. This package provides reusable, well-designed components that ensure consistency across all Voo Flutter applications.

## Features

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

## Architecture

The package follows a feature-based architecture for better organization and discoverability:

```
lib/src/
├── foundations/    # Core design system elements
│   ├── colors.dart      # Color palettes and utilities
│   ├── spacing.dart     # Spacing and sizing constants
│   ├── theme.dart       # Theme decorations and utilities
│   └── typography.dart  # Text styles and typography
├── display/        # Components for displaying content
│   ├── list_tile.dart   # Enhanced list tiles
│   └── timestamp_text.dart # Time formatting
├── feedback/       # User feedback components
│   ├── empty_state.dart # Empty states
│   └── status_badge.dart # Status indicators
├── inputs/         # Input and form components
│   └── search_bar.dart  # Search input
├── layout/         # Layout and structural components
│   └── page_header.dart # Page headers
├── navigation/     # Navigation components (future)
├── overlays/       # Overlays and modals (future)
└── utils/          # Utility functions (future)
```

## Usage

### Basic Setup

```dart
import 'package:voo_ui/voo_ui.dart';
```

### Foundations

#### Colors
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

#### Spacing
```dart
// Spacing constants
Container(
  padding: EdgeInsets.all(VooSpacing.md),
  margin: EdgeInsets.symmetric(horizontal: VooSpacing.lg),
)

// Border radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(VooSpacing.radiusMd),
  ),
)

// Component heights
Container(
  height: VooSpacing.headerHeight,
)
```

#### Typography
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

#### Theme Decorations
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

### Display Components

#### VooListTile
```dart
VooListTile(
  title: Text('Item Title'),
  subtitle: Text('Item subtitle'),
  leading: Icon(Icons.folder),
  trailing: Icon(Icons.arrow_forward),
  isSelected: false,
  onTap: () {},
)
```

#### VooTimestamp
```dart
VooTimestamp(
  timestamp: DateTime.now().subtract(Duration(minutes: 5)),
  style: TextStyle(fontSize: 12),
)
```

### Feedback Components

#### VooStatusBadge
```dart
VooStatusBadge(
  statusCode: 200,
  compact: false,
)
```

#### VooEmptyState
```dart
VooEmptyState(
  icon: Icons.inbox_outlined,
  title: 'No Data',
  message: 'There is no data to display',
  action: ElevatedButton(
    onPressed: () {},
    child: Text('Refresh'),
  ),
)
```

### Input Components

#### VooSearchBar
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

### Layout Components

#### VooPageHeader
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

## Component Properties

### Display Components

#### VooListTile
- `title` (Widget, required): Main content
- `subtitle` (Widget?): Secondary content
- `leading` (Widget?): Leading widget
- `trailing` (Widget?): Trailing widget
- `isSelected` (bool): Selection state
- `onTap` (VoidCallback?): Tap handler
- `onLongPress` (VoidCallback?): Long press handler
- `padding` (EdgeInsetsGeometry?): Custom padding
- `selectedColor` (Color?): Color when selected
- `borderRadius` (BorderRadius?): Custom border radius

#### VooTimestamp
- `timestamp` (DateTime, required): The time to display
- `style` (TextStyle?): Custom text style

### Feedback Components

#### VooStatusBadge
- `statusCode` (int, required): HTTP status code to display
- `compact` (bool): Use compact display mode

#### VooEmptyState
- `icon` (IconData, required): Icon to display
- `title` (String, required): Main title text
- `message` (String, required): Description message
- `action` (Widget?): Optional action widget

### Input Components

#### VooSearchBar
- `hintText` (String): Placeholder text
- `onSearchChanged` (ValueChanged<String>?): Search value change handler
- `onClear` (VoidCallback?): Clear button handler
- `controller` (TextEditingController?): Text controller

### Layout Components

#### VooPageHeader
- `icon` (IconData, required): Header icon
- `title` (String, required): Header title
- `subtitle` (String, required): Header subtitle
- `actions` (List<Widget>): Action widgets
- `iconColor` (Color?): Custom icon color

## Design System Constants

### Spacing Values
- `VooSpacing.xs`: 4.0
- `VooSpacing.sm`: 8.0
- `VooSpacing.md`: 12.0
- `VooSpacing.lg`: 16.0
- `VooSpacing.xl`: 24.0
- `VooSpacing.xxl`: 32.0
- `VooSpacing.xxxl`: 48.0

### Border Radius Values
- `VooSpacing.radiusXs`: 2.0
- `VooSpacing.radiusSm`: 4.0
- `VooSpacing.radiusMd`: 8.0
- `VooSpacing.radiusLg`: 12.0
- `VooSpacing.radiusXl`: 16.0
- `VooSpacing.radiusXxl`: 24.0
- `VooSpacing.radiusFull`: 999.0

### Icon Sizes
- `VooSpacing.iconSizeSm`: 16.0
- `VooSpacing.iconSizeMd`: 20.0
- `VooSpacing.iconSizeLg`: 24.0
- `VooSpacing.iconSizeXl`: 32.0
- `VooSpacing.iconSizeXxl`: 48.0

### Component Heights
- `VooSpacing.filterBarHeight`: 56.0
- `VooSpacing.listTileHeight`: 72.0
- `VooSpacing.headerHeight`: 80.0
- `VooSpacing.searchBarHeight`: 40.0

## Contributing

This package is part of the VooFlutter monorepo. To contribute:

1. Follow the feature-based architecture
2. Place components in the appropriate feature folder
3. Ensure components work in both light and dark themes
4. Add proper documentation for new components
5. Test components thoroughly

## License

This package is part of the VooFlutter project.