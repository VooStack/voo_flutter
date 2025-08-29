import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class DropdownComprehensiveTestPage extends StatefulWidget {
  const DropdownComprehensiveTestPage({super.key});

  @override
  State<DropdownComprehensiveTestPage> createState() => _DropdownComprehensiveTestPageState();
}

class _DropdownComprehensiveTestPageState extends State<DropdownComprehensiveTestPage> {
  String? _selectedCountry;
  USState? _selectedState;
  User? _selectedUser;
  
  // Test data
  final List<String> _countries = ['United States', 'Canada', 'Mexico', 'United Kingdom'];
  final List<USState> _states = [
    USState(code: 'CA', name: 'California'),
    USState(code: 'TX', name: 'Texas'),
    USState(code: 'NY', name: 'New York'),
    USState(code: 'FL', name: 'Florida'),
  ];
  
  // Simulate async data loading
  Future<List<User>> _loadUsers(String query) async {
    debugPrint('🔍 Loading users with query: "$query"');
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allUsers = [
      User(id: '1', name: 'John Doe', email: 'john@example.com'),
      User(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
      User(id: '3', name: 'Bob Johnson', email: 'bob@example.com'),
    ];
    
    if (query.isEmpty) return allUsers;
    
    return allUsers.where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
      user.email.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Comprehensive Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Objectives:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Verify all dropdowns respect labelPosition: above'),
                    const Text('2. Check consistent design across all dropdown types'),
                    const Text('3. Test type safety with different value types'),
                    const Text('4. Ensure async dropdown queries work properly'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Using VooSimpleForm with labelPosition: above',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            VooSimpleForm(
              defaultConfig: const VooFormConfig(
                labelPosition: LabelPosition.above,
                fieldVariant: FieldVariant.outlined,
                showRequiredIndicator: true,
              ),
              fields: [
                // Simple string dropdown
                VooField.dropdownSimple(
                  name: 'country',
                  label: 'Country (Simple String)',
                  hint: 'Select a country',
                  options: _countries,
                  initialValue: _countries.first,
                  required: true,
                  onChanged: (value) {
                    debugPrint('✅ Country selected: $value (Type: ${value.runtimeType})');
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                ),
                
                // Typed dropdown with custom objects
                VooField.dropdown<USState>(
                  name: 'state',
                  label: 'State (Typed Object)',
                  hint: 'Select a state',
                  options: _states,
                  converter: (state) => VooDropdownChild<USState>(
                    value: state,
                    label: state.name,
                    subtitle: state.code,
                    icon: Icons.location_city,
                  ),
                  initialValue: _states.first,
                  onChanged: (value) {
                    debugPrint('✅ State selected: ${value?.name} (Type: ${value.runtimeType})');
                    setState(() {
                      _selectedState = value;
                    });
                  },
                ),
                
                // Searchable dropdown
                VooField.dropdown<String>(
                  name: 'searchable_country',
                  label: 'Country (Searchable)',
                  hint: 'Search for a country',
                  options: _countries,
                  converter: (country) => VooDropdownChild<String>(
                    value: country,
                    label: country,
                    icon: Icons.flag,
                  ),
                  enableSearch: true,
                  searchHint: 'Type to search...',
                  onChanged: (value) {
                    debugPrint('✅ Searchable country selected: $value');
                  },
                ),
                
                // Async dropdown
                VooField.dropdownAsync<User>(
                  name: 'user',
                  label: 'User (Async Loading)',
                  hint: 'Search for a user',
                  asyncOptionsLoader: _loadUsers,
                  converter: (user) => VooDropdownChild<User>(
                    value: user,
                    label: user.name,
                    subtitle: user.email,
                    icon: Icons.person,
                  ),
                  searchHint: 'Type to search users...',
                  minSearchLength: 0,
                  searchDebounce: const Duration(milliseconds: 300),
                  onChanged: (value) {
                    debugPrint('✅ User selected: ${value?.name} (Type: ${value.runtimeType})');
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                ),
                
                // Regular text field for comparison
                VooField.text(
                  name: 'notes',
                  label: 'Notes (Text Field for Comparison)',
                  hint: 'Enter some notes',
                  helper: 'This shows how other fields look',
                ),
              ],
              onSubmit: (values) {
                debugPrint('Form submitted with values:');
                values.forEach((key, value) {
                  debugPrint('  $key: $value (Type: ${value.runtimeType})');
                });
              },
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            
            // Display selected values
            if (_selectedCountry != null || _selectedState != null || _selectedUser != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Values:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedCountry != null)
                        Text('Country: $_selectedCountry'),
                      if (_selectedState != null)
                        Text('State: ${_selectedState!.name} (${_selectedState!.code})'),
                      if (_selectedUser != null)
                        Text('User: ${_selectedUser!.name} (${_selectedUser!.email})'),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Individual field tests
            Text(
              'Individual Field Tests (Outside Form)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // Test individual async dropdown with label above
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Async Dropdown with Label Above:'),
                  const SizedBox(height: 8),
                  VooFieldWidget(
                    field: VooField.dropdownAsync<User>(
                      name: 'test_user',
                      label: 'Select User (Label Should Be Above)',
                      hint: 'Search for a user',
                      asyncOptionsLoader: _loadUsers,
                      converter: (user) => VooDropdownChild<User>(
                        value: user,
                        label: user.name,
                        subtitle: user.email,
                        icon: Icons.person,
                      ),
                      searchHint: 'Type to search...',
                    ),
                    options: VooFieldOptions.material.copyWith(
                      labelPosition: LabelPosition.above,
                      fieldVariant: FieldVariant.outlined,
                    ),
                    onChanged: (value) {
                      debugPrint('✅ Test user selected: ${(value as User?)?.name}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Test models
class USState {
  final String code;
  final String name;
  
  USState({required this.code, required this.name});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is USState &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}