## 0.0.12

### Fixed
- **Theme Compliance**: Replaced all hardcoded colors with Theme.of(context) throughout the package
  - Updated all atom components to use theme colors (voo_modern_icon, voo_modern_badge, voo_rail_modern_badge)
  - Fixed molecule components to properly use theme.colorScheme colors
  - Updated organism components (voo_custom_navigation_bar, voo_scaffold_builder) to use theme colors
  - Removed hardcoded hex colors in favor of theme.colorScheme.surfaceContainer
  - Ensured proper color usage: onSurface, onPrimary, error, shadow based on context

## 0.0.11

### Fixed
- **Margin**: Added configurable margin parameter to VooAdaptiveAppBar for better layout control
- **Spacing**: Improved spacing consistency across tablet and desktop scaffolds
- **Polish**: Removed debug banner from example app for cleaner demo experience

## 0.0.10

### Changed
- **REFACTOR**: Integrated VooTokens design system throughout all navigation components
  - Replaced hardcoded values with VooTokens for consistent spacing, padding, and margins
  - Updated all navigation scaffolds (mobile, tablet, desktop) to use token-based styling
  - Applied VooTokens to app bars for consistent padding and elevation
  - Updated navigation items to use token-based spacing and sizing

### Improved
- **CONSISTENCY**: Enhanced UI consistency across all navigation components with standardized tokens
- **MAINTAINABILITY**: Simplified style updates through centralized token system
- **SCALABILITY**: Better responsive behavior with token-based responsive scaling

### Dependencies
- Updated voo_tokens from ^0.0.7 to ^0.0.8 to access additional design tokens

## 0.0.9

 - **FIX**: Improve navigation rail border radius test.
 - **FIX**: Update tests and fix overflow issue after refactoring.
 - **FEAT**: Update version in pubspec.yaml and adjust VooAdaptiveNavigationRail test for border radius and width changes.
 - **FEAT**: Add various scaffold and navigation components for improved UI structure.
 - **FEAT**: Enhance VooAdaptive components with improved styling and shadow effects.
 - **FEAT**: Enhance VooAdaptive components with improved styling and functionality.
 - **FEAT**: add example modules and run configurations for VooFlutter packages.
 - **FEAT**: Integrate voo_tokens package and update navigation components for improved theming and spacing.
 - **DOCS**: Add comprehensive changelog for v0.0.9 refactoring.

## 0.0.9 (Unreleased)

### Changed
- **Major Refactoring**: Complete refactoring to comply with clean architecture and atomic design patterns
  - Extracted all `_buildXXX` methods into proper widget classes following rules.md requirements
  - Created 36 new widget classes organized by atomic design principles
  - Improved code organization and maintainability
  - Better separation of concerns and single responsibility principle

### Added
- **New Atom Widgets** (14 total):
  - `VooBackgroundIndicator` - Background style indicator for navigation items
  - `VooLineIndicator` - Line indicator with customizable position (top/bottom/left/right)
  - `VooPillIndicator` - Pill-shaped selection indicator
  - `VooCustomIndicator` - Customizable indicator widget
  - `VooDotBadge` - Simple dot badge for notifications
  - `VooTextBadge` - Text-based badge with count or label
  - `VooModernIcon` - Modern styled navigation icon
  - `VooModernBadge` - Modern styled badge widget
  - `VooAnimatedIcon` - Icon with animated transitions
  - `VooIconWithBadge` - Composite icon and badge component
  - `VooRailModernBadge` - Badge specific to rail navigation
  - Additional navigation-specific atom widgets

- **New Molecule Widgets** (18 total):
  - `VooDropdownHeader` - Header for dropdown sections
  - `VooDropdownChildren` - Container for dropdown child items
  - `VooDropdownChildItem` - Individual dropdown child item
  - `VooAppBarLeading` - Leading widget for app bar
  - `VooAppBarTitle` - Title widget for app bar with animations
  - `VooAppBarActions` - Actions section for app bar
  - `VooCustomNavigationItem` - Custom styled navigation item
  - `VooRailDefaultHeader` - Default header for navigation rail
  - `VooRailNavigationItem` - Rail-specific navigation item
  - `VooRailSectionHeader` - Section header for rail navigation
  - `VooDrawerDefaultHeader` - Default header for navigation drawer
  - `VooDrawerNavigationItems` - Container for drawer items
  - `VooDrawerExpandableSection` - Expandable section in drawer
  - `VooDrawerNavigationItem` - Drawer-specific navigation item
  - `VooDrawerChildNavigationItem` - Child item in drawer
  - `VooDrawerModernBadge` - Modern badge for drawer items
  - Additional navigation molecule widgets

- **New Organism Widgets** (4 total):
  - `VooMaterial3NavigationBar` - Material 3 compliant navigation bar
  - `VooMaterial2BottomNavigation` - Material 2 style bottom navigation
  - `VooCustomNavigationBar` - Customizable navigation bar
  - `VooRailNavigationItems` - Container for rail navigation items
  - `VooScaffoldBuilder` - Builder for adaptive scaffold
  - `VooMobileScaffold` - Mobile-specific scaffold
  - `VooTabletScaffold` - Tablet-specific scaffold
  - `VooDesktopScaffold` - Desktop-specific scaffold
  - `VooRouterShell` - Router shell wrapper for go_router integration

- **Test Coverage**:
  - Added comprehensive tests for atom widgets
  - 21 new test cases for VooDotBadge, VooTextBadge, and VooLineIndicator
  - All new tests passing

