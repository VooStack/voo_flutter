import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Comprehensive example demonstrating VooField.list usage
/// Shows various configurations and use cases for dynamic field lists
class ListFieldExamplePage extends StatefulWidget {
  const ListFieldExamplePage({super.key});

  @override
  State<ListFieldExamplePage> createState() => _ListFieldExamplePageState();
}

class _ListFieldExamplePageState extends State<ListFieldExamplePage> {
  final _formKey = GlobalKey<FormState>();

  // Track values for display
  List<String>? emailList;
  List<PhoneNumber>? phoneNumbers;
  List<Address>? addresses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooField.list Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),

              // Example 1: Simple email list
              _buildSection(
                title: 'Example 1: Email List',
                description: 'Dynamic list of email addresses with validation',
                child: VooFieldWidget(
                  field: VooField.list<String>(
                    name: 'emails',
                    label: 'Email Addresses',
                    hint: 'Add multiple email addresses',
                    helper: 'Enter email addresses for notifications',
                    itemTemplate: VooField.email(
                      name: 'email',
                      label: 'Email',
                      validators: const [
                        EmailValidation(),
                      ],
                    ),
                    initialItems: ['user@example.com'],
                    minItems: 1,
                    maxItems: 5,
                    onChanged: (List<String>? value) {
                      setState(() {
                        emailList = value;
                      });
                      debugPrint('Emails changed: $value');
                    },
                  ),
                  options: VooFieldOptions.material.copyWith(
                    fieldVariant: FieldVariant.outlined,
                    labelPosition: LabelPosition.above,
                  ),
                ),
              ),
              if (emailList != null && emailList!.isNotEmpty)
                _buildResultCard('Email List', emailList!.join(', ')),

              const SizedBox(height: 32),

              // Example 2: Phone numbers with custom type
              _buildSection(
                title: 'Example 2: Phone Numbers',
                description: 'List of phone numbers with type selection',
                child: VooFieldWidget(
                  field: VooField.list<String>(
                    name: 'phones',
                    label: 'Phone Numbers',
                    itemTemplate: VooField.phone(
                      name: 'phone',
                      label: 'Phone Number',
                      prefixIcon: Icons.phone,
                    ),
                    initialItems: [
                      '555-0001',
                    ],
                    minItems: 1,
                    maxItems: 3,
                    addButtonText: 'Add Phone',
                    addButtonIcon: Icons.phone_android,
                    removeButtonIcon: Icons.delete_outline,
                    onChanged: (List<String>? value) {
                      setState(() {
                        phoneNumbers = value
                            ?.map((phone) => PhoneNumber(number: phone))
                            .toList();
                      });
                    },
                  ),
                  options: VooFieldOptions.material.copyWith(
                    fieldVariant: FieldVariant.filled,
                  ),
                ),
              ),
              if (phoneNumbers != null && phoneNumbers!.isNotEmpty)
                _buildResultCard(
                  'Phone Numbers',
                  phoneNumbers!
                      .map((p) => '${p.number} (${p.type})')
                      .join(', '),
                ),

              const SizedBox(height: 32),

              // Example 3: Complex nested fields
              _buildSection(
                title: 'Example 3: Address List',
                description: 'Complex objects with multiple fields per item',
                child: VooFormWidget(
                  form: VooForm(
                    id: 'address_form',
                    fields: [
                      VooField.list<String>(
                        name: 'addresses',
                        label: 'Shipping Addresses',
                        itemTemplate: VooField.multiline(
                          name: 'address',
                          label: 'Address',
                          maxLines: 2,
                          hint: 'Street, City, State, ZIP',
                        ),
                        initialItems: [
                          '123 Main St, Anytown, CA 90210',
                        ],
                        maxItems: 3,
                        canReorderItems: true,
                        onChanged: (List<String>? value) {
                          setState(() {
                            addresses = value
                                ?.map((addr) => Address(
                                      street: addr.split(',')[0],
                                      city: addr.split(',').length > 1
                                          ? addr.split(',')[1].trim()
                                          : '',
                                      state: addr.split(',').length > 2
                                          ? addr
                                              .split(',')[2]
                                              .trim()
                                              .split(' ')[0]
                                          : '',
                                      zip: addr.split(',').length > 2
                                          ? addr
                                              .split(',')[2]
                                              .trim()
                                              .split(' ')[1]
                                          : '',
                                    ))
                                .toList();
                          });
                        },
                      ),
                    ],
                  ),
                  config: const VooFormConfig(
                    defaultFieldOptions: VooFieldOptions.material,
                  ),
                ),
              ),
              if (addresses != null && addresses!.isNotEmpty)
                Column(
                  children: addresses!
                      .map((addr) =>
                          _buildResultCard('Address', addr.toString()))
                      .toList(),
                ),

              const SizedBox(height: 32),

              // Example 4: Tags with chips display
              _buildSection(
                title: 'Example 4: Tag List',
                description: 'Simple tag management with chips display',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VooFieldWidget(
                      field: VooField.list<String>(
                        name: 'tags',
                        label: 'Tags',
                        itemTemplate: VooField.text(
                          name: 'tag',
                          label: 'Tag',
                          maxLength: 20,
                        ),
                        initialItems: ['flutter', 'dart'],
                        maxItems: 10,
                        addButtonText: 'Add Tag',
                        addButtonIcon: Icons.label,
                      ),
                      options: VooFieldOptions.material,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Example 5: Read-only list
              _buildSection(
                title: 'Example 5: Read-only List',
                description: 'List in read-only mode (no add/remove)',
                child: VooFieldWidget(
                  field: VooField.list<String>(
                    name: 'readonly_items',
                    label: 'Fixed Items',
                    itemTemplate: VooField.text(
                      name: 'item',
                      label: 'Item',
                    ),
                    initialItems: ['Item A', 'Item B', 'Item C'],
                    readOnly: true,
                  ),
                  options: VooFieldOptions.material,
                ),
              ),

              const SizedBox(height: 32),

              // Example 6: Minimum items enforced
              _buildSection(
                title: 'Example 6: Required Minimum Items',
                description: 'List that requires at least 2 items',
                child: VooFieldWidget(
                  field: VooField.list<String>(
                    name: 'min_required',
                    label: 'Required Fields (Min 2)',
                    itemTemplate: VooField.text(
                      name: 'field',
                      label: 'Required Field',
                      required: true,
                    ),
                    minItems: 2,
                    helper: 'You must have at least 2 items',
                  ),
                  options: VooFieldOptions.material.copyWith(
                    errorDisplayMode: ErrorDisplayMode.tooltip,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form submitted successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Submit Form'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
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
                  'VooField.list Features',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Dynamic adding/removing of fields\n'
              '• Min/max items constraints\n'
              '• Custom add/remove buttons\n'
              '• Support for any field type as template\n'
              '• Optional reordering (drag & drop)\n'
              '• Read-only mode support\n'
              '• Full validation support\n'
              '• Works with complex object types',
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
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data models for examples
class PhoneNumber {
  final String number;
  final String type;

  PhoneNumber({required this.number, this.type = 'Mobile'});

  @override
  String toString() => number;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zip;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  @override
  String toString() => '$street, $city, $state $zip';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          street == other.street &&
          city == other.city &&
          state == other.state &&
          zip == other.zip;

  @override
  int get hashCode =>
      street.hashCode ^ city.hashCode ^ state.hashCode ^ zip.hashCode;
}
