import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class SearchableDropdownExample extends StatefulWidget {
  const SearchableDropdownExample({super.key});

  @override
  State<SearchableDropdownExample> createState() => _SearchableDropdownExampleState();
}

class _SearchableDropdownExampleState extends State<SearchableDropdownExample> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCountry;
  User? _selectedUser;

  // Sample data
  final List<String> _countries = [
    'United States',
    'Canada',
    'Mexico',
    'Brazil',
    'Argentina',
    'United Kingdom',
    'France',
    'Germany',
    'Italy',
    'Spain',
    'China',
    'Japan',
    'India',
    'Australia',
    'New Zealand',
  ];

  // Mock API for async user search
  Future<List<User>> _searchUsers(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock user data
    final allUsers = [
      User('john.doe@example.com', 'John Doe', 'Engineering'),
      User('jane.smith@example.com', 'Jane Smith', 'Marketing'),
      User('bob.johnson@example.com', 'Bob Johnson', 'Sales'),
      User('alice.brown@example.com', 'Alice Brown', 'HR'),
      User('charlie.wilson@example.com', 'Charlie Wilson', 'Finance'),
      User('diana.miller@example.com', 'Diana Miller', 'Operations'),
      User('evan.davis@example.com', 'Evan Davis', 'Engineering'),
      User('fiona.garcia@example.com', 'Fiona Garcia', 'Marketing'),
    ];

    // Filter users based on query
    if (query.isEmpty) {
      return allUsers;
    }

    return allUsers
        .where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.department.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Searchable Dropdown Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Regular dropdown with search enabled
              Text(
                'Regular Dropdown with Search',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              VooFieldWidget(
                field: VooField.dropdownSimple(
                  name: 'country',
                  label: 'Select Country',
                  hint: 'Choose a country',
                  options: _countries,
                  enableSearch: true,
                  searchHint: 'Search countries...',
                  required: true,
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              if (_selectedCountry != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Selected: $_selectedCountry'),
                ),
              const SizedBox(height: 32),

              // Async dropdown with search
              Text(
                'Async Dropdown (User Search)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              VooFieldWidget(
                field: VooField.dropdownAsync<User>(
                  name: 'user',
                  label: 'Select User',
                  hint: 'Search for a user',
                  asyncOptionsLoader: (query) async {
                    return await _searchUsers(query);
                  },
                  converter: (user) => VooDropdownChild<User>(
                    value: user,
                    label: user.name,
                    subtitle: '${user.email} • ${user.department}',
                    icon: Icons.person,
                  ),
                  searchHint: 'Search by name, email, or department...',
                  minSearchLength: 0,
                  searchDebounce: const Duration(milliseconds: 300),
                  required: true,
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedUser = value;
                  });
                },
              ),
              if (_selectedUser != null)
                Card(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected User:',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedUser!.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          _selectedUser!.email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Department: ${_selectedUser!.department}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form submitted successfully!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// User model for the example
class User {
  final String email;
  final String name;
  final String department;

  User(this.email, this.name, this.department);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}