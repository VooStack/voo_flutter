# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-08-25

### Changes

---

Packages with breaking changes:

 - [`voo_analytics` - `v0.4.0`](#voo_analytics---v040)
 - [`voo_core` - `v0.4.0`](#voo_core---v040)
 - [`voo_logging` - `v0.4.0`](#voo_logging---v040)
 - [`voo_performance` - `v0.4.0`](#voo_performance---v040)
 - [`voo_telemetry` - `v0.2.0`](#voo_telemetry---v020)

Packages with other changes:

 - [`voo_ui` - `v0.1.3`](#voo_ui---v013)

---

#### `voo_analytics` - `v0.4.0`

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **REFACTOR**: Remove obsolete integration and widget tests; streamline HeatMapData and VooPerformance initialization.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Refactor NetworkList to support both log and request models.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **FEAT**: Enhance logging configuration with enableDevToolsJson option; update LogSyncEntity and SyncStorage for improved functionality.
 - **FEAT**: Add cloud sync support for analytics and performance metrics; enhance VooAnalytics and VooPerformance plugins; update CHANGELOGs and tests.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Add license files and update package versions to 0.0.1 for voo_core, voo_analytics, and voo_performance.
 - **FEAT**: Implement route-aware touch tracking and heat map visualization; enhance analytics data collection and UI components.
 - **FEAT**: Enhance touch event logging and heat map visualization; improve coordinate normalization and rendering.
 - **FEAT**: Integrate Voo Analytics and Performance tracking; add example pages for analytics and performance metrics.
 - **FEAT**: Enhance Voo DevTools extension with heat map visualization and analytics improvements.
 - **FEAT**: Update package versions and enhance analytics, performance, and logging functionalities.
 - **FEAT**: Add analytics tracking and UI components to Voo DevTools extension.
 - **FEAT**: Add VooFlutter example app with integration and widget tests.
 - **FEAT**: Add logs and network details panels for improved logging functionality.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

#### `voo_core` - `v0.4.0`

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **FEAT**: Update CHANGELOG and version for voo_core to 0.3.4; fix network request status display in DevTools extension.
 - **FEAT**: Update DevTools extension to improve network request handling and UI feedback, including timeout detection and enhanced loading indicators.
 - **FEAT**: Update cSpell words in settings, increment version to 0.3.2, and refactor network_bloc for improved readability.
 - **FEAT**: Update package versions and fix dev tools name in configuration.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **FEAT**: Add DevStack integration and telemetry support.
 - **FEAT**: Add DevStack integration guide and example app; enhance telemetry configuration and logging features.
 - **FEAT**: Enhance logging configuration with enableDevToolsJson option; update LogSyncEntity and SyncStorage for improved functionality.
 - **FEAT**: Add cloud sync support for analytics and performance metrics; enhance VooAnalytics and VooPerformance plugins; update CHANGELOGs and tests.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Add license files and update package versions to 0.0.1 for voo_core, voo_analytics, and voo_performance.
 - **FEAT**: Enhance Voo DevTools extension with heat map visualization and analytics improvements.
 - **FEAT**: Update package versions and enhance analytics, performance, and logging functionalities.
 - **FEAT**: Add analytics tracking and UI components to Voo DevTools extension.
 - **FEAT**: Add logs and network details panels for improved logging functionality.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

#### `voo_logging` - `v0.4.0`

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **REFACTOR**: Update logging package version to 0.0.7, enhance build scripts, and improve .pubignore.
 - **REFACTOR**: Update logging package configuration and remove unused web assets.
 - **REFACTOR**: Remove unused DevTools extension code and update logging scripts.
 - **REFACTOR**: Move devtools extension widgets and logic to a dedicated package.
 - **FIX**: Update cSpell configuration to include 'devstack'; adjust logging.dart for directive ordering.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Refactor NetworkList to support both log and request models.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **FEAT**: Add DevStack integration guide and example app; enhance telemetry configuration and logging features.
 - **FEAT**: Enhance logging configuration with enableDevToolsJson option; update LogSyncEntity and SyncStorage for improved functionality.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Add pretty logging feature with customizable formatting options; enhance logging configuration and examples.
 - **FEAT**: Implement route-aware touch tracking and heat map visualization; enhance analytics data collection and UI components.
 - **FEAT**: Integrate Voo Analytics and Performance tracking; add example pages for analytics and performance metrics.
 - **FEAT**: Enhance Voo DevTools extension with heat map visualization and analytics improvements.
 - **FEAT**: Update package versions and enhance analytics, performance, and logging functionalities.
 - **FEAT**: Add analytics tracking and UI components to Voo DevTools extension.
 - **FEAT**: Add VooFlutter example app with integration and widget tests.
 - **FEAT**: Add logs and network details panels for improved logging functionality.
 - **FEAT**: Add new Melos run configurations for logging and testing, and update scripts in melos.yaml.
 - **FEAT**: Update version to 0.0.15 and improve CHANGELOG with formatting enhancements for better readability.
 - **FEAT**: Update CHANGELOG for version 0.0.14 with breaking changes and enhancements, add Dio example, and improve interceptor logging.
 - **FEAT**: Update version to 0.0.13 and enhance CHANGELOG with new features for network and performance monitoring.
 - **FEAT**: Add network and performance tabs to VooLoggerPage.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

#### `voo_performance` - `v0.4.0`

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **REFACTOR**: Remove obsolete integration and widget tests; streamline HeatMapData and VooPerformance initialization.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Refactor NetworkList to support both log and request models.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **FEAT**: Add cloud sync support for analytics and performance metrics; enhance VooAnalytics and VooPerformance plugins; update CHANGELOGs and tests.
 - **FEAT**: Implement cloud sync functionality for analytics, logging, and performance data; add SyncEntity and CloudSyncManager classes; update version to 0.1.0.
 - **FEAT**: Enhance package description and add additional metadata in pubspec.yaml.
 - **FEAT**: Update dependencies in pubspec.yaml; add dio package and remove duplicate entry.
 - **FEAT**: Add license files and update package versions to 0.0.1 for voo_core, voo_analytics, and voo_performance.
 - **FEAT**: Integrate Voo Analytics and Performance tracking; add example pages for analytics and performance metrics.
 - **FEAT**: Enhance Voo DevTools extension with heat map visualization and analytics improvements.
 - **FEAT**: Update package versions and enhance analytics, performance, and logging functionalities.
 - **FEAT**: Add analytics tracking and UI components to Voo DevTools extension.
 - **FEAT**: Add VooFlutter example app with integration and widget tests.
 - **FEAT**: Add logs and network details panels for improved logging functionality.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

#### `voo_telemetry` - `v0.2.0`

 - **REFACTOR**: remove deprecated performance sync entity and update plugin structure.
 - **FEAT**: Update cSpell words in settings, increment version to 0.3.2, and refactor network_bloc for improved readability.
 - **FEAT**: Refactor network list and performance list to use new empty state widget.
 - **FEAT**: Refactor NetworkList to support both log and request models.
 - **FEAT**: Update changelogs for voo_analytics, voo_core, voo_logging, and voo_performance packages to reflect deprecation and migration to voo_telemetry.
 - **FEAT**: Enhance topics in pubspec.yaml files for voo_analytics, voo_core, voo_logging, voo_performance, and voo_telemetry packages.
 - **FEAT**: Add comprehensive test suite and configuration for VooTelemetry package.
 - **FEAT**: Update package versions and descriptions; enhance import statements for consistency.
 - **BREAKING** **FEAT**(voo_telemetry): Complete OpenTelemetry migration for VooFlutter.

#### `voo_ui` - `v0.1.3`

 - **FEAT**: add preview page for date and time picker components.
 - **FEAT**: add Material 3 compliant time picker and related components.
 - **FEAT**: Add VooDateTimePicker and calendar previews.
 - **FEAT**: Integrate voo_ui package and replace custom components with Voo equivalents.
 - **FEAT**: Add design system demo and main application structure.
 - **FEAT**: Refactor VooTextField to use OutlineInputBorder and improve error handling.
 - **FEAT**: Enhance VooDataGrid with advanced filtering and sorting capabilities.
 - **FEAT**: Initialize macOS Flutter project structure.
 - **FEAT**: Add widget previews for Voo UI components and enhance design system customization.
 - **FEAT**: Enhance README with updated descriptions and quick start guide for VooDesignSystem and components.
 - **FEAT**: Add VooDropdown, VooTextField, VooContainer, and VooAppBar components.
 - **FEAT**: Create voo_ui package with atomic design components.

