# VooForms Developer Guide

## 🚀 Quick Start

VooForms provides a powerful, type-safe form building system for Flutter applications with excellent developer experience.

### Simple Example
```dart
import 'package:voo_forms/voo_forms.dart';

// Create a form with various field types
final form = VooForm(
  fields: [
    VooField.text(
      name: 'username',
      label: 'Username',
      validators: [RequiredValidation()],
    ),
    VooField.email(
      name: 'email',
      label: 'Email Address',
      validators: [
        RequiredValidation(),
        EmailValidation(),
      ],
    ),
    VooField.dropdown<String>(
      name: 'country',
      label: 'Country',
      options: [
        VooFieldOption(value: 'us', label: 'United States'),
        VooFieldOption(value: 'uk', label: 'United Kingdom'),
        VooFieldOption(value: 'ca', label: 'Canada'),
      ],
    ),
  ],
  onSubmit: (values) {
    print('Form submitted with: $values');
  },
);
```

## 📦 Architecture

VooForms follows clean architecture principles with clear separation of concerns:

### Layer Structure
```
Presentation Layer (UI/Widgets)
        ↓
    Domain Layer (Entities/Business Logic)
        ↓
     Data Layer (Models/Repositories)
```

### Atomic Design Pattern
Components are organized following atomic design:
- **Atoms**: Basic field widgets (text, checkbox, dropdown)
- **Molecules**: Composed components (field with label, field with error)
- **Organisms**: Complete forms and layouts

## 🎯 Key Features

### 1. Type-Safe Fields
Every field maintains type safety throughout the form lifecycle:
```dart
VooField.number(
  name: 'age',
  label: 'Age',
  onChanged: (int value) { // Type-safe callback
    print('Age changed to: $value');
  },
)
```

### 2. Built-in Validators
Comprehensive validation system with composable validators:
```dart
VooField.text(
  name: 'password',
  validators: [
    RequiredValidation(),
    MinLengthValidation(minLength: 8),
    PatternValidation(
      pattern: r'^(?=.*[A-Z])(?=.*[0-9])',
      errorMessage: 'Must contain uppercase and number',
    ),
  ],
)
```

### 3. Input Formatters
Rich set of formatters for common use cases:
```dart
VooField.text(
  name: 'phone',
  inputFormatters: [VooFormatters.phoneUS()],
  // Automatically formats as (XXX) XXX-XXXX
)

VooField.text(
  name: 'creditCard',
  inputFormatters: [VooFormatters.creditCard()],
  // Formats as XXXX XXXX XXXX XXXX
)
```

### 4. Async Options Loading
Support for dynamic dropdown options:
```dart
VooField.dropdown<City>(
  name: 'city',
  asyncOptionsLoader: (query) async {
    final cities = await api.searchCities(query);
    return cities.map((c) => VooFieldOption(
      value: c,
      label: c.name,
    )).toList();
  },
)
```

## 🛠️ Validators

### Available Validators
- `RequiredValidation` - Field must have a value
- `MinLengthValidation` - Minimum string length
- `MaxLengthValidation` - Maximum string length
- `EmailValidation` - Valid email format
- `PhoneValidation` - Valid phone number
- `UrlValidation` - Valid URL format
- `PatternValidation` - Custom regex pattern
- `MinValueValidation` - Minimum numeric value
- `MaxValueValidation` - Maximum numeric value
- `RangeValidation` - Value within range
- `DateRangeValidation` - Date within range
- `CustomValidation` - Custom validation logic
- `CompoundValidation` - Combine multiple validators

### Custom Validators
```dart
class PasswordMatchValidation extends VooValidationRule<String> {
  final String Function() getPassword;
  
  PasswordMatchValidation({required this.getPassword})
    : super(errorMessage: 'Passwords do not match');
  
  @override
  String? validate(String? value) {
    if (value != getPassword()) {
      return errorMessage;
    }
    return null;
  }
}
```

## 🎨 Formatters

