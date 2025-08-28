# VooForms

A comprehensive cross-platform forms package with atomic design, clean architecture, and Material 3 support for Flutter applications.

## Features

- 🎨 **Atomic Design Pattern** - Components organized as atoms, molecules, and organisms
- 🏛️ **Clean Architecture** - Clear separation of concerns with domain, data, and presentation layers
- 📱 **Cross-Platform** - Works seamlessly on iOS, Android, Web, Desktop
- 🎯 **Type-Safe** - Full type safety with generics support
- 🎨 **Material 3** - Built with the latest Material Design guidelines
- 📐 **Responsive** - Adapts to all screen sizes automatically
- ✅ **Built-in Validators** - Comprehensive validation rules out of the box
- 🔧 **Custom Formatters** - Phone, credit card, date, currency, and more
- 🎮 **Form Controller** - Powerful state management for forms
- 🌈 **Highly Customizable** - Theming, layouts, and custom field types

## Installation

Add `voo_forms` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_forms:
    path: ../voo_forms  # Or use published version when available
```

## Quick Start

### Simple Form Example

```dart
import 'package:voo_forms/voo_forms.dart';
import 'package:flutter/material.dart';

// Define your form
final loginForm = VooForm(
  id: 'login',
  title: 'Sign In',
  fields: [
    VooFormField<String>(
      id: 'email',
      name: 'email',
      label: 'Email',
      type: VooFieldType.email,
      required: true,
      validators: [
        VooValidator.required(),
        VooValidator.email(),
      ],
    ),
    VooFormField<String>(
      id: 'password',
      name: 'password',
      label: 'Password',
      type: VooFieldType.password,
      required: true,
      validators: [
        VooValidator.required(),
        VooValidator.minLength(8),
      ],
    ),
  ],
);

