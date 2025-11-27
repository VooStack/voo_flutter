# VooAdaptiveOverlay

A powerful, adaptive overlay system for Flutter that automatically selects the most appropriate overlay presentation (modal, bottom sheet, side sheet, etc.) based on screen size and device type.

[![pub package](https://img.shields.io/pub/v/voo_adaptive_overlay.svg)](https://pub.dev/packages/voo_adaptive_overlay)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Adaptive Presentation** - Automatically chooses the best overlay type based on screen size
- **Multiple Overlay Types** - Bottom sheets, modals, side sheets, drawers, action sheets, snackbars, banners, popups, tooltips, and alerts
- **Style Presets** - Material, Cupertino, Glass, Minimal, and more out of the box
- **Fully Customizable** - Configure breakpoints, animations, constraints, and styling
- **Type-Safe** - Full generic support for return values
- **Zero Boilerplate** - Simple API with sensible defaults

## Responsive Behavior

| Screen Width | Default Overlay Type |
|--------------|---------------------|
| < 600px (Mobile) | Bottom Sheet |
| 600-1024px (Tablet) | Modal Dialog |
| > 1024px (Desktop) | Side Sheet |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_adaptive_overlay: ^0.0.2
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:voo_adaptive_overlay/voo_adaptive_overlay.dart';

// Show an adaptive overlay - automatically picks the right type
final result = await VooAdaptiveOverlay.show<bool>(
  context: context,
  title: Text('Confirm Action'),
  content: Text('Are you sure you want to proceed?'),
  actions: [
    VooOverlayAction.cancel(),
    VooOverlayAction.confirm(
      onPressed: () => Navigator.pop(context, true),
    ),
  ],
);

if (result == true) {
  // User confirmed
}
```

### Using Extension Method

```dart
// Even simpler with the extension method
await context.showAdaptiveOverlay(
  title: Text('Settings'),
  content: SettingsForm(),
);
```

## Overlay Types

### Bottom Sheet

```dart
await VooAdaptiveOverlay.showBottomSheet(
  context: context,
  title: Text('Options'),
  content: MyOptionsWidget(),
);
```

### Modal Dialog

```dart
await VooAdaptiveOverlay.showModal(
  context: context,
  title: Text('Edit Profile'),
  content: ProfileForm(),
  actions: [
    VooOverlayAction.cancel(),
    VooOverlayAction(label: 'Save', onPressed: () => Navigator.pop(context)),
  ],
);
```

### Side Sheet

```dart
await VooAdaptiveOverlay.showSideSheet(
  context: context,
  title: Text('Details'),
  content: DetailView(),
);
```

### Drawer

```dart
await VooAdaptiveOverlay.showDrawer(
  context: context,
  title: Text('Navigation'),
  content: NavigationMenu(),
  anchorRight: false, // Opens from left
);
```

### Action Sheet

```dart
final selected = await VooAdaptiveOverlay.showActionSheet<String>(
  context: context,
  title: Text('Choose Photo Source'),
  actions: [
    VooOverlayAction(
      label: 'Camera',
      icon: Icons.camera_alt,
      onPressed: () => Navigator.pop(context, 'camera'),
    ),
    VooOverlayAction(
      label: 'Gallery',
      icon: Icons.photo_library,
      onPressed: () => Navigator.pop(context, 'gallery'),
    ),
    VooOverlayAction.destructive(
      label: 'Remove Photo',
      icon: Icons.delete,
      onPressed: () => Navigator.pop(context, 'remove'),
    ),
  ],
  cancelAction: VooOverlayAction.cancel(),
);
```

### Snackbar

```dart
await VooAdaptiveOverlay.showSnackbar(
  context: context,
  message: 'Item deleted',
  action: VooOverlayAction(
    label: 'Undo',
    onPressed: () => undoDelete(),
  ),
  duration: Duration(seconds: 4),
);
```

### Banner

```dart
await VooAdaptiveOverlay.showBanner(
  context: context,
  title: 'Update Available',
  message: 'A new version is ready to install.',
  type: VooBannerType.info,
  action: VooOverlayAction(
    label: 'Update',
    onPressed: () => launchUpdate(),
  ),
  duration: Duration(seconds: 8),
);
```

### Alert

```dart
final confirmed = await VooAdaptiveOverlay.showAlert<bool>(
  context: context,
  title: 'Delete Item?',
  message: 'This action cannot be undone.',
  type: VooAlertType.warning,
  actions: [
    VooOverlayAction.cancel(),
    VooOverlayAction.destructive(
      label: 'Delete',
      onPressed: () => Navigator.pop(context, true),
    ),
  ],
);
```

### Popup

```dart
await VooAdaptiveOverlay.showPopup(
  context: context,
  anchorRect: buttonRect, // Position near a button
  actions: [
    VooOverlayAction.withIcon(label: 'Edit', icon: Icons.edit),
    VooOverlayAction.withIcon(label: 'Share', icon: Icons.share),
    VooOverlayAction.withIcon(label: 'Delete', icon: Icons.delete),
  ],
);
```

### Tooltip

```dart
await VooAdaptiveOverlay.showTooltip(
  context: context,
  message: 'Click to learn more',
  anchorRect: helpIconRect,
  duration: Duration(seconds: 3),
);
```

## Style Presets

Apply different visual styles with the `style` parameter:

```dart
await VooAdaptiveOverlay.show(
  context: context,
  title: Text('Glassmorphism'),
  content: MyContent(),
  config: VooOverlayConfig.glass, // Use glass style preset
);
```

### Available Presets

| Style | Description |
|-------|-------------|
| `material` | Standard Material Design 3 |
| `cupertino` | iOS-style with blur and rounded corners |
| `glass` | Glassmorphism with frosted glass effect |
| `minimal` | Clean, borderless design |
| `outlined` | Modern outlined style |
| `elevated` | Strong shadow elevation |
| `soft` | Soft pastel colors |
| `dark` | Dark mode optimized |
| `gradient` | Gradient background |
| `neumorphic` | Soft 3D shadows |

## Configuration

### Custom Breakpoints

```dart
await VooAdaptiveOverlay.show(
  context: context,
  title: Text('Custom Breakpoints'),
  content: MyContent(),
  config: VooOverlayConfig(
    breakpoints: VooOverlayBreakpoints(
      bottomSheetMaxWidth: 500,  // Bottom sheet up to 500px
      modalMaxWidth: 900,        // Modal from 500-900px
      preferSideSheetOnDesktop: true,
    ),
  ),
);
```

### Custom Behavior

```dart
await VooAdaptiveOverlay.show(
  context: context,
  title: Text('Custom Behavior'),
  content: MyContent(),
  config: VooOverlayConfig(
    behavior: VooOverlayBehavior(
      dismissOnTapOutside: true,
      enableDrag: true,
      showDragHandle: true,
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeOutCubic,
    ),
  ),
);
```

### Size Constraints

```dart
await VooAdaptiveOverlay.show(
  context: context,
  title: Text('Constrained'),
  content: MyContent(),
  config: VooOverlayConfig(
    constraints: VooOverlayConstraints(
      minWidth: 300,
      maxWidth: 500,
      minHeight: 200,
      maxHeight: 600,
    ),
  ),
);
```

### Force Specific Type

```dart
// Always show as modal, regardless of screen size
await VooAdaptiveOverlay.show(
  context: context,
  title: Text('Always Modal'),
  content: MyContent(),
  config: VooOverlayConfig(
    forceType: VooOverlayType.modal,
  ),
);
```

## Custom Content with Builder

For scrollable content that needs access to a scroll controller:

```dart
await VooAdaptiveOverlay.show(
  context: context,
  title: Text('Long List'),
  builder: (context, scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(
        title: Text('Item $index'),
      ),
    );
  },
);
```

## Actions

### Pre-built Actions

```dart
VooOverlayAction.cancel()           // "Cancel" with default styling
VooOverlayAction.confirm()          // "Confirm" as primary action
VooOverlayAction.close()            // "Close" button
VooOverlayAction.destructive()      // Red destructive action
VooOverlayAction.withIcon()         // Action with leading icon
```

### Custom Actions

```dart
VooOverlayAction(
  label: 'Custom Action',
  icon: Icons.star,
  isPrimary: true,
  isDestructive: false,
  onPressed: () {
    // Handle action
    Navigator.pop(context, 'custom');
  },
)
```

## Dependencies

- [voo_responsive](https://pub.dev/packages/voo_responsive) - Screen size utilities
- [voo_tokens](https://pub.dev/packages/voo_tokens) - Design tokens
- [equatable](https://pub.dev/packages/equatable) - Value equality

## Example

Check out the [example app](https://github.com/voostack/voo_flutter/tree/main/packages/ui/voo_adaptive_overlay/example) for a complete demonstration of all features.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please read our [contributing guidelines](https://github.com/voostack/voo_flutter/blob/main/CONTRIBUTING.md) before submitting a pull request.
