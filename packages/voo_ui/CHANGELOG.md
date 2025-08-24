# Changelog

All notable changes to the voo_ui package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-01-24

### Added

#### 🎨 Design System
- **VooDesignSystem**: Central design token management with consistent spacing, radius, and animation values
- **VooTheme**: Comprehensive Material 3 theming with light and dark mode support
- **VooColors**: Semantic color system with status indicators and custom color support
- **VooTypography**: Material Design 3 type scale implementation
- **VooSpacing**: Consistent spacing system (xs through xxxl)
- **VooMaterialApp**: Pre-configured MaterialApp with VooDesignSystem integration

#### 📊 Advanced Data Grid
- **VooDataGrid**: Production-ready data grid with three operation modes
  - Local mode: All filtering, sorting, and pagination handled client-side
  - Remote mode: Server-side operations with debounced API calls
  - Mixed mode: Remote data fetching with local filtering/sorting
- **Smart Filter System**: Automatic filter widget selection based on column data type
  - Text fields for string data
  - Number fields with range support for numeric data
  - Date pickers with range selection for temporal data
  - Dropdowns for enum/select fields with icons and subtitles
  - Multi-select for multiple choice filtering
  - Custom filter builders for specialized needs
- **Advanced Features**:
  - Multi-column sorting with visual indicators
  - Row selection (single and multiple modes)
  - Frozen columns for important data
  - Custom cell rendering with builder pattern
  - Pagination with customizable page sizes
  - Column resizing and reordering
  - Performance optimized for large datasets (virtual scrolling)
- **VooDataGridSource**: Abstract data source with repository pattern
- **VooDataGridController**: Centralized state management for data grid

#### 🧩 Foundation Components
- **VooContainer**: Responsive container with Material 3 elevation and animation support
- **VooCard**: Material 3 cards with hover states and interaction feedback
- **VooScaffold**: Enhanced scaffold with responsive behavior
- **VooAppBar**: Material 3 app bar with sliver support

#### 📝 Input Components
- **VooTextField**: Material 3 outlined text field with floating labels
- **VooButton**: Multiple variants (elevated, outlined, text, tonal, filled)
- **VooDropdown**: Enhanced dropdown with icons, subtitles, and grouping support
- **VooSearchBar**: Material 3 search bar with clear action and suggestions

#### 📋 Display Components
- **VooListTile**: Enhanced list tiles with selection states and custom content
- **VooStatusBadge**: HTTP status and semantic status badges with color coding
- **VooTimestampText**: Intelligent relative time display (e.g., "2 hours ago")
- **VooEmptyState**: Beautiful empty states with customizable illustrations and actions

#### 🔧 Utility Components
- **VooPageHeader**: Consistent page headers with titles, subtitles, and actions
- **Context Extensions**: Easy access to design tokens via `context.vooDesign`

### Features
- Full Material 3 (Material You) design system implementation
- Atomic design pattern architecture (atoms, molecules, organisms)
- Responsive design with breakpoint-aware layouts
- Dark mode support with automatic theme switching
- Accessibility features built into all components
- Comprehensive documentation with code examples
- TypeScript-like type safety with Dart null safety

### Technical Details
- Minimum Flutter SDK: 3.0.0
- Minimum Dart SDK: 3.0.0
- Dependencies: intl for internationalization
- Zero external UI dependencies (pure Flutter implementation)

### Documentation
- Comprehensive README with getting started guide
- API documentation for all public classes
- Example implementations for every component
- Design system usage guidelines
- Data grid implementation examples for all three modes

## [Unreleased]

### Planned for 0.2.0
- VooChart: Interactive charts powered by fl_chart
- VooCalendar: Material 3 calendar with event support
- VooDatePicker: Enhanced date picker with range selection
- VooTimePicker: Material 3 time picker
- VooStepper: Horizontal and vertical steppers
- VooTimeline: Timeline component with custom markers

---

For more details about upcoming releases, see the [Roadmap](README.md#-roadmap--future-widgets) section in the README.