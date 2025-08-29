import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class AsyncDropdownTestPage extends StatefulWidget {
  const AsyncDropdownTestPage({super.key});

  @override
  State<AsyncDropdownTestPage> createState() => _AsyncDropdownTestPageState();
}

class _AsyncDropdownTestPageState extends State<AsyncDropdownTestPage> {
  User? _selectedUser;
  
  // Simulate async data loading
  Future<List<User>> _loadUsers(String query) async {
    debugPrint('Loading users with query: "$query"');
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Sample user data
    final allUsers = [
      User(id: '1', name: 'John Doe', email: 'john@example.com'),
      User(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
      User(id: '3', name: 'Bob Johnson', email: 'bob@example.com'),
      User(id: '4', name: 'Alice Williams', email: 'alice@example.com'),
      User(id: '5', name: 'Charlie Brown', email: 'charlie@example.com'),
    ];
    
    // Filter based on query
    if (query.isEmpty) {
      return allUsers;
    }
    
    return allUsers.where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
      user.email.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Dropdown Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Async Dropdown with Different Styles',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Filled variant
            _buildSection(
              'Filled Variant',
              VooFieldOptions.material.copyWith(
                fieldVariant: FieldVariant.filled,
                labelPosition: LabelPosition.above,
              ),
            ),
            
            // Outlined variant
            _buildSection(
              'Outlined Variant',
              VooFieldOptions.material.copyWith(
                fieldVariant: FieldVariant.outlined,
                labelPosition: LabelPosition.above,
              ),
            ),
            
            // Ghost variant
            _buildSection(
              'Ghost Variant',
              VooFieldOptions.material.copyWith(
                fieldVariant: FieldVariant.ghost,
                labelPosition: LabelPosition.above,
              ),
            ),
            
            const SizedBox(height: 24),
            if (_selectedUser != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected User:', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Name: ${_selectedUser!.name}'),
                      Text('Email: ${_selectedUser!.email}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, VooFieldOptions options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        VooFieldWidget(
          field: VooField.dropdownAsync<User>(
            name: 'user',
            label: 'Select User',
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
          ),
          options: options,
          onChanged: (value) {
            setState(() {
              _selectedUser = value;
            });
          },
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
}