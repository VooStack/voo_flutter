import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class FormSectionExample extends StatelessWidget {
  const FormSectionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Section Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Basic section with title and fields
            VooFormSection(
              title: 'Personal Information',
              description: 'Please provide your basic details',
              children: const [
                VooTextField(
                  name: 'firstName',
                  label: 'First Name',
                  placeholder: 'Enter your first name',
                ),
                VooTextField(
                  name: 'lastName',
                  label: 'Last Name',
                  placeholder: 'Enter your last name',
                ),
                VooEmailField(
                  name: 'email',
                  label: 'Email Address',
                  placeholder: 'your.email@example.com',
                ),
              ],
            ),

            // Section with custom styling
            VooFormSection(
              title: 'Contact Details',
              leading: const Icon(Icons.phone),
              elevation: 2,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              children: const [
                VooPhoneField(
                  name: 'phone',
                  label: 'Phone Number',
                  placeholder: '(555) 123-4567',
                ),
                VooTextField(
                  name: 'address',
                  label: 'Address',
                  placeholder: 'Street address',
                ),
                VooDropdownField(
                  name: 'country',
                  label: 'Country',
                  options: ['USA', 'Canada', 'UK', 'Australia'],
                  placeholder: 'Select your country',
                ),
              ],
            ),

            // Collapsible section
            VooFormSection(
              title: 'Additional Information',
              description: 'Optional details about your preferences',
              isCollapsible: true,
              initiallyExpanded: false,
              leading: const Icon(Icons.info_outline),
              onExpansionChanged: (expanded) {
                debugPrint('Section expanded: $expanded');
              },
              children: [
                const VooBooleanField(
                  name: 'newsletter',
                  label: 'Subscribe to newsletter',
                  helper: 'Receive updates about new features',
                ),
                const VooMultilineField(
                  name: 'comments',
                  label: 'Comments',
                  placeholder: 'Any additional comments...',
                  maxLines: 5,
                ),
                VooDateField(
                  name: 'birthdate',
                  label: 'Date of Birth',
                  initialValue:
                      DateTime.now().subtract(const Duration(days: 365 * 25)),
                ),
              ],
            ),

            // Section without border
            const VooFormSection(
              title: 'Preferences',
              showTitleDivider: false,
              children: [
                VooCheckboxField(
                  name: 'terms',
                  label: 'I agree to the terms and conditions',
                ),
                VooCheckboxField(
                  name: 'privacy',
                  label: 'I have read the privacy policy',
                ),
              ],
            ),

            // Nested sections
            VooFormSection(
              title: 'Account Settings',
              leading: const Icon(Icons.settings),
              children: [
                const VooTextField(
                  name: 'username',
                  label: 'Username',
                  placeholder: 'Choose a username',
                ),
                const VooPasswordField(
                  name: 'password',
                  label: 'Password',
                  placeholder: 'Enter a strong password',
                ),
                const SizedBox(height: 16),
                VooFormSection(
                  title: 'Security Options',
                  elevation: 0,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  children: const [
                    VooBooleanField(
                      name: 'twoFactor',
                      label: 'Enable two-factor authentication',
                    ),
                    VooBooleanField(
                      name: 'rememberMe',
                      label: 'Remember me on this device',
                    ),
                  ],
                ),
              ],
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
    home: const FormSectionExample(),
  ));
}
