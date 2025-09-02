import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example showing how to use field widgets directly without factories
/// This is the new, simplified approach following KISS principles
class DirectWidgetFormExample extends StatelessWidget {
  const DirectWidgetFormExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Widget Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: VooForm(
          fields: [
            // All fields are now direct widget instantiations
            // No factories, no complex builders - just widgets
            
            VooTextField(
              name: 'fullName',
              label: 'Full Name',
              placeholder: 'John Doe',
              required: true,
            ),
            
            const VooEmailField(
              name: 'email',
              label: 'Email Address',
              required: true,
            ),
            
            const VooPasswordField(
              name: 'password',
              label: 'Password',
              required: true,
            ),
            
            const VooPhoneField(
              name: 'phone',
              label: 'Phone Number',
            ),
            
            VooIntegerField(
              name: 'age',
              label: 'Age',
              min: 18,
              max: 120,
              required: true,
            ),
            
            VooDropdownField<String>(
              name: 'country',
              label: 'Country',
              placeholder: 'Select a country',
              options: const ['USA', 'Canada', 'Mexico', 'UK', 'France', 'Germany'],
              required: true,
            ),
            
            VooCurrencyField(
              name: 'income',
              label: 'Annual Income',
              max: 10000000,
            ),
            
            const VooBooleanField(
              name: 'newsletter',
              label: 'Subscribe to Newsletter',
            ),
            
            const VooCheckboxField(
              name: 'terms',
              label: 'I agree to the Terms and Conditions',
              required: true,
            ),
          ],
          onSubmit: (values) {
            // Show submitted values
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Form Submitted'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: values.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('${entry.key}: ${entry.value}'),
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DirectWidgetFormExample(),
  ));
}