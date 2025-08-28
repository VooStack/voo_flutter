import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class ResponsiveFormExample extends StatefulWidget {
  const ResponsiveFormExample({super.key});

  @override
  State<ResponsiveFormExample> createState() => _ResponsiveFormExampleState();
}

class _ResponsiveFormExampleState extends State<ResponsiveFormExample> {
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
      id: 'responsive_form',
      title: 'Responsive Form Example',
      description: 'This form adapts to different screen sizes',
      layout: FormLayout.vertical,
      validationMode: FormValidationMode.onChange,
      fields: [
        // Basic Information Section
        VooFieldUtils.textField(
          id: 'firstName',
          name: 'firstName',
          label: 'First Name',
          required: true,
          validators: [
            VooValidator.required(),
            VooValidator.minLength(2),
          ],
        ),
        VooFieldUtils.textField(
          id: 'lastName',
          name: 'lastName',
          label: 'Last Name',
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
        
        // Account Settings
        VooFieldUtils.textField(
          id: 'username',
          name: 'username',
          label: 'Username',
          required: true,
          validators: [
            VooValidator.alphanumeric(),
            VooValidator.minLength(3),
            VooValidator.maxLength(20),
          ],
        ),
        VooFieldUtils.passwordField(
          id: 'password',
          name: 'password',
          required: true,
        ),
        VooFieldUtils.switchField(
          id: 'newsletter',
          name: 'newsletter',
          label: 'Subscribe to newsletter',
          helper: 'Receive updates about new features',
          prefixIcon: Icons.mail,
        ),
        VooFieldUtils.switchField(
          id: 'notifications',
          name: 'notifications',
          label: 'Enable notifications',
          helper: 'Get real-time updates',
          prefixIcon: Icons.notifications,
        ),
        
        // Preferences
        VooFieldUtils.dropdownField(
          id: 'theme',
          name: 'theme',
          label: 'Theme Preference',
          initialValue: 'system',
          options: const [
            VooFieldOption(value: 'light', label: 'Light'),
            VooFieldOption(value: 'dark', label: 'Dark'),
            VooFieldOption(value: 'system', label: 'System Default'),
          ],
        ),
        VooFieldUtils.sliderField(
          id: 'fontSize',
          name: 'fontSize',
          label: 'Font Size',
          min: 12,
          max: 24,
          initialValue: 16.0,
        ),
        VooFieldUtils.multiSelectField(
          id: 'interests',
          name: 'interests',
          label: 'Your Interests',
          helper: 'Select all that apply',
          options: const [
            VooFieldOption(value: 'tech', label: 'Technology'),
            VooFieldOption(value: 'design', label: 'Design'),
            VooFieldOption(value: 'business', label: 'Business'),
            VooFieldOption(value: 'science', label: 'Science'),
            VooFieldOption(value: 'arts', label: 'Arts'),
          ],
        ),
        
        // Terms
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
        title: const Text('Responsive Form Example'),
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
          desktopMaxWidth: 1200,
          alignment: FormAlignment.center,
          useSurfaceTint: true,
          elevation: 2,
          // Custom padding per device
          phonePadding: EdgeInsets.all(design.spacingMd),
          tabletPadding: EdgeInsets.all(design.spacingLg),
          desktopPadding: EdgeInsets.all(design.spacingXl),
          // Header with custom content
          header: _buildHeader(context),
          footer: _buildFooter(context),
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
  
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Container(
      padding: EdgeInsets.all(design.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(design.radiusLg),
          topRight: Radius.circular(design.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 64,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          SizedBox(height: design.spacingMd),
          Text(
            'Create Your Account',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: design.spacingSm),
          Text(
            'Join our community and get started',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Container(
      padding: EdgeInsets.all(design.spacingMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(design.radiusLg),
          bottomRight: Radius.circular(design.radiusLg),
        ),
      ),
      child: Column(
        children: [
          Text(
            'By signing up, you agree to our Terms of Service and Privacy Policy',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: design.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Privacy Policy'),
              ),
              Text('•', style: TextStyle(color: theme.colorScheme.outline)),
              TextButton(
                onPressed: () {},
                child: const Text('Terms of Service'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom form builder that handles dividers
class ResponsiveFormWithDividers extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final void Function(Map<String, dynamic>)? onSubmit;

  const ResponsiveFormWithDividers({
    super.key,
    required this.form,
    required this.controller,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return VooResponsiveFormWrapper(
      form: form,
      controller: controller,
      onSubmit: onSubmit,
      phoneColumns: 1,
      tabletColumns: 2,
      desktopColumns: 2,
      header: Column(
        children: [
          const Text(
            'Account Setup',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: design.spacingMd),
          VooFormSectionDivider.inset(),
        ],
      ),
    );
  }
  
}

/// Example showing all divider styles
class DividerStylesExample extends StatelessWidget {
  const DividerStylesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Divider Styles'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Dividers
            Text(
              'Section Dividers',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: design.spacingMd),
            
            _buildDividerExample(
              context,
              'Full Width',
              VooFormSectionDivider.full(),
            ),
            
            _buildDividerExample(
              context,
              'Inset (Material 3 Standard)',
              VooFormSectionDivider.inset(),
            ),
            
            _buildDividerExample(
              context,
              'Middle',
              VooFormSectionDivider.middle(),
            ),
            
            _buildDividerExample(
              context,
              'Custom Color',
              VooFormSectionDivider.full(
                color: theme.colorScheme.primary,
                thickness: 2,
              ),
            ),
            
            SizedBox(height: design.spacingXl),
            
            // Text Dividers
            Text(
              'Text Dividers',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: design.spacingMd),
            
            _buildDividerExample(
              context,
              'Plain Style',
              VooFormSectionTextDivider(
                text: 'Section Break',
                style: DividerTextStyle.plain,
              ),
            ),
            
            _buildDividerExample(
              context,
              'Outlined Style (Default)',
              VooFormSectionTextDivider(
                text: 'Continue',
                style: DividerTextStyle.outlined,
              ),
            ),
            
            _buildDividerExample(
              context,
              'Chip Style',
              VooFormSectionTextDivider(
                text: 'Step 2',
                style: DividerTextStyle.chip,
              ),
            ),
            
            _buildDividerExample(
              context,
              'Filled Style',
              VooFormSectionTextDivider(
                text: 'Next Section',
                style: DividerTextStyle.filled,
              ),
            ),
            
            _buildDividerExample(
              context,
              'OR Divider',
              VooFormSectionTextDivider.or(
                style: DividerTextStyle.outlined,
              ),
            ),
            
            _buildDividerExample(
              context,
              'AND Divider',
              VooFormSectionTextDivider.and(
                style: DividerTextStyle.chip,
              ),
            ),
            
            _buildDividerExample(
              context,
              'With Icon',
              VooFormSectionTextDivider.withIcon(
                text: 'Social Login',
                icon: const Icon(Icons.people, size: 18),
                style: DividerTextStyle.filled,
              ),
            ),
            
            _buildDividerExample(
              context,
              'Custom Style',
              VooFormSectionTextDivider(
                text: 'PREMIUM',
                textStyle: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                thickness: 2,
                style: DividerTextStyle.outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDividerExample(
    BuildContext context,
    String label,
    Widget divider,
  ) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: design.spacingSm),
        divider,
        SizedBox(height: design.spacingLg),
      ],
    );
  }
}