import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: VooResponsiveBuilder(
        child: MaterialApp(
          title: 'VooForms Example',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const FormExamplePage(),
        ),
      ),
    );
  }
}

class FormExamplePage extends StatefulWidget {
  const FormExamplePage({super.key});

  @override
  State<FormExamplePage> createState() => _FormExamplePageState();
}

class _FormExamplePageState extends State<FormExamplePage> {
  late VooFormController _controller;
  final Map<String, dynamic> _capturedValues = {};
  
  @override
  void initState() {
    super.initState();
    _initializeForm();
  }
  
  void _initializeForm() {
    final form = VooForm(
      id: 'example_form',
      fields: _createFields(),
      sections: [
        VooFormSection(
          id: 'text_fields',
          title: 'Text Fields',
          subtitle: 'Various text input fields with typed onChanged callbacks',
          fieldIds: ['text', 'email', 'password', 'phone', 'multiline'],
        ),
        VooFormSection(
          id: 'numeric_fields',
          title: 'Numeric Fields',
          subtitle: 'Number and slider fields with proper type conversion',
          fieldIds: ['number', 'slider'],
        ),
        VooFormSection(
          id: 'boolean_fields',
          title: 'Boolean Fields',
          subtitle: 'Switch and checkbox fields with bool callbacks',
          fieldIds: ['switch', 'checkbox'],
        ),
        VooFormSection(
          id: 'selection_fields',
          title: 'Selection Fields',
          subtitle: 'Dropdown and radio fields with typed values',
          fieldIds: ['dropdown', 'dropdown_enum', 'radio'],
        ),
        VooFormSection(
          id: 'date_time_fields',
          title: 'Date & Time Fields',
          subtitle: 'Date and time pickers with proper callbacks',
          fieldIds: ['date', 'time'],
        ),
      ],
    );
    
    _controller = VooFormController(form: form);
  }
  
