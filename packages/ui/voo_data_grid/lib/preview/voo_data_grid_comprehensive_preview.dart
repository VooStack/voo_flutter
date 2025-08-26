import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'dart:math';
import 'dart:convert';

/// Comprehensive preview with all features including advanced filtering
@pragma('preview')
class VooDataGridComprehensivePreview extends StatefulWidget {
  const VooDataGridComprehensivePreview({super.key});

  @override
  State<VooDataGridComprehensivePreview> createState() =>
      _VooDataGridComprehensivePreviewState();
}

class _VooDataGridComprehensivePreviewState
    extends State<VooDataGridComprehensivePreview> {
  late VooDataGridController _controller;
  late AdvancedRemoteDataSource _dataSource;
  bool _showAdvancedFilter = false;
  bool _showApiRequest = false;
  Map<String, dynamic> _lastApiRequest = {};
  final ScrollController _apiRequestScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _dataSource = AdvancedRemoteDataSource(
      apiEndpoint: '/api/employees',
      httpClient: (url, body, headers) async {
        // Simulate API call - in real app this would make actual HTTP request
        setState(() {
          _lastApiRequest = body;
        });

        // Return simulated data
        return {
          'data': _dataSource.rows,
          'total': _dataSource.totalRows,
          'page': 0,
          'pageSize': 20,
        };
      },
      useAdvancedFilters: true,
    );

    // Load initial data
    _dataSource.setLocalData(_generateComprehensiveData());

    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: _buildComprehensiveColumns(),
      showFilters: true,
    );

    _dataSource.loadData();
  }

  List<Map<String, dynamic>> _generateComprehensiveData() {
    final random = Random();
    final data = <Map<String, dynamic>>[];

    final departments = [
      'Engineering',
      'Sales',
      'Marketing',
      'HR',
      'Finance',
      'Operations',
      'Support'
    ];
    final locations = [
      'New York',
      'San Francisco',
      'London',
      'Tokyo',
      'Sydney',
      'Berlin',
      'Paris'
    ];
    final skills = [
      'Flutter',
      'React',
      'Python',
      'Java',
      'AWS',
      'Docker',
      'Kubernetes',
      'SQL'
    ];
    final statuses = ['Active', 'On Leave', 'Training', 'Remote', 'Contract'];
    final levels = ['Junior', 'Mid', 'Senior', 'Lead', 'Principal', 'Director'];
    final projects = [
      'Project Alpha',
      'Project Beta',
      'Project Gamma',
      'Project Delta',
      'Project Epsilon'
    ];

    for (int i = 1; i <= 500; i++) {
      final isManager = random.nextBool();
      final performanceScore = 60 + random.nextInt(40); // 60-100
      final yearsExperience = random.nextInt(20);

      data.add({
        'id': i,
        'employeeCode': 'EMP${i.toString().padLeft(6, '0')}',
        'firstName': _getRandomFromList([
          'John',
          'Jane',
          'Michael',
          'Sarah',
          'David',
          'Emily',
          'James',
          'Jessica'
        ]),
        'lastName': _getRandomFromList([
          'Smith',
          'Johnson',
          'Williams',
          'Brown',
          'Jones',
          'Garcia',
          'Miller'
        ]),
        'email': 'employee$i@company.com',
        'phone':
            '+1 555-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}',
        'department': departments[random.nextInt(departments.length)],
        'location': locations[random.nextInt(locations.length)],
        'level': levels[random.nextInt(levels.length)],
        'status': statuses[random.nextInt(statuses.length)],
        'isActive': random.nextBool(),
        'isManager': isManager,
        'teamSize': isManager ? random.nextInt(20) + 1 : 0,
        'salary': 50000 + random.nextInt(150000),
        'bonus': (5000 + random.nextInt(45000)) * (performanceScore / 100),
        'stockOptions': random.nextInt(10000),
        'performanceScore': performanceScore,
        'rating': (performanceScore / 20).round(), // 1-5 stars
        'completionRate': 50 + random.nextInt(50), // 50-100%
        'efficiency': 60 + random.nextInt(40), // 60-100%
        'skills': List.generate(random.nextInt(4) + 1,
            (index) => skills[random.nextInt(skills.length)]).toSet().toList(),
        'projects': List.generate(random.nextInt(3) + 1,
                (index) => projects[random.nextInt(projects.length)])
            .toSet()
            .toList(),
        'startDate': DateTime(2010 + random.nextInt(14), random.nextInt(12) + 1,
            random.nextInt(28) + 1),
        'lastReviewDate':
            DateTime(2024, random.nextInt(12) + 1, random.nextInt(28) + 1),
        'nextReviewDate':
            DateTime(2025, random.nextInt(12) + 1, random.nextInt(28) + 1),
        'birthDate': DateTime(1970 + random.nextInt(35), random.nextInt(12) + 1,
            random.nextInt(28) + 1),
        'vacationDays': random.nextInt(30),
        'sickDays': random.nextInt(10),
        'workFromHomeDays': random.nextInt(5),
        'yearsExperience': yearsExperience,
        'certifications': random.nextInt(5),
        'trainingsCompleted': random.nextInt(20),
        'notes': 'Employee notes for ID $i',
        'avatarUrl': 'https://i.pravatar.cc/150?img=${random.nextInt(70)}',
      });
    }

    return data;
  }

  String _getRandomFromList(List<String> list) {
    return list[Random().nextInt(list.length)];
  }

  List<VooDataColumn> _buildComprehensiveColumns() {
    return [
      // Frozen ID column
      const VooDataColumn(
        field: 'employeeCode',
        label: 'Emp Code',
        width: 100,
        frozen: true,
        sortable: true,
        filterable: true,
      ),

      // Basic info columns
      const VooDataColumn(
        field: 'firstName',
        label: 'First Name',
        width: 120,
        sortable: true,
        filterable: true,
      ),
      const VooDataColumn(
        field: 'lastName',
        label: 'Last Name',
        width: 120,
        sortable: true,
        filterable: true,
      ),
      const VooDataColumn(
        field: 'email',
        label: 'Email',
        width: 200,
        sortable: true,
        filterable: true,
      ),
      const VooDataColumn(
        field: 'phone',
        label: 'Phone',
        width: 150,
        filterable: true,
      ),

      // Department and location
      const VooDataColumn(
        field: 'department',
        label: 'Department',
        width: 120,
        sortable: true,
        filterable: true,
      ),
      const VooDataColumn(
        field: 'location',
        label: 'Location',
        width: 120,
        sortable: true,
        filterable: true,
      ),
      const VooDataColumn(
        field: 'level',
        label: 'Level',
        width: 100,
        sortable: true,
        filterable: true,
      ),

      // Status columns with custom rendering
      VooDataColumn(
        field: 'status',
        label: 'Status',
        width: 100,
        sortable: true,
        filterable: true,
        cellBuilder: (context, value, row) {
          final status = row['status'];
          Color color;
          IconData icon;

          switch (status) {
            case 'Active':
              color = Colors.green;
              icon = Icons.check_circle;
              break;
            case 'On Leave':
              color = Colors.orange;
              icon = Icons.flight;
              break;
            case 'Training':
              color = Colors.blue;
              icon = Icons.school;
              break;
            case 'Remote':
              color = Colors.purple;
              icon = Icons.home;
              break;
            default:
              color = Colors.grey;
              icon = Icons.work;
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(status, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          );
        },
      ),

      // Boolean columns
      VooDataColumn(
        field: 'isActive',
        label: 'Active',
        width: 80,
        sortable: true,
        filterable: true,
        cellBuilder: (context, value, row) {
          final isActive = row['isActive'] == true;
          return Center(
            child: Icon(
              isActive ? Icons.check_box : Icons.check_box_outline_blank,
              color: isActive ? Colors.green : Colors.grey,
              size: 20,
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'isManager',
        label: 'Manager',
        width: 80,
        sortable: true,
        filterable: true,
        cellBuilder: (context, value, row) {
          final isManager = row['isManager'] == true;
          return Center(
            child: isManager
                ? Icon(Icons.supervisor_account, color: Colors.blue, size: 20)
                : const SizedBox.shrink(),
          );
        },
      ),

      // Numeric columns
      VooDataColumn(
        field: 'teamSize',
        label: 'Team',
        width: 70,
        sortable: true,
        textAlign: TextAlign.right,
        valueFormatter: (value) => value > 0 ? value.toString() : '-',
      ),

      // Currency columns
      VooDataColumn(
        field: 'salary',
        label: 'Salary',
        width: 120,
        sortable: true,
        filterable: true,
        textAlign: TextAlign.right,
        valueFormatter: (value) =>
            '\$${(value as num).toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}',
      ),
      VooDataColumn(
        field: 'bonus',
        label: 'Bonus',
        width: 100,
        sortable: true,
        textAlign: TextAlign.right,
        valueFormatter: (value) =>
            '\$${(value as num).toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}',
      ),
      VooDataColumn(
        field: 'stockOptions',
        label: 'Stock',
        width: 80,
        sortable: true,
        textAlign: TextAlign.right,
        valueFormatter: (value) => value.toString(),
      ),

      // Performance metrics with custom rendering
      VooDataColumn(
        field: 'performanceScore',
        label: 'Performance',
        width: 120,
        sortable: true,
        filterable: true,
        cellBuilder: (context, value, row) {
          final score = row['performanceScore'] as int;
          final percentage = score / 100;
          Color color;

          if (score >= 90) {
            color = Colors.green;
          } else if (score >= 75) {
            color = Colors.blue;
          } else if (score >= 60) {
            color = Colors.orange;
          } else {
            color = Colors.red;
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
                const SizedBox(height: 2),
                Text(
                  '$score%',
                  style: TextStyle(fontSize: 10, color: color),
                ),
              ],
            ),
          );
        },
      ),

      // Rating column with stars
      VooDataColumn(
        field: 'rating',
        label: 'Rating',
        width: 100,
        sortable: true,
        filterable: true,
        cellBuilder: (context, value, row) {
          final rating = row['rating'] as int;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          );
        },
      ),

      // Percentage columns
      VooDataColumn(
        field: 'completionRate',
        label: 'Completion',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) {
          final rate = row['completionRate'] as int;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPercentageColor(rate).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$rate%',
              style: TextStyle(
                color: _getPercentageColor(rate),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'efficiency',
        label: 'Efficiency',
        width: 100,
        sortable: true,
        valueFormatter: (value) => '$value%',
        textAlign: TextAlign.center,
      ),

      // Tags/Skills column
      VooDataColumn(
        field: 'skills',
        label: 'Skills',
        width: 200,
        cellBuilder: (context, value, row) {
          final skills = row['skills'] as List<dynamic>;
          return Wrap(
            spacing: 4,
            runSpacing: 2,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  skill.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            }).toList(),
          );
        },
      ),

      // Projects column
      VooDataColumn(
        field: 'projects',
        label: 'Projects',
        width: 180,
        cellBuilder: (context, value, row) {
          final projects = row['projects'] as List<dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: projects.map((project) {
              return Text(
                '• $project',
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              );
            }).toList(),
          );
        },
      ),

      // Date columns
      VooDataColumn(
        field: 'startDate',
        label: 'Start Date',
        width: 100,
        sortable: true,
        filterable: true,
        valueFormatter: (value) {
          final date = value as DateTime;
          return '${date.month}/${date.day}/${date.year}';
        },
      ),
      VooDataColumn(
        field: 'lastReviewDate',
        label: 'Last Review',
        width: 100,
        sortable: true,
        valueFormatter: (value) {
          final date = value as DateTime;
          return '${date.month}/${date.day}/${date.year}';
        },
      ),
      VooDataColumn(
        field: 'nextReviewDate',
        label: 'Next Review',
        width: 100,
        sortable: true,
        valueFormatter: (value) {
          final date = value as DateTime;
          final daysUntil = date.difference(DateTime.now()).inDays;
          return '${date.month}/${date.day} ($daysUntil d)';
        },
      ),

      // Leave days columns
      VooDataColumn(
        field: 'vacationDays',
        label: 'Vacation',
        width: 80,
        sortable: true,
        textAlign: TextAlign.center,
        cellBuilder: (context, value, row) {
          final days = row['vacationDays'] as int;
          Color color = Colors.green;
          if (days < 5) color = Colors.orange;
          if (days < 2) color = Colors.red;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              days.toString(),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'sickDays',
        label: 'Sick',
        width: 60,
        sortable: true,
        textAlign: TextAlign.center,
        valueFormatter: (value) => value.toString(),
      ),
      VooDataColumn(
        field: 'workFromHomeDays',
        label: 'WFH',
        width: 60,
        sortable: true,
        textAlign: TextAlign.center,
        valueFormatter: (value) => value.toString(),
      ),

      // Experience and training
      VooDataColumn(
        field: 'yearsExperience',
        label: 'Exp (yrs)',
        width: 80,
        sortable: true,
        filterable: true,
        textAlign: TextAlign.center,
        valueFormatter: (value) => value.toString(),
      ),
      VooDataColumn(
        field: 'certifications',
        label: 'Certs',
        width: 60,
        sortable: true,
        textAlign: TextAlign.center,
        valueFormatter: (value) => value.toString(),
      ),
      VooDataColumn(
        field: 'trainingsCompleted',
        label: 'Training',
        width: 80,
        sortable: true,
        textAlign: TextAlign.center,
        valueFormatter: (value) => value.toString(),
      ),

      // Notes column
      const VooDataColumn(
        field: 'notes',
        label: 'Notes',
        width: 200,
      ),
    ];
  }

  Color _getPercentageColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildAdvancedFilter() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_alt,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Advanced Filters',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear All'),
                  onPressed: () {
                    _dataSource.clearAdvancedFilters();
                    _dataSource.loadData();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            AdvancedFilterWidget(
              dataSource: _dataSource,
              fields: [
                const FilterFieldConfig(
                  fieldName: 'employeeCode',
                  displayName: 'Employee Code',
                  type: FilterType.string,
                ),
                const FilterFieldConfig(
                  fieldName: 'firstName',
                  displayName: 'First Name',
                  type: FilterType.string,
                ),
                const FilterFieldConfig(
                  fieldName: 'lastName',
                  displayName: 'Last Name',
                  type: FilterType.string,
                ),
                const FilterFieldConfig(
                  fieldName: 'department',
                  displayName: 'Department',
                  type: FilterType.string,
                ),
                const FilterFieldConfig(
                  fieldName: 'location',
                  displayName: 'Location',
                  type: FilterType.string,
                ),
                const FilterFieldConfig(
                  fieldName: 'level',
                  displayName: 'Level',
                  type: FilterType.string,
                ),
                const FilterFieldConfig(
                  fieldName: 'salary',
                  displayName: 'Salary',
                  type: FilterType.decimal,
                ),
                const FilterFieldConfig(
                  fieldName: 'performanceScore',
                  displayName: 'Performance Score',
                  type: FilterType.int,
                ),
                const FilterFieldConfig(
                  fieldName: 'yearsExperience',
                  displayName: 'Years Experience',
                  type: FilterType.int,
                ),
                const FilterFieldConfig(
                  fieldName: 'startDate',
                  displayName: 'Start Date',
                  type: FilterType.date,
                ),
              ],
              onFilterApplied: (request) {
                setState(() {
                  _lastApiRequest = request.toJson();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiRequestViewer() {
    final encoder = const JsonEncoder.withIndent('  ');
    final formattedJson = encoder.convert(_lastApiRequest);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.code,
                    color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'API Request',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    // Copy to clipboard
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Request copied to clipboard')),
                    );
                  },
                  tooltip: 'Copy request',
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Scrollbar(
              controller: _apiRequestScrollController,
              child: SingleChildScrollView(
                controller: _apiRequestScrollController,
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  formattedJson,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataSource.dispose();
    _apiRequestScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('VooDataGrid - Comprehensive Preview'),
            actions: [
              TextButton.icon(
                icon: Icon(
                  _showAdvancedFilter ? Icons.filter_alt_off : Icons.filter_alt,
                  color: Colors.white,
                ),
                label: Text(
                  _showAdvancedFilter ? 'Hide Filters' : 'Show Filters',
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _showAdvancedFilter = !_showAdvancedFilter;
                  });
                },
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                icon: Icon(
                  _showApiRequest ? Icons.code_off : Icons.code,
                  color: Colors.white,
                ),
                label: Text(
                  _showApiRequest ? 'Hide Request' : 'Show Request',
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _showApiRequest = !_showApiRequest;
                  });
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              // Information banner
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Comprehensive preview with ${_controller.columns.length} columns, advanced filtering, '
                        'custom cell rendering, and various data types. Try filtering, sorting, and scrolling!',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Data'),
                      onPressed: () {
                        setState(() {
                          _dataSource
                              .setLocalData(_generateComprehensiveData());
                          _dataSource.clearAdvancedFilters();
                          _dataSource.loadData();
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Advanced filter panel
              if (_showAdvancedFilter) _buildAdvancedFilter(),

              // API request viewer
              if (_showApiRequest) _buildApiRequestViewer(),

              // Data grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: VooDataGrid(
                      controller: _controller,
                      showPagination: true,
                      showToolbar: true,
                      emptyStateWidget: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No matching records found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VooDataGridComprehensivePreview(),
  ));
}
