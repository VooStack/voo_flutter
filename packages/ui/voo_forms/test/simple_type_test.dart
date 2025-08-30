// Simple test to verify the type error is fixed
// The original error was: TypeError: Instance of '(String?) => void': type '(String?) => void' is not a subtype of type '((dynamic) => void)?'

import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  // This code should compile without type errors
  final textField = VooField.text(
    name: 'site_name',
    label: 'Site Name',
    prefixIcon: Icons.home,
    onChanged: (String? value) {
      // This typed callback should work without errors
      // print('Site name changed to: $value');
    },
  );

  final dropdown = VooField.dropdown<USState>(
    name: 'site_state',
    label: 'Site State',
    options: USState.values,
    validators: [VooValidator.required()],
    prefixIcon: Icons.map,
    converter: (USState state) => VooDropdownChild(
      label: state.displayName,
      value: state,
    ),
    onChanged: (USState? value) {
      // This typed callback should work without errors
      // print('State changed to: $value');
    },
  );

  final dateField = VooField.date(
    name: 'order_date',
    label: 'Order Date',
    prefixIcon: Icons.calendar_today,
    onChanged: (DateTime? value) {
      // This typed callback should work without errors
      // print('Date changed to: $value');
    },
  );

  // Create a widget that uses these fields
  final widget = MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          VooFieldWidget(field: textField),
          VooFieldWidget(field: dropdown),
          VooFieldWidget(field: dateField),
        ],
      ),
    ),
  );

  // print('Type test completed successfully - no type errors!');
}

// Sample enum for testing
enum USState {
  ny('NY', 'New York'),
  ca('CA', 'California'),
  tx('TX', 'Texas');

  final String code;
  final String displayName;
  
  const USState(this.code, this.displayName);
}