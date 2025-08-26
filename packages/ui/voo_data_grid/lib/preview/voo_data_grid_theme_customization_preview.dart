import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

class VooDataGridThemeCustomizationPreview extends StatefulWidget {
  const VooDataGridThemeCustomizationPreview({super.key});

  @override
  State<VooDataGridThemeCustomizationPreview> createState() =>
      _VooDataGridThemeCustomizationPreviewState();
}

class _VooDataGridThemeCustomizationPreviewState
    extends State<VooDataGridThemeCustomizationPreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;

  // Theme settings
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = Colors.blue;
  Color _accentColor = Colors.orange;
  double _borderRadius = 8.0;
  double _elevation = 2.0;
  double _rowHeight = 48.0;
  double _headerHeight = 56.0;
  double _fontSize = 14.0;
  FontWeight _headerFontWeight = FontWeight.bold;
  bool _showGridLines = true;
  bool _alternatingRows = true;
  bool _compactMode = false;
  String _fontFamily = 'Roboto';

  // Grid customization
  bool _stickyHeader = true;
  bool _resizableColumns = true;
  bool _reorderableColumns = false;
  bool _showRowNumbers = false;
  bool _highlightOnHover = true;

  @override
  void initState() {
    super.initState();
    _generateSampleData();
  }

  void _generateSampleData() {
    final products = List.generate(
      50,
      (index) => {
        'id': index + 1,
        'product': 'Product ${index + 1}',
        'category': [
          'Electronics',
          'Clothing',
          'Books',
          'Food',
          'Toys'
        ][index % 5],
        'price': (index + 1) * 9.99,
        'stock': index * 10,
        'rating': 3.0 + (index % 3),
        'discount': index % 4 == 0 ? 0.1 + (index % 3) * 0.05 : 0.0,
        'featured': index % 5 == 0,
      },
    );

    _dataSource = LocalDataGridSource(data: products);
    _dataSource.setSelectionMode(VooSelectionMode.single);

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: [
        if (_showRowNumbers)
          VooDataColumn(
            field: '#',
            label: '#',
            width: 50,
            cellBuilder: (context, value, row) {
              final index = _dataSource.rows.indexOf(row);
              return Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: _fontSize * 0.9,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              );
            },
          ),
        VooDataColumn(
          field: 'product',
          label: 'Product Name',
          flex: 2,
          sortable: true,
          filterable: true,
        ),
        VooDataColumn(
          field: 'category',
          label: 'Category',
          width: 120,
          sortable: true,
          filterable: true,
          cellBuilder: (context, value, row) {
            final category = row['category'] as String;
            final colors = {
              'Electronics': Colors.blue,
              'Clothing': Colors.purple,
              'Books': Colors.green,
              'Food': Colors.orange,
              'Toys': Colors.pink,
            };

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (colors[category] ?? Colors.grey).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(_borderRadius / 2),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: colors[category] ?? Colors.grey,
                  fontSize: _fontSize * 0.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
        VooDataColumn(
          field: 'price',
          label: 'Price',
          width: 100,
          sortable: true,
          valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
          cellBuilder: (context, value, row) {
            final price = row['price'] as double;
            final discount = row['discount'] as double;
            final hasDiscount = discount > 0;
            final discountedPrice = price * (1 - discount);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (hasDiscount)
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: _fontSize * 0.8,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                Text(
                  '\$${(hasDiscount ? discountedPrice : price).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight:
                        hasDiscount ? FontWeight.bold : FontWeight.normal,
                    color: hasDiscount ? _accentColor : null,
                  ),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'stock',
          label: 'Stock',
          width: 80,
          sortable: true,
          cellBuilder: (context, value, row) {
            final stock = row['stock'] as int;
            final color = stock > 100
                ? Colors.green
                : stock > 50
                    ? Colors.orange
                    : stock > 0
                        ? Colors.red
                        : Colors.grey;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  stock.toString(),
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        VooDataColumn(
          field: 'rating',
          label: 'Rating',
          width: 120,
          sortable: true,
          cellBuilder: (context, value, row) {
            final rating = row['rating'] as double;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                if (index < rating.floor()) {
                  return Icon(Icons.star, size: _fontSize, color: Colors.amber);
                } else if (index == rating.floor() && rating % 1 != 0) {
                  return Icon(Icons.star_half,
                      size: _fontSize, color: Colors.amber);
                } else {
                  return Icon(Icons.star_border,
                      size: _fontSize, color: Colors.grey);
                }
              }),
            );
          },
        ),
        VooDataColumn(
          field: 'featured',
          label: 'Featured',
          width: 80,
          cellBuilder: (context, value, row) {
            final featured = row['featured'] as bool;
            return Center(
              child: featured
                  ? Icon(Icons.star,
                      color: _primaryColor, size: _fontSize * 1.2)
                  : Icon(Icons.star_border,
                      color: Colors.grey, size: _fontSize),
            );
          },
        ),
      ],
      showFilters: true,
    );

    _dataSource.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: brightness,
      ),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: _fontSize),
        bodyMedium: TextStyle(fontSize: _fontSize),
        bodySmall: TextStyle(fontSize: _fontSize * 0.85),
        titleLarge:
            TextStyle(fontSize: _fontSize * 1.2, fontWeight: _headerFontWeight),
        titleMedium:
            TextStyle(fontSize: _fontSize * 1.1, fontWeight: _headerFontWeight),
      ),
      cardTheme: CardThemeData(
        elevation: _elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Customization Preview',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Grid Theme Customization'),
          backgroundColor: _primaryColor.withValues(alpha: 0.1),
          foregroundColor: _primaryColor,
        ),
        body: Row(
          children: [
            // Theme Controls Panel
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Mode Section
                    _buildSectionHeader('Theme Mode'),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System'),
                          icon: Icon(Icons.settings_brightness),
                        ),
                      ],
                      selected: {_themeMode},
                      onSelectionChanged: (Set<ThemeMode> selection) {
                        setState(() {
                          _themeMode = selection.first;
                        });
                      },
                    ),

                    SizedBox(height: 24),

                    // Color Section
                    _buildSectionHeader('Colors'),
                    _buildColorPicker('Primary Color', _primaryColor, (color) {
                      setState(() => _primaryColor = color);
                    }),
                    _buildColorPicker('Accent Color', _accentColor, (color) {
                      setState(() => _accentColor = color);
                    }),

                    SizedBox(height: 24),

                    // Typography Section
                    _buildSectionHeader('Typography'),
                    _buildSlider(
                      'Font Size',
                      _fontSize,
                      10,
                      20,
                      (value) => setState(() => _fontSize = value),
                      suffix: 'px',
                    ),
                    _buildDropdown<String>(
                      'Font Family',
                      _fontFamily,
                      [
                        'Roboto',
                        'Arial',
                        'Helvetica',
                        'Times New Roman',
                        'Courier'
                      ],
                      (value) => setState(() => _fontFamily = value!),
                    ),
                    _buildDropdown<FontWeight>(
                      'Header Weight',
                      _headerFontWeight,
                      [
                        FontWeight.normal,
                        FontWeight.w500,
                        FontWeight.w600,
                        FontWeight.bold,
                        FontWeight.w900,
                      ],
                      (value) => setState(() => _headerFontWeight = value!),
                      displayText: (weight) => switch (weight) {
                        FontWeight.normal => 'Normal',
                        FontWeight.w500 => 'Medium',
                        FontWeight.w600 => 'Semi Bold',
                        FontWeight.bold => 'Bold',
                        FontWeight.w900 => 'Black',
                        _ => weight.toString(),
                      },
                    ),

                    SizedBox(height: 24),

                    // Layout Section
                    _buildSectionHeader('Layout'),
                    _buildSlider(
                      'Row Height',
                      _rowHeight,
                      32,
                      72,
                      (value) => setState(() => _rowHeight = value),
                      suffix: 'px',
                    ),
                    _buildSlider(
                      'Header Height',
                      _headerHeight,
                      40,
                      80,
                      (value) => setState(() => _headerHeight = value),
                      suffix: 'px',
                    ),
                    _buildSlider(
                      'Border Radius',
                      _borderRadius,
                      0,
                      24,
                      (value) => setState(() => _borderRadius = value),
                      suffix: 'px',
                    ),
                    _buildSlider(
                      'Elevation',
                      _elevation,
                      0,
                      12,
                      (value) => setState(() => _elevation = value),
                    ),

                    SizedBox(height: 24),

                    // Grid Options Section
                    _buildSectionHeader('Grid Options'),
                    _buildSwitch('Show Grid Lines', _showGridLines, (value) {
                      setState(() => _showGridLines = value);
                    }),
                    _buildSwitch('Alternating Rows', _alternatingRows, (value) {
                      setState(() => _alternatingRows = value);
                    }),
                    _buildSwitch('Compact Mode', _compactMode, (value) {
                      setState(() {
                        _compactMode = value;
                        if (value) {
                          _rowHeight = 36;
                          _headerHeight = 44;
                          _fontSize = 12;
                        } else {
                          _rowHeight = 48;
                          _headerHeight = 56;
                          _fontSize = 14;
                        }
                      });
                    }),
                    _buildSwitch('Sticky Header', _stickyHeader, (value) {
                      setState(() => _stickyHeader = value);
                    }),
                    _buildSwitch('Resizable Columns', _resizableColumns,
                        (value) {
                      setState(() => _resizableColumns = value);
                    }),
                    _buildSwitch('Reorderable Columns', _reorderableColumns,
                        (value) {
                      setState(() => _reorderableColumns = value);
                    }),
                    _buildSwitch('Show Row Numbers', _showRowNumbers, (value) {
                      setState(() {
                        _showRowNumbers = value;
                        _generateSampleData(); // Regenerate to add/remove row numbers column
                      });
                    }),
                    _buildSwitch('Highlight on Hover', _highlightOnHover,
                        (value) {
                      setState(() => _highlightOnHover = value);
                    }),

                    SizedBox(height: 24),

                    // Reset Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _themeMode = ThemeMode.light;
                            _primaryColor = Colors.blue;
                            _accentColor = Colors.orange;
                            _borderRadius = 8.0;
                            _elevation = 2.0;
                            _rowHeight = 48.0;
                            _headerHeight = 56.0;
                            _fontSize = 14.0;
                            _headerFontWeight = FontWeight.bold;
                            _showGridLines = true;
                            _alternatingRows = true;
                            _compactMode = false;
                            _fontFamily = 'Roboto';
                            _stickyHeader = true;
                            _resizableColumns = true;
                            _reorderableColumns = false;
                            _showRowNumbers = false;
                            _highlightOnHover = true;
                            _generateSampleData();
                          });
                        },
                        icon: Icon(Icons.restore),
                        label: Text('Reset to Defaults'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Data Grid Preview
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Preview Header
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(_borderRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: _primaryColor),
                          SizedBox(width: 8),
                          Text(
                            'Live Preview',
                            style: TextStyle(
                              fontSize: _fontSize * 1.2,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _accentColor.withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(_borderRadius / 2),
                            ),
                            child: Text(
                              'Theme: ${_themeMode.name}',
                              style: TextStyle(
                                color: _accentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Data Grid
                    Expanded(
                      child: Card(
                        elevation: _elevation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dataTableTheme: DataTableThemeData(
                                headingRowHeight: _headerHeight,
                                dataRowMinHeight: _rowHeight,
                                dataRowMaxHeight: _rowHeight,
                                headingTextStyle: TextStyle(
                                  fontSize: _fontSize,
                                  fontWeight: _headerFontWeight,
                                  fontFamily: _fontFamily,
                                ),
                                dataTextStyle: TextStyle(
                                  fontSize: _fontSize,
                                  fontFamily: _fontFamily,
                                ),
                                decoration: _showGridLines
                                    ? BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                                Theme.of(context).dividerColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            child: VooDataGrid(
                              controller: _controller,
                              showPagination: true,
                              // Additional theme properties would be passed here
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildColorPicker(
      String label, Color color, ValueChanged<Color> onChanged) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () => onChanged(c),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: color == c ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: color == c
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12)),
            Text(
              '${value.toStringAsFixed(0)}${suffix ?? ''}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T value,
    List<T> items,
    ValueChanged<T?> onChanged, {
    String Function(T)? displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12)),
        SizedBox(height: 8),
        DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayText != null ? displayText(item) : item.toString(),
                style: TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 12),
      ],
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
