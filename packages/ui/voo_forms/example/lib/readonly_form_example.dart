import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example demonstrating how to use VooForm with isReadOnly parameter
/// This allows you to display form data in read-only mode for viewing details
class ReadOnlyFormExample extends StatefulWidget {
  const ReadOnlyFormExample({super.key});

  @override
  State<ReadOnlyFormExample> createState() => _ReadOnlyFormExampleState();
}

class _ReadOnlyFormExampleState extends State<ReadOnlyFormExample> {
  bool _isReadOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read-Only Form Example'),
        actions: [
          Switch(
            value: _isReadOnly,
            onChanged: (value) {
              setState(() {
                _isReadOnly = value;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: VooForm(
          isReadOnly: _isReadOnly,
          fields: [
            VooTextField(
              name: 'name',
              label: 'Full Name',
              initialValue: 'John Doe',
            ),
            VooEmailField(
              name: 'email',
              label: 'Email Address',
              initialValue: 'john.doe@example.com',
            ),
            VooDropdownField<String>(
              name: 'state',
              label: 'State',
              options: const ['California', 'New York', 'Texas', 'Florida'],
              initialValue: 'California',
            ),
            VooPhoneField(
              name: 'phone',
              label: 'Phone Number',
              initialValue: '5551234567',
            ),
            VooMultilineField(
              name: 'notes',
              label: 'Additional Notes',
              initialValue:
                  'This is a sample note that demonstrates the read-only functionality.',
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const ReadOnlyFormExample(),
  ));
}
