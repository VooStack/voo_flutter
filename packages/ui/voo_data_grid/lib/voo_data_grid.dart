library;

// Domain Layer - Entities
export 'src/domain/entities/data_grid_column.dart';
export 'src/domain/entities/data_grid_filter.dart';
export 'src/domain/entities/data_grid_types.dart';
export 'src/domain/entities/typed_data_column.dart';
export 'src/domain/entities/filter_type_extensions.dart';

// Data Layer - Datasources
export 'src/data/datasources/advanced_remote_data_source.dart';
export 'src/data/datasources/data_grid_source.dart'; // Legacy ChangeNotifier-based - will be deprecated
export 'src/data/datasources/data_grid_source_base.dart'; // New state-agnostic interface

// Data Layer - Models
export 'src/data/models/advanced_filters.dart';
export 'src/data/models/data_grid_constraints.dart';

// Presentation Layer - Controllers
export 'src/presentation/controllers/data_grid_controller.dart';
export 'src/presentation/controllers/voo_data_grid_controller.dart'
    show VooDataGridStateController; // For Provider users

// Presentation Layer - Widgets
export 'src/presentation/widgets/data_grid.dart';
export 'src/presentation/widgets/data_grid_header.dart';
export 'src/presentation/widgets/data_grid_pagination.dart';
export 'src/presentation/widgets/data_grid_row.dart';
export 'src/presentation/widgets/optimized_data_grid_row.dart'; // Performance-optimized row widget
export 'src/presentation/widgets/voo_data_grid_stateless.dart'; // New state-agnostic widget

// Presentation Layer - Organisms
export 'src/presentation/widgets/organisms/advanced_filter_widget.dart';

// Utils
export 'src/utils/data_grid_request_builder.dart';
export 'src/utils/synchronized_scroll_controller.dart';