import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example demonstrating a complete user registration form
class RegistrationExample extends StatefulWidget {
  const RegistrationExample({super.key});

  @override
  State<RegistrationExample> createState() => _RegistrationExampleState();
}

class _RegistrationExampleState extends State<RegistrationExample> {
  final _controller = VooFormController();
  String? _password;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add,
                      size: 40,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    'Join Us Today',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    'Create your account to get started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.lg),

            // Registration Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: VooForm(
                  controller: _controller,
                  fields: [
                    // Account Information Section
                    VooFormSectionDivider(
                      name: 'account_section',
                      label: 'Account Information',
                    ),
                    VooTextField(
                      name: 'username',
                      label: 'Username',
                      placeholder: 'Choose a username',
                      prefixIcon: const Icon(Icons.alternate_email),
                      validators: [
                        RequiredValidation(),
                        MinLengthValidation(minLength: 3),
                        MaxLengthValidation(maxLength: 20),
                        PatternValidation(
                          pattern: r'^[a-zA-Z0-9_]+$',
                          errorMessage: 'Only letters, numbers, and underscores',
                        ),
                      ],
                    ),
                    VooEmailField(
                      name: 'email',
                      label: 'Email Address',
                      placeholder: 'your@email.com',
                      validators: [
                        RequiredValidation(),
                        EmailValidation(),
                      ],
                    ),
                    VooPasswordField(
                      name: 'password',
                      label: 'Password',
                      placeholder: 'Create a strong password',
                      validators: [
                        RequiredValidation(),
                        MinLengthValidation(
                          minLength: 8,
                          errorMessage: 'Password must be at least 8 characters',
                        ),
                        PatternValidation(
                          pattern: r'[A-Z]',
                          errorMessage: 'Include at least one uppercase letter',
                        ),
                        PatternValidation(
                          pattern: r'[0-9]',
                          errorMessage: 'Include at least one number',
                        ),
                      ],
                      onChanged: (value) => _password = value,
                    ),
                    VooPasswordField(
                      name: 'confirmPassword',
                      label: 'Confirm Password',
                      placeholder: 'Re-enter your password',
                      validators: [
                        RequiredValidation(),
                        VooValidator.custom<String>(
                          validator: (value) {
                            if (value != _password) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    // Personal Information Section
                    VooFormSectionDivider(
                      name: 'personal_section',
                      label: 'Personal Information',
                    ),
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
                    VooDateField(
                      name: 'birthDate',
                      label: 'Date of Birth',
                      placeholder: 'Select your birth date',
                      lastDate: DateTime.now().subtract(
                        const Duration(days: 365 * 13), // Must be 13+
                      ),
                      firstDate: DateTime(1900),
                      validators: [RequiredValidation()],
                    ),
                    VooPhoneField(
                      name: 'phone',
                      label: 'Phone Number (Optional)',
                      placeholder: '(555) 123-4567',
                    ),

                    // Preferences Section
                    VooFormSectionDivider(
                      name: 'preferences_section',
                      label: 'Preferences',
                    ),
                    VooDropdownField<String>(
                      name: 'language',
                      label: 'Preferred Language',
                      initialValue: 'English',
                      options: const [
                        'English',
                        'Spanish',
                        'French',
                        'German',
                        'Chinese',
                        'Japanese',
                      ],
                    ),
                    VooDropdownField<String>(
                      name: 'timezone',
                      label: 'Timezone',
                      placeholder: 'Select your timezone',
                      options: const [
                        'Pacific Time (PT)',
                        'Mountain Time (MT)',
                        'Central Time (CT)',
                        'Eastern Time (ET)',
                        'UTC',
                        'GMT',
                      ],
                    ),
                    VooBooleanField(
                      name: 'newsletter',
                      label: 'Subscribe to Newsletter',
                      helper: 'Receive updates about new features and tips',
                      initialValue: true,
                    ),
                    VooBooleanField(
                      name: 'notifications',
                      label: 'Enable Push Notifications',
                      helper: 'Get notified about important updates',
                      initialValue: true,
                    ),

                    // Terms Section
                    VooFormSectionDivider(
                      name: 'terms_section',
                      label: 'Terms & Conditions',
                    ),
                    VooCheckboxField(
                      name: 'termsAccepted',
                      label: 'I agree to the Terms of Service and Privacy Policy',
                      validators: [
                        VooValidator.custom<bool>(
                          validator: (value) {
                            if (value != true) {
                              return 'You must accept the terms to continue';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    VooCheckboxField(
                      name: 'ageVerified',
                      label: 'I confirm that I am at least 13 years old',
                      validators: [
                        VooValidator.custom<bool>(
                          validator: (value) {
                            if (value != true) {
                              return 'You must be at least 13 years old';
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
              onPressed: _submitForm,
              child: const Text('Create Account'),
            ),
            SizedBox(height: spacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Login'),
            ),
            SizedBox(height: spacing.lg),
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
          content: Text(
            'Account created for ${values['firstName']} ${values['lastName']}!',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors above'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
