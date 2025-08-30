# VooDataGrid Migration Guide

## Breaking Change: VooDataGridSource No Longer Extends ChangeNotifier

### Why This Change?

The previous implementation of `VooDataGridSource` extended `ChangeNotifier`, which caused conflicts with state management solutions like Cubit/BLoC. This forced inheritance approach prevented users from using their preferred state management patterns.

### What Changed?

**Before (v0.x.x):**
```dart
abstract class VooDataGridSource<T> extends ChangeNotifier {
  // ...
}
```

**After (v1.0.0):**
```dart
// State-management agnostic interface
abstract class VooDataGridDataSource<T> {
  Future<VooDataGridResponse<T>> fetchRemoteData({...});
  void dispose() {}
}
```

## Migration Examples

### 1. Using with Cubit (flutter_bloc)

**Your Repository (implements data fetching only):**
```dart
import 'package:voo_data_grid/voo_data_grid.dart';

class OrderRepositoryImpl extends VooDataGridDataSource<OrderList> {
  final OrderRemoteDataSource remoteDataSource = OrderRemoteDataSource();

  @override
  Future<VooDataGridResponse<OrderList>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    try {
      final response = await remoteDataSource.getOrders({
        'page': page,
        'pageSize': pageSize,
        // Convert filters and sorts to your API format
      });
      
      return VooDataGridResponse<OrderList>(
        rows: response.items,
        totalRows: response.totalCount,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      rethrow;
    }
  }
}
```

**Your Cubit (handles state management):**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class OrderGridCubit extends Cubit<VooDataGridState<OrderList>> {
  final OrderRepositoryImpl repository;
  Timer? _debounceTimer;

  OrderGridCubit({required this.repository}) 
    : super(const VooDataGridState<OrderList>());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final response = await repository.fetchRemoteData(
        page: state.currentPage,
        pageSize: state.pageSize,
        filters: state.filters,
        sorts: state.sorts,
      );
      
      emit(state.copyWith(
        rows: response.rows,
        totalRows: response.totalRows,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void applyFilter(String field, VooDataFilter? filter) {
    final newFilters = Map<String, VooDataFilter>.from(state.filters);
    if (filter == null) {
      newFilters.remove(field);
    } else {
      newFilters[field] = filter;
    }
    emit(state.copyWith(filters: newFilters, currentPage: 0));
    _debouncedLoadData();
  }

  void changePage(int page) {
    emit(state.copyWith(currentPage: page));
    loadData();
  }

  void _debouncedLoadData() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), loadData);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    repository.dispose();
    return super.close();
  }
}
```

**Using in your widget:**
```dart
BlocProvider(
  create: (context) => OrderGridCubit(
    repository: OrderRepositoryImpl(),
  )..loadData(),
  child: BlocBuilder<OrderGridCubit, VooDataGridState<OrderList>>(
    builder: (context, state) {
      return VooDataGrid<OrderList>(
        state: state,
        columns: [...],
        onPageChanged: (page) => context.read<OrderGridCubit>().changePage(page),
        onFilterChanged: (field, filter) => 
          context.read<OrderGridCubit>().applyFilter(field, filter),
        onSortChanged: (field, direction) => 
          context.read<OrderGridCubit>().applySort(field, direction),
      );
    },
  ),
)
```

### 2. Using with Provider (ChangeNotifier)

**Use the provided VooDataGridStateController:**
```dart
import 'package:provider/provider.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

// Your repository stays the same
class OrderRepositoryImpl extends VooDataGridDataSource<OrderList> {
  // Same implementation as above
}

