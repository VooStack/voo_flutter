import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/voo_forms.dart';

// ============================================================================
// COMPLETE FORM PREVIEWS
// ============================================================================

/// Toggleable form preview showing editable/read-only switch
class ToggleableFormPreview extends StatefulWidget {
  const ToggleableFormPreview({super.key});

  @override
  State<ToggleableFormPreview> createState() => _ToggleableFormPreviewState();
}

class _ToggleableFormPreviewState extends State<ToggleableFormPreview> {
  bool _isEditable = true;

  @override
  Widget build(BuildContext context) {
    final form = VooForm(
      id: 'preview_form',
      title: 'All Field Types Demo',
      description: 'Showcasing all available VooForm field types',
      sections: const [
        VooFormSection(
          id: 'text_section',
          title: 'Text Input Fields',
          description: 'Various text input types',
          fieldIds: ['text', 'email', 'password', 'phone', 'url', 'multiline'],
        ),
        VooFormSection(
          id: 'selection_section',
          title: 'Selection Fields',
          description: 'Dropdown, radio, and checkbox fields',
          fieldIds: ['dropdown', 'radio', 'checkbox', 'switch'],
        ),
        VooFormSection(
          id: 'datetime_section',
          title: 'Date & Time Fields',
          description: 'Date and time pickers',
          fieldIds: ['date', 'time'],
        ),
        VooFormSection(
          id: 'other_section',
          title: 'Other Fields',
          description: 'Slider and custom fields',
          fieldIds: ['slider', 'custom'],
        ),
      ],
      fields: [
        // Text Fields
        const VooFormField(
          id: 'text',
          name: 'text_field',
          type: VooFieldType.text,
          label: 'Full Name',
          hint: 'Enter your full name',
          required: true,
          prefixIcon: Icons.person,
          initialValue: 'John Doe',
        ),
        const VooFormField(
          id: 'email',
          name: 'email_field',
          type: VooFieldType.email,
          label: 'Email Address',
          hint: 'your.email@example.com',
          required: true,
          prefixIcon: Icons.email,
          initialValue: 'john.doe@example.com',
        ),
        const VooFormField(
          id: 'password',
          name: 'password_field',
          type: VooFieldType.password,
          label: 'Password',
          hint: 'Enter your password',
          required: true,
          prefixIcon: Icons.lock,
          initialValue: 'secretPassword',
        ),
        const VooFormField(
          id: 'phone',
          name: 'phone_field',
          type: VooFieldType.phone,
          label: 'Phone Number',
          hint: '+1 234 567 8900',
          prefixIcon: Icons.phone,
          initialValue: '+1 555 123 4567',
        ),
        const VooFormField(
          id: 'url',
          name: 'url_field',
          type: VooFieldType.url,
          label: 'Website',
          hint: 'https://example.com',
          prefixIcon: Icons.link,
          initialValue: 'https://flutter.dev',
        ),
        const VooFormField(
          id: 'multiline',
          name: 'multiline_field',
          type: VooFieldType.multiline,
          label: 'Description',
          hint: 'Tell us about yourself',
          maxLines: 5,
          initialValue: 'This is a multiline text field.\nIt can contain multiple lines of text.\nPerfect for descriptions and comments.',
        ),

        // Selection Fields
        const VooFormField<String>(
          id: 'dropdown',
          name: 'dropdown_field',
          type: VooFieldType.dropdown,
          label: 'Country',
          hint: 'Select your country',
          initialValue: 'US',
          options: [
            VooFieldOption(value: 'US', label: 'United States', icon: Icons.flag),
            VooFieldOption(value: 'CA', label: 'Canada', icon: Icons.flag),
            VooFieldOption(value: 'UK', label: 'United Kingdom', icon: Icons.flag),
            VooFieldOption(value: 'AU', label: 'Australia', icon: Icons.flag),
            VooFieldOption(value: 'DE', label: 'Germany', icon: Icons.flag),
          ],
        ),
        const VooFormField<String>(
          id: 'radio',
          name: 'radio_field',
          type: VooFieldType.radio,
          label: 'Gender',
          initialValue: 'male',
          options: [
            VooFieldOption(value: 'male', label: 'Male', icon: Icons.male),
            VooFieldOption(value: 'female', label: 'Female', icon: Icons.female),
            VooFieldOption(value: 'other', label: 'Other', icon: Icons.transgender),
          ],
        ),
        const VooFormField<bool>(
          id: 'checkbox',
          name: 'checkbox_field',
          type: VooFieldType.checkbox,
          label: 'I agree to the terms and conditions',
          initialValue: true,
        ),
        const VooFormField<bool>(
          id: 'switch',
          name: 'switch_field',
          type: VooFieldType.boolean,
          label: 'Enable notifications',
          helper: 'Receive email updates about your account',
          initialValue: true,
        ),

        // Date & Time Fields
        VooFormField<DateTime>(
          id: 'date',
          name: 'date_field',
          type: VooFieldType.date,
          label: 'Date of Birth',
          hint: 'Select your birth date',
          initialValue: DateTime(1990, 6, 15),
        ),
        const VooFormField<TimeOfDay>(
          id: 'time',
          name: 'time_field',
          type: VooFieldType.time,
          label: 'Appointment Time',
          hint: 'Select preferred time',
          initialValue: TimeOfDay(hour: 14, minute: 30),
        ),

        // Other Fields
        const VooFormField<double>(
          id: 'slider',
          name: 'slider_field',
          type: VooFieldType.slider,
          label: 'Satisfaction Level',
          helper: 'Rate from 0 to 10',
          initialValue: 7.5,
          min: 0,
          max: 10,
          divisions: 20,
        ),
        VooFormField(
          id: 'custom',
          name: 'custom_field',
          type: VooFieldType.custom,
          label: 'Custom Widget',
          customWidget: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.widgets, size: 32),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Widget Field',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'You can put any widget here!',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_isEditable ? 'Editable Form' : 'Read-Only Form'),
          backgroundColor: _isEditable ? Colors.blue.shade50 : Colors.grey.shade50,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _isEditable ? 'Editable' : 'Read-Only',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isEditable,
                    onChanged: (value) {
                      setState(() {
                        _isEditable = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isEditable ? Colors.blue.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isEditable ? Colors.blue : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isEditable ? Icons.edit : Icons.visibility,
                      color: _isEditable ? Colors.blue : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isEditable ? 'Form is EDITABLE - All fields can be modified' : 'Form is READ-ONLY - Displaying values in detail view',
                        style: TextStyle(
                          color: _isEditable ? Colors.blue.shade700 : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              VooFormBuilder(
                form: form,
                isEditable: _isEditable,
                onSubmit: _isEditable
                    ? (values) {
                        debugPrint('Form submitted with values: $values');
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple toggleable form preview
class SimpleToggleableForm extends StatefulWidget {
  const SimpleToggleableForm({super.key});

  @override
  State<SimpleToggleableForm> createState() => _SimpleToggleableFormState();
}

class _SimpleToggleableFormState extends State<SimpleToggleableForm> {
  bool _isEditable = true;

  @override
  Widget build(BuildContext context) {
    const form = VooForm(
      id: 'simple_form',
      title: 'User Profile',
      description: 'Toggle between edit and read-only modes',
      fields: [
        VooFormField(
          id: 'name',
          name: 'name',
          type: VooFieldType.text,
          label: 'Full Name',
          initialValue: 'John Smith',
          prefixIcon: Icons.person,
        ),
        VooFormField(
          id: 'email',
          name: 'email',
          type: VooFieldType.email,
          label: 'Email Address',
          initialValue: 'john.smith@example.com',
          prefixIcon: Icons.email,
        ),
        VooFormField<bool>(
          id: 'active',
          name: 'active',
          type: VooFieldType.boolean,
          label: 'Account Active',
          initialValue: true,
        ),
        VooFormField<String>(
          id: 'role',
          name: 'role',
          type: VooFieldType.dropdown,
          label: 'User Role',
          initialValue: 'admin',
          options: [
            VooFieldOption(value: 'admin', label: 'Administrator', icon: Icons.admin_panel_settings),
            VooFieldOption(value: 'user', label: 'User', icon: Icons.person),
            VooFieldOption(value: 'guest', label: 'Guest', icon: Icons.person_outline),
          ],
        ),
      ],
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Toggleable Form'),
          backgroundColor: Colors.teal.shade50,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Toggle control card
              Card(
                elevation: 4,
                color: _isEditable ? Colors.blue.shade50 : Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Form Mode',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isEditable ? 'You can edit all fields below' : 'Fields are displayed in read-only mode',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            _isEditable ? 'EDIT' : 'VIEW',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isEditable ? Colors.blue : Colors.orange,
                            ),
                          ),
                          Switch(
                            value: _isEditable,
                            onChanged: (value) {
                              setState(() {
                                _isEditable = value;
                              });
                            },
                            activeThumbColor: Colors.blue,
                            inactiveThumbColor: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // The form
              Expanded(
                child: SingleChildScrollView(
                  child: VooFormBuilder(
                    form: form,
                    isEditable: _isEditable,
                    showProgress: false,
                    onSubmit: _isEditable
                        ? (values) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Form submitted successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Complete form with all field types in read-only mode
class ReadOnlyFormPreview {
  static Widget build() {
    final form = VooForm(
      id: 'readonly_form',
      title: 'Form Details View',
      description: 'All fields displayed in read-only mode',
      fields: [
        const VooFormField(
          id: 'name',
          name: 'name',
          type: VooFieldType.text,
          label: 'Name',
          value: 'Jane Smith',
        ),
        const VooFormField(
          id: 'email',
          name: 'email',
          type: VooFieldType.email,
          label: 'Email',
          value: 'jane.smith@company.com',
        ),
        const VooFormField(
          id: 'phone',
          name: 'phone',
          type: VooFieldType.phone,
          label: 'Phone',
          value: '+1 555 987 6543',
        ),
        const VooFormField(
          id: 'country',
          name: 'country',
          type: VooFieldType.dropdown,
          label: 'Country',
          value: 'CA',
          options: [
            VooFieldOption(value: 'US', label: 'United States'),
            VooFieldOption(value: 'CA', label: 'Canada'),
            VooFieldOption(value: 'UK', label: 'United Kingdom'),
          ],
        ),
        const VooFormField<bool>(
          id: 'active',
          name: 'active',
          type: VooFieldType.boolean,
          label: 'Account Active',
          value: true,
        ),
        VooFormField<DateTime>(
          id: 'joined',
          name: 'joined',
          type: VooFieldType.date,
          label: 'Date Joined',
          value: DateTime.now().subtract(const Duration(days: 365)),
        ),
        const VooFormField<double>(
          id: 'progress',
          name: 'progress',
          type: VooFieldType.slider,
          label: 'Profile Completion',
          value: 8.5,
          min: 0,
          max: 10,
        ),
      ],
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Read-Only Form Preview'),
          backgroundColor: Colors.green.shade50,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: VooFormBuilder(
            form: form,
            isEditable: false, // Key setting for read-only mode
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// INDIVIDUAL FIELD PREVIEWS
// ============================================================================

@Preview(name: 'Toggleable Form - Edit/Read-Only')
Widget buildToggleableFormPreview() => const ToggleableFormPreview();

@Preview(name: 'Simple Toggleable Form')
Widget buildSimpleToggleableFormPreview() => const SimpleToggleableForm();

@Preview(name: 'All Fields - Read Only')
Widget buildReadOnlyFormPreview() => ReadOnlyFormPreview.build();

@Preview(name: 'Text Field')
Widget buildTextFieldPreview() => const _FieldPreview(
      field: VooFormField(
        id: 'text_preview',
        name: 'text_field',
        type: VooFieldType.text,
        label: 'Username',
        hint: 'Enter your username',
        helper: 'Must be 3-20 characters',
        required: true,
        prefixIcon: Icons.person,
        initialValue: 'flutter_dev',
      ),
    );

@Preview(name: 'Email Field')
Widget buildEmailFieldPreview() => const _FieldPreview(
      field: VooFormField(
        id: 'email_preview',
        name: 'email_field',
        type: VooFieldType.email,
        label: 'Email Address',
        hint: 'your.email@example.com',
        required: true,
        prefixIcon: Icons.email,
        initialValue: 'user@flutter.dev',
      ),
    );

@Preview(name: 'Password Field')
Widget buildPasswordFieldPreview() => const _FieldPreview(
      field: VooFormField(
        id: 'password_preview',
        name: 'password_field',
        type: VooFieldType.password,
        label: 'Password',
        hint: 'Enter secure password',
        helper: 'Minimum 8 characters',
        required: true,
        prefixIcon: Icons.lock,
        initialValue: 'MySecretPass123!',
      ),
    );

@Preview(name: 'Dropdown Field')
Widget buildDropdownFieldPreview() => const _FieldPreview(
      field: VooFormField<String>(
        id: 'dropdown_preview',
        name: 'dropdown_field',
        type: VooFieldType.dropdown,
        label: 'Select Framework',
        hint: 'Choose your favorite',
        initialValue: 'flutter',
        options: [
          VooFieldOption(value: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
          VooFieldOption(value: 'react', label: 'React Native', icon: Icons.code),
          VooFieldOption(value: 'swift', label: 'SwiftUI', icon: Icons.apple),
          VooFieldOption(value: 'kotlin', label: 'Kotlin', icon: Icons.android),
        ],
      ),
    );

@Preview(name: 'Checkbox Field')
Widget buildCheckboxFieldPreview() => const _FieldPreview(
      field: VooFormField<bool>(
        id: 'checkbox_preview',
        name: 'checkbox_field',
        type: VooFieldType.checkbox,
        label: 'I accept the terms and conditions',
        helper: 'Please read our terms before accepting',
        initialValue: false,
      ),
    );

@Preview(name: 'Switch Field')
Widget buildSwitchFieldPreview() => const _FieldPreview(
      field: VooFormField<bool>(
        id: 'switch_preview',
        name: 'switch_field',
        type: VooFieldType.boolean,
        label: 'Dark Mode',
        helper: 'Toggle application theme',
        initialValue: true,
      ),
    );

@Preview(name: 'Slider Field')
Widget buildSliderFieldPreview() => const _FieldPreview(
      field: VooFormField<double>(
        id: 'slider_preview',
        name: 'slider_field',
        type: VooFieldType.slider,
        label: 'Volume',
        helper: 'Adjust the volume level',
        initialValue: 65,
        min: 0,
        max: 100,
        divisions: 20,
      ),
    );

@Preview(name: 'Date Field')
Widget buildDateFieldPreview() => _FieldPreview(
      field: VooFormField<DateTime>(
        id: 'date_preview',
        name: 'date_field',
        type: VooFieldType.date,
        label: 'Birthday',
        hint: 'Select your birth date',
        initialValue: DateTime(2000),
      ),
    );

@Preview(name: 'Time Field')
Widget buildTimeFieldPreview() => const _FieldPreview(
      field: VooFormField<TimeOfDay>(
        id: 'time_preview',
        name: 'time_field',
        type: VooFieldType.time,
        label: 'Meeting Time',
        hint: 'Select meeting time',
        initialValue: TimeOfDay(hour: 10, minute: 30),
      ),
    );

@Preview(name: 'Custom Field - Card')
Widget buildCustomCardFieldPreview() => _FieldPreview(
      field: VooFormField(
        id: 'custom_card',
        name: 'custom_card',
        type: VooFieldType.custom,
        label: 'Status Card',
        customWidget: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, color: Colors.green.shade700),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'System Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'All systems operational',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

@Preview(name: 'Custom Field - Builder')
Widget buildCustomBuilderFieldPreview() => _FieldPreview(
      field: VooFormField(
        id: 'custom_builder',
        name: 'custom_builder',
        type: VooFieldType.custom,
        label: 'Dynamic Content',
        customBuilder: (context, field, value) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark ? [Colors.purple.shade900, Colors.blue.shade900] : [Colors.purple.shade100, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: isDark ? Colors.white : Colors.purple,
                ),
                const SizedBox(height: 8),
                Text(
                  'Custom Builder Widget',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.purple.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This widget adapts to theme changes',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

// ============================================================================
// LAYOUT PREVIEWS
// ============================================================================

@Preview(name: 'Grid Layout Form')
Widget buildGridLayoutPreview() {
  const form = VooForm(
    id: 'grid_form',
    title: 'Grid Layout Example',
    layout: FormLayout.grid,
    fields: [
      VooFormField(
        id: 'first_name',
        name: 'first_name',
        type: VooFieldType.text,
        label: 'First Name',
        initialValue: 'John',
      ),
      VooFormField(
        id: 'last_name',
        name: 'last_name',
        type: VooFieldType.text,
        label: 'Last Name',
        initialValue: 'Doe',
      ),
      VooFormField(
        id: 'email',
        name: 'email',
        type: VooFieldType.email,
        label: 'Email',
        initialValue: 'john@example.com',
      ),
      VooFormField(
        id: 'phone',
        name: 'phone',
        type: VooFieldType.phone,
        label: 'Phone',
        initialValue: '+1234567890',
      ),
    ],
  );

  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      appBar: AppBar(title: const Text('Grid Layout')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: VooFormBuilder(form: form),
      ),
    ),
  );
}

@Preview(name: 'Tabbed Layout Form')
Widget buildTabbedLayoutPreview() {
  const form = VooForm(
    id: 'tabbed_form',
    title: 'Tabbed Layout Example',
    layout: FormLayout.tabbed,
    sections: [
      VooFormSection(
        id: 'personal',
        title: 'Personal Info',
        icon: Icons.person,
        fieldIds: ['name', 'email'],
      ),
      VooFormSection(
        id: 'address',
        title: 'Address',
        icon: Icons.home,
        fieldIds: ['street', 'city'],
      ),
    ],
    fields: [
      VooFormField(
        id: 'name',
        name: 'name',
        type: VooFieldType.text,
        label: 'Full Name',
      ),
      VooFormField(
        id: 'email',
        name: 'email',
        type: VooFieldType.email,
        label: 'Email Address',
      ),
      VooFormField(
        id: 'street',
        name: 'street',
        type: VooFieldType.text,
        label: 'Street Address',
      ),
      VooFormField(
        id: 'city',
        name: 'city',
        type: VooFieldType.text,
        label: 'City',
      ),
    ],
  );

  return MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: DefaultTabController(
      length: form.sections!.length,
      child: Scaffold(
        appBar: AppBar(title: const Text('Tabbed Layout')),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: VooFormBuilder(form: form),
        ),
      ),
    ),
  );
}

// ============================================================================
// HELPER WIDGETS
// ============================================================================

/// Helper widget to preview individual fields with toggle
class _FieldPreview extends StatefulWidget {
  final VooFormField field;

  const _FieldPreview({
    required this.field,
  });

  @override
  State<_FieldPreview> createState() => _FieldPreviewState();
}

class _FieldPreviewState extends State<_FieldPreview> {
  bool _isEditable = true;

  @override
  Widget build(BuildContext context) {
    final form = VooForm(
      id: 'field_preview',
      fields: [widget.field],
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('${widget.field.type.label} Field'),
          backgroundColor: Colors.blue.shade50,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Toggle Mode:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isEditable,
                    onChanged: (value) {
                      setState(() {
                        _isEditable = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Mode indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isEditable ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isEditable ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isEditable ? Icons.edit : Icons.visibility,
                      color: _isEditable ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isEditable ? 'EDITABLE MODE' : 'READ-ONLY MODE',
                      style: TextStyle(
                        color: _isEditable ? Colors.green.shade700 : Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Field display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VooFormBuilder(
                        form: form,
                        isEditable: _isEditable,
                        showProgress: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
