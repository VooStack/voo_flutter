# VooJsonTree

A feature-rich JSON tree viewer/editor widget for Flutter with collapsible nodes, syntax highlighting, search, and editing capabilities. Part of the VooFlutter ecosystem.

## Features

- **Tree Visualization**: Collapsible/expandable nodes with indentation guides
- **Syntax Highlighting**: Color-coded values by type (string, number, boolean, null)
- **Search**: Fuzzy search across keys and values with navigation
- **Copy Support**: Copy paths and values to clipboard
- **Keyboard Navigation**: Navigate and control the tree with keyboard
- **Multiple Themes**: Dark, light, VS Code, Monokai, system theme, and custom themes
- **Responsive**: Auto-adapts to screen size with VooJsonTreeResponsive
- **Token Integration**: Uses voo_tokens for consistent design system
- **Customizable**: Builder callbacks for custom rendering
- **Performance**: Virtualized rendering for large JSON structures

## Installation

Add `voo_json_tree` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_json_tree: ^0.1.0
```

## Usage

### Basic Usage

```dart
import 'package:voo_json_tree/voo_json_tree.dart';

VooJsonTree(
  data: {
    'name': 'John Doe',
    'age': 30,
    'email': 'john@example.com',
    'active': true,
    'roles': ['admin', 'user'],
    'settings': {
      'theme': 'dark',
      'notifications': true,
    },
  },
)
```

### Factory Constructors

```dart
// From JSON string
VooJsonTree.fromString('{"name": "John", "age": 30}')

// Read-only mode (no editing, no context menu)
VooJsonTree.readOnly(data: jsonData)

// With search enabled
VooJsonTree.searchable(data: jsonData)

// Compact mode (minimal UI)
VooJsonTree.compact(data: jsonData)

// Minimal mode (bare bones - just the tree)
VooJsonTree.minimal(data: jsonData)

// Raw mode (transparent, no container styling)
VooJsonTree.raw(data: jsonData)

// Developer mode (all expanded, debug-friendly)
VooJsonTree.developer(data: jsonData)

// Editable mode (in-place value editing)
VooJsonTree.editable(
  data: jsonData,
  onValueChanged: (path, value) => print('$path = $value'),
)
```

### Responsive Usage

Auto-adapts to mobile, tablet, and desktop:

```dart
VooJsonTreeResponsive(
  data: jsonData,
  theme: VooJsonTreeTheme.system(context),
)

// With custom configs per screen size
VooJsonTreeResponsive(
  data: jsonData,
  mobileConfig: JsonTreeConfig.minimal(),
  tabletConfig: JsonTreeConfig.compact(),
  desktopConfig: JsonTreeConfig.full(),
)
```

### With Configuration

```dart
VooJsonTree(
  data: jsonData,
  theme: VooJsonTreeTheme.dark(),
  config: JsonTreeConfig(
    expandDepth: 2,           // Auto-expand to depth 2
    showArrayIndices: true,   // Show [0], [1], etc.
    showNodeCount: true,      // Show {3} or [5] counts
    enableSearch: true,       // Enable search bar
    enableCopy: true,         // Enable copy buttons
  ),
  onNodeTap: (node) {
    print('Tapped: ${node.path}');
  },
)
```

### With Controller

```dart
final controller = JsonTreeController(
  config: JsonTreeConfig(expandDepth: 1),
);

// Set data
controller.setData(jsonData);

// Expand/collapse
controller.expandAll();
controller.collapseAll();
controller.toggleNode('root.users[0]');

// Search
controller.search('email');
controller.nextSearchResult();
controller.clearSearch();

// Selection
controller.selectNode('root.users[0].name');
controller.revealNode('root.users[0].name');

// Export
String jsonString = controller.toJsonString(pretty: true);

