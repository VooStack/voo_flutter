import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example demonstrating best practices with the new VooField API
/// and VooSimpleForm for an amazing developer experience
class BestPracticesExample extends StatelessWidget {
  const BestPracticesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooForms Best Practices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Simple Form Example',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildSimpleForm(),
              const Divider(height: 48),
              Text(
                'Form with Options',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildFormWithOptions(),
              const Divider(height: 48),
              Text(
                'Grid Layout Form',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildGridForm(),
              const Divider(height: 48),
              Text(
                'Stepped Form',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildSteppedForm(),
            ],
          ),
        ),
      ),
    );
  }

  /// Simple form using VooField factory constructors
  Widget _buildSimpleForm() {
    return VooSimpleForm(
      fields: [
        VooField.text(
          name: 'firstName',
          label: 'First Name',
          required: true,
          placeholder: 'Enter your first name',
        ),
        VooField.text(
          name: 'lastName',
          label: 'Last Name',
          required: true,
          placeholder: 'Enter your last name',
        ),
        VooField.email(
          name: 'email',
          label: 'Email Address',
          required: true,
          placeholder: 'user@example.com',
        ),
        VooField.phone(
          name: 'phone',
          label: 'Phone Number',
          placeholder: '(555) 123-4567',
        ),
        VooField.dropdown(
          name: 'country',
          label: 'Country',
          options: ['United States', 'Canada', 'Mexico', 'Other'],
          required: true,
        ),
        VooField.boolean(
          name: 'newsletter',
          label: 'Subscribe to newsletter',
          initialValue: false,
        ),
      ],
      onSubmit: (values) {
        if (kDebugMode) {
          print('Form submitted with values: $values');
        }
      },
      showProgress: true,
    );
  }

  /// Form with custom field options
  Widget _buildFormWithOptions() {
    return VooSimpleForm(
      // Set default options for all fields
      defaultFieldOptions: VooFieldOptions.comfortable,
      fields: [
        VooField.text(
          name: 'username',
          label: 'Username',
          required: true,
        ),
        VooField.password(
          name: 'password',
          label: 'Password',
          required: true,
        ),
        VooField.password(
          name: 'confirmPassword',
          label: 'Confirm Password',
          required: true,
        ),
        VooField.date(
          name: 'birthDate',
          label: 'Date of Birth',
          required: true,
        ),
        VooField.slider(
          name: 'experience',
          label: 'Years of Experience',
          min: 0,
          max: 20,
          divisions: 20,
          initialValue: 5.0,
        ),
        VooField.checkbox(
          name: 'terms',
          label: 'I agree to the terms and conditions',
          required: true,
        ),
      ],
      onSubmit: (values) {
        if (kDebugMode) {
          print('Account created with: $values');
        }
      },
      submitLabel: 'Create Account',
    );
  }

  /// Form with grid layout
  Widget _buildGridForm() {
    return VooSimpleForm(
      layout: FormLayout.grid,
      defaultFieldOptions: VooFieldOptions.material,
      fields: [
        VooField.text(
          name: 'company',
          label: 'Company Name',
          gridColumns: 2, // Span 2 columns
        ),
        VooField.text(
          name: 'industry',
          label: 'Industry',
        ),
        VooField.number(
          name: 'employees',
          label: 'Number of Employees',
        ),
        VooField.text(
          name: 'website',
          label: 'Website',
        ),
        VooField.email(
          name: 'contactEmail',
          label: 'Contact Email',
        ),
        VooField.multiline(
          name: 'description',
          label: 'Company Description',
          gridColumns: 2,
          maxLines: 4,
        ),
      ],
      onSubmit: (values) {
        if (kDebugMode) {
          print('Company profile: $values');
        }
      },
    );
  }

  /// Stepped/Wizard form with sections
  Widget _buildSteppedForm() {
    return SizedBox(
      height: 500,
      child: VooSimpleForm(
        layout: FormLayout.stepped,
        sections: [
          VooFormSection(
            title: 'Personal Information',
            fieldIds: ['name', 'email', 'phone'],
            id: 'personal',
          ),
          VooFormSection(
            title: 'Address',
            fieldIds: ['street', 'city', 'state', 'zip'],
            id: 'address',
          ),
          VooFormSection(
            title: 'Preferences',
            fieldIds: ['notifications', 'theme', 'language'],
            id: 'preferences',
          ),
        ],
        metadata: {
          'steps': [
            {'title': 'Personal'},
            {'title': 'Address'},
            {'title': 'Preferences'},
          ],
        },
        fields: [
          // Personal Information
          VooField.text(
            name: 'name',
            label: 'Full Name',
            required: true,
          ),
          VooField.email(
            name: 'email',
            label: 'Email',
            required: true,
          ),
          VooField.phone(
            name: 'phone',
            label: 'Phone',
          ),
          // Address
          VooField.text(
            name: 'street',
            label: 'Street Address',
            required: true,
          ),
          VooField.text(
            name: 'city',
            label: 'City',
            required: true,
          ),
          VooField.dropdown(
            name: 'state',
            label: 'State',
            options: ['CA', 'NY', 'TX', 'FL', 'Other'],
            required: true,
          ),
          VooField.text(
            name: 'zip',
            label: 'ZIP Code',
            required: true,
          ),
          // Preferences
          VooField.boolean(
            name: 'notifications',
            label: 'Enable notifications',
            initialValue: true,
          ),
          VooField.radio(
            name: 'theme',
            label: 'Theme',
            options: ['Light', 'Dark', 'System'],
            initialValue: 'System',
          ),
          VooField.dropdown(
            name: 'language',
            label: 'Language',
            options: ['English', 'Spanish', 'French', 'German'],
            initialValue: 'English',
          ),
        ],
        onSubmit: (values) {
          if (kDebugMode) {
            print('Wizard completed: $values');
          }
        },
        showProgress: true,
      ),
    );
  }
}
