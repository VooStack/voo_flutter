# VooForms File Architecture

## Overview
VooForms follows the **Atomic Design Pattern** combined with **Clean Architecture** principles to create a scalable, maintainable, and testable forms package.

## Directory Structure

```
voo_forms/
├── lib/
│   ├── src/
│   │   ├── domain/                      # Business Logic Layer
│   │   │   ├── entities/                # Core business objects
│   │   │   │   ├── form_config.dart     # Form configuration entity
│   │   │   │   ├── field_config.dart    # Field configuration entity
│   │   │   │   ├── validation_rule.dart # Validation rules
│   │   │   │   └── field_value.dart     # Field value wrapper
│   │   │   ├── enums/                    # Domain enumerations
│   │   │   │   ├── field_type.dart      # Field type enum
│   │   │   │   ├── validation_type.dart # Validation type enum
│   │   │   │   ├── label_position.dart  # Label positioning
│   │   │   │   └── error_display.dart   # Error display modes
│   │   │   ├── repositories/            # Repository interfaces
│   │   │   │   ├── form_repository.dart # Form data repository
│   │   │   │   └── validation_repository.dart
│   │   │   └── use_cases/               # Business use cases
│   │   │       ├── validate_form.dart   # Form validation logic
│   │   │       ├── submit_form.dart     # Form submission logic
│   │   │       └── reset_form.dart      # Form reset logic
│   │   │
│   │   ├── data/                         # Data Layer
│   │   │   ├── repositories/            # Repository implementations
│   │   │   │   └── form_repository_impl.dart
│   │   │   ├── datasources/             # Data sources
│   │   │   │   ├── local/               # Local data sources
│   │   │   │   └── remote/              # Remote data sources
│   │   │   └── models/                  # Data models
│   │   │       └── form_data_model.dart
│   │   │
│   │   ├── presentation/                # Presentation Layer
│   │   │   ├── state/                   # State management
│   │   │   │   ├── form_state.dart      # Form state definition
│   │   │   │   ├── form_controller.dart # Form controller/bloc
│   │   │   │   └── field_controller.dart # Field-level controller
│   │   │   │
│   │   │   ├── widgets/                 # UI Components (Atomic Design)
│   │   │   │   ├── atoms/               # Basic building blocks
│   │   │   │   │   ├── base/            # Base atomic components
│   │   │   │   │   │   ├── field_label.dart
│   │   │   │   │   │   ├── field_error.dart
│   │   │   │   │   │   ├── field_hint.dart
│   │   │   │   │   │   ├── field_icon.dart
│   │   │   │   │   │   └── field_wrapper.dart
│   │   │   │   │   ├── inputs/          # Input atoms
│   │   │   │   │   │   ├── text_input.dart
│   │   │   │   │   │   ├── number_input.dart
│   │   │   │   │   │   ├── checkbox_input.dart
│   │   │   │   │   │   ├── radio_input.dart
│   │   │   │   │   │   ├── switch_input.dart
│   │   │   │   │   │   ├── slider_input.dart
│   │   │   │   │   │   └── dropdown_trigger.dart
│   │   │   │   │   ├── buttons/         # Button atoms
│   │   │   │   │   │   ├── submit_button.dart
│   │   │   │   │   │   ├── reset_button.dart
│   │   │   │   │   │   ├── cancel_button.dart
│   │   │   │   │   │   └── action_button.dart
│   │   │   │   │   └── feedback/        # Feedback atoms
│   │   │   │   │       ├── loading_indicator.dart
│   │   │   │   │       ├── success_icon.dart
│   │   │   │   │       └── error_icon.dart
│   │   │   │   │
│   │   │   │   ├── molecules/           # Combinations of atoms
│   │   │   │   │   ├── fields/          # Complete field molecules
│   │   │   │   │   │   ├── text_field.dart
│   │   │   │   │   │   ├── number_field.dart
│   │   │   │   │   │   ├── email_field.dart
│   │   │   │   │   │   ├── password_field.dart
│   │   │   │   │   │   ├── phone_field.dart
│   │   │   │   │   │   ├── date_field.dart
│   │   │   │   │   │   ├── time_field.dart
│   │   │   │   │   │   ├── datetime_field.dart
│   │   │   │   │   │   ├── dropdown_field.dart
│   │   │   │   │   │   ├── multi_select_field.dart
│   │   │   │   │   │   ├── checkbox_field.dart
│   │   │   │   │   │   ├── radio_group_field.dart
│   │   │   │   │   │   ├── switch_field.dart
│   │   │   │   │   │   ├── slider_field.dart
│   │   │   │   │   │   ├── file_upload_field.dart
│   │   │   │   │   │   └── list_field.dart
│   │   │   │   │   ├── groups/          # Field grouping molecules
│   │   │   │   │   │   ├── field_group.dart
│   │   │   │   │   │   ├── collapsible_group.dart
│   │   │   │   │   │   └── conditional_group.dart
│   │   │   │   │   ├── sections/        # Form sections
│   │   │   │   │   │   ├── form_section.dart
│   │   │   │   │   │   ├── form_header.dart
│   │   │   │   │   │   ├── form_footer.dart
│   │   │   │   │   │   └── section_divider.dart
│   │   │   │   │   ├── navigation/      # Form navigation
│   │   │   │   │   │   ├── step_indicator.dart
│   │   │   │   │   │   ├── tab_bar.dart
│   │   │   │   │   │   └── progress_bar.dart
│   │   │   │   │   └── actions/         # Action molecules
│   │   │   │   │       ├── form_actions.dart
│   │   │   │   │       ├── field_actions.dart
│   │   │   │   │       └── validation_feedback.dart
│   │   │   │   │
│   │   │   │   └── organisms/           # Complete form components
│   │   │   │       ├── forms/           # Different form types
│   │   │   │       │   ├── simple_form.dart
│   │   │   │       │   ├── stepped_form.dart
│   │   │   │       │   ├── tabbed_form.dart
│   │   │   │       │   ├── wizard_form.dart
│   │   │   │       │   └── dynamic_form.dart
│   │   │   │       ├── layouts/         # Form layouts
│   │   │   │       │   ├── vertical_layout.dart
│   │   │   │       │   ├── horizontal_layout.dart
│   │   │   │       │   ├── grid_layout.dart
│   │   │   │       │   ├── responsive_layout.dart
│   │   │   │       │   └── custom_layout.dart
│   │   │   │       └── builders/        # Form builders
│   │   │   │           ├── form_builder.dart
│   │   │   │           ├── field_builder.dart
│   │   │   │           └── validation_builder.dart
│   │   │   │
│   │   │   ├── pages/                   # Complete pages/screens
│   │   │   │   ├── form_page.dart       # Generic form page
│   │   │   │   └── form_dialog.dart     # Form in dialog
│   │   │   │
│   │   │   └── config/                  # Widget configuration
│   │   │       ├── theme/               # Theme configuration
│   │   │       │   ├── form_theme.dart
│   │   │       │   └── field_theme.dart
│   │   │       └── options/             # Widget options
│   │   │           ├── field_options.dart
│   │   │           └── form_options.dart
│   │   │
│   │   └── utils/                       # Utilities
│   │       ├── validators/              # Validation utilities
│   │       │   ├── email_validator.dart
│   │       │   ├── phone_validator.dart
│   │       │   └── custom_validators.dart
│   │       ├── formatters/              # Input formatters
│   │       │   ├── phone_formatter.dart
│   │       │   ├── currency_formatter.dart
│   │       │   └── strict_number_formatter.dart
│   │       └── helpers/                 # Helper functions
│   │           ├── field_factory.dart
│   │           └── form_helpers.dart
│   │
│   ├── previews/                        # Preview/Demo components
│   │   ├── fields/                      # Field previews
│   │   │   └── field_preview_gallery.dart
│   │   └── forms/                       # Form previews
│   │       └── form_preview_gallery.dart
│   │
│   └── voo_forms.dart                   # Public API barrel export
│
├── example/                             # Example application
│   └── lib/
│       ├── main.dart
│       └── examples/
│           ├── simple_form_example.dart
│           ├── complex_form_example.dart
│           └── custom_form_example.dart
│
└── test/                                # Tests
    ├── atoms/                           # Atom tests
    │   ├── base/
    │   ├── inputs/
    │   └── buttons/
    ├── molecules/                       # Molecule tests
    │   ├── fields/
    │   ├── groups/
    │   └── sections/
    ├── organisms/                       # Organism tests
    │   ├── forms/
    │   └── layouts/
    └── integration/                     # Integration tests
        └── form_workflow_test.dart
```