// Use in widget
VooJsonTree(
  controller: controller,
  theme: VooJsonTreeTheme.dark(),
)
```

### Custom Builders

Customize how nodes, keys, and values are rendered:

```dart
VooJsonTree(
  data: jsonData,
  builders: JsonTreeBuilders(
    // Custom key rendering
    keyBuilder: (context, node, defaultWidget) {
      if (node.key?.startsWith('_') == true) {
        return Text(
          node.key!,
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        );
      }
      return defaultWidget;
    },
    // Custom value rendering (e.g., make URLs clickable)
    valueBuilder: (context, node, defaultWidget) {
      if (node.value is String && (node.value as String).startsWith('http')) {
        return GestureDetector(
          onTap: () => launchUrl(Uri.parse(node.value)),
          child: Text(
            node.value,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
      return defaultWidget;
    },
    // Custom node wrapper (e.g., highlight special nodes)
    nodeBuilder: (context, node, defaultWidget) {
      if (node.key == 'important') {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber),
            borderRadius: BorderRadius.circular(4),
          ),
          child: defaultWidget,
        );
      }
      return defaultWidget;
    },
  ),
)
```

## Themes

### Built-in Themes

```dart
VooJsonTreeTheme.dark()         // Dark theme (default)
VooJsonTreeTheme.light()        // Light theme
VooJsonTreeTheme.vscode()       // VS Code inspired
VooJsonTreeTheme.monokai()      // Monokai inspired
VooJsonTreeTheme.fromTokens()   // Uses voo_tokens design system
VooJsonTreeTheme.system(context) // Inherits from Material theme
VooJsonTreeTheme.transparent()  // No background (for custom containers)
```

### Custom Theme

```dart
VooJsonTreeTheme(
  backgroundColor: Color(0xFF1E1E1E),
  keyColor: Color(0xFF9CDCFE),
  stringColor: Color(0xFFCE9178),
  numberColor: Color(0xFFB5CEA8),
  booleanColor: Color(0xFF569CD6),
  nullColor: Color(0xFF808080),
  bracketColor: Color(0xFFFFD700),
  fontFamily: 'JetBrains Mono',
  fontSize: 13.0,
  indentWidth: 20.0,
  showIndentGuides: true,
)
```

## Configuration Presets

```dart
JsonTreeConfig()            // Standard config
JsonTreeConfig.readOnly()   // No editing, no context menu
JsonTreeConfig.compact()    // Minimal UI
JsonTreeConfig.full()       // All features
JsonTreeConfig.minimal()    // Bare minimum (just tree display)
JsonTreeConfig.developer()  // Debug-friendly (all expanded)
JsonTreeConfig.editable()   // Editing-focused
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `expandDepth` | int | 1 | Default expand depth (-1 for all) |
| `showArrayIndices` | bool | true | Show array indices |
| `showNodeCount` | bool | true | Show child counts |
| `showRootNode` | bool | true | Show root node |
| `enableSearch` | bool | true | Enable search |
| `enableCopy` | bool | true | Enable copy buttons |
| `enableEditing` | bool | false | Enable editing |
| `enableSelection` | bool | true | Enable selection |
| `enableHover` | bool | true | Enable hover effects |
| `enableContextMenu` | bool | true | Enable right-click menu |
| `enableKeyboardNavigation` | bool | true | Enable keyboard nav |
| `animateExpansion` | bool | true | Animate expand/collapse |
| `maxDisplayStringLength` | int | 100 | Max string length |

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| Up/Down | Navigate nodes |
| Left/Right | Collapse/expand |
| Enter | Toggle expand |
| Ctrl+F | Focus search |
| Enter (search) | Next result |
| Shift+Enter | Previous result |
| Esc | Clear search |

## Token Integration

Use design tokens from voo_tokens for consistent styling:

```dart
// Access token values directly
JsonTreeTokens.indentWidth      // 16.0 (from spacing.md)
JsonTreeTokens.nodeSpacing      // 2.0 (from spacing.xxs)
JsonTreeTokens.containerRadius  // 8.0 (from radius.md)
JsonTreeTokens.expansionDuration // 250ms (from animation.durationNormal)

// Responsive font size
JsonTreeTokens.getResponsiveFontSize(screenWidth)

// Responsive indent width
JsonTreeTokens.getResponsiveIndentWidth(screenWidth)
```

## Architecture

This package follows clean architecture with atomic design:

```
lib/
├── src/
│   ├── domain/              # Entities and business logic
│   │   └── entities/
│   │       ├── json_node.dart
│   │       ├── json_tree_config.dart
│   │       ├── json_tree_theme.dart
│   │       ├── json_tree_tokens.dart
│   │       └── json_tree_builders.dart
│   ├── data/                # Services and state
│   │   ├── models/
│   │   └── services/
│   └── presentation/        # UI layer
│       ├── controllers/
│       └── widgets/
│           ├── atoms/       # Basic components
│           ├── molecules/   # Composite components
│           └── organisms/   # Complex components
└── voo_json_tree.dart       # Public API
```

## Dependencies

- **voo_tokens**: Design tokens for spacing, radius, animation
- **voo_responsive**: Responsive utilities and breakpoints
- **equatable**: Value equality for entities

## Contributing

Contributions are welcome! Please read the contribution guidelines in the main VooFlutter repository.

## License

MIT License - see LICENSE file for details.
