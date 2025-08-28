import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class SimpleResponsiveExample extends StatefulWidget {
  const SimpleResponsiveExample({super.key});

  @override
  State<SimpleResponsiveExample> createState() => _SimpleResponsiveExampleState();
}

class _SimpleResponsiveExampleState extends State<SimpleResponsiveExample> {
  late VooFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VooFormController(form: _buildForm());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  VooForm _buildForm() {
    return VooForm(
      id: 'simple_responsive',
      title: 'Simple Responsive Form',
      description: 'This form adapts to different screen sizes',
      layout: FormLayout.vertical,
      validationMode: FormValidationMode.onChange,
      fields: [
        VooFieldUtils.textField(
          id: 'name',
          name: 'name',
          label: 'Full Name',
          required: true,
          validators: [
            VooValidator.required(),
            VooValidator.minLength(2),
          ],
        ),
        VooFieldUtils.emailField(
          id: 'email',
          name: 'email',
          required: true,
        ),
        VooFieldUtils.phoneField(
          id: 'phone',
          name: 'phone',
          formatter: VooFormatters.phoneUS(),
        ),
        VooFieldUtils.dropdownField(
          id: 'country',
          name: 'country',
          label: 'Country',
          initialValue: 'US',
          options: const [
            VooFieldOption(value: 'US', label: 'United States'),
            VooFieldOption(value: 'CA', label: 'Canada'),
            VooFieldOption(value: 'UK', label: 'United Kingdom'),
            VooFieldOption(value: 'AU', label: 'Australia'),
          ],
        ),
        VooFieldUtils.switchField(
          id: 'newsletter',
          name: 'newsletter',
          label: 'Subscribe to newsletter',
          helper: 'Receive updates about new features',
          prefixIcon: Icons.mail,
        ),
        VooFieldUtils.checkboxField(
          id: 'terms',
          name: 'terms',
          label: 'I agree to the terms and conditions',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Responsive Form'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: VooResponsiveFormWrapper(
          form: _controller.form,
          controller: _controller,
          // Responsive settings
          phoneColumns: 1,
          tabletColumns: 2,
          desktopColumns: 3,
          phoneMaxWidth: null, // Full width on phone
          tabletMaxWidth: 800,
          desktopMaxWidth: 1000,
          alignment: FormAlignment.center,
          useSurfaceTint: true,
          elevation: 2,
          // Custom padding per device
          phonePadding: EdgeInsets.all(design.spacingMd),
          tabletPadding: EdgeInsets.all(design.spacingLg),
          desktopPadding: EdgeInsets.all(design.spacingXl),
          // Simple header
          header: Container(
            padding: EdgeInsets.all(design.spacingLg),
            child: Column(
              children: [
                Icon(
                  Icons.devices,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: design.spacingMd),
                Text(
                  'Responsive Form Demo',
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: design.spacingSm),
                Text(
                  'Resize your window to see the form adapt',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          footer: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Text(
              'This form automatically adjusts columns based on screen size',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          showProgress: true,
          showValidation: true,
          onSubmit: (values) async {
            // Show loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            
            // Simulate API call
            await Future.delayed(const Duration(seconds: 2));
            
            if (!context.mounted) return;
            Navigator.of(context).pop();
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Form submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}