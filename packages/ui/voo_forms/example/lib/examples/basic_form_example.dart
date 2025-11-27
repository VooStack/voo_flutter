import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Basic form example demonstrating simple form creation and submission
class BasicFormExample extends StatefulWidget {
  const BasicFormExample({super.key});

  @override
  State<BasicFormExample> createState() => _BasicFormExampleState();
}

class _BasicFormExampleState extends State<BasicFormExample> {
  final _controller = VooFormController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Basic Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: VooForm(
                  controller: _controller,
                  fields: [
                    VooTextField(
                      name: 'firstName',
                      label: 'First Name',
                      placeholder: 'Enter your first name',
                      validators: [RequiredValidation()],
                    ),
                    VooTextField(
                      name: 'lastName',
                      label: 'Last Name',
                      placeholder: 'Enter your last name',
                      validators: [RequiredValidation()],
                    ),
                    VooEmailField(
                      name: 'email',
                      label: 'Email',
                      placeholder: 'example@email.com',
                      validators: [RequiredValidation(), EmailValidation()],
                    ),
                    VooPhoneField(
                      name: 'phone',
                      label: 'Phone Number',
                      placeholder: '(555) 123-4567',
                    ),
                  ],
                  onChanged: (values) {
                    debugPrint('Form values: $values');
                  },
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
            SizedBox(height: spacing.sm),
            OutlinedButton(
              onPressed: _resetForm,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_controller.validate()) {
      final values = _controller.values;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form submitted: ${values['firstName']} ${values['lastName']}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resetForm() {
    _controller.reset();
  }
}
