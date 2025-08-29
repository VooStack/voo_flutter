import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class AsyncDropdownWithInitialValueTestPage extends StatefulWidget {
  const AsyncDropdownWithInitialValueTestPage({super.key});

  @override
  State<AsyncDropdownWithInitialValueTestPage> createState() => _AsyncDropdownWithInitialValueTestPageState();
}

class _AsyncDropdownWithInitialValueTestPageState extends State<AsyncDropdownWithInitialValueTestPage> {
  User? _selectedUser;
  
  // Pre-selected user for testing initial value
  final _initialUser = User(id: '2', name: 'Jane Smith', email: 'jane@example.com');
  
  // Simulate async data loading
  Future<List<User>> _loadUsers(String query) async {
    debugPrint('🔍 Loading users with query: "$query"');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Sample user data
    final allUsers = [
      User(id: '1', name: 'John Doe', email: 'john@example.com'),
      User(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
      User(id: '3', name: 'Bob Johnson', email: 'bob@example.com'),
      User(id: '4', name: 'Alice Williams', email: 'alice@example.com'),
      User(id: '5', name: 'Charlie Brown', email: 'charlie@example.com'),
      User(id: '6', name: 'David Davis', email: 'david@example.com'),
      User(id: '7', name: 'Emma Wilson', email: 'emma@example.com'),
      User(id: '8', name: 'Frank Miller', email: 'frank@example.com'),
      User(id: '9', name: 'Grace Taylor', email: 'grace@example.com'),
      User(id: '10', name: 'Henry Anderson', email: 'henry@example.com'),
    ];
    
    // Filter based on query
    if (query.isEmpty) {
      debugPrint('✅ Returning all ${allUsers.length} users');
      return allUsers;
    }
    
    final filtered = allUsers.where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
      user.email.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    debugPrint('✅ Found ${filtered.length} users matching "$query"');
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Dropdown with Initial Value Test'),
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
                      'Test Instructions:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. The dropdown should show "Jane Smith" as initial value'),
                    const Text('2. Click on the dropdown and type to search'),
                    const Text('3. Typing should trigger queries (see debug console)'),
                    const Text('4. Queries should be debounced (300ms delay)'),
                    const Text('5. Results should update based on search'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Async Dropdown with Initial Value',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // Test with initial value and label above
            _buildSection(
              'With Initial Value (Label Above)',
              VooFieldOptions.material.copyWith(
                fieldVariant: FieldVariant.outlined,
                labelPosition: LabelPosition.above,
              ),
              initialValue: _initialUser,
            ),
            
            // Test with initial value and floating label
            _buildSection(
              'With Initial Value (Floating Label)',
              VooFieldOptions.material.copyWith(
                fieldVariant: FieldVariant.outlined,
                labelPosition: LabelPosition.floating,
              ),
              initialValue: _initialUser,
            ),
            
            // Test without initial value
            _buildSection(
              'Without Initial Value',
              VooFieldOptions.material.copyWith(
                fieldVariant: FieldVariant.outlined,
                labelPosition: LabelPosition.above,
              ),
              initialValue: null,
            ),
            
            const SizedBox(height: 24),
            if (_selectedUser != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected User:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('ID: ${_selectedUser!.id}'),
                      Text('Name: ${_selectedUser!.name}'),
                      Text('Email: ${_selectedUser!.email}'),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedUser = null;
                });
              },
              child: const Text('Clear Selection'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, VooFieldOptions options, {User? initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              VooFieldWidget(
                field: VooField.dropdownAsync<User>(
                  name: 'user_${title.toLowerCase().replaceAll(' ', '_')}',
                  label: 'Select User',
                  hint: 'Search for a user',
                  initialValue: initialValue,
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
                ),
                options: options,
                onChanged: (value) {
                  debugPrint('🎯 User selected: ${value?.name}');
                  setState(() {
                    _selectedUser = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}