## Atomic Design Hierarchy

### 1. Atoms (Indivisible Components)
**Location**: `lib/src/presentation/widgets/atoms/`

These are the smallest, most basic building blocks:
- **Base**: Labels, errors, hints, icons, wrappers
- **Inputs**: Raw input elements (text, checkbox, radio, etc.)
- **Buttons**: Individual button components
- **Feedback**: Loading indicators, success/error icons

**Characteristics**:
- Cannot be broken down further
- No business logic
- Pure presentation
- Highly reusable
- Accept only primitive props

### 2. Molecules (Simple Component Groups)
**Location**: `lib/src/presentation/widgets/molecules/`

Combinations of atoms that form functional units:
- **Fields**: Complete form fields with label, input, error
- **Groups**: Collections of related fields
- **Sections**: Logical form sections
- **Navigation**: Step indicators, progress bars
- **Actions**: Button groups with logic

**Characteristics**:
- Composed of 2+ atoms
- Single responsibility
- Minimal business logic
- Context-aware
- Reusable across different forms

### 3. Organisms (Complex Components)
**Location**: `lib/src/presentation/widgets/organisms/`

Complete, self-contained form components:
- **Forms**: Different form types (simple, stepped, wizard)
- **Layouts**: Complete layout systems
- **Builders**: Dynamic form generation

