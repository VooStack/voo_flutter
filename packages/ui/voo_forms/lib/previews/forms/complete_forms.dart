import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/voo_forms.dart';

// ============================================================================
// Complete form previews showcasing the new VooForm widget
// ============================================================================

@Preview(name: 'User Registration Form')
Widget previewRegistrationForm() => const RegistrationFormPreview();

class RegistrationFormPreview extends StatelessWidget {
  const RegistrationFormPreview({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('User Registration'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VooForm(
            fields: [
              const VooTextField(
                name: 'firstName',
                label: 'First Name',
                placeholder: 'John',
                required: true,
              ),
              const VooTextField(
                name: 'lastName',
                label: 'Last Name',
                placeholder: 'Doe',
                required: true,
              ),
              const VooEmailField(
                name: 'email',
                label: 'Email Address',
                placeholder: 'john.doe@example.com',
                required: true,
              ),
              const VooPasswordField(
                name: 'password',
                label: 'Password',
                helper: 'At least 8 characters',
                required: true,
              ),
              const VooPasswordField(
                name: 'confirmPassword',
                label: 'Confirm Password',
                required: true,
              ),
              const VooPhoneField(
                name: 'phone',
                label: 'Phone Number',
                placeholder: '(555) 123-4567',
              ),
              VooIntegerField(
                name: 'age',
                label: 'Age',
                min: 13,
                max: 120,
                required: true,
              ),
              const VooCheckboxField(
                name: 'terms',
                label: 'I agree to the Terms and Conditions',
                required: true,
              ),
              const VooBooleanField(
                name: 'newsletter',
                label: 'Subscribe to newsletter',
              ),
            ],
            onSubmit: (values) {
              // Validate passwords match
              if (values['password'] != values['confirmPassword']) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registration successful for ${values['email']}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
      );
}

@Preview(name: 'Product Order Form')
Widget previewOrderForm() => const OrderFormPreview();

class OrderFormPreview extends StatefulWidget {
  const OrderFormPreview({super.key});

  @override
  State<OrderFormPreview> createState() => _OrderFormPreviewState();
}

class _OrderFormPreviewState extends State<OrderFormPreview> {
  String? selectedCategory;
  int quantity = 1;
  double unitPrice = 29.99;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Product Order'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VooForm(
            fields: [
              const VooTextField(
                name: 'customerName',
                label: 'Customer Name',
                required: true,
              ),
              const VooEmailField(
                name: 'customerEmail',
                label: 'Email',
                required: true,
              ),
              VooDropdownField<String>(
                name: 'category',
                label: 'Product Category',
                placeholder: 'Select a category',
                options: const ['Electronics', 'Clothing', 'Books', 'Food', 'Other'],
                value: selectedCategory,
                required: true,
                onChanged: (String? value) => setState(() {
                  selectedCategory = value;
                }),
              ),
              const VooTextField(
                name: 'productName',
                label: 'Product Name',
                required: true,
              ),
              VooIntegerField(
                name: 'quantity',
                label: 'Quantity',
                value: quantity,
                min: 1,
                max: 100,
                required: true,
                onChanged: (int? value) => setState(() {
                  quantity = value ?? 1;
                }),
              ),
              VooCurrencyField(
                name: 'unitPrice',
                label: 'Unit Price',
                value: unitPrice,
                max: 10000,
                required: true,
                onChanged: (double? value) => setState(() {
                  unitPrice = value ?? 0;
                }),
              ),
              VooPercentageField(
                name: 'discount',
                label: 'Discount',
                initialValue: 10,
              ),
              const VooMultilineField(
                name: 'notes',
                label: 'Order Notes',
                placeholder: 'Any special instructions...',
                maxLines: 3,
              ),
            ],
            footer: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Quantity: $quantity'),
                  Text('Unit Price: \$${unitPrice.toStringAsFixed(2)}'),
                  Text('Subtotal: \$${(quantity * unitPrice).toStringAsFixed(2)}'),
                  const Divider(),
                  Text(
                    'Total: \$${(quantity * unitPrice * 0.9).toStringAsFixed(2)} (10% discount applied)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            onSubmit: (values) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
      );
}

@Preview(name: 'Contact Form')
Widget previewContactForm() => const ContactFormPreview();

class ContactFormPreview extends StatefulWidget {
  const ContactFormPreview({super.key});

  @override
  State<ContactFormPreview> createState() => _ContactFormPreviewState();
}

class _ContactFormPreviewState extends State<ContactFormPreview> {
  String? selectedSubject;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Contact Us'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VooForm(
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get in Touch',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'We would love to hear from you. Send us a message and we will respond as soon as possible.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
              ],
            ),
            fields: [
              const VooTextField(
                name: 'name',
                label: 'Your Name',
                required: true,
                prefixIcon: Icon(Icons.person),
              ),
              const VooEmailField(
                name: 'email',
                label: 'Email Address',
                required: true,
                prefixIcon: Icon(Icons.email),
              ),
              const VooPhoneField(
                name: 'phone',
                label: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              VooDropdownField<String>(
                name: 'subject',
                label: 'Subject',
                placeholder: 'What is this about?',
                options: const [
                  'General Inquiry',
                  'Technical Support',
                  'Sales Question',
                  'Partnership',
                  'Other',
                ],
                value: selectedSubject,
                required: true,
                onChanged: (String? value) => setState(() {
                  selectedSubject = value;
                }),
              ),
              const VooMultilineField(
                name: 'message',
                label: 'Message',
                placeholder: 'Tell us more...',
                required: true,
                maxLines: 5,
              ),
            ],
            footer: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'We typically respond within 24 hours.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            submitText: 'Send Message',
            showCancelButton: true,
            onSubmit: (values) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message sent successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
}

@Preview(name: 'Employee Information Form')
Widget previewEmployeeForm() => const EmployeeFormPreview();

class EmployeeFormPreview extends StatefulWidget {
  const EmployeeFormPreview({super.key});

  @override
  State<EmployeeFormPreview> createState() => _EmployeeFormPreviewState();
}

class _EmployeeFormPreviewState extends State<EmployeeFormPreview> {
  bool isFullTime = true;
  String? selectedDepartment;
  String? selectedCountry;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Employee Information'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: VooForm(
            spacing: 20,
            fields: [
              // Personal Information Section
              const VooTextField(
                name: 'employeeId',
                label: 'Employee ID',
                placeholder: 'EMP001',
                required: true,
              ),
              const VooTextField(
                name: 'firstName',
                label: 'First Name',
                required: true,
              ),
              const VooTextField(
                name: 'lastName',
                label: 'Last Name',
                required: true,
              ),
              const VooEmailField(
                name: 'workEmail',
                label: 'Work Email',
                required: true,
              ),
              const VooPhoneField(
                name: 'workPhone',
                label: 'Work Phone',
                required: true,
              ),

              // Employment Details Section
              VooDropdownField<String>(
                name: 'department',
                label: 'Department',
                placeholder: 'Select department',
                options: const [
                  'Engineering',
                  'Sales',
                  'Marketing',
                  'Human Resources',
                  'Finance',
                  'Operations',
                ],
                value: selectedDepartment,
                required: true,
                onChanged: (String? value) => setState(() {
                  selectedDepartment = value;
                }),
              ),
              const VooTextField(
                name: 'jobTitle',
                label: 'Job Title',
                required: true,
              ),
              VooBooleanField(
                name: 'fullTime',
                label: 'Full-Time Employee',
                value: isFullTime,
                onChanged: (bool? value) => setState(() {
                  isFullTime = value ?? false;
                }),
              ),
              VooCurrencyField(
                name: 'salary',
                label: 'Annual Salary',
                max: 1000000,
                required: isFullTime,
              ),

              // Address Section
              const VooTextField(
                name: 'street',
                label: 'Street Address',
                required: true,
              ),
              const VooTextField(
                name: 'city',
                label: 'City',
                required: true,
              ),
              const VooTextField(
                name: 'state',
                label: 'State/Province',
                required: true,
              ),
              const VooTextField(
                name: 'zipCode',
                label: 'ZIP/Postal Code',
                required: true,
              ),
              VooDropdownField<String>(
                name: 'country',
                label: 'Country',
                placeholder: 'Select country',
                options: const ['USA', 'Canada', 'Mexico', 'UK', 'Germany', 'France'],
                value: selectedCountry,
                required: true,
                onChanged: (String? value) => setState(() {
                  selectedCountry = value;
                }),
              ),
            ],
            onSubmit: (values) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee information saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
      );
}

@Preview(name: 'Dynamic Form - Editable/ReadOnly')
Widget previewDynamicForm() => const DynamicFormPreview();

class DynamicFormPreview extends StatefulWidget {
  const DynamicFormPreview({super.key});

  @override
  State<DynamicFormPreview> createState() => _DynamicFormPreviewState();
}

class _DynamicFormPreviewState extends State<DynamicFormPreview> {
  bool isEditable = true;
  bool showValidation = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Form'),
          actions: [
            IconButton(
              icon: Icon(isEditable ? Icons.lock_open : Icons.lock),
              onPressed: () => setState(() {
                isEditable = !isEditable;
              }),
            ),
          ],
        ),
        body: Column(
          children: [
            // Controls
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Editable'),
                    subtitle: const Text('Toggle form edit mode'),
                    value: isEditable,
                    onChanged: (bool value) => setState(() {
                      isEditable = value;
                    }),
                  ),
                  SwitchListTile(
                    title: const Text('Show Validation'),
                    subtitle: const Text('Display validation errors'),
                    value: showValidation,
                    onChanged: (bool value) => setState(() {
                      showValidation = value;
                    }),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: VooForm(
                  isEditable: isEditable,
                  showValidationErrors: showValidation,
                  showSubmitButton: isEditable,
                  fields: [
                    VooTextField(
                      name: 'username',
                      label: 'Username',
                      value: isEditable ? null : 'john_doe',
                      required: true,
                      enabled: isEditable,
                    ),
                    VooEmailField(
                      name: 'email',
                      label: 'Email',
                      value: isEditable ? null : 'john@example.com',
                      required: true,
                      enabled: isEditable,
                    ),
                    VooDropdownField<String>(
                      name: 'role',
                      label: 'Role',
                      options: const ['Admin', 'User', 'Guest'],
                      value: isEditable ? null : 'User',
                      required: true,
                      enabled: isEditable,
                    ),
                    VooBooleanField(
                      name: 'active',
                      label: 'Active',
                      value: true,
                      enabled: isEditable,
                    ),
                  ],
                  onSubmit: (values) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form submitted!'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
}
