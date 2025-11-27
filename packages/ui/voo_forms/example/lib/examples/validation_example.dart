import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating validation features
class ValidationExample extends StatefulWidget {
  const ValidationExample({super.key});

  @override
  State<ValidationExample> createState() => _ValidationExampleState();
}

class _ValidationExampleState extends State<ValidationExample> {
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
      appBar: AppBar(title: const Text('Validation')),
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
                    // Required validation
                    VooTextField(
                      name: 'required',
                      label: 'Required Field',
                      placeholder: 'This field is required',
                      validators: [RequiredValidation()],
                    ),

                    // Email validation
                    VooEmailField(
                      name: 'email',
                      label: 'Email (with format validation)',
                      placeholder: 'Must be a valid email',
                      validators: [
                        RequiredValidation(),
                        EmailValidation(),
                      ],
                    ),

                    // Min/Max length validation using VooValidator helper
                    VooTextField(
                      name: 'username',
                      label: 'Username (3-20 characters)',
                      placeholder: 'Enter username',
                      validators: [
                        RequiredValidation(),
                        MinLengthValidation(minLength: 3),
                        MaxLengthValidation(maxLength: 20),
                      ],
                    ),

                    // Password with pattern validation
                    VooPasswordField(
                      name: 'password',
                      label: 'Password (min 8 chars, 1 number)',
                      placeholder: 'Enter a strong password',
                      validators: [
                        RequiredValidation(),
                        MinLengthValidation(minLength: 8),
                        PatternValidation(
                          pattern: r'[0-9]',
                          errorMessage: 'Password must contain at least one number',
                        ),
                      ],
                    ),

                    // Number range validation
                    VooIntegerField(
                      name: 'age',
                      label: 'Age (18-120)',
                      placeholder: 'Enter your age',
                      validators: [
                        RequiredValidation(),
                        MinValueValidation(minValue: 18),
                        MaxValueValidation(maxValue: 120),
                      ],
                    ),

                    // Custom validation using VooValidator helper
                    VooTextField(
                      name: 'custom',
                      label: 'Custom Validation',
                      placeholder: 'Must start with "VOO"',
                      validators: [
                        VooValidator.custom<String>(
                          validator: (value) {
                            if (value == null || value.isEmpty) return null;
                            if (!value.startsWith('VOO')) {
                              return 'Value must start with "VOO"';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    // Checkbox validation using VooValidator helper
                    VooCheckboxField(
                      name: 'terms',
                      label: 'I accept the terms and conditions',
                      validators: [
                        VooValidator.custom<bool>(
                          validator: (value) {
                            if (value != true) {
                              return 'You must accept the terms and conditions';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: _validateForm,
              child: const Text('Validate All'),
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

  void _validateForm() {
    final isValid = _controller.validate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isValid ? 'All fields are valid!' : 'Please fix the errors'),
        backgroundColor: isValid ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetForm() {
    _controller.reset();
  }
}
