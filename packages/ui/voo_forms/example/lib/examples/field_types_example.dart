import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Example showcasing all available field types
class FieldTypesExample extends StatelessWidget {
  const FieldTypesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Field Types')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.md),
        child: VooForm(
          layout: FormLayout.vertical,
          fields: [
            // Text Fields Section
            VooFormSectionDivider(
              name: 'text_section',
              label: 'Text Fields',
              subtitle: 'Various text input types',
            ),
            VooTextField(
              name: 'text',
              label: 'Text Field',
              placeholder: 'Enter any text',
            ),
            VooEmailField(
              name: 'email',
              label: 'Email Field',
              placeholder: 'example@email.com',
            ),
            VooPasswordField(
              name: 'password',
              label: 'Password Field',
              placeholder: 'Enter password',
            ),
            VooPhoneField(
              name: 'phone',
              label: 'Phone Field',
              placeholder: '(555) 123-4567',
            ),
            VooMultilineField(
              name: 'multiline',
              label: 'Multiline Field',
              placeholder: 'Enter multiple lines of text...',
              maxLines: 4,
            ),

            // Number Fields Section
            VooFormSectionDivider(
              name: 'number_section',
              label: 'Number Fields',
              subtitle: 'Numeric input types',
            ),
            VooIntegerField(
              name: 'integer',
              label: 'Integer Field',
              placeholder: 'Enter a whole number',
            ),
            VooDecimalField(
              name: 'decimal',
              label: 'Decimal Field',
              placeholder: 'Enter a decimal number',
            ),
            VooCurrencyField(
              name: 'currency',
              label: 'Currency Field',
              placeholder: '\$0.00',
            ),
            VooPercentageField(
              name: 'percentage',
              label: 'Percentage Field',
              placeholder: '0%',
            ),

            // Selection Fields Section
            VooFormSectionDivider(
              name: 'selection_section',
              label: 'Selection Fields',
              subtitle: 'Choose from options',
            ),
            VooDropdownField<String>(
              name: 'dropdown',
              label: 'Dropdown Field',
              placeholder: 'Select an option',
              options: const ['Option 1', 'Option 2', 'Option 3'],
            ),
            VooBooleanField(
              name: 'boolean',
              label: 'Enable Feature',
              helper: 'Toggle this setting on or off',
            ),
            VooCheckboxField(
              name: 'checkbox',
              label: 'I agree to the terms and conditions',
            ),

            // Date Field Section
            VooFormSectionDivider(
              name: 'date_section',
              label: 'Date Fields',
              subtitle: 'Date and time selection',
            ),
            VooDateField(
              name: 'date',
              label: 'Date Field',
              placeholder: 'Select a date',
            ),
          ],
        ),
      ),
    );
  }
}