### Available Formatters
- `phoneUS()` - US phone format (XXX) XXX-XXXX
- `phoneInternational()` - International phone format
- `creditCard()` - Credit card XXXX XXXX XXXX XXXX
- `dateUS()` - MM/DD/YYYY
- `dateEU()` - DD/MM/YYYY
- `dateISO()` - YYYY-MM-DD
- `currency()` - Currency with symbol
- `ssn()` - XXX-XX-XXXX
- `zipCode()` - XXXXX or XXXXX-XXXX
- `percentage()` - 0-100%
- `uppercase()` - Convert to uppercase
- `lowercase()` - Convert to lowercase
- `alphanumeric()` - Allow only letters and numbers
- `numbersOnly()` - Allow only numbers
- `decimal()` - Decimal numbers with precision

### Custom Formatters
```dart
class CustomFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Your custom formatting logic
    return newValue;
  }
}
```

## 🎭 Field Options

Customize field appearance and behavior:
```dart
VooField.text(
  name: 'username',
  options: VooFieldOptions(
    labelPosition: LabelPosition.floating,
    fieldVariant: FieldVariant.filled,
    errorDisplayMode: ErrorDisplayMode.always,
    focusBehavior: FocusBehavior.next,
  ),
)
```

### Label Positions
- `floating` - Label floats above field
- `above` - Label fixed above field
- `left` - Label to the left
- `placeholder` - Label as placeholder
- `hidden` - No label

### Field Variants
- `outlined` - Default outlined style
- `filled` - Filled background
- `underlined` - Only bottom border
- `ghost` - No border until focused
- `rounded` - Rounded corners
- `sharp` - Sharp corners

## 🔧 Form Controller

Advanced form control with the controller:
```dart
final controller = VooFormController(
  form: form,
  onFieldChange: (field, value) {
    print('Field ${field.name} changed to $value');
  },
  onValidationChange: (isValid) {
    print('Form is ${isValid ? "valid" : "invalid"}');
  },
);

// Programmatic control
controller.setValue('username', 'john_doe');
controller.validate();
controller.reset();
controller.submit();
```

## 📐 Layouts

Multiple layout options for different use cases:

### Vertical Layout (Default)
```dart
VooFormVerticalLayout(
  fields: fields,
  spacing: 16.0,
)
```

### Grid Layout
```dart
VooFormGridLayout(
  fields: fields,
  columns: 2,
  spacing: 16.0,
  crossAxisSpacing: 12.0,
)
```

### Stepped Layout
```dart
VooFormSteppedLayout(
  steps: [
    VooFormStep(title: 'Personal Info', fields: [...]),
    VooFormStep(title: 'Contact', fields: [...]),
    VooFormStep(title: 'Review', fields: [...]),
  ],
)
```

### Tabbed Layout
```dart
VooFormTabbedLayout(
  tabs: [
    VooFormTab(label: 'Basic', fields: [...]),
    VooFormTab(label: 'Advanced', fields: [...]),
  ],
)
```

## 🧪 Testing

VooForms is designed to be easily testable:

```dart
testWidgets('Form submission test', (tester) async {
  final form = VooForm(
    fields: [
      VooField.text(name: 'username'),
    ],
    onSubmit: expectAsync1((values) {
      expect(values['username'], 'testuser');
    }),
  );
  
  await tester.pumpWidget(MaterialApp(home: form));
  
  // Enter text
  await tester.enterText(
    find.byType(TextFormField),
    'testuser',
  );
  
  // Submit form
  await tester.tap(find.text('Submit'));
  await tester.pump();
});
```

## 💡 Best Practices

1. **Use Type-Safe Fields**: Always specify types for better IDE support
2. **Compose Validators**: Combine validators for complex validation
3. **Leverage Formatters**: Use built-in formatters for common patterns
4. **Handle Errors Gracefully**: Provide clear error messages
5. **Test Form Logic**: Write tests for validation and submission logic
6. **Use Controllers**: For complex forms, use controllers for better control
7. **Optimize Performance**: Use const constructors where possible

## 🚦 Migration from Old Version

If you're upgrading from an older version:

1. **Validators**: Now in separate files but same API
2. **Formatters**: Now in separate files but same API
3. **No Breaking Changes**: Public API remains compatible

## 📚 Additional Resources

- [API Documentation](./api/index.html)
- [Example App](../../apps/voo_example)
- [Test Suite](./test)
- [Changelog](./CHANGELOG.md)

## 🤝 Contributing

Contributions are welcome! Please ensure:
- Follow clean architecture principles
- One class per file
- No _buildXXX methods returning widgets
- Add tests for new features
- Update documentation

## 📄 License

See LICENSE file for details.