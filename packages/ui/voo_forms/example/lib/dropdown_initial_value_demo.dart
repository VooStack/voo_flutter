import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Comprehensive example demonstrating proper usage of initialValue
/// for both regular dropdowns and async dropdowns
class DropdownInitialValueDemo extends StatefulWidget {
  const DropdownInitialValueDemo({super.key});

  @override
  State<DropdownInitialValueDemo> createState() => _DropdownInitialValueDemoState();
}

class _DropdownInitialValueDemoState extends State<DropdownInitialValueDemo> {
  // Track selected values for display
  String? selectedCountry;
  User? selectedUser;
  Product? selectedProduct;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown InitialValue Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            
            // Example 1: Simple String Dropdown with InitialValue
            _buildSection(
              title: 'Example 1: Simple String Dropdown',
              description: 'Regular dropdown with string values and initialValue set to "CA"',
              child: VooFieldWidget(
                field: VooField.dropdown<String>(
                  name: 'country',
                  label: 'Select Country',
                  hint: 'Choose your country',
                  initialValue: 'CA', // Initial value set here
                  options: const ['US', 'CA', 'UK', 'AU'],
                  converter: (code) => VooDropdownChild<String>(
                    value: code,
                    label: _getCountryName(code),
                    icon: Icons.flag,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                    debugPrint('Selected country: $value');
                  },
                ),
                options: VooFieldOptions.material.copyWith(
                  fieldVariant: FieldVariant.outlined,
                  labelPosition: LabelPosition.above,
                ),
              ),
            ),
            if (selectedCountry != null)
              _buildResultCard('Selected Country', _getCountryName(selectedCountry!)),
            
            const SizedBox(height: 32),
            