// In your widget
ChangeNotifierProvider(
  create: (context) => VooDataGridStateController<OrderList>(
    dataSource: OrderRepositoryImpl(),
    mode: VooDataGridMode.remote,
  )..loadData(),
  child: Consumer<VooDataGridStateController<OrderList>>(
    builder: (context, controller, child) {
      return VooDataGrid<OrderList>(
        state: controller.state,
        columns: [...],
        onPageChanged: controller.changePage,
        onFilterChanged: controller.applyFilter,
        onSortChanged: controller.applySort,
      );
    },
  ),
)
```

### 3. Using with Riverpod

**StateNotifier approach:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class OrderGridNotifier extends StateNotifier<VooDataGridState<OrderList>> {
  final OrderRepositoryImpl repository;
  Timer? _debounceTimer;

  OrderGridNotifier({required this.repository}) 
    : super(const VooDataGridState<OrderList>());

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final response = await repository.fetchRemoteData(
        page: state.currentPage,
        pageSize: state.pageSize,
        filters: state.filters,
        sorts: state.sorts,
      );
      
      state = state.copyWith(
        rows: response.rows,
        totalRows: response.totalRows,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Add other methods similar to Cubit example
}

// Provider definition
final orderGridProvider = StateNotifierProvider<OrderGridNotifier, VooDataGridState<OrderList>>((ref) {
  return OrderGridNotifier(
    repository: OrderRepositoryImpl(),
  )..loadData();
});

// In your widget
Consumer(
  builder: (context, ref, child) {
    final state = ref.watch(orderGridProvider);
    final notifier = ref.read(orderGridProvider.notifier);
    
    return VooDataGrid<OrderList>(
      state: state,
      columns: [...],
      onPageChanged: notifier.changePage,
      onFilterChanged: notifier.applyFilter,
      onSortChanged: notifier.applySort,
    );
  },
)
```

### 4. Using with GetX

```dart
import 'package:get/get.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class OrderGridController extends GetxController {
  final OrderRepositoryImpl repository;
  final Rx<VooDataGridState<OrderList>> state = 
    const VooDataGridState<OrderList>().obs;

  OrderGridController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    state.value = state.value.copyWith(isLoading: true);
    
    try {
      final response = await repository.fetchRemoteData(
        page: state.value.currentPage,
        pageSize: state.value.pageSize,
        filters: state.value.filters,
        sorts: state.value.sorts,
      );
      
      state.value = state.value.copyWith(
        rows: response.rows,
        totalRows: response.totalRows,
        isLoading: false,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Add other methods
}

// In your widget
GetBuilder<OrderGridController>(
  init: OrderGridController(repository: OrderRepositoryImpl()),
  builder: (controller) {
    return Obx(() => VooDataGrid<OrderList>(
      state: controller.state.value,
      columns: [...],
      onPageChanged: controller.changePage,
      onFilterChanged: controller.applyFilter,
      onSortChanged: controller.applySort,
    ));
  },
)
```

## Key Benefits

1. **No Forced Inheritance**: Your repository doesn't extend ChangeNotifier
2. **State Management Freedom**: Use any state management solution
3. **Better Separation of Concerns**: Data fetching is separate from state management
4. **Type Safety**: Strongly typed with generics throughout
5. **Testability**: Easier to mock and test components independently

## VooDataGrid Widget Changes

The `VooDataGrid` widget now accepts a `state` parameter instead of a `dataSource`:

**Before:**
```dart
VooDataGrid<T>(
  dataSource: myDataSource,
  columns: [...],
)
```

**After:**
```dart
VooDataGrid<T>(
  state: myState, // VooDataGridState<T>
  columns: [...],
  onPageChanged: (page) => ...,
  onFilterChanged: (field, filter) => ...,
  onSortChanged: (field, direction) => ...,
)
```

## Helper Classes Available

### For Provider Users
Use `VooDataGridStateController<T>` which extends ChangeNotifier and manages state for you.

### For Everyone
- `VooDataGridState<T>`: Immutable state class with copyWith method
- `VooDataGridDataSource<T>`: Simple interface for data fetching
- `VooDataGridResponse<T>`: Response wrapper for data source results

## Need Help?

If you're having trouble migrating, please:
1. Check the example app for complete implementations
2. File an issue with your specific use case
3. Join our Discord for community support