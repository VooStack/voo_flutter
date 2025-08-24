# Voo UI

[![pub package](https://img.shields.io/pub/v/voo_ui.svg)](https://pub.dev/packages/voo_ui)
[![pub points](https://img.shields.io/pub/points/voo_ui)](https://pub.dev/packages/voo_ui/score)
[![flutter platform](https://img.shields.io/badge/Platform-Flutter-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter UI component library built with Material 3 design principles and atomic design pattern. Voo UI provides production-ready, customizable widgets with built-in theming, responsive design, and accessibility features.

## ✨ Features

### 🎨 Design System
- **Material 3 Support**: Full Material You (Material 3) theming with dynamic color support
- **Atomic Design Pattern**: Components organized as atoms, molecules, and organisms
- **Responsive Design**: Adaptive layouts that work across mobile, tablet, and desktop
- **Dark Mode**: Built-in dark mode support with seamless transitions
- **Custom Theming**: Extensive customization through VooDesignSystem

### 📊 Advanced Data Grid
- **Three Operation Modes**: Local, Remote, and Mixed (hybrid) data handling
- **Smart Filtering**: Automatic filter input selection based on data type
- **Multi-Column Sorting**: Sort by multiple columns with visual indicators
- **Built-in Pagination**: Customizable page sizes with navigation controls
- **Row Selection**: Single and multiple selection modes
- **Frozen Columns**: Keep important columns visible while scrolling
- **Custom Cell Rendering**: Full control over cell appearance and behavior
- **Performance Optimized**: Efficient rendering for large datasets

### 🧩 Component Library

#### Foundation Components
- **VooDesignSystem**: Central design token management
- **VooTheme**: Comprehensive Material 3 theming
- **VooColors**: Semantic color system with status indicators
- **VooTypography**: Type scale following Material Design
- **VooSpacing**: Consistent spacing system

#### Input Components
- **VooTextField**: Material 3 outlined text field with floating labels
- **VooButton**: Multiple variants (elevated, outlined, text, tonal)
- **VooDropdown**: Enhanced dropdown with icons and subtitles
- **VooSearchBar**: Material 3 search bar with clear action

#### Display Components
- **VooCard**: Material 3 cards with interaction states
- **VooListTile**: Enhanced list tiles with selection support
- **VooStatusBadge**: HTTP status and semantic badges
- **VooTimestampText**: Intelligent relative time display

#### Layout Components
- **VooContainer**: Responsive container with animation support
- **VooPageHeader**: Page headers with actions and icons
- **VooAppBar**: Enhanced app bar with sliver support

#### Feedback Components
- **VooEmptyState**: Beautiful empty states with actions
- **VooStatusBadge**: Color-coded status indicators

## 🚀 Getting Started

### Installation

Add `voo_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_ui: ^0.1.0
```

Run the following command:

```bash
flutter pub get
```

### Quick Setup

1. **Wrap your app with VooDesignSystem:**

```dart
import 'package:voo_ui/voo_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      child: MaterialApp(
        theme: VooTheme.light(),
        darkTheme: VooTheme.dark(),
        home: MyHomePage(),
      ),
    );
  }
}
```

2. **Or use VooMaterialApp for automatic setup:**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VooMaterialApp(
      title: 'My Voo App',
      theme: VooTheme.light(),
      darkTheme: VooTheme.dark(),
      home: MyHomePage(),
    );
  }
}
```

## 📊 Data Grid Examples

### Basic Data Grid

```dart
class DataGridExample extends StatefulWidget {
  @override
  State<DataGridExample> createState() => _DataGridExampleState();
}

class _DataGridExampleState extends State<DataGridExample> {
  late final UserDataSource _dataSource;
  late final VooDataGridController _controller;

  @override
  void initState() {
    super.initState();
    _dataSource = UserDataSource();
    _controller = VooDataGridController(dataSource: _dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return VooDataGrid(
      controller: _controller,
      columns: [
        VooDataColumn(
          field: 'id',
          label: 'ID',
          width: 80,
          frozen: true,
          dataType: VooDataColumnType.number,
        ),
        VooDataColumn(
          field: 'name',
          label: 'Name',
          dataType: VooDataColumnType.text,
          filterHint: 'Search by name...',
        ),
        VooDataColumn(
          field: 'email',
          label: 'Email',
          dataType: VooDataColumnType.text,
        ),
        VooDataColumn(
          field: 'role',
          label: 'Role',
          dataType: VooDataColumnType.select,
          filterOptions: [
            VooFilterOption(value: 'admin', label: 'Admin', icon: Icons.admin_panel_settings),
            VooFilterOption(value: 'user', label: 'User', icon: Icons.person),
            VooFilterOption(value: 'moderator', label: 'Moderator', icon: Icons.shield),
          ],
        ),
        VooDataColumn(
          field: 'status',
          label: 'Status',
          dataType: VooDataColumnType.select,
          cellBuilder: (context, value, row) {
            final color = value == 'active' ? Colors.green : Colors.grey;
            return Row(
              children: [
                Icon(Icons.circle, size: 10, color: color),
                const SizedBox(width: 8),
                Text(value, style: TextStyle(color: color)),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'lastLogin',
          label: 'Last Login',
          dataType: VooDataColumnType.date,
          valueFormatter: (value) {
            if (value is DateTime) {
              final diff = DateTime.now().difference(value);
              if (diff.inDays > 0) return '${diff.inDays} days ago';
              if (diff.inHours > 0) return '${diff.inHours} hours ago';
              return '${diff.inMinutes} minutes ago';
            }
            return 'Never';
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }
}
```

### Data Source Implementation

```dart
// Remote data source
class UserDataSource extends VooDataGridSource {
  UserDataSource() : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Make API call with filters and sorts
    final response = await api.getUsers(
      page: page,
      pageSize: pageSize,
      filters: filters,
      sorts: sorts,
    );
    
    return VooDataGridResponse(
      rows: response.data,
      totalRows: response.total,
      page: page,
      pageSize: pageSize,
    );
  }
}

// Local data source
class LocalDataSource extends VooDataGridSource {
  LocalDataSource() : super(mode: VooDataGridMode.local);
  
  void loadData(List<Map<String, dynamic>> data) {
    setLocalData(data);
  }
}

// Mixed mode (remote fetch, local filter/sort)
class MixedDataSource extends VooDataGridSource {
  MixedDataSource() : super(mode: VooDataGridMode.mixed);
  
  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Fetch all data once, then filter/sort locally
    final response = await api.getAllData();
    return VooDataGridResponse(
      rows: response.data,
      totalRows: response.data.length,
      page: 0,
      pageSize: 999999,
    );
  }
}
```

## 🎨 Design System Usage

### Accessing Design Tokens

```dart
Widget build(BuildContext context) {
  final design = context.vooDesign;
  
  return Container(
    padding: EdgeInsets.all(design.spacingMd),
    margin: EdgeInsets.symmetric(horizontal: design.spacingLg),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(design.radiusMd),
      color: Theme.of(context).colorScheme.surface,
    ),
    child: Column(
      children: [
        Icon(Icons.star, size: design.iconSizeLg),
        SizedBox(height: design.spacingMd),
        Text(
          'Content',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    ),
  );
}
```

### Custom Design System

```dart
VooDesignSystem(
  spacingUnit: 4.0,
  radiusUnit: 4.0,
  animationDurationUnit: 100,
  child: MaterialApp(
    theme: VooTheme.light(
      primaryColor: Colors.blue,
      customColors: {
        'brand': Colors.purple,
        'success': Colors.green,
        'warning': Colors.orange,
        'danger': Colors.red,
      },
    ),
    home: MyApp(),
  ),
);
```

## 🔮 Roadmap & Future Widgets

### Version 0.2.0
- ✅ **VooDataGrid**: Advanced data grid with filtering and sorting
- 🚧 **VooChart**: Custom-built interactive charts with animations
- 🚧 **VooCalendar**: Material 3 calendar with event support
- 🚧 **VooDatePicker**: Enhanced date picker with range selection
- 🚧 **VooTimePicker**: Material 3 time picker
- 🚧 **VooStepper**: Horizontal and vertical steppers
- 🚧 **VooTimeline**: Timeline component with custom markers

### Version 0.3.0
- **VooAvatar**: Avatar with online status and groups
- **VooChip**: Material 3 chips (input, choice, filter, action)
- **VooTooltip**: Rich tooltips with custom content
- **VooBadge**: Notification badges with animations
- **VooTabs**: Enhanced tab bar with custom indicators
- **VooBottomSheet**: Draggable bottom sheet with snap points
- **VooNavigationRail**: Adaptive navigation for tablets

### Version 0.4.0
- **VooSpeedDial**: FAB with speed dial actions
- **VooDataTable**: Simplified table for basic use cases
- **VooTreeView**: Expandable tree view component
- **VooKanban**: Drag-and-drop kanban board
- **VooGanttChart**: Project timeline visualization
- **VooSlider**: Enhanced slider with custom thumbs
- **VooRating**: Star rating component

### Version 0.5.0
- **VooForm**: Form builder with validation
- **VooWizard**: Multi-step wizard with progress
- **VooUploader**: File upload with progress and preview
- **VooImageViewer**: Image gallery with zoom
- **VooVideoPlayer**: Custom video player controls
- **VooAudioPlayer**: Audio player with waveform
- **VooColorPicker**: Material 3 color picker

### Version 1.0.0
- **VooRichTextEditor**: WYSIWYG editor
- **VooCodeEditor**: Syntax highlighted code editor
- **VooMarkdownViewer**: Markdown renderer
- **VooMaps**: Map integration with markers
- **VooGraphEditor**: Node-based graph editor
- **VooDashboard**: Dashboard builder components
- **VooAnalytics**: Analytics dashboard widgets

## 📖 API Documentation

### Design System Properties

#### Spacing Values
```dart
context.vooDesign.spacingXs   // 4.0
context.vooDesign.spacingSm   // 8.0
context.vooDesign.spacingMd   // 12.0
context.vooDesign.spacingLg   // 16.0
context.vooDesign.spacingXl   // 24.0
context.vooDesign.spacingXxl  // 32.0
context.vooDesign.spacingXxxl // 48.0
```

#### Border Radius
```dart
context.vooDesign.radiusXs   // 2.0
context.vooDesign.radiusSm   // 4.0
context.vooDesign.radiusMd   // 8.0
context.vooDesign.radiusLg   // 12.0
context.vooDesign.radiusXl   // 16.0
context.vooDesign.radiusXxl  // 24.0
context.vooDesign.radiusFull // 999.0
```

#### Component Sizes
```dart
context.vooDesign.iconSizeSm  // 16.0
context.vooDesign.iconSizeMd  // 20.0
context.vooDesign.iconSizeLg  // 24.0
context.vooDesign.iconSizeXl  // 32.0
context.vooDesign.iconSizeXxl // 48.0
```

#### Animation
```dart
context.vooDesign.animationDuration     // 300ms
context.vooDesign.animationDurationFast // 150ms
context.vooDesign.animationDurationSlow // 500ms
context.vooDesign.animationCurve        // Curves.easeInOut
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Run `flutter pub get`
3. Run tests with `flutter test`
4. Submit a pull request

### Code Style

- Follow Effective Dart guidelines
- Use the provided linter rules
- Add dartdoc comments for public APIs
- Include examples for new components

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Documentation**: [https://voo-ui-docs.com](https://voo-ui-docs.com)
- **Issues**: [GitHub Issues](https://github.com/yourusername/voo_ui/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/voo_ui/discussions)

## 📊 Package Stats

![Pub Version](https://img.shields.io/pub/v/voo_ui)
![Pub Likes](https://img.shields.io/pub/likes/voo_ui)
![Pub Points](https://img.shields.io/pub/points/voo_ui)
![Pub Popularity](https://img.shields.io/pub/popularity/voo_ui)

---

Made with ❤️ by the Voo Team