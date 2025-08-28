## 0.0.1

* Initial release of voo_motion - A powerful and simple animation package for Flutter

### Features

#### Core Animations (16 types)
* **Drop Animation** - Elements drop in from above with bounce effect
* **Fade Animation** - Smooth opacity transitions
* **Slide Animations** - Slide in from left, right, top, or bottom
* **Scale Animation** - Grow or shrink elements smoothly
* **Rotation Animation** - 360-degree rotation effects
* **Bounce Animation** - Elastic bounce effects
* **Shake Animation** - Horizontal shake for attention
* **Flip Animation** - 3D flip on X or Y axis
* **Blur Animation** - Gaussian blur transitions
* **Glow Animation** - Glowing shadow effects
* **Pulse Animation** - Rhythmic scaling pulse
* **Shimmer Animation** - Loading shimmer effects
* **Wave Animation** - Wave distortion effects
* **Ripple Animation** - Material-style ripple effects

#### Hover Animations (10 types) - For web and desktop
* **Hover Grow** - Scale up on hover
* **Hover Lift** - Elevate with shadow on hover
* **Hover Glow** - Glow effect on hover
* **Hover Tilt** - 3D tilt effect following mouse
* **Hover Shine** - Shine overlay effect
* **Hover Rotate** - Rotation on hover
* **Hover Color** - Color transition on hover
* **Hover Blur** - Blur background on hover
* **Hover Underline** - Animated underline for text
* **Hover Border** - Animated border appearance

### API Design
* Simple extension-based API - Just add `.animationName()` to any widget
* Full customization at call level for all animations
* Chainable animations for complex effects
* Configurable duration, delay, curve, and callbacks
* Support for repeat, reverse, and auto-play options

### Architecture
* Clean separation between animations and configuration
* Reusable VooAnimationConfig for consistent settings
* Performance-optimized with proper lifecycle management
* Memory-efficient animation controllers

### Testing
* Comprehensive widget tests for all animations
* Extension method tests
* Animation parameter validation
* Hover interaction tests

### Example Usage
```dart
// Simple animation
Text('Hello').fadeIn()

// Customized animation
Card(child: content).dropIn(
  duration: Duration(seconds: 1),
  delay: Duration(milliseconds: 200),
  curve: Curves.bounceOut,
)

// Hover animation for web/desktop
Button().hoverGrow(growScale: 1.1)

// Chained animations
Widget().fadeIn().scaleIn().hoverGlow()
```