// Use the form in your widget
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VooFormWidget(
        form: loginForm,
        onSubmit: (values) async {
          // Handle form submission
          print('Email: ${values['email']}');
          print('Password: ${values['password']}');
        },
        onSuccess: () {
          // Handle success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );
        },
        onError: (error) {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: $error')),
          );
        },
      ),
    );
  }
}
```

### Using Form Controller

```dart
class AdvancedForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final form = VooForm(
      id: 'registration',
      fields: [
        VooFormField<String>(
          id: 'username',
          name: 'username',
          label: 'Username',
          type: VooFieldType.text,
          validators: [
            VooValidator.required(),
            VooValidator.alphanumeric(),
            VooValidator.minLength(3),
          ],
        ),
        VooFormField<String>(
          id: 'phone',
          name: 'phone',
          label: 'Phone Number',
          type: VooFieldType.phone,
          inputFormatters: [VooFormatters.phoneUS()],
          validators: [
            VooValidator.required(),
            VooValidator.phone(),
          ],
        ),
      ],
    );

    final controller = useVooFormController(form);

    return VooFormBuilder(
      form: form,
      controller: controller,
      builder: (context, controller) {
        return Column(
          children: [
            // Access field values
            Text('Username: ${controller.getValue('username') ?? 'Not set'}'),
            
            // Custom field rendering
            VooFormFieldBuilder(
              field: form.fields[0],
              controller: controller,
            ),
            
            // Custom submit button
            ElevatedButton(
              onPressed: controller.isValid
                  ? () async {
                      if (controller.validate()) {
                        // Submit form
                        final values = controller.toJson();
                        print('Form data: $values');
                      }
                    }
                  : null,
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
```

## Field Types

VooForms supports a wide range of field types:

- `text` - Single line text input
- `multiline` - Multi-line text input
- `number` - Numeric input
- `email` - Email input with validation
- `password` - Password input with obscured text
- `phone` - Phone number input
- `url` - URL input
- `date` - Date picker
- `time` - Time picker
- `dateTime` - Date and time picker
- `boolean` - Checkbox
- `checkbox` - Checkbox with label
- `dropdown` - Dropdown selection
- `radio` - Radio button group
- `multiSelect` - Multiple selection
- `slider` - Numeric slider
- `file` - File upload
- `color` - Color picker
- `rating` - Star rating
- `custom` - Custom field type

## Validators

Built-in validators for common use cases:

```dart
// Required field
VooValidator.required('This field is required')

// Email validation
VooValidator.email()

// Phone number
VooValidator.phone()

// URL
VooValidator.url()

// Length validators
VooValidator.minLength(3)
VooValidator.maxLength(50)
VooValidator.lengthRange(3, 50)

// Numeric validators
VooValidator.min(0)
VooValidator.max(100)
VooValidator.range(0, 100)

// Pattern matching
VooValidator.pattern(r'^[A-Z]{2}\d{4}$', 'Invalid format')

// Password strength
VooValidator.password(
  minLength: 8,
  requireUppercase: true,
  requireNumbers: true,
)

// Credit card
VooValidator.creditCard()

// Custom validation
VooValidator.custom(
  validator: (value) {
    if (value == 'admin') {
      return 'Username not available';
    }
    return null;
  },
)

// Combine validators
VooValidator.all([
  VooValidator.required(),
  VooValidator.email(),
])
```

## Formatters

Text input formatters for better UX:

```dart
// Phone number (US format)
VooFormatters.phoneUS() // (123) 456-7890

// Credit card
VooFormatters.creditCard() // 1234 5678 9012 3456

// Date formatters
VooFormatters.dateUS() // MM/DD/YYYY
VooFormatters.dateEU() // DD/MM/YYYY
VooFormatters.dateISO() // YYYY-MM-DD

// Currency
VooFormatters.currency(
  symbol: '\$',
  decimalPlaces: 2,
)

// Case formatters
VooFormatters.uppercase()
VooFormatters.lowercase()

// Filter inputs
VooFormatters.alphanumeric()
VooFormatters.lettersOnly()
VooFormatters.numbersOnly()
VooFormatters.decimal(decimalPlaces: 2)

// SSN
VooFormatters.ssn() // 123-45-6789

// ZIP code
VooFormatters.zipCode() // 12345 or 12345-6789

// Custom mask
VooFormatters.mask('###-##-####') // For SSN
```

## Form Layouts

VooForms supports multiple layout options:

```dart
// Vertical layout (default)
VooForm(
  layout: FormLayout.vertical,
  // ...
)

// Horizontal layout
VooForm(
  layout: FormLayout.horizontal,
  // ...
)

// Grid layout
VooForm(
  layout: FormLayout.grid,
  // ...
)

// Stepped layout (wizard)
VooForm(
  layout: FormLayout.stepped,
  // ...
)

// Tabbed layout
VooForm(
  layout: FormLayout.tabbed,
  // ...
)
```

## Form Sections

Group related fields into sections:

```dart
final form = VooForm(
  id: 'user-profile',
  sections: [
    VooFormSection(
      id: 'personal',
      title: 'Personal Information',
      icon: Icons.person,
      fieldIds: ['firstName', 'lastName', 'email'],
      collapsible: true,
    ),
    VooFormSection(
      id: 'address',
      title: 'Address',
      icon: Icons.location_on,
      fieldIds: ['street', 'city', 'zipCode'],
      collapsible: true,
      collapsed: true, // Start collapsed
    ),
  ],
  fields: [
    // Define fields...
  ],
);
```

## Responsive Design

VooForms automatically adapts to different screen sizes:

```dart
VooFormField(
  // ...
  gridColumns: 2, // Span 2 columns in grid layout
)
```

## Custom Field Types

Create custom field types:

```dart
VooFormField(
  type: VooFieldType.custom,
  customBuilder: (context, field) {
    return MyCustomWidget(
      value: field.value,
      onChanged: field.onChanged,
    );
  },
)
```

## Form Controller API

The form controller provides powerful form management:

```dart
final controller = VooFormController(form: myForm);

// Get/set values
controller.setValue('email', 'user@example.com');
final email = controller.getValue('email');

// Validation
controller.validateField('email');
controller.validateAll();
final isValid = controller.isValid;

// Form state
controller.reset(); // Reset to initial values
controller.clear(); // Clear all values
controller.clearErrors(); // Clear all errors

// Field management
controller.enableField('email');
controller.disableField('password');
controller.showField('optional');
controller.hideField('advanced');

// Navigation
controller.focusField('email');
controller.focusNextField('email');

// Submission
await controller.submit(
  onSubmit: (values) async {
    // API call
  },
  onSuccess: () {
    // Handle success
  },
  onError: (error) {
    // Handle error
  },
);
```

## Theming

VooForms respects your app's Material theme and works with VooUI design system:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  ),
  home: VooDesignSystem(
    data: VooDesignSystemData.comfortable,
    child: MyApp(),
  ),
)
```

## License

MIT