            // Example 2: Async Dropdown with InitialValue
            _buildSection(
              title: 'Example 2: Async Dropdown with Objects',
              description: 'Async dropdown that loads users from an API with initialValue',
              child: VooFieldWidget(
                field: VooField.dropdownAsync<User>(
                  name: 'user',
                  label: 'Select User',
                  hint: 'Search for a user',
                  // Set initial value to a specific user
                  initialValue: User(
                    id: '2',
                    name: 'Jane Smith',
                    email: 'jane@example.com',
                    department: 'Engineering',
                  ),
                  asyncOptionsLoader: _loadUsers,
                  converter: (user) => VooDropdownChild<User>(
                    value: user,
                    label: user.name,
                    subtitle: '${user.email} - ${user.department}',
                    icon: Icons.person,
                  ),
                  searchHint: 'Type to search users...',
                  minSearchLength: 0,
                  searchDebounce: const Duration(milliseconds: 300),
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value;
                    });
                    debugPrint('Selected user: ${value?.name}');
                  },
                ),
                options: VooFieldOptions.material.copyWith(
                  fieldVariant: FieldVariant.outlined,
                  labelPosition: LabelPosition.floating,
                ),
              ),
            ),
            if (selectedUser != null)
              _buildResultCard('Selected User', '${selectedUser!.name} (${selectedUser!.email})'),
            
            const SizedBox(height: 32),
            
            // Example 3: Searchable Dropdown with Complex Objects
            _buildSection(
              title: 'Example 3: Searchable Dropdown with Products',
              description: 'Searchable dropdown with complex product objects and initialValue',
              child: VooFieldWidget(
                field: VooField.dropdown<Product>(
                  name: 'product',
                  label: 'Select Product',
                  hint: 'Choose a product',
                  // Initial value with complex object
                  initialValue: Product(
                    id: 'p3',
                    name: 'Wireless Headphones',
                    price: 149.99,
                    category: 'Audio',
                    inStock: true,
                  ),
                  options: _getProducts(),
                  converter: (product) => VooDropdownChild<Product>(
                    value: product,
                    label: product.name,
                    subtitle: '\$${product.price.toStringAsFixed(2)} - ${product.category}',
                    icon: _getProductIcon(product.category),
                  ),
                  enableSearch: true, // Enable search functionality
                  searchHint: 'Search products...',
                  onChanged: (value) {
                    setState(() {
                      selectedProduct = value;
                    });
                    debugPrint('Selected product: ${value?.name}');
                  },
                ),
                options: VooFieldOptions.material.copyWith(
                  fieldVariant: FieldVariant.filled,
                  labelPosition: LabelPosition.floating,
                ),
              ),
            ),
            if (selectedProduct != null)
              _buildResultCard(
                'Selected Product',
                '${selectedProduct!.name} - \$${selectedProduct!.price.toStringAsFixed(2)}',
              ),
            
            const SizedBox(height: 32),
            
            // Example 4: Form with Multiple Dropdowns
            _buildSection(
              title: 'Example 4: Form with Multiple Dropdowns',
              description: 'Complete form showing multiple dropdowns with initialValues',
              child: VooFormWidget(
                form: VooForm(
                  id: 'user_profile_form',
                  fields: [
                    VooField.text(
                      name: 'name',
                      label: 'Full Name',
                      initialValue: 'John Doe',
                    ),
                    VooField.dropdown<String>(
                      name: 'role',
                      label: 'User Role',
                      initialValue: 'developer', // Initial role
                      options: const ['admin', 'developer', 'designer', 'manager'],
                      converter: (role) => VooDropdownChild<String>(
                        value: role,
                        label: _formatRole(role),
                        icon: _getRoleIcon(role),
                      ),
                    ),
                    VooField.dropdown<String>(
                      name: 'department',
                      label: 'Department',
                      initialValue: 'engineering', // Initial department
                      options: const ['engineering', 'design', 'marketing', 'sales'],
                      converter: (dept) => VooDropdownChild<String>(
                        value: dept,
                        label: _formatDepartment(dept),
                      ),
                    ),
                  ],
                ),
                config: const VooFormConfig(
                  defaultFieldOptions: VooFieldOptions.material,
                  fieldSpacing: 16,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Important Notes Section
            _buildNotesSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'How InitialValue Works',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• initialValue sets the default selection when the dropdown is first created\n'
              '• For async dropdowns, the initial value is displayed even before options load\n'
              '• The value parameter overrides initialValue if both are provided\n'
              '• InitialValue must match the type of the dropdown (String, User, Product, etc.)\n'
              '• For objects, ensure proper equality operators are implemented',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
  
  Widget _buildResultCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
  
  Widget _buildNotesSection() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Important Notes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Object Equality: When using custom objects, implement == and hashCode\n'
              '2. Async Loading: InitialValue displays immediately, even before options load\n'
              '3. Type Safety: Ensure initialValue type matches the dropdown generic type\n'
              '4. Converter Function: Required for converting objects to display values\n'
              '5. Search Feature: Enable with enableSearch: true for better UX',
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper methods
  String _getCountryName(String code) {
    switch (code) {
      case 'US':
        return 'United States';
      case 'CA':
        return 'Canada';
      case 'UK':
        return 'United Kingdom';
      case 'AU':
        return 'Australia';
      default:
        return code;
    }
  }
  
  Future<List<User>> _loadUsers(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allUsers = [
      User(id: '1', name: 'John Doe', email: 'john@example.com', department: 'Sales'),
      User(id: '2', name: 'Jane Smith', email: 'jane@example.com', department: 'Engineering'),
      User(id: '3', name: 'Bob Johnson', email: 'bob@example.com', department: 'Marketing'),
      User(id: '4', name: 'Alice Williams', email: 'alice@example.com', department: 'Design'),
      User(id: '5', name: 'Charlie Brown', email: 'charlie@example.com', department: 'Engineering'),
    ];
    
    if (query.isEmpty) {
      return allUsers;
    }
    
    return allUsers.where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
      user.email.toLowerCase().contains(query.toLowerCase()) ||
      user.department.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  List<Product> _getProducts() {
    return [
      Product(id: 'p1', name: 'Laptop Pro', price: 1299.99, category: 'Electronics', inStock: true),
      Product(id: 'p2', name: 'Smartphone X', price: 899.99, category: 'Electronics', inStock: true),
      Product(id: 'p3', name: 'Wireless Headphones', price: 149.99, category: 'Audio', inStock: true),
      Product(id: 'p4', name: 'Coffee Maker', price: 79.99, category: 'Appliances', inStock: false),
      Product(id: 'p5', name: 'Standing Desk', price: 499.99, category: 'Furniture', inStock: true),
    ];
  }
  
  IconData _getProductIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices;
      case 'Audio':
        return Icons.headphones;
      case 'Appliances':
        return Icons.kitchen;
      case 'Furniture':
        return Icons.chair;
      default:
        return Icons.shopping_bag;
    }
  }
  
  String _formatRole(String role) {
    return role[0].toUpperCase() + role.substring(1);
  }
  
  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'developer':
        return Icons.code;
      case 'designer':
        return Icons.palette;
      case 'manager':
        return Icons.business_center;
      default:
        return Icons.person;
    }
  }
  
  String _formatDepartment(String dept) {
    return dept[0].toUpperCase() + dept.substring(1);
  }
}

// Data Models
class User {
  final String id;
  final String name;
  final String email;
  final String department;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
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

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool inStock;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.inStock,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}