## 0.1.2

 - **FEAT**: Introduce voo_tokens package for design tokens and responsive utilities.
 - **FEAT**: Enhance form components with configurable options and improved theming.
 - **FEAT**: Introduce VooFieldOptions and VooFieldWidget for enhanced form field customization.
 - **FEAT**: Add Voo Design System implementation with responsive support.
 - **FEAT**: Implement advanced filtering in VooDataGrid.
 - **FEAT**: Update LICENSE files to include full MIT License text.
 - **FEAT**: Implement Windows runner for Voo Data Grid example.
 - **FEAT**: Add VooDataGrid previews and update configurations for better development experience.

## 0.1.1

* **BREAKING**: Removed duplicate responsive system - now uses voo_responsive package
* **BREAKING**: Removed duplicate token definitions (VooSpacing, VooTypography) - use voo_tokens instead
* Added dependency on voo_responsive package (^0.1.0) for responsive utilities
* Added dependency on voo_tokens package (^0.0.1) for design tokens
* Refactored to use shared responsive utilities from voo_responsive
* Removed duplicate spacing constants from all UI components
* Removed duplicate typography definitions in favor of voo_tokens
* Updated VooDesignSystem to use voo_responsive components
* Fixed all hardcoded spacing values to maintain consistency
* Hidden duplicate token exports (VooElevation, VooRadius, VooSpacing, VooTypography) from public API

## 0.1.0

* Comprehensive UI component library with Material 3 design system
* Added responsive layout utilities and breakpoint system
* Implemented customizable theme system with light and dark mode support
* Added core UI components: buttons, cards, dialogs, forms
* Implemented advanced input widgets with validation
* Added animation utilities and transitions
* Included spacing and padding utilities following Material guidelines
* Added typography system with predefined text styles
* Implemented color system with semantic colors
* Added accessibility features and screen reader support

## 0.0.1

* Initial release of VooUICore
* Basic UI components and utilities
* Foundation for Material 3 design system
* Core theme and styling functionality
