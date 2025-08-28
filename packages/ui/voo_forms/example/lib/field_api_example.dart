import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example demonstrating the new VooField API with factory constructors
/// and inheritable field options
void main() {
  runApp(const FieldApiExample());
}

class FieldApiExample extends StatelessWidget {
  const FieldApiExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooField API Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FieldApiExamplePage(),
    );
  }
}

class FieldApiExamplePage extends StatefulWidget {
  const FieldApiExamplePage({super.key});

  @override
  State<FieldApiExamplePage> createState() => _FieldApiExamplePageState();
}

class _FieldApiExamplePageState extends State<FieldApiExamplePage> {
  VooFieldOptions _currentOptions = VooFieldOptions.material;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New VooField API'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Options selector
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: _buildOptionsSelector(),
          ),
          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSelector() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Field Options Presets',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          'Material Design',
          'Default Material design patterns',
          VooFieldOptions.material,
        ),
        _buildOptionTile(
          'Compact',
          'Dense layout for data-heavy forms',
          VooFieldOptions.compact,
        ),
        _buildOptionTile(
          'Comfortable',
          'Spacious layout with extra padding',
          VooFieldOptions.comfortable,
        ),
        _buildOptionTile(
          'Minimal',
          'Clean, minimal appearance',
          VooFieldOptions.minimal,
        ),
        const Divider(height: 32),
        Text(
          'Custom Options',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          'Floating Labels',
          'Material-style floating labels',
          const VooFieldOptions(
            labelPosition: LabelPosition.floating,
            fieldVariant: FieldVariant.outlined,
            showRequiredIndicator: true,
          ),
        ),
        _buildOptionTile(
          'Inline Labels',
          'Labels inside the field',
          const VooFieldOptions(
            labelPosition: LabelPosition.inline,
            fieldVariant: FieldVariant.filled,
            showRequiredIndicator: false,
          ),
        ),
        _buildOptionTile(
          'Left-aligned Labels',
          'Labels to the left of fields',
          const VooFieldOptions(
            labelPosition: LabelPosition.left,
            fieldVariant: FieldVariant.outlined,
            spacing: 16.0,
          ),
        ),
        _buildOptionTile(
          'Ghost Fields',
          'Minimal border until focused',
          const VooFieldOptions(
            labelPosition: LabelPosition.above,
            fieldVariant: FieldVariant.ghost,
            fieldSize: FieldSize.large,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(String title, String subtitle, VooFieldOptions options) {
    final isSelected = _currentOptions == options;
    
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected 
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          setState(() {
            _currentOptions = options;
          });
        },
      ),
    );
  }

  Widget _buildForm() {
    return VooFieldOptionsProvider(
      options: _currentOptions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Using VooField factory constructors with inherited options',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // Text field
          VooField.text(
            name: 'fullName',
            label: 'Full Name',
            required: true,
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          
          // Email field
          VooField.email(
            name: 'email',
            label: 'Email Address',
            required: true,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          
          // Phone field
          VooField.phone(
            name: 'phone',
            label: 'Phone Number',
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: 16),
          
          // Password field
          VooField.password(
            name: 'password',
            label: 'Password',
            required: true,
            helper: 'Must be at least 8 characters',
          ),
          const SizedBox(height: 24),
          
          Text(
            'Additional Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // Dropdown field
          VooField.dropdown(
            name: 'country',
            label: 'Country',
            required: true,
            items: const [
              VooFieldOption(value: 'us', label: 'United States'),
              VooFieldOption(value: 'ca', label: 'Canada'),
              VooFieldOption(value: 'uk', label: 'United Kingdom'),
              VooFieldOption(value: 'au', label: 'Australia'),
              VooFieldOption(value: 'other', label: 'Other'),
            ],
            prefixIcon: Icons.public,
          ),
          const SizedBox(height: 16),
          
          // Date field
          VooField.date(
            name: 'birthDate',
            label: 'Date of Birth',
            required: true,
            prefixIcon: Icons.cake_outlined,
          ),
          const SizedBox(height: 16),
          
          // Time field
          VooField.time(
            name: 'preferredTime',
            label: 'Preferred Contact Time',
            prefixIcon: Icons.access_time,
          ),
          const SizedBox(height: 16),
          
          // Number field
          VooField.number(
            name: 'age',
            label: 'Age',
            min: 0,
            max: 150,
            prefixIcon: Icons.numbers,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // Switch field
          VooField.switchField(
            name: 'newsletter',
            label: 'Subscribe to newsletter',
          ),
          const SizedBox(height: 16),
          
          // Checkbox field
          VooField.checkbox(
            name: 'terms',
            label: 'I agree to the terms and conditions',
            required: true,
          ),
          const SizedBox(height: 16),
          
          // Radio field
          VooField.radio(
            name: 'contactMethod',
            label: 'Preferred Contact Method',
            items: const [
              VooFieldOption(value: 'email', label: 'Email'),
              VooFieldOption(value: 'phone', label: 'Phone'),
              VooFieldOption(value: 'text', label: 'Text Message'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Slider field
          VooField.slider(
            name: 'satisfaction',
            label: 'How satisfied are you?',
            min: 0,
            max: 10,
            divisions: 10,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Comments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // Multiline field
          VooField.multiline(
            name: 'comments',
            label: 'Additional Comments',
            hint: 'Tell us more about your experience',
            maxLines: 5,
            minLines: 3,
            maxLength: 500,
            prefixIcon: Icons.comment_outlined,
          ),
          const SizedBox(height: 24),
          
          // Custom field with overridden options
          Text(
            'Field with Custom Options',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This field overrides the inherited options',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          VooField.text(
            name: 'customField',
            label: 'Custom Field',
            hint: 'This field has its own options',
            options: const VooFieldOptions(
              labelPosition: LabelPosition.floating,
              fieldVariant: FieldVariant.filled,
              fieldSize: FieldSize.large,
              filled: true,
              showRequiredIndicator: false,
            ),
          ),
          const SizedBox(height: 32),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Form submitted!'),
                  ),
                );
              },
              child: const Text('Submit Form'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}