  List<VooFormField> _createFields() {
    return [
      // Text Fields
      VooField.text(
        name: 'text',
        label: 'Text Field',
        placeholder: 'Enter any text',
        helper: 'This demonstrates a basic text field with String? callback',
        prefixIcon: Icons.text_fields,
        onChanged: (String? value) {
          setState(() {
            _capturedValues['text'] = value;
          });
          debugPrint('Text field changed: $value (type: ${value.runtimeType})');
        },
      ),
      
      VooField.email(
        name: 'email',
        label: 'Email Field',
        placeholder: 'user@example.com',
        helper: 'Email field with validation and typed callback',
        prefixIcon: Icons.email,
        validators: [VooValidator.email()],
        onChanged: (String? value) {
          setState(() {
            _capturedValues['email'] = value;
          });
          debugPrint('Email field changed: $value');
        },
      ),
      
      VooField.password(
        name: 'password',
        label: 'Password Field',
        placeholder: 'Enter password',
        helper: 'Password field with obscured text',
        prefixIcon: Icons.lock,
        validators: [
          VooValidator.required(),
          VooValidator.minLength(8),
        ],
        onChanged: (String? value) {
          setState(() {
            _capturedValues['password'] = value?.isNotEmpty == true ? '***' : null;
          });
          debugPrint('Password field changed: ${value?.replaceAll(RegExp(r'.'), '*')}');
        },
      ),
      
      VooField.phone(
        name: 'phone',
        label: 'Phone Field',
        placeholder: '+1 (555) 123-4567',
        helper: 'Phone number with formatting',
        prefixIcon: Icons.phone,
        onChanged: (String? value) {
          setState(() {
            _capturedValues['phone'] = value;
          });
          debugPrint('Phone field changed: $value');
        },
      ),
      
      VooField.multiline(
        name: 'multiline',
        label: 'Multiline Text',
        placeholder: 'Enter multiple lines of text...',
        helper: 'Supports multiple lines',
        maxLines: 4,
        onChanged: (String? value) {
          setState(() {
            _capturedValues['multiline'] = value;
          });
          debugPrint('Multiline field changed: ${value?.replaceAll('\n', '\\n')}');
        },
      ),
      
      // Numeric Fields
      VooField.number(
        name: 'number',
        label: 'Number Field',
        placeholder: 'Enter a number',
        helper: 'Automatically parses to num type',
        prefixIcon: Icons.numbers,
        validators: [
          VooValidator.min(0),
          VooValidator.max(100),
        ],
        onChanged: (num? value) {
          setState(() {
            _capturedValues['number'] = value;
          });
          debugPrint('Number field changed: $value (type: ${value.runtimeType})');
        },
      ),
      
      VooField.slider(
        name: 'slider',
        label: 'Slider Field',
        helper: 'Drag to select a value',
        min: 0,
        max: 100,
        divisions: 20,
        initialValue: 50,
        onChanged: (double? value) {
          setState(() {
            _capturedValues['slider'] = value?.toStringAsFixed(1);
          });
          debugPrint('Slider field changed: $value');
        },
      ),
      
      // Boolean Fields
      VooField.boolean(
        name: 'switch',
        label: 'Switch Field',
        helper: 'Toggle on/off with bool callback',
        initialValue: false,
        onChanged: (bool? value) {
          setState(() {
            _capturedValues['switch'] = value;
          });
          debugPrint('Switch field changed: $value');
        },
      ),
      
      VooField.checkbox(
        name: 'checkbox',
        label: 'Checkbox Field',
        helper: 'Check/uncheck with bool callback',
        initialValue: false,
        onChanged: (bool? value) {
          setState(() {
            _capturedValues['checkbox'] = value;
          });
          debugPrint('Checkbox field changed: $value');
        },
      ),
      
      // Selection Fields
      VooField.dropdown<String>(
        name: 'dropdown',
        label: 'String Dropdown',
        helper: 'Dropdown with String values',
        prefixIcon: Icons.arrow_drop_down,
        options: ['Option A', 'Option B', 'Option C'],
        converter: (String option) => VooDropdownChild(
          label: option,
          value: option,
        ),
        onChanged: (String? value) {
          setState(() {
            _capturedValues['dropdown'] = value;
          });
          debugPrint('Dropdown field changed: $value');
        },
      ),
      
      VooField.dropdown<ExampleEnum>(
        name: 'dropdown_enum',
        label: 'Enum Dropdown',
        helper: 'Dropdown with typed enum values',
        prefixIcon: Icons.category,
        options: ExampleEnum.values,
        converter: (ExampleEnum value) => VooDropdownChild(
          label: value.displayName,
          value: value,
        ),
        onChanged: (ExampleEnum? value) {
          setState(() {
            _capturedValues['dropdown_enum'] = value?.displayName;
          });
          debugPrint('Enum dropdown changed: $value');
        },
      ),
      
      VooField.radio(
        name: 'radio',
        label: 'Radio Field',
        helper: 'Select one option',
        options: const ['Small', 'Medium', 'Large'],
        onChanged: (dynamic value) {
          setState(() {
            _capturedValues['radio'] = value;
          });
          debugPrint('Radio field changed: $value');
        },
      ),
      
      // Date & Time Fields
      VooField.date(
        name: 'date',
        label: 'Date Field',
        placeholder: 'Select a date',
        helper: 'Date picker with DateTime callback',
        prefixIcon: Icons.calendar_today,
        onChanged: (DateTime? value) {
          setState(() {
            _capturedValues['date'] = value?.toString().split(' ')[0];
          });
          debugPrint('Date field changed: $value');
        },
      ),
      
      VooField.time(
        name: 'time',
        label: 'Time Field',
        placeholder: 'Select a time',
        helper: 'Time picker with TimeOfDay callback',
        prefixIcon: Icons.access_time,
        onChanged: (TimeOfDay? value) {
          setState(() {
            _capturedValues['time'] = value?.format(context);
          });
          debugPrint('Time field changed: $value');
        },
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooForms Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Form Section
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Fields with Typed onChanged Callbacks',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This example demonstrates all field types with properly typed onChanged callbacks.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  VooFormBuilder(
                    form: _controller.form,
                    controller: _controller,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.validate()) {
                            final values = _controller.values;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Form is valid! Values: $values'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fix validation errors'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Validate & Submit'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          _controller.reset();
                          setState(() {
                            _capturedValues.clear();
                          });
                        },
                        child: const Text('Reset Form'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Live Values Panel
          Container(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live onChanged Values',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Values captured by onChanged callbacks:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: _capturedValues.isEmpty
                        ? Center(
                            child: Text(
                              'Start typing to see values...',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView(
                            children: _capturedValues.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        '${entry.key}:',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        entry.value?.toString() ?? 'null',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontFamily: 'monospace',
                                          color: entry.value != null
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum ExampleEnum {
  small('Small Size'),
  medium('Medium Size'),
  large('Large Size');
  
  final String displayName;
  const ExampleEnum(this.displayName);
}