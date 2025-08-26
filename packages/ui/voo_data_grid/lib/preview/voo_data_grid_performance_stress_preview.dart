import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class VooDataGridPerformanceStressPreview extends StatefulWidget {
  const VooDataGridPerformanceStressPreview({super.key});

  @override
  State<VooDataGridPerformanceStressPreview> createState() =>
      _VooDataGridPerformanceStressPreviewState();
}

class _VooDataGridPerformanceStressPreviewState
    extends State<VooDataGridPerformanceStressPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;
  final Random _random = Random();

  // Performance metrics
  int _rowCount = 1000;
  int _columnCount = 20;
  bool _isGenerating = false;
  DateTime? _lastGenerationTime;
  Duration? _generationDuration;
  // DateTime? _lastRenderTime;
  int _frameCount = 0;
  double _fps = 0;
  Timer? _fpsTimer;
  Timer? _updateTimer;
  bool _autoUpdate = false;
  int _updateFrequency = 1000; // milliseconds

  // Test modes
  bool _enableVirtualization = true;
  bool _enableCaching = true;
  bool _enableLazyLoading = true;
  bool _showComplexCells = false;
  bool _showManyColumns = false;

  @override
  void initState() {
    super.initState();
    _generateData();
    _startFpsMonitor();
  }

  void _startFpsMonitor() {
    _fpsTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _fps = _frameCount.toDouble();
        _frameCount = 0;
      });
    });
  }

  void _generateData() async {
    setState(() {
      _isGenerating = true;
      _lastGenerationTime = DateTime.now();
    });

    final data = <Map<String, dynamic>>[];

    // Generate data in chunks to avoid blocking UI
    const chunkSize = 100;
    for (int chunk = 0; chunk < (_rowCount / chunkSize).ceil(); chunk++) {
      final start = chunk * chunkSize;
      final end = min((chunk + 1) * chunkSize, _rowCount);

      for (int i = start; i < end; i++) {
        final row = <String, dynamic>{
          'id': i + 1,
          'index': i,
        };

        // Generate columns based on settings
        final colCount = _showManyColumns ? 50 : _columnCount;
        for (int j = 0; j < colCount; j++) {
          row['col_$j'] = _generateCellValue(i, j);
        }

        // Add metadata
        row['timestamp'] = DateTime.now().millisecondsSinceEpoch;
        row['random'] = _random.nextDouble();

        data.add(row);
      }

      // Allow UI to update between chunks
      if (chunk % 5 == 0) {
        await Future.delayed(Duration(microseconds: 1));
      }
    }

    // Initialize data source
    _dataSource = LocalDataGridSource(data: data);

    // Generate columns
    final columns = <VooDataColumn>[
      VooDataColumn(
        field: 'id',
        label: 'ID',
        width: 60,
        sortable: true,
      ),
    ];

    final colCount = _showManyColumns ? 50 : _columnCount;
    for (int j = 0; j < colCount; j++) {
      columns.add(
        VooDataColumn(
          field: 'col_$j',
          label: 'Column ${j + 1}',
          width: _showManyColumns ? 100 : 120,
          sortable: j < 5, // Only first 5 columns sortable for performance
          filterable: j < 3, // Only first 3 columns filterable
          // cellBuilder: _showComplexCells ? _buildComplexCell : null,
        ),
      );
    }

    // Initialize controller
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: columns,
      showFilters: true,
    );

    _dataSource.loadData();

    final endTime = DateTime.now();
    setState(() {
      _isGenerating = false;
      _generationDuration = endTime.difference(_lastGenerationTime!);
      // _lastRenderTime = DateTime.now();
    });
  }

  dynamic _generateCellValue(int row, int col) {
    if (_showComplexCells) {
      // Generate complex data for stress testing
      return {
        'value': 'R${row}C$col',
        'numeric': _random.nextDouble() * 1000,
        'status': ['active', 'pending', 'completed'][_random.nextInt(3)],
        'progress': _random.nextDouble(),
        'tags': List.generate(_random.nextInt(3) + 1, (i) => 'tag$i'),
      };
    } else {
      // Simple string value
      final type = col % 4;
      switch (type) {
        case 0:
          return 'Text_R${row}_C$col';
        case 1:
          return (_random.nextDouble() * 1000).toStringAsFixed(2);
        case 2:
          return _random.nextBool();
        case 3:
          return DateTime.now()
              .add(Duration(hours: row * col))
              .toIso8601String();
        default:
          return 'Value_${row}_$col';
      }
    }
  }

  // Complex cell builder removed for simplicity - would implement custom cell rendering here

  void _startAutoUpdate() {
    _updateTimer?.cancel();
    if (_autoUpdate) {
      _updateTimer =
          Timer.periodic(Duration(milliseconds: _updateFrequency), (_) {
        _updateRandomRows();
      });
    }
  }

  void _updateRandomRows() {
    if (_dataSource.rows.isEmpty) return;

    // Update 10 random rows
    for (int i = 0; i < 10; i++) {
      final index = _random.nextInt(_dataSource.rows.length);
      final row = Map<String, dynamic>.from(_dataSource.rows[index]);

      // Update some values
      for (int j = 0; j < 3; j++) {
        final colIndex = _random.nextInt(_columnCount);
        row['col_$colIndex'] = _generateCellValue(index, colIndex);
      }
      row['timestamp'] = DateTime.now().millisecondsSinceEpoch;

      _dataSource.rows[index] = row;
    }

    setState(() {
      // Trigger UI update
      _dataSource.loadData();
    });
  }

  @override
  void dispose() {
    _fpsTimer?.cancel();
    _updateTimer?.cancel();
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Performance Stress Test'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Row(
          children: [
            // Control Panel
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                border: Border(
                  right: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Metrics',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // Metrics Display
                    _buildMetricCard(
                      'FPS',
                      _fps.toStringAsFixed(1),
                      _fps > 50
                          ? Colors.green
                          : _fps > 30
                              ? Colors.orange
                              : Colors.red,
                    ),
                    _buildMetricCard(
                      'Rows',
                      _rowCount.toString(),
                      Colors.blue,
                    ),
                    _buildMetricCard(
                      'Columns',
                      (_showManyColumns ? 50 : _columnCount).toString(),
                      Colors.blue,
                    ),
                    if (_generationDuration != null)
                      _buildMetricCard(
                        'Generation Time',
                        '${_generationDuration!.inMilliseconds}ms',
                        _generationDuration!.inMilliseconds < 1000
                            ? Colors.green
                            : Colors.orange,
                      ),

                    Divider(height: 32),

                    Text(
                      'Data Configuration',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // Row Count Slider
                    Text('Rows: $_rowCount'),
                    Slider(
                      value: _rowCount.toDouble(),
                      min: 100,
                      max: 10000,
                      divisions: 99,
                      label: _rowCount.toString(),
                      onChanged: (value) {
                        setState(() {
                          _rowCount = value.toInt();
                        });
                      },
                    ),

                    // Column Count Slider
                    Text('Columns: $_columnCount'),
                    Slider(
                      value: _columnCount.toDouble(),
                      min: 5,
                      max: 50,
                      divisions: 45,
                      label: _columnCount.toString(),
                      onChanged: !_showManyColumns
                          ? (value) {
                              setState(() {
                                _columnCount = value.toInt();
                              });
                            }
                          : null,
                    ),

                    ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateData,
                      icon: Icon(Icons.refresh),
                      label: Text(
                          _isGenerating ? 'Generating...' : 'Regenerate Data'),
                    ),

                    Divider(height: 32),

                    Text(
                      'Stress Test Options',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    SwitchListTile(
                      title: Text('Complex Cells'),
                      subtitle: Text('Render complex cell content'),
                      value: _showComplexCells,
                      onChanged: (value) {
                        setState(() {
                          _showComplexCells = value;
                          _generateData();
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    SwitchListTile(
                      title: Text('Many Columns'),
                      subtitle: Text('Show 50 columns'),
                      value: _showManyColumns,
                      onChanged: (value) {
                        setState(() {
                          _showManyColumns = value;
                          _generateData();
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    SwitchListTile(
                      title: Text('Auto Update'),
                      subtitle: Text('Update random rows'),
                      value: _autoUpdate,
                      onChanged: (value) {
                        setState(() {
                          _autoUpdate = value;
                          _startAutoUpdate();
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    if (_autoUpdate) ...[
                      Text('Update Frequency: ${_updateFrequency}ms'),
                      Slider(
                        value: _updateFrequency.toDouble(),
                        min: 100,
                        max: 5000,
                        divisions: 49,
                        label: '${_updateFrequency}ms',
                        onChanged: (value) {
                          setState(() {
                            _updateFrequency = value.toInt();
                            _startAutoUpdate();
                          });
                        },
                      ),
                    ],

                    Divider(height: 32),

                    Text(
                      'Optimization Settings',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    SwitchListTile(
                      title: Text('Virtualization'),
                      subtitle: Text('Only render visible rows'),
                      value: _enableVirtualization,
                      onChanged: (value) {
                        setState(() {
                          _enableVirtualization = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    SwitchListTile(
                      title: Text('Caching'),
                      subtitle: Text('Cache rendered cells'),
                      value: _enableCaching,
                      onChanged: (value) {
                        setState(() {
                          _enableCaching = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    SwitchListTile(
                      title: Text('Lazy Loading'),
                      subtitle: Text('Load data on demand'),
                      value: _enableLazyLoading,
                      onChanged: (value) {
                        setState(() {
                          _enableLazyLoading = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    Divider(height: 32),

                    // Actions
                    ElevatedButton.icon(
                      onPressed: () {
                        // Scroll test - would need to implement this method
                        // _controller.scrollToRow(_rowCount ~/ 2);
                      },
                      icon: Icon(Icons.vertical_align_center),
                      label: Text('Scroll to Middle'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Sort test - would need to implement this method
                        // _controller.sort('col_0', ascending: _random.nextBool());
                      },
                      icon: Icon(Icons.sort),
                      label: Text('Random Sort'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Filter test - would need to implement this method
                        // Toggle filter logic would go here
                      },
                      icon: Icon(Icons.filter_list),
                      label: Text('Toggle Filter'),
                    ),
                  ],
                ),
              ),
            ),

            // Data Grid
            Expanded(
              child: _isGenerating
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Generating $_rowCount rows...'),
                        ],
                      ),
                    )
                  : VooDataGrid(
                      controller: _controller,
                      showPagination: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class for local data source
class LocalDataGridSource extends VooDataGridSource {
  LocalDataGridSource({
    List<dynamic>? data,
  }) : super(mode: VooDataGridMode.local) {
    if (data != null) {
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
    // Not needed for local mode
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}
