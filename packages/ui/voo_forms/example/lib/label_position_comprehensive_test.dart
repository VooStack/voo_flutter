import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class LabelPositionComprehensiveTestPage extends StatelessWidget {
  const LabelPositionComprehensiveTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprehensive Label Position Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Label Position: Above',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'All fields should have labels positioned above the input field',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            
            // Create a form with labelPosition: above
            VooSimpleForm(
              defaultConfig: const VooFormConfig(
                labelPosition: LabelPosition.above,
                fieldVariant: FieldVariant.outlined,
                showRequiredIndicator: true,
              ),
              fields: [
                VooField.text(
                  name: 'name',
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  required: true,
                ),
                VooField.email(
                  name: 'email',
                  label: 'Email Address',
                  hint: 'Enter your email',
                  required: true,
                ),
                VooField.date(
                  name: 'birth_date',
                  label: 'Date of Birth',
                  hint: 'Select your birth date',
                  required: true,
                ),
                VooField.dropdownSimple(
                  name: 'country',
                  label: 'Country',
                  hint: 'Select your country',
                  options: ['United States', 'Canada', 'Mexico', 'United Kingdom', 'Germany', 'France'],
                  required: true,
                ),
                VooField.dropdown<String>(
                  name: 'city',
                  label: 'City (Searchable)',
                  hint: 'Select your city',
                  options: ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia'],
                  converter: (city) => VooDropdownChild(
                    value: city,
                    label: city,
                    icon: Icons.location_city,
                  ),
                  enableSearch: true,
                  searchHint: 'Search cities...',
                ),
                VooField.phone(
                  name: 'phone',
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                ),
                VooField.multiline(
                  name: 'address',
                  label: 'Address',
                  hint: 'Enter your full address',
                  maxLines: 3,
                ),
                VooField.time(
                  name: 'preferred_time',
                  label: 'Preferred Contact Time',
                  hint: 'Select preferred time',
                ),
                VooField.boolean(
                  name: 'newsletter',
                  label: 'Subscribe to newsletter',
                  helper: 'Receive weekly updates',
                ),
                VooField.checkbox(
                  name: 'terms',
                  label: 'I agree to the terms and conditions',
                  required: true,
                ),
              ],
              onSubmit: (values) {
                debugPrint('Form submitted with values: $values');
              },
            ),
            
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 48),
            
            Text(
              'Testing Different Label Positions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Test individual field widgets with different label positions
            _buildFieldSection(
              context,
              'Date Field - Label Above',
              VooFieldWidget(
                field: VooField.date(
                  name: 'test_date_above',
                  label: 'Date (Label Above)',
                  hint: 'Select a date',
                ),
                options: VooFieldOptions.material.copyWith(
                  labelPosition: LabelPosition.above,
                ),
              ),
            ),
            
            _buildFieldSection(
              context,
              'Dropdown Field - Label Above',
              VooFieldWidget(
                field: VooField.dropdownSimple(
                  name: 'test_dropdown_above',
                  label: 'Dropdown (Label Above)',
                  hint: 'Select an option',
                  options: ['Option 1', 'Option 2', 'Option 3'],
                ),
                options: VooFieldOptions.material.copyWith(
                  labelPosition: LabelPosition.above,
                ),
              ),
            ),
            
            _buildFieldSection(
              context,
              'Date Field - Label Left',
              VooFieldWidget(
                field: VooField.date(
                  name: 'test_date_left',
                  label: 'Date (Left)',
                  hint: 'Select a date',
                ),
                options: VooFieldOptions.material.copyWith(
                  labelPosition: LabelPosition.left,
                ),
              ),
            ),
            
            _buildFieldSection(
              context,
              'Dropdown Field - Label Left',
              VooFieldWidget(
                field: VooField.dropdownSimple(
                  name: 'test_dropdown_left',
                  label: 'Dropdown (Left)',
                  hint: 'Select an option',
                  options: ['Option A', 'Option B', 'Option C'],
                ),
                options: VooFieldOptions.material.copyWith(
                  labelPosition: LabelPosition.left,
                ),
              ),
            ),
            
            _buildFieldSection(
              context,
              'Date Field - Label Floating',
              VooFieldWidget(
                field: VooField.date(
                  name: 'test_date_floating',
                  label: 'Date (Floating)',
                  hint: 'Select a date',
                ),
                options: VooFieldOptions.material.copyWith(
                  labelPosition: LabelPosition.floating,
                ),
              ),
            ),
            
            _buildFieldSection(
              context,
              'Dropdown Field - Label Floating',
              VooFieldWidget(
                field: VooField.dropdownSimple(
                  name: 'test_dropdown_floating',
                  label: 'Dropdown (Floating)',
                  hint: 'Select an option',
                  options: ['Item 1', 'Item 2', 'Item 3'],
                ),
                options: VooFieldOptions.material.copyWith(
                  labelPosition: LabelPosition.floating,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFieldSection(BuildContext context, String title, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: field,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}