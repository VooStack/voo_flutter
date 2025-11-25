/// A feature-rich JSON tree viewer/editor widget for Flutter.
///
/// This package provides an interactive JSON tree visualization with:
/// - Collapsible/expandable nodes
/// - Syntax highlighting by value type
/// - Search functionality
/// - Copy path/value to clipboard
/// - Keyboard navigation
/// - Customizable theming
///
/// ## Getting Started
///
/// Add `voo_json_tree` to your `pubspec.yaml`:
///
/// ```yaml
/// dependencies:
///   voo_json_tree: ^0.1.0
/// ```
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:voo_json_tree/voo_json_tree.dart';
///
/// VooJsonTree(
///   data: {
///     'name': 'John Doe',
///     'age': 30,
///     'email': 'john@example.com',
///   },
/// )
/// ```
///
/// ## With Custom Theme
///
/// ```dart
/// VooJsonTree(
///   data: jsonData,
///   theme: VooJsonTreeTheme.monokai(),
///   config: JsonTreeConfig(
///     expandDepth: 2,
///     enableSearch: true,
///   ),
/// )
/// ```
library voo_json_tree;

// Domain Layer - Entities
export 'src/domain/entities/json_node.dart';
export 'src/domain/entities/json_node_type.dart';
export 'src/domain/entities/json_path.dart';
export 'src/domain/entities/json_search_result.dart';
export 'src/domain/entities/json_tree_builders.dart';
export 'src/domain/entities/json_tree_config.dart';
export 'src/domain/entities/json_tree_theme.dart';
export 'src/domain/entities/json_tree_tokens.dart';

// Data Layer - Models
export 'src/data/models/json_tree_state.dart';

// Data Layer - Services
export 'src/data/services/json_parser_service.dart';
export 'src/data/services/json_path_service.dart';
export 'src/data/services/json_search_service.dart';

// Presentation Layer - Controllers
export 'src/presentation/controllers/json_tree_controller.dart';

// Presentation Layer - Widgets (Main)
export 'src/presentation/widgets/voo_json_tree.dart';

// Presentation Layer - Organisms (for advanced customization)
export 'src/presentation/widgets/organisms/json_tree_toolbar.dart';
export 'src/presentation/widgets/organisms/json_tree_view.dart';
export 'src/presentation/widgets/organisms/voo_json_tree_responsive.dart';

// Presentation Layer - Molecules (for advanced customization)
export 'src/presentation/widgets/molecules/json_search_bar.dart';
export 'src/presentation/widgets/molecules/node_context_menu.dart';
export 'src/presentation/widgets/molecules/path_breadcrumb.dart';
export 'src/presentation/widgets/molecules/tree_node.dart';

// Presentation Layer - Atoms (for advanced customization)
export 'src/presentation/widgets/atoms/copy_button.dart';
export 'src/presentation/widgets/atoms/expand_icon.dart';
export 'src/presentation/widgets/atoms/json_key_text.dart';
export 'src/presentation/widgets/atoms/json_value_text.dart';
export 'src/presentation/widgets/atoms/node_bracket.dart';
