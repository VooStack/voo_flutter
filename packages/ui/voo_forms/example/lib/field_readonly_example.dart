import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example demonstrating field-level readOnly control
/// Some fields can be read-only while others remain editable
class FieldReadOnlyExample extends StatelessWidget {
  const FieldReadOnlyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field-Level ReadOnly Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: VooSimpleForm(
          fields: [
            // System-generated ID field - always read-only
            VooField.text(
              name: 'userId',
              label: 'User ID',
              initialValue: 'USR-2025-001',
              readOnly: true, // This field is always read-only
              helper: 'System-generated ID',
            ),
            
            // Editable username field
            VooField.text(
              name: 'username',
              label: 'Username',
              placeholder: 'Enter your username',
              required: true,
              readOnly: false, // This field is editable
            ),
            
            // Editable email field
            VooField.email(
              name: 'email',
              label: 'Email Address',
              placeholder: 'user@example.com',
              required: true,
              readOnly: false, // This field is editable
            ),
            
            // Auto-calculated field - always read-only
            VooField.text(
              name: 'accountType',
              label: 'Account Type',
              initialValue: 'Premium',
              readOnly: true, // This field is always read-only
              helper: 'Based on subscription status',
            ),
            
            // System timestamp - always read-only
            VooField.text(
              name: 'createdAt',
              label: 'Account Created',
              initialValue: '2025-01-01 10:30:00',
              readOnly: true, // This field is always read-only
              helper: 'Account creation timestamp',
            ),
            
            // Editable bio field
            VooField.multiline(
              name: 'bio',
              label: 'Bio',
              placeholder: 'Tell us about yourself',
              maxLines: 4,
              readOnly: false, // This field is editable
            ),
            
            // Editable preferences
            VooField.boolean(
              name: 'notifications',
              label: 'Enable Notifications',
              initialValue: true,
              readOnly: false, // This field is editable
            ),
            
            // System-managed field - always read-only
            VooField.text(
              name: 'lastLogin',
              label: 'Last Login',
              initialValue: '2025-09-01 14:22:00',
              readOnly: true, // This field is always read-only
              helper: 'Automatically updated on login',
            ),
          ],
          defaultConfig: const VooFormConfig(
            labelPosition: LabelPosition.above,
            fieldVariant: FieldVariant.outlined,
          ),
          isEditable: true, // Form is editable, but individual fields can override
          onSubmit: (values) async {
            // Show submitted values
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Form submitted with ${values.length} fields'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Field ReadOnly Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FieldReadOnlyExample(),
    ),
  );
}