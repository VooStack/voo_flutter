# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2025-01-23

### Fixed
- Removed incorrectly named files (voo__LAdvanced_LList.dart, voo__LData_LList.dart) that violated naming conventions
- Fixed import sorting issues throughout the package
- Applied automatic dart fixes for better code quality:
  - Fixed directives_ordering issues
  - Converted block function bodies to expression function bodies where appropriate
  - Fixed deprecated surfaceVariant usage
  - Removed unnecessary overrides
  - Fixed parameter assignment issues

### Changed
- Improved code quality with automated linting fixes (10 fixes in 8 files)
- Updated imports to follow alphabetical ordering as per Flutter best practices

## [0.1.0] - Initial Release

### Added
- VooSimpleList - Basic scrollable list with standard features
- VooReorderableList - Drag-and-drop reorderable list
- VooGroupedList - Lists with grouped sections
- VooNestedList - Hierarchical nested lists
- VooExpandableList - Lists with expandable/collapsible items
- VooSearchableList - Lists with built-in search functionality
- VooInfiniteList - Infinite scrolling lists
- VooPaginatedList - Lists with pagination support
- Single and multi-selection support
- Various animation types for list items
- Swipe-to-dismiss functionality
- Pull-to-refresh support
- Customizable empty state widgets
- Built-in loading indicators