import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_forms/voo_forms.dart';

class Country {
  final String code;
  final String name;
  final String flag;
  final int population;

  const Country({
    required this.code,
    required this.name,
    required this.flag,
    required this.population,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

const countries = [
  Country(
    code: 'US',
    name: 'United States',
    flag: '🇺🇸',
    population: 331900000,
  ),
  Country(
    code: 'CA',
    name: 'Canada',
    flag: '🇨🇦',
    population: 38250000,
  ),
  Country(
    code: 'MX',
    name: 'Mexico',
    flag: '🇲🇽',
    population: 128900000,
  ),
  Country(
    code: 'GB',
    name: 'United Kingdom',
    flag: '🇬🇧',
    population: 67500000,
  ),
  Country(
    code: 'DE',
    name: 'Germany',
    flag: '🇩🇪',
    population: 83200000,
  ),
  Country(
    code: 'FR',
    name: 'France',
    flag: '🇫🇷',
    population: 67400000,
  ),
  Country(
    code: 'JP',
    name: 'Japan',
    flag: '🇯🇵',
    population: 125800000,
  ),
  Country(
    code: 'AU',
    name: 'Australia',
    flag: '🇦🇺',
    population: 25700000,
  ),
];

@Preview(name: 'VooFormBuilder')
Widget formPreview() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.blue.shade50,
          Colors.purple.shade50,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: VooFormBuilder(
            header: const Text(
              'Create Your Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            footer: const Text(
              'By signing up, you agree to our Terms of Service and Privacy Policy.',
            ),
            form: VooForm(
              id: 'user_registration',
              fields: [
                VooField.text(
                  name: 'name',
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  required: true,
                ),
                VooField.email(
                  name: 'email',
                  label: 'Email Address',
                  hint: 'your.email@example.com',
                  prefixIcon: Icons.email_outlined,
                  required: true,
                ),
                VooField.password(
                  name: 'password',
                  label: 'Password',
                  hint: 'Choose a strong password',
                  prefixIcon: Icons.lock_outline,
                  helper: 'Must be at least 8 characters',
                  required: true,
                ),
                VooField.phone(
                  name: 'phone',
                  label: 'Phone Number',
                  hint: '+1 (555) 123-4567',
                  prefixIcon: Icons.phone_outlined,
                ),
                VooField.date(
                  name: 'birthdate',
                  label: 'Date of Birth',
                  prefixIcon: Icons.cake_outlined,
                ),
                VooField.dropdown<Country>(
                  name: 'country',
                  label: 'Country',
                  prefixIcon: Icons.public,
                  options: countries,
                  converter: (country) => VooDropdownChild(
                    value: country,
                    label: '${country.flag} ${country.name}',
                    subtitle:
                        'Population: ${(country.population / 1000000).toStringAsFixed(1)}M',
                  ),
                  initialValue: countries.first,
                ),
                VooField.slider(
                  name: 'experience',
                  label: 'Years of Experience',
                  min: 0,
                  max: 20,
                  initialValue: 5,
                ),
                VooField.radio(
                  name: 'gender',
                  label: 'Gender',
                  options: ['Male', 'Female', 'Other', 'Prefer not to say'],
                ),
                VooField.checkbox(
                  name: 'subscribe',
                  label: 'Subscribe to our newsletter',
                  helper: 'Get weekly updates and exclusive offers',
                  initialValue: false,
                ),
                VooField.checkbox(
                  name: 'terms',
                  label: 'I agree to the Terms and Conditions',
                  required: true,
                ),
              ],
            ),
            onSubmit: (values) {},
            onCancel: () {},
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'VooSimpleForm - Full Screen')
Widget largeFormPreview() {
  return VooFormBuilder(
    defaultConfig: const VooFormConfig(
      labelPosition: LabelPosition.above,
      fieldVariant: FieldVariant.outlined,
      showFieldIcons: true,
      showRequiredIndicator: true,
      fieldSpacing: 20.0,
      sectionSpacing: 30.0,
    ),
    header: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Your Account',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in your information to get started',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
      ],
    ),
    footer: const Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Text(
        'By signing up, you agree to our Terms of Service and Privacy Policy.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    ),
    form: VooForm(
      layout: FormLayout.grid,
      id: 'user_registration',
      fields: [
        VooField.text(
          name: 'firstName',
          label: 'First Name',
          hint: 'Enter your first name',
          prefixIcon: Icons.person_outline,
          required: true,
          gridColumns: 1,
        ),
        VooField.text(
          name: 'lastName',
          label: 'Last Name',
          hint: 'Enter your last name',
          prefixIcon: Icons.person_outline,
          required: true,
          gridColumns: 1,
        ),
        VooField.email(
          name: 'email',
          label: 'Email Address',
          hint: 'your.email@example.com',
          prefixIcon: Icons.email_outlined,
          required: true,
          gridColumns: 2,
        ),
        VooField.password(
          name: 'password',
          label: 'Password',
          hint: 'Choose a strong password',
          prefixIcon: Icons.lock_outline,
          helper: 'Must be at least 8 characters',
          required: true,
          gridColumns: 1,
        ),
        VooField.password(
          name: 'confirmPassword',
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          prefixIcon: Icons.lock_outline,
          required: true,
          gridColumns: 1,
        ),
        VooField.phone(
          name: 'phone',
          label: 'Phone Number',
          hint: '+1 (555) 123-4567',
          prefixIcon: Icons.phone_outlined,
          gridColumns: 1,
        ),
        VooField.date(
          name: 'birthdate',
          label: 'Date of Birth',
          prefixIcon: Icons.cake_outlined,
          gridColumns: 1,
        ),
        VooField.dropdown<Country>(
          name: 'country',
          label: 'Country',
          prefixIcon: Icons.public,
          options: countries,
          converter: (country) => VooDropdownChild(
            value: country,
            label: '${country.flag} ${country.name}',
            subtitle:
                'Population: ${(country.population / 1000000).toStringAsFixed(1)}M',
          ),
          initialValue: countries.first,
        ),
        VooField.slider(
          name: 'experience',
          label: 'Years of Experience',
          min: 0,
          max: 20,
          initialValue: 5,
        ),
        VooField.radio(
          name: 'gender',
          label: 'Gender',
          options: ['Male', 'Female', 'Other', 'Prefer not to say'],
        ),
        VooField.checkbox(
          name: 'subscribe',
          label: 'Subscribe to our newsletter',
          helper: 'Get weekly updates and exclusive offers',
          initialValue: false,
        ),
        VooField.checkbox(
          name: 'terms',
          label: 'I agree to the Terms and Conditions',
          required: true,
        ),
      ],
    ),
    onSubmit: (values) {},
    onCancel: () {},
  );
}
