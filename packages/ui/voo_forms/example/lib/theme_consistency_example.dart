import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

/// Example demonstrating consistent theming across all form components
void main() {
  runApp(const ThemeConsistencyExample());
}

class ThemeConsistencyExample extends StatelessWidget {
  const ThemeConsistencyExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a custom dark theme with purple primary color
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    // Define a custom light theme with purple primary color
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Theme Consistency Example',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const ThemeConsistencyPage(),
    );
  }
}

class ThemeConsistencyPage extends StatefulWidget {
  const ThemeConsistencyPage({super.key});

  @override
  State<ThemeConsistencyPage> createState() => _ThemeConsistencyPageState();
}

class _ThemeConsistencyPageState extends State<ThemeConsistencyPage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkMode 
          ? ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            )
          : ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Consistent Theming Example'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Text('Dark Mode'),
                    const SizedBox(width: 8),
                    Switch(
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                      },
                      // Note: Uses theme colors automatically
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildFormContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    final form = VooForm(
      id: 'theme-test',
      title: 'All Components Use Theme Colors',
      description: 'No hardcoded colors - everything follows your app theme',
      layout: FormLayout.vertical,
      fields: [
        // Text fields with consistent theming
        VooFormField(
          id: 'orderType',
          name: 'orderType',
          label: 'Order Type',
          type: VooFieldType.dropdown,
          required: true,
          prefixIcon: Icons.category_outlined,
          options: [
            const VooFieldOption(value: 'standard', label: 'Standard'),
            const VooFieldOption(value: 'express', label: 'Express'),
            const VooFieldOption(value: 'priority', label: 'Priority'),
          ],
        ),
        
        // Date field - uses theme colors
        VooFormField(
          id: 'orderDate',
          name: 'orderDate',
          label: 'Order Date',
          type: VooFieldType.date,
          required: true,
          prefixIcon: Icons.calendar_today,
        ),
        
        // Time field - uses theme colors
        VooFormField(
          id: 'deliveryTime',
          name: 'deliveryTime',
          label: 'Delivery Time',
          type: VooFieldType.time,
          prefixIcon: Icons.access_time,
        ),
        
        // Switch - uses theme primary color (not green!)
        VooFormField(
          id: 'priority',
          name: 'priority',
          label: 'Priority',
          type: VooFieldType.boolean,
        ),
        
        // Checkbox - uses theme primary color
        VooFormField(
          id: 'notifications',
          name: 'notifications',
          label: 'Send notifications',
          type: VooFieldType.checkbox,
        ),
        
        // Radio buttons - use theme colors
        VooFormField(
          id: 'deliveryOption',
          name: 'deliveryOption',
          label: 'Delivery Option',
          type: VooFieldType.radio,
          options: [
            const VooFieldOption(value: 'standard', label: 'Standard (3-5 days)'),
            const VooFieldOption(value: 'express', label: 'Express (1-2 days)'),
            const VooFieldOption(value: 'sameDay', label: 'Same Day'),
          ],
        ),
        
        // Slider - uses theme colors
        VooFormField(
          id: 'priority_level',
          name: 'priority_level',
          label: 'Priority Level',
          type: VooFieldType.slider,
          min: 0,
          max: 10,
          step: 1,
        ),
        
        // Multi-select chips - use theme colors
        VooFormField(
          id: 'tags',
          name: 'tags',
          label: 'Tags',
          type: VooFieldType.multiSelect,
          options: [
            const VooFieldOption(value: 'urgent', label: 'Urgent'),
            const VooFieldOption(value: 'fragile', label: 'Fragile'),
            const VooFieldOption(value: 'large', label: 'Large'),
            const VooFieldOption(value: 'heavy', label: 'Heavy'),
          ],
        ),
        
        // Rating - uses theme colors (not amber!)
        VooFormField(
          id: 'satisfaction',
          name: 'satisfaction',
          label: 'Satisfaction Rating',
          type: VooFieldType.rating,
          max: 5,
        ),
        
        // Color picker - uses theme colors as defaults
        VooFormField(
          id: 'labelColor',
          name: 'labelColor',
          label: 'Label Color',
          type: VooFieldType.color,
        ),
        
        // Text fields
        VooFormField(
          id: 'orderCost',
          name: 'orderCost',
          label: 'Order Cost',
          type: VooFieldType.text,
          prefixIcon: Icons.attach_money,
        ),
        
        VooFormField(
          id: 'specialInstructions',
          name: 'specialInstructions',
          label: 'Special Instructions',
          type: VooFieldType.multiline,
          maxLines: 4,
          prefixIcon: Icons.note_outlined,
        ),
        
        VooFormField(
          id: 'attachment',
          name: 'attachment',
          label: 'Attach File',
          type: VooFieldType.file,
          helper: 'Upload supporting documents',
        ),
        
        VooFormField(
          id: 'notes',
          name: 'notes',
          label: 'Internal Comments',
          type: VooFieldType.multiline,
          maxLines: 3,
          prefixIcon: Icons.comment,
        ),
      ],
    );

    return Column(
      children: [
        // Show different form configurations
        _buildFormVariant(
          context,
          form,
          'Outlined Fields (Default)',
          VooFormConfig(
            labelPosition: LabelPosition.above,
            fieldVariant: FieldVariant.outlined,
            showRequiredIndicator: true,
          ),
        ),
        const SizedBox(height: 32),
        _buildFormVariant(
          context,
          form,
          'Filled Fields',
          VooFormConfig(
            labelPosition: LabelPosition.floating,
            fieldVariant: FieldVariant.filled,
            showRequiredIndicator: true,
          ),
        ),
        const SizedBox(height: 32),
        _buildFormVariant(
          context,
          form,
          'Underlined Fields',
          const VooFormConfig(
            labelPosition: LabelPosition.floating,
            fieldVariant: FieldVariant.underlined,
            showRequiredIndicator: false,
          ),
        ),
      ],
    );
  }

  Widget _buildFormVariant(
    BuildContext context,
    VooForm form,
    String title,
    VooFormConfig config,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            VooFormV2(
              form: form.copyWith(
                title: null,
                description: null,
              ),
              config: config,
              showSubmitButton: false,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}