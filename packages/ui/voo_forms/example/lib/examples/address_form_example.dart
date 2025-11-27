import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating address forms with multiple addresses
class AddressFormExample extends StatefulWidget {
  const AddressFormExample({super.key});

  @override
  State<AddressFormExample> createState() => _AddressFormExampleState();
}

class _AddressFormExampleState extends State<AddressFormExample> {
  final _controller = VooFormController();
  bool _sameAsBilling = false;

  static const _usStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
    'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
    'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
    'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
    'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
    'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
    'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
    'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
    'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
    'West Virginia', 'Wisconsin', 'Wyoming',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Address Forms')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Billing Address Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: VooForm(
                  controller: _controller,
                  fields: [
                    VooFormSectionDivider(
                      name: 'billing_section',
                      label: 'Billing Address',
                      subtitle: 'Enter your billing information',
                    ),
                    VooTextField(
                      name: 'billing_name',
                      label: 'Full Name',
                      placeholder: 'Enter full name',
                      validators: [RequiredValidation()],
                      layout: VooFieldLayout.wide,
                    ),
                    VooTextField(
                      name: 'billing_street1',
                      label: 'Street Address',
                      placeholder: '123 Main Street',
                      validators: [RequiredValidation()],
                      layout: VooFieldLayout.wide,
                    ),
                    VooTextField(
                      name: 'billing_street2',
                      label: 'Apt, Suite, Unit (Optional)',
                      placeholder: 'Apartment 4B',
                      layout: VooFieldLayout.wide,
                    ),
                    VooTextField(
                      name: 'billing_city',
                      label: 'City',
                      placeholder: 'City',
                      validators: [RequiredValidation()],
                    ),
                    VooDropdownField<String>(
                      name: 'billing_state',
                      label: 'State',
                      placeholder: 'Select state',
                      options: _usStates,
                      validators: [RequiredValidation()],
                    ),
                    VooTextField(
                      name: 'billing_zip',
                      label: 'ZIP Code',
                      placeholder: '12345',
                      validators: [
                        RequiredValidation(),
                        PatternValidation(
                          pattern: r'^\d{5}(-\d{4})?$',
                          errorMessage: 'Enter a valid ZIP code',
                        ),
                      ],
                    ),
                    VooPhoneField(
                      name: 'billing_phone',
                      label: 'Phone Number',
                      placeholder: '(555) 123-4567',
                      validators: [RequiredValidation()],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),

            // Same as billing checkbox
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Row(
                  children: [
                    Checkbox(
                      value: _sameAsBilling,
                      onChanged: (value) {
                        setState(() => _sameAsBilling = value ?? false);
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _sameAsBilling = !_sameAsBilling);
                        },
                        child: Text(
                          'Shipping address is the same as billing',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),

            // Shipping Address Card (conditionally shown)
            if (!_sameAsBilling)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: VooForm(
                    fields: [
                      VooFormSectionDivider(
                        name: 'shipping_section',
                        label: 'Shipping Address',
                        subtitle: 'Where should we deliver?',
                      ),
                      VooTextField(
                        name: 'shipping_name',
                        label: 'Recipient Name',
                        placeholder: 'Enter recipient name',
                        validators: [RequiredValidation()],
                        layout: VooFieldLayout.wide,
                      ),
                      VooTextField(
                        name: 'shipping_company',
                        label: 'Company (Optional)',
                        placeholder: 'Company name',
                        layout: VooFieldLayout.wide,
                      ),
                      VooTextField(
                        name: 'shipping_street1',
                        label: 'Street Address',
                        placeholder: '123 Main Street',
                        validators: [RequiredValidation()],
                        layout: VooFieldLayout.wide,
                      ),
                      VooTextField(
                        name: 'shipping_street2',
                        label: 'Apt, Suite, Unit (Optional)',
                        placeholder: 'Apartment 4B',
                        layout: VooFieldLayout.wide,
                      ),
                      VooTextField(
                        name: 'shipping_city',
                        label: 'City',
                        placeholder: 'City',
                        validators: [RequiredValidation()],
                      ),
                      VooDropdownField<String>(
                        name: 'shipping_state',
                        label: 'State',
                        placeholder: 'Select state',
                        options: _usStates,
                        validators: [RequiredValidation()],
                      ),
                      VooTextField(
                        name: 'shipping_zip',
                        label: 'ZIP Code',
                        placeholder: '12345',
                        validators: [
                          RequiredValidation(),
                          PatternValidation(
                            pattern: r'^\d{5}(-\d{4})?$',
                            errorMessage: 'Enter a valid ZIP code',
                          ),
                        ],
                      ),
                      VooPhoneField(
                        name: 'shipping_phone',
                        label: 'Phone Number',
                        placeholder: '(555) 123-4567',
                      ),
                      VooMultilineField(
                        name: 'delivery_instructions',
                        label: 'Delivery Instructions (Optional)',
                        placeholder: 'Leave at door, ring bell, etc.',
                        maxLines: 3,
                        layout: VooFieldLayout.wide,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: _submitForm,
              child: const Text('Save Addresses'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_controller.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Addresses saved successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