**Characteristics**:
- Composed of molecules and atoms
- Contains business logic
- May manage local state
- Less reusable, more specific
- Handles user interactions

### 4. Pages (Complete Screens)
**Location**: `lib/src/presentation/pages/`

Full screen implementations:
- Complete form pages
- Form dialogs
- Form wizards

**Characteristics**:
- Uses organisms
- Connects to state management
- Handles navigation
- Contains page-specific logic

## State Management Structure

```
State Management/
├── Controllers/
│   ├── FormController       # Main form state controller
│   ├── FieldController      # Individual field controllers
│   └── ValidationController # Validation state management
│
├── State Objects/
│   ├── FormState           # Overall form state
│   ├── FieldState          # Individual field state
│   └── ValidationState     # Validation results
│
└── Events & Actions/
    ├── FormEvents          # Form-level events
    ├── FieldEvents         # Field-level events
    └── ValidationEvents    # Validation triggers
```

## Import Rules

### Allowed Import Directions
```
Pages → Organisms → Molecules → Atoms
Pages → State Management
Organisms → State Management
All Layers → Domain
All Layers → Utils
```

### Forbidden Import Directions
```
Atoms → Molecules/Organisms/Pages
Molecules → Organisms/Pages
Domain → Presentation/Data
```

## File Naming Conventions

### Widgets
- **Atoms**: `{component}_input.dart`, `{component}_label.dart`
- **Molecules**: `{type}_field.dart`, `{component}_group.dart`
- **Organisms**: `{type}_form.dart`, `{type}_layout.dart`
- **Pages**: `{feature}_page.dart`, `{feature}_screen.dart`

### State Management
- **Controllers**: `{feature}_controller.dart`
- **State**: `{feature}_state.dart`
- **Events**: `{feature}_events.dart`

### Domain
- **Entities**: `{entity_name}.dart` (singular)
- **Enums**: `{enum_name}.dart` (singular)
- **Use Cases**: `{action}_{entity}.dart`

## Component Composition Example

```dart
// Atom: field_label.dart
class FieldLabel extends StatelessWidget {...}

// Atom: text_input.dart
class TextInput extends StatelessWidget {...}

// Atom: field_error.dart
class FieldError extends StatelessWidget {...}

// Molecule: text_field.dart
class TextField extends StatelessWidget {
  // Composes: FieldLabel + TextInput + FieldError
}

// Organism: simple_form.dart
class SimpleForm extends StatelessWidget {
  // Composes: Multiple field molecules + form actions
}

// Page: user_registration_page.dart
class UserRegistrationPage extends StatelessWidget {
  // Uses: SimpleForm organism + navigation + state management
}
```

## Testing Strategy

### Unit Tests by Layer
1. **Atoms**: Test rendering and prop handling
2. **Molecules**: Test composition and interactions
3. **Organisms**: Test business logic and state
4. **Integration**: Test complete workflows

### Test Organization
```
test/
├── atoms/          # One test file per atom
├── molecules/      # One test file per molecule
├── organisms/      # One test file per organism
├── state/          # State management tests
├── domain/         # Business logic tests
└── integration/    # End-to-end tests
```

## Migration Path

For existing code migration to atomic structure:

1. **Identify atoms** in existing widgets
2. **Extract atoms** to `atoms/` directory
3. **Refactor molecules** from existing fields
4. **Build organisms** from form components
5. **Update imports** throughout codebase
6. **Add tests** for each level

## Best Practices

### Do's
- ✅ Keep atoms pure and simple
- ✅ Make molecules focused and reusable
- ✅ Let organisms handle complexity
- ✅ Use composition over inheritance
- ✅ Test each level independently
- ✅ Document component APIs
- ✅ Follow single responsibility principle

### Don'ts
- ❌ Don't add business logic to atoms
- ❌ Don't make molecules too complex
- ❌ Don't bypass the hierarchy
- ❌ Don't create circular dependencies
- ❌ Don't mix presentation with domain
- ❌ Don't use relative imports
- ❌ Don't create function widgets

## Component Documentation Template

```dart
/// [ComponentName] - [Atomic Level: Atom|Molecule|Organism]
/// 
/// Purpose: Brief description of component purpose
/// 
/// Composition:
/// - Uses: [List of components this uses]
/// - Used by: [List of components that use this]
/// 
/// Properties:
/// - [prop1]: Description
/// - [prop2]: Description
/// 
/// Example:
/// ```dart
/// ComponentName(
///   prop1: value1,
///   prop2: value2,
/// )
/// ```
class ComponentName extends StatelessWidget {
  // Implementation
}
```