### Fixed
- Fixed RenderFlex overflow in navigation rail items
- Fixed test failures related to structural changes from refactoring
- Updated tests to work with new widget architecture
- Fixed deprecated API usage (opacity → a)

### Improved
- **Code Quality**:
  - 100% compliance with rules.md for production code
  - Eliminated all `_buildXXX` methods from production widgets
  - Each widget now has single responsibility
  - Better testability with isolated widget classes
  - Improved reusability of UI components

- **Architecture**:
  - Clean separation between atoms, molecules, and organisms
  - Proper file organization following naming conventions
  - No relative imports used
  - Consistent widget patterns throughout

## 0.0.8

 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.
 - **FEAT**: Improve VooAdaptiveNavigationRail and VooAdaptiveScaffold for seamless theming and layout integration.
 - **FEAT**: Enhance VooAdaptiveNavigationRail and VooAdaptiveScaffold with improved theming and layout options.
 - **FEAT**: Introduce VooGoRouter for enhanced navigation integration.
 - **FEAT**: Bump version to 0.0.3 and update dependencies for improved stability and performance.
 - **FEAT**: Update version to 0.0.2 and enhance CHANGELOG with design, animation, and performance improvements.
 - **FEAT**: Enhance VooFormField and VooField with actions parameter.

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.7]

### Fixed
- **Breaking**: Removed duplicate breakpoint system - now properly uses Material 3 standard breakpoint values
- Fixed undefined VooBreakpoints references by using hardcoded Material 3 compliant values (600px, 840px, 1240px, 1440px)
- Fixed VooResponsiveBuilder usage in VooAdaptiveScaffold to use correct builder pattern
- Added proper voo_responsive integration through voo_ui_core re-exports
- Removed unused voo_ui_core import from breakpoint.dart

### Changed
- Updated breakpoint values to match Material 3 specifications:
  - Compact: 0-600px (phones)
  - Medium: 600-840px (tablets)
  - Expanded: 840-1240px (small laptops)
  - Large: 1240-1440px (desktops)
  - Extra Large: 1440px+ (large desktops)

## [0.0.6]

### Changed
- **Dependencies**:
  - Updated go_router from ^14.0.0 to ^16.2.2 for latest features and bug fixes
  - Ensures compatibility with latest Flutter SDK and routing improvements

## [0.0.5]

### Changed
- **Visual Design Overhaul**:
  - Replaced gradient backgrounds with sophisticated solid colors (#1F2937 light, #1A1D23 dark)
  - Professional dark sidebar design matching modern SaaS applications (Notion, Linear, Figma)
  - Improved selection states with primary color at 12% opacity and subtle borders
  - Reduced hover effects to 5% white overlay for cleaner interactions
  - Refined shadows and elevation for better depth perception

- **UX Improvements**:
  - Added AnimatedSwitcher for smooth icon transitions (200ms duration)
  - Better visual hierarchy with theme-aware colors
  - Optimized typography with proper font weights (600 selected, 400 unselected)
  - Improved spacing and padding for better touch targets
  - Enhanced micro-animations for state changes

### Fixed
- **Critical Issues**:
  - Fixed RenderFlex overflow by 3 pixels in bottom navigation
  - Resolved window.dart assertion errors in web platform
  - Fixed padding and margin calculations for compact layouts
  - Corrected icon sizes to prevent content overflow (20-22px range)
  - Fixed DecoratedBox vs Container usage for better performance

- **Layout Issues**:
  - Reduced bottom navigation height from 70px to 65px to prevent overflow
  - Adjusted padding from 6px to 4px vertical in navigation items
  - Fixed font sizes (11px for labels) to fit within constraints
  - Improved responsive behavior when scaling down width

### Improved
- **Code Quality**:
  - Removed unused variable warnings (primaryColor, isDark)
  - Fixed deprecated withOpacity() usage with withValues()
  - Consistent use of theme colors instead of hardcoded values
  - Better separation of concerns in color management

## [0.0.4]

### Added
- **go_router Integration**:
  - Full integration with go_router's `StatefulNavigationShell` for native navigation
  - `VooNavigationRoute` entity with multiple transition types (fade, slide, scale, material)
  - Support for nested routes and children routes with proper state preservation
  - `VooNavigationBuilder` for fluent API configuration
  - `VooGoRouter` provider with shell route support (optional utility)
  - `VooNavigationShell` wrapper for automatic route synchronization

- **Material You Support**:
  - `VooNavigationBuilder.materialYou()` factory for instant Material You theming
  - Dynamic color theming with seed colors
  - Enhanced default animations (350ms with easeInOutCubicEmphasized curve)
  - Rounded indicators with 24px border radius by default

- **Developer Experience**:
  - Direct integration with go_router's native patterns
  - Works seamlessly with `StatefulShellRoute.indexedStack`
  - Support for `goBranch()` navigation with state preservation
  - Comprehensive examples for StatefulNavigationShell usage
  - Type-safe navigation with go_router

- **Testing**:
  - Comprehensive test coverage for navigation routes
  - Tests for nested and children routes
  - Integration tests for StatefulNavigationShell
  - Builder pattern tests
  - All tests following voo_forms architecture pattern

### Changed
- VooAdaptiveScaffold now directly accepts StatefulNavigationShell as body
- Navigation is handled through go_router's native navigation methods
- Improved documentation with go_router integration examples

### Fixed
- Navigation state synchronization with go_router
- Proper handling of nested route navigation
- Badge display in navigation items

## [0.0.3]

### Changed
- Minor version bump for package registry update
- Package maintenance and dependency alignment

## [0.0.2]

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

## [0.0.1]

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