import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  runApp(const EnhancedFormExampleApp());
}

class EnhancedFormExampleApp extends StatelessWidget {
  const EnhancedFormExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced VooForm Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EnhancedFormExamplePage(),
    );
  }
}

class EnhancedFormExamplePage extends StatefulWidget {
  const EnhancedFormExamplePage({super.key});

  @override
  State<EnhancedFormExamplePage> createState() => _EnhancedFormExamplePageState();
}

class _EnhancedFormExamplePageState extends State<EnhancedFormExamplePage> {
  int _selectedExample = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced VooForm Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Side navigation
          NavigationRail(
            selectedIndex: _selectedExample,
            onDestinationSelected: (index) {
              setState(() {
                _selectedExample = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle),
                label: Text('Registration'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text('Order Form'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.contact_mail_outlined),
                selectedIcon: Icon(Icons.contact_mail),
                label: Text('Contact'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Form content
          Expanded(
            child: _buildExample(_selectedExample),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(int index) {
    switch (index) {
      case 0:
        return _buildRegistrationForm();
      case 1:
        return _buildOrderForm();
      case 2:
        return _buildSettingsForm();
      case 3:
        return _buildContactForm();
      default:
        return _buildRegistrationForm();
    }
  }

  Widget _buildRegistrationForm() {
    final form = VooForm(
      id: 'registration',
      title: 'Create Your Account',
      description: 'Register with your @globalzoning.com email',
      layout: FormLayout.vertical,
      fields: [
        VooFormField(
          id: 'firstName',
          name: 'firstName',
          label: 'First Name',
          type: VooFieldType.text,
          required: true,
          prefixIcon: Icons.person_outline,
          gridColumns: 2,
          validators: [
            MinLengthValidator(2, 'Name must be at least 2 characters'),
          ],
        ),
        VooFormField(
          id: 'middleInitial',
          name: 'middleInitial',
          label: 'M.I.',
          type: VooFieldType.text,
          maxLength: 1,
          gridColumns: 1,
        ),
        VooFormField(
          id: 'lastName',
          name: 'lastName',
          label: 'Last Name',
          type: VooFieldType.text,
          required: true,
          gridColumns: 2,
          validators: [
            MinLengthValidator(2, 'Name must be at least 2 characters'),
          ],
        ),
        VooFormField(
          id: 'username',
          name: 'username',
          label: 'Username',
          type: VooFieldType.text,
          required: true,
          prefixIcon: Icons.alternate_email,
          validators: [
            MinLengthValidator(3, 'Username must be at least 3 characters'),
            PatternValidator(r'^[a-zA-Z0-9_]+$', 'Username can only contain letters, numbers, and underscores'),
          ],
        ),
        VooFormField(
          id: 'email',
          name: 'email',
          label: 'Corporate Email',
          type: VooFieldType.email,
          required: true,
          prefixIcon: Icons.email_outlined,
          validators: [
            EmailValidator('Please enter a valid email'),
            PatternValidator(r'@globalzoning\.com$', 'Must be a @globalzoning.com email'),
          ],
        ),
        VooFormField(
          id: 'password',
          name: 'password',
          label: 'Password',
          hint: 'Create a strong password',
          type: VooFieldType.password,
          required: true,
          prefixIcon: Icons.lock_outline,
          validators: [
            MinLengthValidator(8, 'Password must be at least 8 characters'),
            PatternValidator(r'(?=.*[A-Z])', 'Password must contain at least one uppercase letter'),
            PatternValidator(r'(?=.*[0-9])', 'Password must contain at least one number'),
          ],
        ),
        VooFormField(
          id: 'confirmPassword',
          name: 'confirmPassword',
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          type: VooFieldType.password,
          required: true,
          prefixIcon: Icons.lock_outline,
        ),
        VooFormField(
          id: 'terms',
          name: 'terms',
          label: 'I agree to the Terms of Service and Privacy Policy',
          type: VooFieldType.checkbox,
          required: true,
        ),
      ],
    );

    final fieldGroups = [
      const FieldGroup(
        title: 'Name',
        fieldIds: ['firstName', 'middleInitial', 'lastName'],
        columns: 5, // 2 + 1 + 2 = 5 columns total
      ),
      const FieldGroup(
        title: 'Account Information',
        fieldIds: ['username', 'email'],
        columns: 1,
      ),
      const FieldGroup(
        title: 'Security',
        fieldIds: ['password', 'confirmPassword'],
        columns: 1,
      ),
      const FieldGroup(
        fieldIds: ['terms'],
        columns: 1,
      ),
    ];

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: VooFormWidget(
          form: form,
          config: VooFormConfig.desktop().copyWith(
            labelPosition: LabelPosition.above,
            fieldVariant: FieldVariant.outlined,
            fieldSize: FieldSize.medium,
            maxFormWidth: 500,
            showRequiredIndicator: true,
            submitButtonPosition: ButtonPosition.bottomCenter,
            backgroundColor: Theme.of(context).colorScheme.surface,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(32.0),
          ),
          fieldGroups: fieldGroups,
          submitButtonText: 'Create Account',
          submitButtonIcon: const Icon(Icons.arrow_forward),
          footer: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {},
                child: const Text('Already have an account? Sign In'),
              ),
            ),
          ),
          onSubmit: (values) async {
            await Future.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful!')),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderForm() {
    final form = VooForm(
      id: 'order',
      title: 'Create New Order',
      layout: FormLayout.grid,
      fields: [
        VooFormField(
          id: 'customerName',
          name: 'customerName',
          label: 'Customer Name',
          type: VooFieldType.text,
          required: true,
          prefixIcon: Icons.person_outline,
        ),
        VooFormField(
          id: 'company',
          name: 'company',
          label: 'Company',
          type: VooFieldType.text,
          prefixIcon: Icons.business,
        ),
        VooFormField(
          id: 'orderType',
          name: 'orderType',
          label: 'Order Type',
          type: VooFieldType.dropdown,
          required: true,
          prefixIcon: Icons.category_outlined,
          options: [
            VooFieldOption(value: 'standard', label: 'Standard'),
            VooFieldOption(value: 'express', label: 'Express'),
            VooFieldOption(value: 'priority', label: 'Priority'),
          ],
        ),
        VooFormField(
          id: 'deliveryDate',
          name: 'deliveryDate',
          label: 'Delivery Date',
          type: VooFieldType.date,
          required: true,
          prefixIcon: Icons.calendar_today,
        ),
        VooFormField(
          id: 'shippingAddress',
          name: 'shippingAddress',
          label: 'Shipping Address',
          type: VooFieldType.multiline,
          required: true,
          prefixIcon: Icons.location_on_outlined,
          maxLines: 3,
          gridColumns: 2,
        ),
        VooFormField(
          id: 'notes',
          name: 'notes',
          label: 'Special Instructions',
          type: VooFieldType.multiline,
          prefixIcon: Icons.note_outlined,
          maxLines: 3,
          gridColumns: 2,
        ),
        VooFormField(
          id: 'attachment',
          name: 'attachment',
          label: 'Attach File',
          type: VooFieldType.file,
          prefixIcon: Icons.attach_file,
        ),
      ],
    );

    return VooFormWidget(
      form: form,
      config: const VooFormConfig(
        labelPosition: LabelPosition.above,
        fieldVariant: FieldVariant.outlined,
        fieldSize: FieldSize.medium,
        gridColumns: ResponsiveColumns(
          mobile: 1,
          tablet: 2,
          desktop: 2,
        ),
        centerOnLargeScreens: false,
        padding: EdgeInsets.all(24.0),
      ),
      submitButtonText: 'Submit Order',
      onSubmit: (values) async {
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order submitted successfully!')),
          );
        }
      },
    );
  }

  Widget _buildSettingsForm() {
    final form = VooForm(
      id: 'settings',
      title: 'Account Settings',
      layout: FormLayout.vertical,
      fields: [
        VooFormField(
          id: 'displayName',
          name: 'displayName',
          label: 'Display Name',
          type: VooFieldType.text,
          prefixIcon: Icons.badge_outlined,
        ),
        VooFormField(
          id: 'bio',
          name: 'bio',
          label: 'Bio',
          type: VooFieldType.multiline,
          maxLines: 4,
          prefixIcon: Icons.info_outline,
        ),
        VooFormField(
          id: 'notifications',
          name: 'notifications',
          label: 'Enable notifications',
          type: VooFieldType.boolean,
        ),
        VooFormField(
          id: 'emailUpdates',
          name: 'emailUpdates',
          label: 'Receive email updates',
          type: VooFieldType.boolean,
        ),
        VooFormField(
          id: 'theme',
          name: 'theme',
          label: 'Theme',
          type: VooFieldType.radio,
          options: [
            VooFieldOption(value: 'light', label: 'Light'),
            VooFieldOption(value: 'dark', label: 'Dark'),
            VooFieldOption(value: 'system', label: 'System'),
          ],
        ),
        VooFormField(
          id: 'language',
          name: 'language',
          label: 'Language',
          type: VooFieldType.dropdown,
          prefixIcon: Icons.language,
          options: [
            VooFieldOption(value: 'en', label: 'English'),
            VooFieldOption(value: 'es', label: 'Spanish'),
            VooFieldOption(value: 'fr', label: 'French'),
            VooFieldOption(value: 'de', label: 'German'),
          ],
        ),
      ],
    );

    final fieldGroups = [
      const FieldGroup(
        title: 'Profile',
        fieldIds: ['displayName', 'bio'],
        columns: 1,
        collapsible: true,
        initiallyExpanded: true,
      ),
      const FieldGroup(
        title: 'Notifications',
        fieldIds: ['notifications', 'emailUpdates'],
        columns: 1,
        collapsible: true,
        initiallyExpanded: true,
      ),
      const FieldGroup(
        title: 'Appearance',
        fieldIds: ['theme', 'language'],
        columns: 1,
        collapsible: true,
        initiallyExpanded: true,
      ),
    ];

    return VooFormWidget(
      form: form,
      config: const VooFormConfig(
        labelPosition: LabelPosition.above,
        fieldVariant: FieldVariant.filled,
        fieldSize: FieldSize.medium,
        maxFormWidth: 600,
        padding: EdgeInsets.all(24.0),
      ),
      fieldGroups: fieldGroups,
      submitButtonText: 'Save Settings',
      onSubmit: (values) async {
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings saved successfully!')),
          );
        }
      },
    );
  }

  Widget _buildContactForm() {
    final form = VooForm(
      id: 'contact',
      title: 'Contact Us',
      description: 'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
      layout: FormLayout.vertical,
      fields: [
        VooFormField(
          id: 'name',
          name: 'name',
          label: 'Your Name',
          type: VooFieldType.text,
          required: true,
          prefixIcon: Icons.person_outline,
        ),
        VooFormField(
          id: 'email',
          name: 'email',
          label: 'Email Address',
          type: VooFieldType.email,
          required: true,
          prefixIcon: Icons.email_outlined,
          validators: [
            EmailValidator('Please enter a valid email'),
          ],
        ),
        VooFormField(
          id: 'subject',
          name: 'subject',
          label: 'Subject',
          type: VooFieldType.text,
          required: true,
          prefixIcon: Icons.subject,
        ),
        VooFormField(
          id: 'message',
          name: 'message',
          label: 'Message',
          type: VooFieldType.multiline,
          required: true,
          maxLines: 6,
          minLines: 4,
          prefixIcon: Icons.message_outlined,
          validators: [
            MinLengthValidator(10, 'Message must be at least 10 characters'),
          ],
        ),
        VooFormField(
          id: 'priority',
          name: 'priority',
          label: 'Priority',
          type: VooFieldType.dropdown,
          prefixIcon: Icons.flag_outlined,
          options: [
            VooFieldOption(value: 'low', label: 'Low'),
            VooFieldOption(value: 'normal', label: 'Normal'),
            VooFieldOption(value: 'high', label: 'High'),
            VooFieldOption(value: 'urgent', label: 'Urgent'),
          ],
        ),
      ],
    );

    return Center(
      child: VooFormWidget(
        form: form,
        config: VooFormConfig(
          labelPosition: LabelPosition.floating,
          fieldVariant: FieldVariant.outlined,
          fieldSize: FieldSize.large,
          maxFormWidth: 600,
          centerOnLargeScreens: true,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        submitButtonText: 'Send Message',
        submitButtonIcon: const Icon(Icons.send),
        onSubmit: (values) async {
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message sent successfully!')),
            );
          }
        },
      ),
    );
  }
}

/// Custom validators for demonstration
class EmailValidator extends VooValidationRule<String> {
  const EmailValidator(String errorMessage) : super(errorMessage: errorMessage);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : errorMessage;
  }
}

class MinLengthValidator extends VooValidationRule<String> {
  final int minLength;
  
  const MinLengthValidator(this.minLength, String errorMessage) : super(errorMessage: errorMessage);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    return value.length >= minLength ? null : errorMessage;
  }
}

class PatternValidator extends VooValidationRule<String> {
  final String pattern;
  
  const PatternValidator(this.pattern, String errorMessage) : super(errorMessage: errorMessage);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(pattern);
    return regex.hasMatch(value) ? null : errorMessage;
  }
}