import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class ConsistentStylingTestPage extends StatefulWidget {
  const ConsistentStylingTestPage({super.key});

  @override
  State<ConsistentStylingTestPage> createState() => _ConsistentStylingTestPageState();
}

class _ConsistentStylingTestPageState extends State<ConsistentStylingTestPage> {
  // Test data
  final List<String> _countries = ['United States', 'Canada', 'Mexico', 'United Kingdom'];
  
  // Async loader for users
  Future<List<User>> _loadUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
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
        title: const Text('Consistent Styling Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ Test Objectives:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• All fields should have transparent backgrounds'),
                    const Text('• Borders should be consistent across all field types'),
                    const Text('• Labels should appear above all fields'),
                    const Text('• Dropdown fields should match text field styling'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Outlined Variant (Default)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Light background to show field transparency
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: VooSimpleForm(
                defaultConfig: const VooFormConfig(
                  labelPosition: LabelPosition.above,
                  fieldVariant: FieldVariant.outlined,
                  showRequiredIndicator: true,
                ),
                fields: [
                  // Text field
                  VooField.text(
                    name: 'text',
                    label: 'Text Field',
                    hint: 'Enter text',
                    initialValue: 'Sample text',
                  ),
                  
                  // Email field
                  VooField.email(
                    name: 'email',
                    label: 'Email Field',
                    hint: 'Enter email',
                    initialValue: 'user@example.com',
                  ),
                  
                  // Number field
                  VooField.number(
                    name: 'number',
                    label: 'Number Field',
                    hint: 'Enter number',
                    initialValue: 42,
                  ),
                  
                  // Simple dropdown
                  VooField.dropdownSimple(
                    name: 'country',
                    label: 'Simple Dropdown',
                    hint: 'Select country',
                    options: _countries,
                    initialValue: _countries.first,
                  ),
                  
                  // Searchable dropdown
                  VooField.dropdown<String>(
                    name: 'searchable_country',
                    label: 'Searchable Dropdown',
                    hint: 'Search country',
                    options: _countries,
                    converter: (country) => VooDropdownChild<String>(
                      value: country,
                      label: country,
                      icon: Icons.flag,
                    ),
                    enableSearch: true,
                    searchHint: 'Type to search...',
                    initialValue: _countries[1],
                  ),
                  
                  // Async dropdown
                  VooField.dropdownAsync<User>(
                    name: 'user',
                    label: 'Async Dropdown',
                    hint: 'Search user',
                    asyncOptionsLoader: _loadUsers,
                    converter: (user) => VooDropdownChild<User>(
                      value: user,
                      label: user.name,
                      subtitle: user.email,
                      icon: Icons.person,
                    ),
                    searchHint: 'Type to search users...',
                  ),
                  
                  // Date field
                  VooField.date(
                    name: 'date',
                    label: 'Date Field',
                    hint: 'Select date',
                    initialValue: DateTime.now(),
                  ),
                  
                  // Time field
                  VooField.time(
                    name: 'time',
                    label: 'Time Field',
                    hint: 'Select time',
                    initialValue: TimeOfDay.now(),
                  ),
                  
                  // Multiline field
                  VooField.multiline(
                    name: 'notes',
                    label: 'Multiline Field',
                    hint: 'Enter notes',
                    maxLines: 3,
                    initialValue: 'This is a multiline\ntext field\nwith multiple lines',
                  ),
                ],
                onSubmit: (values) {
                  debugPrint('Form submitted');
                },
              ),
            ),
            
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            
            Text(
              'Filled Variant',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Dark background to show filled fields
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: VooSimpleForm(
                defaultConfig: const VooFormConfig(
                  labelPosition: LabelPosition.above,
                  fieldVariant: FieldVariant.filled,
                  showRequiredIndicator: false,
                ),
                fields: [
                  VooField.text(
                    name: 'filled_text',
                    label: 'Filled Text Field',
                    hint: 'Enter text',
                    initialValue: 'Filled variant',
                  ),
                  
                  VooField.dropdownSimple(
                    name: 'filled_dropdown',
                    label: 'Filled Dropdown',
                    hint: 'Select option',
                    options: _countries,
                    initialValue: _countries.first,
                  ),
                  
                  VooField.dropdownAsync<User>(
                    name: 'filled_async',
                    label: 'Filled Async Dropdown',
                    hint: 'Search user',
                    asyncOptionsLoader: _loadUsers,
                    converter: (user) => VooDropdownChild<User>(
                      value: user,
                      label: user.name,
                      subtitle: user.email,
                    ),
                  ),
                ],
                onSubmit: (values) {
                  debugPrint('Form submitted');
                },
              ),
            ),
            
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            
            Text(
              'Side-by-Side Comparison',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Gradient background to test transparency
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.purple.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Text Field:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        VooFieldWidget(
                          field: VooField.text(
                            name: 'compare_text',
                            label: 'Text Input',
                            hint: 'Type here',
                            initialValue: 'Text',
                          ),
                          options: VooFieldOptions.material.copyWith(
                            labelPosition: LabelPosition.above,
                            fieldVariant: FieldVariant.outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dropdown Field:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        VooFieldWidget(
                          field: VooField.dropdownSimple(
                            name: 'compare_dropdown',
                            label: 'Dropdown Input',
                            hint: 'Select here',
                            options: ['Option 1', 'Option 2'],
                            initialValue: 'Option 1',
                          ),
                          options: VooFieldOptions.material.copyWith(
                            labelPosition: LabelPosition.above,
                            fieldVariant: FieldVariant.outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            Card(
              color: Colors.yellow.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔍 What to Check:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Outlined fields should be transparent (show background)'),
                    const Text('2. All fields should have consistent border styling'),
                    const Text('3. Filled fields should have light fill color'),
                    const Text('4. Dropdowns should match text field appearance'),
                    const Text('5. Labels should be positioned consistently above fields'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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