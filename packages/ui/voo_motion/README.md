# VooMotion

A simple and powerful animation package for Flutter that makes adding beautiful animations to any widget as easy as calling a method.

## Features

- **Extension-based API**: Apply animations to any widget using simple extension methods like `.dropIn()`, `.fadeIn()`, `.slideInLeft()`
- **Rich Animation Library**: Pre-built animations including fade, slide, scale, rotation, bounce, shake, and flip
- **Highly Configurable**: Fine-tune duration, delay, curves, and other parameters for each animation
- **Staggered Animations**: Create beautiful staggered list animations with `VooStaggerList`
- **Performance Optimized**: Efficient animation controllers with proper lifecycle management
- **Accessibility Support**: Respects system accessibility settings for reduced motion
- **Design System Integration**: Works seamlessly with VooDesignSystem

## Installation

Add `voo_motion` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_motion: ^0.0.1
```

## Quick Start

```dart
import 'package:voo_motion/voo_motion.dart';

// Simply add .dropIn() to any widget
Text('Hello World').dropIn()

// Customize animation parameters
ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
).fadeIn(
  duration: Duration(milliseconds: 800),
  delay: Duration(milliseconds: 200),
)

// Chain multiple animations
Container(
  child: Text('Animated'),
).fadeIn().scaleIn(delay: Duration(milliseconds: 500))
```

## Available Animations

### Drop In
Widget drops from above with a bounce effect.
```dart
Card().dropIn(
  fromHeight: 100, // Drop distance
  duration: Duration(milliseconds: 600),
)
```

### Fade
Fade in or out animations.
```dart
// Fade in
Container().fadeIn(from: 0.0, to: 1.0)

// Fade out
Container().fadeOut(from: 1.0, to: 0.0)
```

### Slide
Slide from any direction.
```dart
Text('Slide').slideInLeft()
Text('Slide').slideInRight()
Text('Slide').slideInTop()
Text('Slide').slideInBottom()
```

### Scale
Scale animations with elastic effects.
```dart
Icon(Icons.star).scaleIn(
  from: 0.0,
  to: 1.0,
  curve: Curves.elasticOut,
)
```

### Rotation
Continuous rotation animations.
```dart
Icon(Icons.refresh).rotate(
  repeat: true,
  duration: Duration(seconds: 2),
)
```

### Bounce
Bouncing animation effect.
```dart
Container().bounce(
  bounceHeight: 20,
  numberOfBounces: 3,
  repeat: true,
)
```

### Shake
Shake animation for emphasis.
```dart
TextField().shake(
  intensity: 10,
  numberOfShakes: 5,
)
```

### Flip
3D flip animations.
```dart
Card().flipX() // Horizontal flip
Card().flipY() // Vertical flip
```

## Staggered Animations

Create beautiful staggered list animations:

```dart
VooStaggerList(
  animationType: StaggerAnimationType.slideLeft,
  staggerDelay: Duration(milliseconds: 100),
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
    ListTile(title: Text('Item 3')),
  ],
)
```

## Animation Configuration

Fine-tune animations with `VooAnimationConfig`:

```dart
Container().fadeIn(
  config: VooAnimationConfig(
    duration: Duration(milliseconds: 500),
    delay: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    repeat: false,
    reverse: false,
    onStart: () => print('Animation started'),
    onComplete: () => print('Animation completed'),
  ),
)
```

## Custom Animation Curves

Use predefined curves or create custom ones:

```dart
// Predefined curves
Container().scaleIn(curve: VooMotionCurve.spring)
Container().slideInLeft(curve: VooMotionCurve.bounce)

// Custom spring curve
Container().dropIn(
  curve: VooMotionCurve.springCurve(tension: 2.0),
)
```

## Global Settings

Configure animations globally:

```dart
VooMotionSettingsProvider(
  settings: VooMotionSettings(
    enabled: true,
    respectAccessibilitySettings: true,
    speedMultiplier: 1.0,
    defaultConfig: VooAnimationConfig(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
  ),
  child: MyApp(),
)
```

## Advanced Usage

### Custom Animation Widget
```dart
VooAnimatedWidget(
  config: VooAnimationConfig(),
  builder: (context, animation, child) {
    return Transform.scale(
      scale: animation.value,
      child: child,
    );
  },
  child: Text('Custom Animation'),
)
```

### Hero Animations
```dart
VooHeroAnimation.material(
  tag: 'hero-tag',
  child: Image.asset('image.png'),
)
```

## Example App

Check out the example app for a comprehensive demonstration of all available animations:

```bash
cd example
flutter run
```

## License

This package is part of the VooFlutter monorepo. See the root LICENSE file for details.