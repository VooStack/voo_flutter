import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/voo_forms.dart';

// ============================================================================
// Previews for text-based fields using the new widget pattern
// ============================================================================

@Preview(name: 'Text Fields - Basic')
Widget previewBasicTextFields() => const BasicTextFieldsPreview();

class BasicTextFieldsPreview extends StatelessWidget {
  const BasicTextFieldsPreview({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            VooTextField(
              name: 'username',
              label: 'Username',
              placeholder: 'Enter your username',
              helper: 'Must be at least 3 characters',
              required: true,
            ),
            SizedBox(height: 16),
            VooEmailField(
              name: 'email',
              label: 'Email Address',
              placeholder: 'user@example.com',
              required: true,
            ),
            SizedBox(height: 16),
            VooPasswordField(
              name: 'password',
              label: 'Password',
              placeholder: 'Enter secure password',
              helper: 'Minimum 8 characters',
              required: true,
            ),
            SizedBox(height: 16),
            VooPhoneField(
              name: 'phone',
              label: 'Phone Number',
              placeholder: '(555) 123-4567',
            ),
            SizedBox(height: 16),
            VooMultilineField(
              name: 'bio',
              label: 'Biography',
              placeholder: 'Tell us about yourself...',
              maxLines: 5,
            ),
          ],
        ),
      );
}

@Preview(name: 'Text Fields with Validation')
Widget previewTextFieldsValidation() => const TextFieldValidationPreview();

class TextFieldValidationPreview extends StatefulWidget {
  const TextFieldValidationPreview({super.key});

  @override
  State<TextFieldValidationPreview> createState() => _TextFieldValidationPreviewState();
}

class _TextFieldValidationPreviewState extends State<TextFieldValidationPreview> {
  String? emailError;
  String? passwordError;

  void _validateEmail(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        emailError = 'Email is required';
      } else if (!value.contains('@')) {
        emailError = 'Please enter a valid email';
      } else {
        emailError = null;
      }
    });
  }

  void _validatePassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        passwordError = 'Password is required';
      } else if (value.length < 8) {
        passwordError = 'Password must be at least 8 characters';
      } else {
        passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VooEmailField(
              name: 'email',
              label: 'Email with Validation',
              error: emailError,
              onChanged: _validateEmail,
            ),
            const SizedBox(height: 16),
            VooPasswordField(
              name: 'password',
              label: 'Password with Validation',
              error: passwordError,
              onChanged: _validatePassword,
            ),
          ],
        ),
      );
}

@Preview(name: 'Text Fields with Actions')
Widget previewTextFieldsWithActions() => const TextFieldActionsPreview();

class TextFieldActionsPreview extends StatefulWidget {
  const TextFieldActionsPreview({super.key});

  @override
  State<TextFieldActionsPreview> createState() => _TextFieldActionsPreviewState();
}

class _TextFieldActionsPreviewState extends State<TextFieldActionsPreview> {
  bool _obscurePassword = true;
  String _searchText = '';

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VooTextField(
              name: 'search',
              label: 'Search',
              placeholder: 'Type to search...',
              value: _searchText,
              onChanged: (String? value) => setState(() => _searchText = value ?? ''),
              prefixIcon: const Icon(Icons.search),
              actions: [
                if (_searchText.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _searchText = ''),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            VooPasswordField(
              name: 'password',
              label: 'Password with Toggle',
              actions: [
                IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const VooTextField(
              name: 'url',
              label: 'Website URL',
              placeholder: 'https://example.com',
              prefixIcon: Icon(Icons.link),
              actions: [
                IconButton(
                  icon: Icon(Icons.open_in_new),
                  onPressed: null, // Disabled for preview
                ),
              ],
            ),
          ],
        ),
      );
}

@Preview(name: 'Text Fields - Disabled/ReadOnly')
Widget previewDisabledTextFields() => const DisabledTextFieldsPreview();

class DisabledTextFieldsPreview extends StatelessWidget {
  const DisabledTextFieldsPreview({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            VooTextField(
              name: 'disabled',
              label: 'Disabled Field',
              value: 'This field is disabled',
              enabled: false,
            ),
            SizedBox(height: 16),
            VooTextField(
              name: 'readonly',
              label: 'Read-Only Field',
              value: 'This field is read-only',
              readOnly: true,
            ),
            SizedBox(height: 16),
            VooTextField(
              name: 'prefilledDisabled',
              label: 'Pre-filled Disabled',
              value: 'Cannot be changed',
              enabled: false,
              helper: 'This value was set by the system',
            ),
          ],
        ),
      );
}