# VooToast

A super developer-friendly toast notification package for Flutter with global access, extensive customizations, and responsive platform-specific defaults.

## Features

- 🌍 **Global Access** - Show toasts from anywhere without context
- 🎨 **Highly Customizable** - Extensive styling and animation options
- 📱 **Platform Aware** - Automatic positioning based on platform
- 🎯 **Type Safe** - Fully typed with strong type constraints
- 🎬 **Rich Animations** - Multiple built-in animations
- 📦 **Queue Management** - Smart queuing system
- 🏗️ **Clean Architecture** - Following best practices
- ⚛️ **Atomic Design** - Well-organized component structure

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_toast: ^0.0.1
```

## Quick Start

### 1. Wrap your app with VooToastOverlay

```dart
import 'package:voo_toast/voo_toast.dart';

MaterialApp(
  home: VooToastOverlay(
    child: YourApp(),
  ),
)
```

### 2. Show toasts from anywhere

```dart
// Simple toasts
VooToast.showSuccess(message: 'Operation successful!');
VooToast.showError(message: 'Something went wrong');
VooToast.showWarning(message: 'Please review your input');
VooToast.showInfo(message: 'New update available');

// With title
VooToast.showSuccess(
  title: 'Success',
  message: 'Your file has been saved',
);

// With actions
VooToast.showInfo(
  message: 'Item deleted',
  actions: [
    ToastAction(
      label: 'UNDO',
      onPressed: () => restoreItem(),
    ),
  ],
);
```

## Configuration

Initialize with custom configuration:

```dart
VooToastController.init(
  config: ToastConfig(
    defaultDuration: Duration(seconds: 4),
    maxToasts: 5,
    queueMode: true,
    preventDuplicates: true,
    mobilePosition: ToastPosition.bottom,
    webPosition: ToastPosition.topRight,
    successColor: Colors.green,
    errorColor: Colors.red,
  ),
);
```

## Toast Types

- `success` - Green themed success messages
- `error` - Red themed error messages
- `warning` - Orange themed warning messages
- `info` - Blue themed informational messages
- `custom` - Fully customizable toasts

## Positions

- Top: `top`, `topLeft`, `topCenter`, `topRight`
- Center: `center`, `centerLeft`, `centerRight`
- Bottom: `bottom`, `bottomLeft`, `bottomCenter`, `bottomRight`
- Auto: Platform-specific positioning

## Animations

- `none` - No animation
- `fade` - Fade in/out
- `slideIn` - Slide from position
- `slideInFromTop/Bottom/Left/Right` - Directional slides
- `bounce` - Bounce effect
- `scale` - Scale in/out
- `rotate` - Rotation effect

## Custom Toasts

```dart
VooToast.showCustom(
  content: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.pink],
      ),
    ),
    child: Text('Custom styled toast!'),
  ),
  duration: Duration(seconds: 5),
);
```

## Platform-Specific Behavior

The package automatically adjusts based on screen size:

- **Mobile (<600px)**: Bottom position, touch-friendly
- **Tablet (600-900px)**: Top-right position
- **Web/Desktop (>900px)**: Top-right position, compact sizing

## API Reference

### VooToast (Global Controller)

- `showSuccess()` - Show success toast
- `showError()` - Show error toast
- `showWarning()` - Show warning toast
- `showInfo()` - Show info toast
- `showCustom()` - Show custom toast
- `dismiss(toastId)` - Dismiss specific toast
- `dismissAll()` - Dismiss all toasts
- `clearQueue()` - Clear queued toasts

### ToastConfig

Configuration options for toast behavior and styling.

### Toast

Main toast entity with all properties.

### ToastAction

Action button for interactive toasts.

## Example

See the [example](example/) folder for a complete sample application.

## License

MIT License