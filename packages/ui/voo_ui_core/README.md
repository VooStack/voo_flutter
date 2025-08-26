# VooUI Core

A comprehensive Flutter UI component library providing Material 3 design system components with enhanced features and customization options.

[![pub package](https://img.shields.io/pub/v/voo_ui_core.svg)](https://pub.dev/packages/voo_ui_core)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-4BC0F5.svg)](https://pub.dev/packages/flutter_lints)

## Features

- **Material 3 Design System**: Full Material 3 (Material You) design implementation
- **Customizable Design Tokens**: Flexible spacing, radius, and animation systems  
- **Rich Input Components**: Text fields, buttons, checkboxes, switches, sliders, and more
- **Responsive Design**: Built-in responsive utilities and breakpoint system
- **Theme Integration**: Seamless integration with Flutter's theme system
- **Accessibility**: WCAG compliant components with proper semantics

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  voo_ui_core: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Setup

Wrap your app with the VooDesignSystem to provide design tokens throughout your widget tree:

```dart
import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(
    VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MyApp(),
    ),
  );
}
```

### Components

#### Buttons

```dart
VooButton(
  onPressed: () {},
  child: const Text('Click Me'),
)

VooButton(
  variant: VooButtonVariant.outlined,
  icon: Icons.add,
  onPressed: () {},
  child: const Text('Add Item'),
)
```

#### Text Fields

```dart
VooTextField(
  label: 'Email',
  hint: 'Enter your email',
  onChanged: (value) {
    // Handle change
  },
)
```

#### Checkboxes

```dart
VooCheckbox(
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value ?? false;
    });
  },
)

// With label
VooCheckboxListTile(
  title: const Text('Accept terms'),
  value: isAccepted,
  onChanged: (value) {
    setState(() {
      isAccepted = value ?? false;
    });
  },
)
```

#### Switches

```dart
VooSwitch(
  value: isEnabled,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
)

// With label
VooSwitchListTile(
  title: const Text('Enable notifications'),
  value: notificationsEnabled,
  onChanged: (value) {
    setState(() {
      notificationsEnabled = value;
    });
  },
)
```

#### Sliders

```dart
VooSlider(
  value: sliderValue,
  min: 0,
  max: 100,
  divisions: 10,
  label: sliderValue.toStringAsFixed(0),
  onChanged: (value) {
    setState(() {
      sliderValue = value;
    });
  },
)
```

#### Date & Time Pickers

```dart
VooDateTimePicker(
  value: selectedDate,
  label: 'Select Date',
  onChanged: (date) {
    setState(() {
      selectedDate = date;
    });
  },
)

// With time
VooDateTimePicker(
  value: selectedDateTime,
  label: 'Select Date & Time',
  showTime: true,
  onChanged: (dateTime) {
    setState(() {
      selectedDateTime = dateTime;
    });
  },
)

// Date range
VooDateRangePicker(
  value: dateRange,
  label: 'Select Range',
  onChanged: (range) {
    setState(() {
      dateRange = range;
    });
  },
)
```

#### Radio Groups

```dart
VooRadioGroup<String>(
  items: ['Option 1', 'Option 2', 'Option 3'],
  value: selectedOption,
  labelBuilder: (item) => item,
  onChanged: (value) {
    setState(() {
      selectedOption = value;
    });
  },
)
```

#### Segmented Buttons

```dart
VooSegmentedButton<String>(
  segments: [
    VooButtonSegment(
      value: 'day',
      label: const Text('Day'),
    ),
    VooButtonSegment(
      value: 'week',
      label: const Text('Week'),
    ),
    VooButtonSegment(
      value: 'month',
      label: const Text('Month'),
    ),
  ],
  selected: selectedView,
  onSelectionChanged: (value) {
    setState(() {
      selectedView = value;
    });
  },
)
```

### Design System Customization

Create custom design systems for different themes or screen sizes:

```dart
// Compact design for mobile
VooDesignSystem(
  data: VooDesignSystemData.compact,
  child: MyCompactView(),
)

// Comfortable design with more spacing
VooDesignSystem(
  data: VooDesignSystemData.comfortable,
  child: MyComfortableView(),
)

// Custom design tokens
VooDesignSystem(
  data: const VooDesignSystemData(
    spacingUnit: 10.0,
    radiusUnit: 6.0,
    borderWidth: 2.0,
    animationDuration: Duration(milliseconds: 250),
    inputHeight: 56.0,
    buttonHeight: 48.0,
  ),
  child: MyCustomView(),
)
```

### Responsive Design

Use the responsive utilities to create adaptive layouts:

```dart
class MyResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final breakpoint = context.vooBreakpoint;
    
    if (breakpoint.isMobile) {
      return MobileLayout();
    } else if (breakpoint.isTablet) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  }
}
```

## Components Reference

### Input Components
- `VooButton` - Material 3 button with variants (elevated, outlined, text, tonal)
- `VooTextField` - Enhanced text input field with validation
- `VooCheckbox` - Checkbox with Material 3 styling
- `VooCheckboxListTile` - Checkbox with integrated label
- `VooCheckboxGroup` - Multiple checkbox selection
- `VooSwitch` - Toggle switch component
- `VooSwitchListTile` - Switch with integrated label
- `VooSwitchGroup` - Multiple switch controls
- `VooSlider` - Slider for numeric input
- `VooRadio` - Radio button control
- `VooRadioGroup` - Radio button group for single selection
- `VooSegmentedButton` - Segmented button control
- `VooDateTimePicker` - Date and time picker
- `VooDateRangePicker` - Date range selector

### Display Components
- `VooCard` - Material 3 card container
- `VooChip` - Chip widget for tags and filters
- `VooListTile` - Enhanced list tile
- `VooTimestampText` - Formatted timestamp display

### Layout Components
- `VooContainer` - Container with design system spacing
- `VooPageHeader` - Page header with title and actions
- `VooResponsiveBuilder` - Responsive layout builder
- `VooBreakpoint` - Breakpoint utilities

### Navigation
- `VooAppBar` - Customized app bar

### Feedback Components
- `VooEmptyState` - Empty state placeholder
- `VooProgressIndicator` - Loading indicators
- `VooStatusBadge` - Status badges and indicators

### Foundation
- `VooDesignSystem` - Design token provider
- `VooDesignSystemData` - Design token configuration
- `VooColors` - Color palette
- `VooTypography` - Typography system
- `VooSpacing` - Spacing system
- `VooTheme` - Theme configuration

## Accessing Design Tokens

```dart
// Access design tokens from context
final design = context.vooDesign;

// Use spacing
Container(
  padding: EdgeInsets.all(design.spacingMd),
  margin: EdgeInsets.symmetric(horizontal: design.spacingLg),
)

// Use radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(design.radiusMd),
  ),
)

// Use animation
AnimatedContainer(
  duration: design.animationDuration,
  curve: design.animationCurve,
)
```

## Migration Guide

If you're migrating from the monolithic `voo_ui` package:

1. Update your pubspec.yaml:
```yaml
dependencies:
  voo_ui_core: ^0.1.0
  # Add these if needed:
  voo_data_grid: ^0.1.0
  voo_calendar: ^0.1.0
```

2. Update imports:
```dart
// Old
import 'package:voo_ui/voo_ui.dart';

// New
import 'package:voo_ui_core/voo_ui_core.dart';
```

3. The API remains the same, just the package structure has changed.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see the [LICENSE](LICENSE) file for details