import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'responsive_form_example.dart';
import 'simple_responsive_example.dart';
import 'design_system_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VooMaterialApp(
      title: 'VooForms Comprehensive Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormExampleHome(),
    );
  }
}

class FormExampleHome extends StatelessWidget {
  const FormExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VooForms Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            'Registration Form',
            'Complete form with sections, validation, and formatters',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrationExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Survey Form',
            'Rating, slider, multi-select, and conditional fields',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SurveyExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Stepped Form',
            'Multi-step wizard form with progress tracking',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SteppedFormExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Dynamic Form',
            'Form with dynamic field generation and dependencies',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DynamicFormExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'All Field Types',
            'Showcase of every supported field type',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AllFieldTypesExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Custom Validators',
            'Advanced validation with custom rules',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ValidationExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Form Headers',
            'Using headers for better organization',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HeadersExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Simple Responsive Form',
            'Basic form that adapts to different screen sizes',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SimpleResponsiveExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Advanced Responsive Form',
            'Complex form with Material 3 dividers and sections',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResponsiveFormExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Divider Styles',
            'All Material 3 form divider styles',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DividerStylesExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Design System',
            'Switch between Voo and Material design systems',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DesignSystemExample()),
            ),
          ),
          _buildExampleCard(
            context,
            'Design System Comparison',
            'Side-by-side design system comparison',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DesignSystemComparison()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

// Registration Form Example
class RegistrationExample extends StatefulWidget {
  const RegistrationExample({super.key});

  @override
  State<RegistrationExample> createState() => _RegistrationExampleState();
}

class _RegistrationExampleState extends State<RegistrationExample> {
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
      id: 'registration',
      title: 'Create Account',
      description: 'Please fill in your information to create an account',
      layout: FormLayout.vertical,
      validationMode: FormValidationMode.onChange,
      sections: const [
        VooFormSection(
          id: 'personal',
          title: 'Personal Information',
          icon: Icons.person,
          fieldIds: ['firstName', 'lastName', 'email', 'phone', 'birthdate'],
          collapsible: true,
          header: VooFormHeader(
            id: 'personal_header',
            title: 'Step 1: Personal Details',
            subtitle: 'Tell us about yourself',
            style: HeaderStyle.card,
            showDivider: true,
          ),
        ),
        VooFormSection(
          id: 'account',
          title: 'Account Security',
          icon: Icons.security,
          fieldIds: ['username', 'password', 'confirmPassword'],
          collapsible: true,
          header: VooFormHeader(
            id: 'account_header',
            title: 'Step 2: Create Login',
            subtitle: 'Choose secure credentials',
            style: HeaderStyle.card,
            showDivider: true,
          ),
        ),
        VooFormSection(
          id: 'address',
          title: 'Address Information',
          icon: Icons.location_on,
          fieldIds: ['street', 'city', 'state', 'zipCode', 'country'],
          collapsible: true,
          collapsed: true,
          header: VooFormHeader(
            id: 'address_header',
            title: 'Step 3: Location',
            subtitle: 'Where can we reach you?',
            style: HeaderStyle.card,
            showDivider: true,
          ),
        ),
      ],
      fields: [
        // Personal Information
        VooFieldUtils.textField(
          id: 'firstName',
          name: 'firstName',
          label: 'First Name',
          required: true,
          validators: [
            VooValidator.required('First name is required'),
            VooValidator.minLength(2),
            VooValidator.alpha(allowSpaces: false),
          ],
          textCapitalization: TextCapitalization.words,
        ),
        VooFieldUtils.textField(
          id: 'lastName',
          name: 'lastName',
          label: 'Last Name',
          required: true,
          validators: [
            VooValidator.required('Last name is required'),
            VooValidator.minLength(2),
            VooValidator.alpha(allowSpaces: false),
          ],
          textCapitalization: TextCapitalization.words,
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
        VooFieldUtils.dateField(
          id: 'birthdate',
          name: 'birthdate',
          label: 'Date of Birth',
          required: true,
          maxDate: DateTime.now(),
          minDate: DateTime(1900),
        ),
        
        // Account Security
        VooFieldUtils.textField(
          id: 'username',
          name: 'username',
          label: 'Username',
          required: true,
          validators: [
            VooValidator.required(),
            VooValidator.alphanumeric(),
            VooValidator.minLength(3),
            VooValidator.maxLength(20),
          ],
          helper: 'Choose a unique username (3-20 characters)',
        ),
        VooFieldUtils.passwordField(
          id: 'password',
          name: 'password',
          required: true,
          minLength: 8,
          requireUppercase: true,
          requireNumbers: true,
        ),
        VooFormField<String>(
          id: 'confirmPassword',
          name: 'confirmPassword',
          label: 'Confirm Password',
          type: VooFieldType.password,
          required: true,
          validators: [
            VooValidator.required('Please confirm your password'),
          ],
        ),
        
        // Address Information
        VooFieldUtils.textField(
          id: 'street',
          name: 'street',
          label: 'Street Address',
          required: true,
        ),
        VooFieldUtils.textField(
          id: 'city',
          name: 'city',
          label: 'City',
          required: true,
          validators: [
            VooValidator.alpha(allowSpaces: true),
          ],
        ),
        VooFieldUtils.dropdownField(
          id: 'state',
          name: 'state',
          label: 'State',
          required: true,
          options: _getStateOptions(),
        ),
        VooFormField<String>(
          id: 'zipCode',
          name: 'zipCode',
          label: 'ZIP Code',
          type: VooFieldType.text,
          required: true,
          inputFormatters: [VooFormatters.postalCodeUS()],
          validators: [
            VooValidator.postalCode(),
          ],
        ),
        VooFieldUtils.dropdownField(
          id: 'country',
          name: 'country',
          label: 'Country',
          required: true,
          initialValue: 'US',
          options: _getCountryOptions(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: VooFormBuilder(
        controller: _controller,
        form: _controller.form,
        showProgress: true,
        showValidation: true,
        onSubmit: (values) async {
          // Validate password match
          if (values['password'] != values['confirmPassword']) {
            throw Exception('Passwords do not match');
          }
          
          // Simulate API call
          await Future.delayed(const Duration(seconds: 2));
          
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  static List<VooFieldOption<String>> _getStateOptions() {
    return const [
      VooFieldOption(value: 'CA', label: 'California'),
      VooFieldOption(value: 'NY', label: 'New York'),
      VooFieldOption(value: 'TX', label: 'Texas'),
      VooFieldOption(value: 'FL', label: 'Florida'),
      VooFieldOption(value: 'IL', label: 'Illinois'),
    ];
  }

  static List<VooFieldOption<String>> _getCountryOptions() {
    return const [
      VooFieldOption(value: 'US', label: 'United States'),
      VooFieldOption(value: 'CA', label: 'Canada'),
      VooFieldOption(value: 'MX', label: 'Mexico'),
      VooFieldOption(value: 'UK', label: 'United Kingdom'),
      VooFieldOption(value: 'AU', label: 'Australia'),
    ];
  }
}

// Survey Form Example
class SurveyExample extends StatefulWidget {
  const SurveyExample({super.key});

  @override
  State<SurveyExample> createState() => _SurveyExampleState();
}

class _SurveyExampleState extends State<SurveyExample> {
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
    return VooFormUtils.createSectionedForm(
      id: 'survey',
      title: 'Customer Satisfaction Survey',
      description: 'Help us improve our services',
      sections: {
        const VooFormSection(
          id: 'experience',
          title: 'Your Experience',
          icon: Icons.star,
          fieldIds: ['overall_rating', 'satisfaction_slider', 'recommend'],
        ): [
          VooFieldUtils.ratingField(
            id: 'overall_rating',
            name: 'overall_rating',
            label: 'Overall Rating',
            helper: 'How would you rate your overall experience?',
            max: 5,
            required: true,
          ),
          VooFieldUtils.sliderField(
            id: 'satisfaction_slider',
            name: 'satisfaction',
            label: 'Satisfaction Level',
            helper: 'Drag to indicate your satisfaction (0-100)',
            min: 0,
            max: 100,
            step: 5,
          ),
          VooFieldUtils.radioField(
            id: 'recommend',
            name: 'recommend',
            label: 'Would you recommend us?',
            required: true,
            options: const [
              VooFieldOption(value: 'yes', label: 'Yes, definitely'),
              VooFieldOption(value: 'maybe', label: 'Maybe'),
              VooFieldOption(value: 'no', label: 'No'),
            ],
          ),
        ],
        const VooFormSection(
          id: 'features',
          title: 'Feature Preferences',
          icon: Icons.check_box,
          fieldIds: ['liked_features', 'improvements'],
        ): [
          VooFieldUtils.multiSelectField(
            id: 'liked_features',
            name: 'liked_features',
            label: 'What features did you like?',
            helper: 'Select all that apply',
            options: const [
              VooFieldOption(value: 'ui', label: 'User Interface'),
              VooFieldOption(value: 'performance', label: 'Performance'),
              VooFieldOption(value: 'features', label: 'Features'),
              VooFieldOption(value: 'support', label: 'Customer Support'),
              VooFieldOption(value: 'pricing', label: 'Pricing'),
            ],
          ),
          VooFieldUtils.textAreaField(
            id: 'improvements',
            name: 'improvements',
            label: 'Suggestions for Improvement',
            hint: 'Tell us how we can improve...',
            minLines: 3,
            maxLines: 5,
            maxLength: 500,
          ),
        ],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: VooFormBuilder(
        controller: _controller,
        form: _controller.form,
        showProgress: true,
        onSubmit: (values) async {
          await Future.delayed(const Duration(seconds: 1));
          
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you for your feedback!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}

// All Field Types Example - Including Switch Field
class AllFieldTypesExample extends StatefulWidget {
  const AllFieldTypesExample({super.key});

  @override
  State<AllFieldTypesExample> createState() => _AllFieldTypesExampleState();
}

class _AllFieldTypesExampleState extends State<AllFieldTypesExample> {
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
    return VooFormUtils.createForm(
      id: 'all_fields',
      title: 'All Field Types',
      description: 'Demonstration of every supported field type',
      layout: FormLayout.vertical,
      fields: [
        // Text fields
        VooFieldUtils.textField(
          id: 'text',
          name: 'text',
          label: 'Text Field',
          hint: 'Enter some text',
        ),
        VooFieldUtils.emailField(
          id: 'email',
          name: 'email',
        ),
        VooFieldUtils.passwordField(
          id: 'password',
          name: 'password',
        ),
        VooFieldUtils.phoneField(
          id: 'phone',
          name: 'phone',
          formatter: VooFormatters.phoneInternational(),
        ),
        VooFieldUtils.urlField(
          id: 'url',
          name: 'url',
        ),
        VooFieldUtils.textAreaField(
          id: 'multiline',
          name: 'multiline',
          label: 'Multiline Text',
        ),
        
        // Number fields
        VooFieldUtils.numberField(
          id: 'number',
          name: 'number',
          label: 'Number Field',
          min: 0,
          max: 100,
        ),
        VooFieldUtils.sliderField(
          id: 'slider',
          name: 'slider',
          label: 'Slider',
        ),
        VooFieldUtils.ratingField(
          id: 'rating',
          name: 'rating',
          label: 'Rating',
        ),
        
        // Date/Time fields
        VooFieldUtils.dateField(
          id: 'date',
          name: 'date',
          label: 'Date Picker',
        ),
        const VooFormField<TimeOfDay>(
          id: 'time',
          name: 'time',
          label: 'Time Picker',
          type: VooFieldType.time,
        ),
        const VooFormField<DateTime>(
          id: 'datetime',
          name: 'datetime',
          label: 'Date & Time',
          type: VooFieldType.dateTime,
        ),
        
        // Boolean fields
        VooFieldUtils.checkboxField(
          id: 'checkbox',
          name: 'checkbox',
          label: 'Checkbox',
        ),
        VooFieldUtils.switchField(
          id: 'switch',
          name: 'switch',
          label: 'Switch Toggle',
          helper: 'Enable or disable this feature',
          prefixIcon: Icons.notifications,
        ),
        
        // Selection fields
        VooFieldUtils.dropdownField(
          id: 'dropdown',
          name: 'dropdown',
          label: 'Dropdown',
          options: const [
            VooFieldOption(value: 'opt1', label: 'Option 1'),
            VooFieldOption(value: 'opt2', label: 'Option 2'),
            VooFieldOption(value: 'opt3', label: 'Option 3'),
          ],
        ),
        VooFieldUtils.radioField(
          id: 'radio',
          name: 'radio',
          label: 'Radio Buttons',
          options: const [
            VooFieldOption(value: 'a', label: 'Option A'),
            VooFieldOption(value: 'b', label: 'Option B'),
            VooFieldOption(value: 'c', label: 'Option C'),
          ],
        ),
        VooFieldUtils.multiSelectField(
          id: 'multiselect',
          name: 'multiselect',
          label: 'Multi Select',
          options: const [
            VooFieldOption(value: 'item1', label: 'Item 1'),
            VooFieldOption(value: 'item2', label: 'Item 2'),
            VooFieldOption(value: 'item3', label: 'Item 3'),
            VooFieldOption(value: 'item4', label: 'Item 4'),
          ],
        ),
        
        // Special fields
        VooFieldUtils.colorField(
          id: 'color',
          name: 'color',
          label: 'Color Picker',
        ),
        const VooFormField<String>(
          id: 'file',
          name: 'file',
          label: 'File Upload',
          type: VooFieldType.file,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Field Types'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: VooFormBuilder(
        controller: _controller,
        form: _controller.form,
        showProgress: false,
        onSubmit: (values) async {
          // Log all values
          debugPrint('Form Values:');
          values.forEach((key, value) {
            debugPrint('  $key: $value');
          });
        },
      ),
    );
  }
}

// Stepped Form Example
class SteppedFormExample extends StatefulWidget {
  const SteppedFormExample({super.key});

  @override
  State<SteppedFormExample> createState() => _SteppedFormExampleState();
}

class _SteppedFormExampleState extends State<SteppedFormExample> {
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
    return VooFormUtils.createSteppedForm(
      id: 'wizard',
      title: 'Setup Wizard',
      steps: [
        FormStep(
          title: 'Basic Info',
          icon: Icons.person,
          fields: [
            VooFieldUtils.textField(
              id: 'name',
              name: 'name',
              label: 'Full Name',
              required: true,
            ),
            VooFieldUtils.emailField(
              id: 'email',
              name: 'email',
              required: true,
            ),
          ],
        ),
        FormStep(
          title: 'Preferences',
          icon: Icons.settings,
          fields: [
            VooFieldUtils.dropdownField(
              id: 'language',
              name: 'language',
              label: 'Language',
              initialValue: 'en',
              options: const [
                VooFieldOption(value: 'en', label: 'English'),
                VooFieldOption(value: 'es', label: 'Spanish'),
                VooFieldOption(value: 'fr', label: 'French'),
              ],
            ),
            VooFieldUtils.switchField(
              id: 'notifications',
              name: 'notifications',
              label: 'Enable Notifications',
              helper: 'Get updates about new features',
            ),
            VooFieldUtils.switchField(
              id: 'darkMode',
              name: 'darkMode',
              label: 'Dark Mode',
              helper: 'Use dark theme for the app',
              prefixIcon: Icons.dark_mode,
            ),
          ],
        ),
        FormStep(
          title: 'Complete',
          icon: Icons.check,
          fields: [
            VooFieldUtils.checkboxField(
              id: 'terms',
              name: 'terms',
              label: 'I agree to the terms and conditions',
            ),
            VooFieldUtils.checkboxField(
              id: 'newsletter',
              name: 'newsletter',
              label: 'Subscribe to newsletter',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stepped Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: VooFormBuilder(
        controller: _controller,
        form: _controller.form,
        onSubmit: (values) async {
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Setup completed!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

// Dynamic Form Example
class DynamicFormExample extends StatefulWidget {
  const DynamicFormExample({super.key});

  @override
  State<DynamicFormExample> createState() => _DynamicFormExampleState();
}

class _DynamicFormExampleState extends State<DynamicFormExample> {
  late VooFormController _controller;
  String _selectedType = 'personal';

  @override
  void initState() {
    super.initState();
    _controller = VooFormController(form: _buildDynamicForm());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  VooForm _buildDynamicForm() {
    final fields = <VooFormField>[];
    
    // Always show type selector
    fields.add(
      VooFieldUtils.radioField(
        id: 'account_type',
        name: 'account_type',
        label: 'Account Type',
        initialValue: _selectedType,
        options: const [
          VooFieldOption(value: 'personal', label: 'Personal'),
          VooFieldOption(value: 'business', label: 'Business'),
        ],
      ),
    );
    
    // Add fields based on selected type
    if (_selectedType == 'personal') {
      fields.addAll([
        VooFieldUtils.textField(
          id: 'first_name',
          name: 'first_name',
          label: 'First Name',
          required: true,
        ),
        VooFieldUtils.textField(
          id: 'last_name',
          name: 'last_name',
          label: 'Last Name',
          required: true,
        ),
        VooFieldUtils.dateField(
          id: 'birth_date',
          name: 'birth_date',
          label: 'Date of Birth',
        ),
        VooFieldUtils.switchField(
          id: 'marketing_emails',
          name: 'marketing_emails',
          label: 'Receive Marketing Emails',
          helper: 'Get updates about our latest offers',
        ),
      ]);
    } else {
      fields.addAll([
        VooFieldUtils.textField(
          id: 'company_name',
          name: 'company_name',
          label: 'Company Name',
          required: true,
        ),
        VooFieldUtils.textField(
          id: 'tax_id',
          name: 'tax_id',
          label: 'Tax ID',
          required: true,
        ),
        VooFieldUtils.numberField(
          id: 'employees',
          name: 'employees',
          label: 'Number of Employees',
          min: 1,
        ),
        VooFieldUtils.switchField(
          id: 'enterprise_features',
          name: 'enterprise_features',
          label: 'Enterprise Features',
          helper: 'Enable advanced business features',
          prefixIcon: Icons.business,
        ),
      ]);
    }
    
    return VooFormUtils.createForm(
      id: 'dynamic',
      title: 'Dynamic Form',
      fields: fields,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final accountType = _controller.getValue('account_type') as String?;
          if (accountType != null && accountType != _selectedType) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedType = accountType;
                _controller.updateForm(_buildDynamicForm());
              });
            });
          }
          
          return VooFormBuilder(
            controller: _controller,
            form: _controller.form,
            onSubmit: (values) async {
              await Future.delayed(const Duration(seconds: 1));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_selectedType account created!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Validation Example
class ValidationExample extends StatefulWidget {
  const ValidationExample({super.key});

  @override
  State<ValidationExample> createState() => _ValidationExampleState();
}

class _ValidationExampleState extends State<ValidationExample> {
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
    return VooFormUtils.createForm(
      id: 'validation',
      title: 'Validation Examples',
      validationMode: FormValidationMode.onChange,
      fields: [
        VooFormField<String>(
          id: 'custom_email',
          name: 'custom_email',
          label: 'Corporate Email',
          type: VooFieldType.email,
          helper: 'Must be a company email address',
          validators: [
            VooValidator.required(),
            VooValidator.email(),
            VooValidator.custom(
              validator: (value) {
                if (value != null && !value.contains('@company.com')) {
                  return 'Must be a @company.com email address';
                }
                return null;
              },
            ),
          ],
        ),
        VooFormField<String>(
          id: 'credit_card',
          name: 'credit_card',
          label: 'Credit Card',
          type: VooFieldType.text,
          inputFormatters: [VooFormatters.creditCard()],
          validators: [
            VooValidator.required(),
            VooValidator.creditCard(),
          ],
        ),
        VooFormField<String>(
          id: 'strong_password',
          name: 'strong_password',
          label: 'Strong Password',
          type: VooFieldType.password,
          helper: 'Must contain uppercase, lowercase, number, and special character',
          validators: [
            VooValidator.required(),
            VooValidator.minLength(8),
            VooValidator.pattern(
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
              'Password must contain uppercase, lowercase, number, and special character',
            ),
          ],
        ),
        VooFormField<num>(
          id: 'age',
          name: 'age',
          label: 'Age',
          type: VooFieldType.number,
          validators: [
            VooValidator.required(),
            VooValidator.min(18, 'Must be at least 18 years old'),
            VooValidator.max(120, 'Invalid age'),
          ],
        ),
        VooFormField<String>(
          id: 'username',
          name: 'username',
          label: 'Username',
          type: VooFieldType.text,
          helper: 'Alphanumeric with underscores, 3-15 characters',
          validators: [
            VooValidator.required(),
            VooValidator.pattern(
              r'^[a-zA-Z0-9_]{3,15}$',
              'Username must be 3-15 characters, alphanumeric with underscores',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: VooFormBuilder(
        controller: _controller,
        form: _controller.form,
        onSubmit: (values) async {
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All validations passed!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

// Headers Example
class HeadersExample extends StatefulWidget {
  const HeadersExample({super.key});

  @override
  State<HeadersExample> createState() => _HeadersExampleState();
}

class _HeadersExampleState extends State<HeadersExample> {
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
      id: 'headers',
      title: 'Form with Headers',
      sections: const [
        VooFormSection(
          id: 'large',
          fieldIds: ['field1', 'switch1'],
          header: VooFormHeader(
            id: 'large_header',
            title: 'Large Header Style',
            subtitle: 'This is a large prominent header',
            style: HeaderStyle.large,
            icon: Icons.star,
            showDivider: true,
          ),
        ),
        VooFormSection(
          id: 'card',
          fieldIds: ['field2', 'switch2'],
          header: VooFormHeader(
            id: 'card_header',
            title: 'Card Style Header',
            subtitle: 'With custom background',
            style: HeaderStyle.card,
            icon: Icons.credit_card,
          ),
        ),
        VooFormSection(
          id: 'banner',
          fieldIds: ['field3', 'switch3'],
          header: VooFormHeader(
            id: 'banner_header',
            title: 'Banner Style',
            description: 'This header style is perfect for important sections',
            style: HeaderStyle.banner,
            padding: EdgeInsets.all(20),
          ),
        ),
        VooFormSection(
          id: 'chip',
          fieldIds: ['field4'],
          header: VooFormHeader(
            id: 'chip_header',
            title: 'Chip Style',
            style: HeaderStyle.chip,
            alignment: HeaderAlignment.center,
          ),
        ),
      ],
      fields: [
        VooFieldUtils.textField(
          id: 'field1',
          name: 'field1',
          label: 'Field under large header',
        ),
        VooFieldUtils.switchField(
          id: 'switch1',
          name: 'switch1',
          label: 'Enable Feature',
          helper: 'Toggle this to enable the feature',
        ),
        VooFieldUtils.textField(
          id: 'field2',
          name: 'field2',
          label: 'Field under card header',
        ),
        VooFieldUtils.switchField(
          id: 'switch2',
          name: 'switch2',
          label: 'Enable Notifications',
          prefixIcon: Icons.notifications,
        ),
        VooFieldUtils.textField(
          id: 'field3',
          name: 'field3',
          label: 'Field under banner header',
        ),
        VooFieldUtils.switchField(
          id: 'switch3',
          name: 'switch3',
          label: 'Advanced Settings',
          helper: 'Enable advanced configuration options',
          prefixIcon: Icons.settings_applications,
        ),
        VooFieldUtils.textField(
          id: 'field4',
          name: 'field4',
          label: 'Field under chip header',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headers Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: VooFormBuilder(
        controller: _controller,
        form: _controller.form,
        showProgress: false,
        onSubmit: (values) async {
          debugPrint('Form submitted');
        },
      ),
    );
  }
}