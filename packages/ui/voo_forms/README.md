# VooForms

A comprehensive, type-safe forms package for Flutter with clean architecture, atomic design pattern, and excellent developer experience.

[![pub package](https://img.shields.io/pub/v/voo_forms.svg)](https://pub.dev/packages/voo_forms)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- 🎯 **Type-Safe Fields** - Full type safety with generics throughout
- 🏛️ **Clean Architecture** - Follows SOLID principles with clear separation of concerns
- 🎨 **Atomic Design** - Components organized as atoms, molecules, and organisms
- 📱 **Cross-Platform** - Works seamlessly on iOS, Android, Web, Desktop
- 🎨 **Material 3** - Built with the latest Material Design guidelines
- ✅ **Rich Validators** - 13+ built-in validators with composable validation
- 🔧 **Smart Formatters** - 12+ formatters for phone, credit card, currency, etc.
- 🎮 **Powerful Controller** - Advanced form state management
- 📐 **Multiple Layouts** - Vertical, grid, stepped, tabbed layouts
- 🚀 **Excellent DX** - Intuitive API with great IDE support

## 📦 Installation

Add `voo_forms` to your `pubspec.yaml`:

```yaml
dependencies:
  voo_forms: ^0.1.14
```

## 🚀 Quick Start

### Simple Form Example

```dart
import 'package:voo_forms/voo_forms.dart';

// Create a form using the intuitive VooField API
final form = VooForm(
  fields: [
    VooField.text(
      name: 'username',
      label: 'Username',
      validators: [
        RequiredValidation(),
        MinLengthValidation(minLength: 3),
      ],
    ),
    VooField.email(
      name: 'email',
      label: 'Email Address',
      validators: [
        RequiredValidation(),
        EmailValidation(),
      ],
    ),
    VooField.password(
      name: 'password',
      label: 'Password',
      validators: [
        RequiredValidation(),
        MinLengthValidation(minLength: 8),
        PatternValidation(
          pattern: r'^(?=.*[A-Z])(?=.*[0-9])',
          errorMessage: 'Must contain uppercase and number',
        ),
      ],
    ),
  ],
  onSubmit: (values) {
    print('Form submitted: $values');
  },
);
```

### Even Simpler with Extension Method

```dart
// Convert a list of fields directly to a form
final loginForm = [
  VooField.email(name: 'email', label: 'Email'),
  VooField.password(name: 'password', label: 'Password'),
].toForm(
  onSubmit: (values) => print('Login: $values'),
);
```

## 🎨 Field Types

VooForms provides factory constructors for all common field types:

```dart
// Text Fields
VooField.text(name: 'username', label: 'Username')
VooField.email(name: 'email', label: 'Email')
VooField.password(name: 'password', label: 'Password')
VooField.phone(name: 'phone', label: 'Phone')
VooField.url(name: 'website', label: 'Website')
VooField.multiline(name: 'bio', label: 'Bio')
VooField.number(name: 'age', label: 'Age')

// Selection Fields
VooField.dropdown<String>(
  name: 'country',
  label: 'Country',
  options: [
    VooFieldOption(value: 'us', label: 'United States'),
    VooFieldOption(value: 'uk', label: 'United Kingdom'),
  ],
)
VooField.radio<String>(
  name: 'gender',
  label: 'Gender',
  options: [...],
)
VooField.checkbox(name: 'terms', label: 'Accept Terms')
VooField.boolean(name: 'newsletter', label: 'Subscribe')

// Date & Time
VooField.date(name: 'birthday', label: 'Birthday')
VooField.time(name: 'appointment', label: 'Time')

// Other Types
VooField.slider(name: 'rating', label: 'Rating', min: 0, max: 10)
VooField.color(name: 'theme', label: 'Theme Color')
VooField.file(name: 'avatar', label: 'Avatar')
```

## ✅ Validators

### Built-in Validators

Each validator is in its own file for better organization:

```dart
// Basic Validators
RequiredValidation()
EmailValidation()
PhoneValidation()
UrlValidation()

// String Validators
MinLengthValidation(minLength: 3)
MaxLengthValidation(maxLength: 50)
PatternValidation(pattern: r'^[A-Z]', errorMessage: 'Must start with capital')

// Numeric Validators
MinValueValidation(minValue: 0)
MaxValueValidation(maxValue: 100)
RangeValidation(minValue: 0, maxValue: 100)

// Date Validators
DateRangeValidation(
  minDate: DateTime(2020),
  maxDate: DateTime(2030),
)

// Custom Validation
CustomValidation(
  validator: (value) {
    if (value == 'admin') return 'Username not available';
    return null;
  },
)

// Combine Multiple Validators
CompoundValidation(rules: [
  RequiredValidation(),
  EmailValidation(),
])
```

### Creating Custom Validators

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

## 🔧 Formatters

Smart input formatting for better UX:

```dart
// Phone Formatters
VooFormatters.phoneUS()              // (123) 456-7890
VooFormatters.phoneInternational()   // +1 234 567 8900

// Card & Financial
VooFormatters.creditCard()           // 1234 5678 9012 3456
VooFormatters.currency(symbol: '\$') // $1,234.56

// Date Formatters
VooFormatters.dateUS()               // MM/DD/YYYY
VooFormatters.dateEU()               // DD/MM/YYYY
VooFormatters.dateISO()              // YYYY-MM-DD

// Text Formatters
VooFormatters.uppercase()
VooFormatters.lowercase()
VooFormatters.alphanumeric()
VooFormatters.numbersOnly()

// US Specific
VooFormatters.ssn()                  // 123-45-6789
VooFormatters.zipCode()              // 12345 or 12345-6789

// Custom Patterns
VooFormatters.mask('###-##-####')    // Custom mask
VooFormatters.pattern(
  pattern: 'AA-####',
  patternMapping: {
    'A': RegExp(r'[A-Z]'),
    '#': RegExp(r'[0-9]'),
  },
)
```

## 🎭 Field Options

Customize field appearance and behavior:

```dart
VooField.text(
  name: 'username',
  options: VooFieldOptions(
    // Label positioning
    labelPosition: LabelPosition.floating,  // or above, left, placeholder, hidden
    
    // Field styling
    fieldVariant: FieldVariant.filled,     // or outlined, underlined, ghost, rounded, sharp
    
    // Validation behavior
    validateOnChange: true,
    validateOnFocusLost: true,
    
    // Error display
    errorDisplayMode: ErrorDisplayMode.always,  // or onFocus, onSubmit
    
    // Focus behavior
    focusBehavior: FocusBehavior.next,     // or submit, none
  ),
)
```

### Preset Options

Use built-in presets for consistency:

```dart
options: VooFieldOptions.material     // Material Design defaults
options: VooFieldOptions.comfortable  // Spacious layout
options: VooFieldOptions.compact      // Dense layout
options: VooFieldOptions.minimal      // Minimal styling
```

## 🎮 Form Controller

Advanced form control:

```dart
final controller = VooFormController(
  form: form,
  onFieldChange: (field, value) {
    print('${field.name} changed to $value');
  },
  onValidationChange: (isValid) {
    print('Form valid: $isValid');
  },
);

// Programmatic control
controller.setValue('username', 'john_doe');
controller.getValue('username');  // 'john_doe'
controller.validate();            // Validate all fields
controller.validateField('email'); // Validate specific field
controller.reset();               // Reset to initial values
controller.clear();               // Clear all values
controller.submit();              // Submit the form

// Field management
controller.enableField('email');
controller.disableField('password');
controller.showField('optional');
controller.hideField('advanced');
controller.focusField('username');
```

## 📐 Layouts

Multiple layout options:

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

### Stepped Layout (Wizard)
```dart
VooFormSteppedLayout(
  steps: [
    VooFormStep(
      title: 'Personal Info',
      fields: [/* fields */],
    ),
    VooFormStep(
      title: 'Contact',
      fields: [/* fields */],
    ),
  ],
)
```

### Tabbed Layout
```dart
VooFormTabbedLayout(
  tabs: [
    VooFormTab(
      label: 'Basic',
      fields: [/* fields */],
    ),
    VooFormTab(
      label: 'Advanced',
      fields: [/* fields */],
    ),
  ],
)
```

## 🔍 Async Options & Search

Support for dynamic dropdown options:

```dart
// Async dropdown with search
VooField.dropdown<City>(
  name: 'city',
  label: 'City',
  enableSearch: true,
  asyncOptionsLoader: (query) async {
    final cities = await api.searchCities(query);
    return cities.map((city) => VooFieldOption(
      value: city,
      label: city.name,
      subtitle: city.state,
      icon: Icons.location_city,
    )).toList();
  },
)
```

## 🧪 Testing

VooForms is designed for easy testing:

```dart
testWidgets('Form submission', (tester) async {
  final form = VooForm(
    fields: [
      VooField.text(name: 'username'),
      VooField.email(name: 'email'),
    ],
    onSubmit: expectAsync1((values) {
      expect(values['username'], 'testuser');
      expect(values['email'], 'test@example.com');
    }),
  );
  
  await tester.pumpWidget(MaterialApp(home: form));
  
  // Enter values
  await tester.enterText(
    find.byType(TextFormField).first,
    'testuser',
  );
  await tester.enterText(
    find.byType(TextFormField).last,
    'test@example.com',
  );
  
  // Submit
  await tester.tap(find.text('Submit'));
  await tester.pump();
});
```

## 🏛️ Architecture

VooForms follows clean architecture principles:

```
Presentation Layer (UI/Widgets)
        ↓
Domain Layer (Entities/Business Logic)  
        ↓
Data Layer (Models/Repositories)
```

### Atomic Design Pattern
- **Atoms**: Basic input widgets (text field, checkbox, etc.)
- **Molecules**: Composed components (field with label, field with error)
- **Organisms**: Complete forms and layouts

### Key Principles
- **One class per file** - Better organization and navigation
- **No _buildXXX methods** - Using helper classes instead
- **Clean imports** - No relative imports, properly ordered
- **Type safety** - Generics used throughout
- **SOLID principles** - Single responsibility, open/closed, etc.

## 🎨 Theming

VooForms respects your app's Material theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  ),
  home: MyApp(),
)
```

## 📖 Documentation

- [Developer Guide](./DEVELOPER_GUIDE.md) - Comprehensive guide with examples
- [API Documentation](./doc/api/) - Full API reference
- [Example App](../../apps/voo_example) - Complete example implementation
- [Changelog](./CHANGELOG.md) - Version history

## 🤝 Contributing

Contributions welcome! Please ensure:
- Follow clean architecture principles
- One class per file
- No _buildXXX methods returning widgets
- Add tests for new features
- Update documentation

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🚀 What's New in 0.1.14

- **Major Technical Debt Cleanup** - Eliminated all _buildXXX methods
- **Better Organization** - 25+ classes split into individual files
- **Improved DX** - Each validator/formatter in its own file
- **Clean Architecture** - Proper separation of concerns throughout
- **Enhanced Testing** - 92.6% test success rate

See [CHANGELOG.md](CHANGELOG.md) for full details.