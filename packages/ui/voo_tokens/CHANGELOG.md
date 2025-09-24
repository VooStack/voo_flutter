## 0.0.8

### Added
- **FEAT**: Added additional design tokens to support enhanced UI consistency:
  - Extended color palette with more nuanced shades
  - Additional spacing and sizing tokens for improved flexibility
  - Enhanced typography scale with more granular text styles
  - New elevation tokens for consistent shadow effects

### Changed
- **IMPROVEMENT**: Refined token values for better visual hierarchy
- **IMPROVEMENT**: Updated responsive scaling factors for improved mobile experience

## 0.0.7

 - **FEAT**: Update CHANGELOG and bump version to 0.0.6 with new token types and improvements.
 - **FEAT**: Enhance VooTokens with additional token categories and responsive design.
 - **FEAT**: add example modules and run configurations for VooFlutter packages.

## 0.0.6

### Added
- **FEAT**: Added specific token types for better use-case coverage:
  - `VooMarginTokens` - Specific margins for pages, cards, dialogs, and sections
  - `VooPaddingTokens` - Component-specific padding presets for buttons, cards, inputs, chips, tabs
  - `VooGapTokens` - Spacing tokens for flex containers, grids, form fields, and component groups
  - `VooComponentRadiusTokens` - Border radius for specific UI components (buttons, cards, dialogs, inputs, chips, avatars)
  - `VooSizeTokens` - Standardized sizes for icons, avatars, buttons, inputs, and UI elements

### Fixed
- **FIX**: Theme extension now provides default tokens automatically when not registered (no more "VooTokensTheme not found" error)
- **FIX**: Scale factor now properly applies to all token types in `VooTokensTheme.standard()`

### Changed
- **BREAKING**: Extended `ResponsiveTokens` and `VooTokensTheme` with new token types
- **IMPROVEMENT**: Enhanced example app to demonstrate all new token types
- **IMPROVEMENT**: Updated README with comprehensive usage examples for all token types

## 0.0.5

- Version bump for package updates

## 0.0.4

- Internal improvements

## 0.0.3

 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.

# Changelog

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## [0.0.2] - 2025-01-23

### Changed
- Package is now properly integrated with voo_ui_core as the primary design token source
- Removed duplicate token definitions from voo_ui_core in favor of this package
- Improved integration with the VooFlutter ecosystem

### Fixed
- Fixed duplicate token system issues across packages
- Ensured consistent token usage throughout the monorepo

## [0.0.1] - 2025-09-22

### Added
- Initial release of voo_tokens package
- Design token system with responsive adaptations
- Theme extension for Flutter's Material Design
- Color system with primary, secondary, tertiary, error, warning, success, and neutral palettes
- Typography system with responsive text styles
- Spacing tokens with density variations
- Border radius tokens for consistent rounded corners
- Breakpoint definitions for responsive design
- Support for light and dark themes
- Integration with Flutter's Material 3 design system