# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-10-29

### Added

- Initial release of VooCircularProgress widget
- Multi-ring circular progress indicator with smooth animations
- `ProgressRing` entity for defining individual progress rings
- `CircularProgressConfig` for animation and layout configuration
- Support for custom colors, stroke widths, and sizes
- Customizable center widget support
- Efficient rendering using `CustomPainter`
- Configurable animation duration and curves
- Support for custom background colors per ring
- Comprehensive example app demonstrating various configurations
- Full test coverage for entities and widgets
- Complete API documentation and README

### Features

- Display multiple concentric progress rings
- Smooth, customizable animations
- Flexible styling options
- High performance with `CustomPainter`
- Type-safe API with null safety
- Support for custom start angles and stroke cap styles
- Automatic progress calculation and percentage conversion
- Goal completion detection

### Architecture

- Clean architecture with domain and presentation layers
- Atomic design pattern (atoms, molecules, organisms)
- Follows VooFlutter development standards
- Integration with voo_tokens for design consistency
