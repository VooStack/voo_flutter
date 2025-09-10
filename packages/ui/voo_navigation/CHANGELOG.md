# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2025-01-10

### Changed
- Minor version bump for package registry update
- Package maintenance and dependency alignment

## [0.0.2] - 2025-01-09

### Enhanced
- **Visual Design Improvements**:
  - Implemented Material 3 glassmorphism effects with subtle blur and surface tints
  - Added smooth hover states with MouseRegion for desktop platforms
  - Enhanced ripple effects and splash colors for better touch feedback
  - Improved border radius and rounded corners throughout components
  - Added gradient backgrounds for custom navigation bars
  - Better shadow and elevation handling with proper Material 3 colors

- **Animation Enhancements**:
  - Added scale animations with easeOutBack curves for delightful interactions
  - Implemented rotation animations for micro-interactions
  - Improved fade transitions using AnimatedSwitcher
  - Enhanced selection animations with individual item controllers
  - Better transition handling between navigation types with AnimatedSwitcher

- **Navigation Rail Improvements**:
  - Increased compact width from 80px to 88px for better spacing
  - Fixed item height to 64px in compact mode for improved touch targets
  - Improved badge positioning to prevent overlap with selection indicators
  - Added conditional badge sizing for compact vs extended modes
  - Better icon sizing (28px in compact mode) for visual hierarchy
  - Fixed padding and spacing issues in compact layout

- **Badge System Refinements**:
  - Reduced dot badge size from 8px to 6px for subtlety
  - Implemented compact badge variant with smaller font size (9px)
  - Added white border to badges for better visibility
  - Improved badge positioning with Stack overflow handling
  - Smart text truncation for badges (99+ for numbers over 99)

### Fixed
- **Critical Issues**:
  - Fixed massive overflow (99828 pixels) when transitioning between rail and drawer
  - Resolved opacity animation error in badge animations (clamped values to 0.0-1.0)
  - Fixed bottom navigation blur/shadow artifacts appearing above content
  - Corrected navigation rail border radius not being applied
  - Fixed test failures related to width expectations and badge detection

- **Layout Issues**:
  - Fixed cramped spacing in compact navigation rail
  - Resolved badge overlap issues in selection state
  - Corrected padding inconsistencies across different navigation types
  - Fixed ClipRect wrapping to prevent transition overflow

### Improved
- **Code Quality**:
  - Removed redundant lint warnings (spreadRadius, MainAxisAlignment defaults)
  - Better separation of concerns with cleaner widget composition
  - Improved test coverage with all 65 tests passing
  - Enhanced documentation and code comments

- **Performance**:
  - Optimized animation controllers with proper disposal
  - Reduced unnecessary widget rebuilds
  - Better memory management for hover state tracking
  - Improved transition performance with KeyedSubtree

## [0.0.1] - 2025-01-01

### Added
- Initial release of VooNavigation package
- **Core Features**:
  - Fully adaptive navigation system that automatically switches between navigation types based on screen size
  - Material 3 design compliance with latest design guidelines
  - Support for bottom navigation, navigation rail, extended rail, and navigation drawer
  - Platform and screen size agnostic implementation

- **Domain Entities**:
  - `VooNavigationType` - Enum for navigation layout types
  - `VooNavigationItem` - Rich navigation item with badges, dropdowns, and customization
  - `VooNavigationConfig` - Comprehensive configuration system
  - `VooBreakpoint` - Material 3 responsive breakpoints

- **UI Components (Organisms)**:
  - `VooAdaptiveScaffold` - Main adaptive scaffold component
  - `VooAdaptiveAppBar` - Responsive app bar with drawer toggle
  - `VooAdaptiveBottomNavigation` - Material 3 bottom navigation
  - `VooAdaptiveNavigationRail` - Rail navigation for tablets/desktops
  - `VooAdaptiveNavigationDrawer` - Full-featured navigation drawer

- **UI Components (Molecules)**:
  - `VooNavigationItemWidget` - Reusable navigation item renderer
  - `VooNavigationBadge` - Animated badges with count, text, or dot
  - `VooNavigationDropdown` - Expandable dropdown for nested navigation

- **UI Components (Atoms)**:
  - `VooNavigationIcon` - Animated icon with selected state transitions
  - `VooNavigationLabel` - Text label with scaling and truncation
  - `VooNavigationIndicator` - Selection indicators with multiple styles

- **Utilities**:
  - `VooNavigationHelper` - Helper utilities for navigation type detection
  - `VooNavigationAnimations` - Comprehensive animation utilities

- **Features**:
  - Rich navigation items with badges (count, text, dot)
  - Expandable sections with nested navigation
  - Custom icons and selected states
  - Extensive theming and customization options
  - Smooth animations throughout
  - Haptic feedback support
  - Floating action button integration
  - Custom header and footer widgets
  - Section dividers and headers

### Dependencies
- Flutter SDK >=3.0.0
- voo_ui_core: ^0.1.0
- voo_motion: ^0.0.1
- equatable: ^2.0.5
- material_design_icons_flutter: ^7.0.7296

### Development
- Clean architecture with domain, data, and presentation layers
- Atomic design pattern for UI components
- Comprehensive example app demonstrating all features
- Unit tests for domain entities
- Zero lint warnings or errors