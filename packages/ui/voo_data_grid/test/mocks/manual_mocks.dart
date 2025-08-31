import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Manual mock for VooDataGridSource (generic class)
class MockVooDataGridSource<T> extends Mock implements VooDataGridSource<T> {
  List<T> _rows = [];
  List<T> _allRows = [];
  int _totalRows = 0;
  bool _isLoading = false;
  String? _error;
  VooDataGridMode _mode = VooDataGridMode.local;

  @override
  List<T> get rows => _rows;
  
  @override
  List<T> get allRows => _allRows;
  
  @override
  int get totalRows => _totalRows;
  
  @override
  bool get isLoading => _isLoading;
  
  @override
  String? get error => _error;
  
  @override
  VooDataGridMode get mode => _mode;

  void setRows(List<T> rows) {
    _rows = rows;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  void setError(String? error) {
    _error = error;
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    return super.noSuchMethod(
      Invocation.method(
        #fetchRemoteData,
        [],
        {
          #page: page,
          #pageSize: pageSize,
          #filters: filters,
          #sorts: sorts,
        },
      ),
      returnValue: Future.value(VooDataGridResponse(
        rows: [],
        totalRows: 0,
        page: page,
        pageSize: pageSize,
      )),
      returnValueForMissingStub: Future.value(VooDataGridResponse(
        rows: [],
        totalRows: 0,
        page: page,
        pageSize: pageSize,
      )),
    );
  }
}

/// Manual mock for DataGridController
class MockDataGridController extends Mock implements DataGridController {
  final _notifier = ValueNotifier<DataGridState>(const DataGridState());
  
  @override
  ValueListenable<DataGridState> get state => _notifier;
  
  @override
  DataGridState get currentState => _notifier.value;

  void setState(DataGridState newState) {
    _notifier.value = newState;
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.noSuchMethod(Invocation.method(#dispose, []));
  }
}

/// Manual mock for BuildContext
class MockBuildContext extends Mock implements BuildContext {}

/// Test stub for VooDataGridSource implementation
class StubVooDataGridSource extends VooDataGridSource<Map<String, dynamic>> {
  StubVooDataGridSource({
    List<Map<String, dynamic>>? data,
    VooDataGridMode mode = VooDataGridMode.local,
  }) : super(mode: mode) {
    if (data != null && mode == VooDataGridMode.local) {
      setLocalData(data);
    }
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 50));
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}