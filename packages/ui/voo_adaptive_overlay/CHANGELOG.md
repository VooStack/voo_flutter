# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-11-27

### Added

- Initial release of `voo_adaptive_overlay`
- **Adaptive overlay system** that automatically selects the appropriate overlay type based on screen size:
  - Mobile (<600px): Bottom sheet
  - Tablet (600-1024px): Modal dialog
  - Desktop (>1024px): Side sheet or modal (configurable)
- **Overlay types**:
  - `VooBottomSheet` - Slides up from the bottom
  - `VooModalDialog` - Centered dialog
  - `VooSideSheet` - Slides in from the side
  - `VooFullscreenOverlay` - Covers the entire screen
  - `VooDrawer` - Slides in from left/right
  - `VooActionSheet` - iOS-style action list
  - `VooSnackbar` - Bottom notification with action
  - `VooBanner` - Top/bottom notification banner
  - `VooPopup` - Contextual popup menu
  - `VooTooltip` - Informational tooltip
  - `VooAlert` - Critical alert dialog
- **Style presets**:
  - `material` - Standard Material Design 3
  - `cupertino` - iOS-style with blur and rounded corners
  - `glass` - Glassmorphism with frosted glass effect
  - `minimal` - Clean, borderless design
  - `outlined` - Modern outlined style
  - `elevated` - Strong shadow elevation
  - `soft` - Soft pastel colors
  - `dark` - Dark mode optimized
  - `gradient` - Gradient background
  - `neumorphic` - Soft 3D shadows
  - `custom` - Full customization
- **Configuration options**:
  - `VooOverlayConfig` for customizing behavior and appearance
  - `VooOverlayBreakpoints` for customizing responsive breakpoints
  - `VooOverlayBehavior` for animation and interaction settings
  - `VooOverlayConstraints` for size constraints
  - `VooOverlayStyleData` for custom styling
- **Extension methods** for convenient overlay showing via `context.showAdaptiveOverlay()`
- **Pre-built action buttons** with `VooOverlayAction` factory methods
- Comprehensive example app demonstrating all features
