# VooCircularProgress

A highly customizable multi-ring circular progress indicator widget for Flutter, inspired by fitness tracking apps like Google Fit.

[![Pub Version](https://img.shields.io/pub/v/voo_circular_progress)](https://pub.dev/packages/voo_circular_progress)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- **Multiple Concentric Rings**: Display multiple progress indicators in a single circular widget
- **Smooth Animations**: Beautiful, customizable animations when progress values change
- **Highly Customizable**: Control colors, stroke widths, sizes, gaps, and more
- **Efficient Rendering**: Uses `CustomPainter` for optimal performance
- **Flexible Center Widget**: Place any widget in the center of the rings
- **Developer-Friendly API**: Clean, intuitive API with great IDE support
- **Type-Safe**: Built with null safety and strong typing

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  voo_circular_progress: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Basic Usage

```dart
import 'package:voo_circular_progress/voo_circular_progress.dart';

VooCircularProgress(
  rings: [
    ProgressRing(
      current: 7762,
      goal: 10000,
      color: Colors.cyan,
      strokeWidth: 12,
    ),
    ProgressRing(
      current: 23,
      goal: 30,
      color: Colors.blue,
      strokeWidth: 12,
    ),
  ],
  size: 200,
  centerWidget: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('23', style: TextStyle(fontSize: 48)),
      Text('7,762', style: TextStyle(fontSize: 24)),
    ],
  ),
)
```

## Examples

### Single Ring

```dart
VooCircularProgress(
  rings: [
    ProgressRing(
      current: 75,
      goal: 100,
      color: Colors.green,
      strokeWidth: 10,
    ),
  ],
  size: 150,
  centerWidget: Text(
    '75%',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
)
```

### Multiple Rings

```dart
VooCircularProgress(
  rings: [
    ProgressRing(
      current: 8500,
      goal: 10000,
      color: Colors.green,
      strokeWidth: 12,
    ),
    ProgressRing(
      current: 45,
      goal: 60,
      color: Colors.orange,
      strokeWidth: 12,
    ),
    ProgressRing(
      current: 25,
      goal: 30,
      color: Colors.red,
      strokeWidth: 12,
    ),
  ],
  size: 220,
  gapBetweenRings: 8,
  centerWidget: Icon(Icons.favorite, size: 48, color: Colors.red),
)
```

### Custom Animation

```dart
VooCircularProgress(
  rings: [
    ProgressRing(
      current: progress,
      goal: 100,
      color: Colors.purple,
    ),
  ],
  animationDuration: Duration(milliseconds: 1500),
  animationCurve: Curves.elasticOut,
  centerWidget: Text('${progress.toInt()}%'),
)
```

### Custom Background Color

```dart
VooCircularProgress(
  rings: [
    ProgressRing(
      current: 60,
      goal: 100,
      color: Colors.blue,
      backgroundColor: Colors.grey.withOpacity(0.3),
      strokeWidth: 10,
    ),
  ],
)
```

## API Reference

### VooCircularProgress

The main widget for displaying circular progress indicators.

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `rings` | `List<ProgressRing>` | **required** | List of progress rings to display (outer to inner) |
| `size` | `double` | `200.0` | Overall diameter of the circular progress indicator |
| `gapBetweenRings` | `double` | `8.0` | Spacing between concentric rings |
| `animationDuration` | `Duration` | `Duration(milliseconds: 1000)` | Duration for progress animations |
| `animationCurve` | `Curve` | `Curves.easeInOutCubic` | Easing curve for animations |
| `centerWidget` | `Widget?` | `null` | Optional widget to display in the center |

### ProgressRing

Represents a single progress ring.

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `current` | `double` | **required** | Current progress value |
| `goal` | `double` | **required** | Target or maximum value |
| `color` | `Color` | **required** | Color of the progress ring |
| `strokeWidth` | `double` | `12.0` | Thickness of the ring |
| `backgroundColor` | `Color?` | `null` | Background ring color (defaults to semi-transparent `color`) |
| `startAngle` | `double` | `-π/2` | Starting angle in radians (default is top) |
| `capStyle` | `StrokeCap` | `StrokeCap.round` | Style of the stroke ends |

#### Computed Properties

- `progress`: Returns progress as a ratio (0.0 to 1.0)
- `percentageInt`: Returns progress as a percentage (0 to 100)
- `isGoalReached`: Returns true if current >= goal

### CircularProgressConfig

Configuration object for animation settings.

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `size` | `double` | `200.0` | Overall size of the indicator |
| `gapBetweenRings` | `double` | `8.0` | Gap between rings |
| `animationDuration` | `Duration` | `Duration(milliseconds: 1000)` | Animation duration |
| `animationCurve` | `Curve` | `Curves.easeInOutCubic` | Animation curve |

## Architecture

This package follows clean architecture principles:

- **Domain Layer**: `ProgressRing` and `CircularProgressConfig` entities
- **Presentation Layer**:
  - **Atoms**: `CircularRingPainter` (CustomPainter for efficient rendering)
  - **Molecules**: `AnimatedProgressRing` (handles animation state)
  - **Organisms**: `VooCircularProgress` (main widget)

## Performance

- Uses `CustomPainter` for efficient rendering
- Animations are optimized with `AnimationController`
- Minimal rebuilds through proper state management
- Suitable for displaying multiple rings without performance issues

## Contributing

Contributions are welcome! Please read the [contributing guidelines](https://github.com/VooStack/VooFlutter/blob/main/CONTRIBUTING.md) before submitting PRs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Part of the [VooFlutter](https://github.com/VooStack/VooFlutter) ecosystem - a comprehensive Flutter development toolkit.

## Support

- [Documentation](https://github.com/VooStack/VooFlutter/tree/main/packages/ui/voo_circular_progress)
- [Issue Tracker](https://github.com/VooStack/VooFlutter/issues)
- [Example App](https://github.com/VooStack/VooFlutter/tree/main/packages/ui/voo_circular_progress/example)
