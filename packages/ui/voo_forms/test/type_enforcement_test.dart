import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/voo_field.dart';
import 'package:voo_forms/src/presentation/formatters/strict_number_formatter.dart';

void main() {
  group('Type Enforcement Tests', () {
    group('StrictNumberFormatter', () {
      test('allows valid numbers', () {
        final formatter = StrictNumberFormatter();
        
        // Test valid inputs
        final validInputs = ['123', '123.45', '-123', '-123.45', '0', '0.0'];
        
        for (final input in validInputs) {
          const oldValue = TextEditingValue.empty;
          final newValue = TextEditingValue(text: input);
          final result = formatter.formatEditUpdate(oldValue, newValue);
          
          expect(result.text, equals(input), 
            reason: 'Should allow valid number: $input',);
        }
      });
      
      test('blocks invalid characters', () {
        final formatter = StrictNumberFormatter();
        
        // Test invalid inputs
        final invalidInputs = ['abc', '12a3', '1.2.3', '--123', '123-', '123.45.67'];
        
        for (final input in invalidInputs) {
          const oldValue = TextEditingValue(text: '123');
          final newValue = TextEditingValue(text: input);
          final result = formatter.formatEditUpdate(oldValue, newValue);
          
          expect(result.text, equals('123'), 
            reason: 'Should block invalid input: $input',);
        }
      });
      
      test('respects decimal places limit', () {
        final formatter = StrictNumberFormatter(maxDecimalPlaces: 2);
        
        const oldValue = TextEditingValue(text: '123.45');
        const newValue = TextEditingValue(text: '123.456');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals('123.45'));
      });
      
      test('respects min/max values', () {
        final formatter = StrictNumberFormatter(minValue: 0, maxValue: 100);
        
        // Test max value
        var oldValue = const TextEditingValue(text: '99');
        var newValue = const TextEditingValue(text: '101');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, equals('99'));
        
        // Test min value
        oldValue = const TextEditingValue(text: '1');
        newValue = const TextEditingValue(text: '-1');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, equals('1'));
      });
      
      test('allows partial input that could lead to valid value', () {
        final formatter = StrictNumberFormatter(minValue: 10, maxValue: 100);
        
        // Allow typing '1' even though min is 10 (could become 10-19)
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '1');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals('1'));
      });
    });
    
    group('StrictIntegerFormatter', () {
      test('blocks decimal points', () {
        final formatter = StrictIntegerFormatter();
        
        const oldValue = TextEditingValue(text: '123');
        const newValue = TextEditingValue(text: '123.5');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals('123'));
      });
      
      test('allows negative integers when enabled', () {
        final formatter = StrictIntegerFormatter();
        
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '-123');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals('-123'));
      });
      
      test('blocks negative integers when disabled', () {
        final formatter = StrictIntegerFormatter(allowNegative: false);
        
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '-123');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals(''));
      });
    });
    
    group('CurrencyFormatter', () {
      test('allows up to 2 decimal places', () {
        final formatter = CurrencyFormatter();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '123.45');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, equals('123.45'));
        
        // Should block third decimal place
        oldValue = const TextEditingValue(text: '123.45');
        newValue = const TextEditingValue(text: '123.456');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, equals('123.45'));
      });
      
      test('blocks negative values', () {
        final formatter = CurrencyFormatter();
        
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '-10');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals(''));
      });
    });
    
    group('PercentageFormatter', () {
      test('limits value to 0-100', () {
        final formatter = PercentageFormatter();
        
        // Test max value
        var oldValue = const TextEditingValue(text: '99');
        var newValue = const TextEditingValue(text: '101');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, equals('99'));
        
        // Test allowing 100
        oldValue = const TextEditingValue(text: '10');
        newValue = const TextEditingValue(text: '100');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, equals('100'));
      });
      
      test('blocks negative values', () {
        final formatter = PercentageFormatter();
        
        const oldValue = TextEditingValue.empty;
        const newValue = TextEditingValue(text: '-10');
        final result = formatter.formatEditUpdate(oldValue, newValue);
        
        expect(result.text, equals(''));
      });
    });
    
    group('VooField factories', () {
      test('VooField.number creates field with proper formatter', () {
        final field = VooField.number(
          name: 'amount',
          min: 0,
          max: 1000,
          allowNegative: false,
        );
        
        expect(field.inputFormatters, isNotNull);
        expect(field.inputFormatters!.length, equals(1));
        expect(field.inputFormatters!.first, isA<StrictNumberFormatter>());
        expect(field.keyboardType, equals(const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),),);
      });
      
      test('VooField.integer creates field with integer formatter', () {
        final field = VooField.integer(
          name: 'count',
          min: 0,
          max: 100,
          allowNegative: false,
        );
        
        expect(field.inputFormatters, isNotNull);
        expect(field.inputFormatters!.length, equals(1));
        expect(field.inputFormatters!.first, isA<StrictIntegerFormatter>());
        expect(field.keyboardType, equals(const TextInputType.numberWithOptions(
          signed: true,
        ),),);
      });
      
      test('VooField.currency creates field with currency formatter', () {
        final field = VooField.currency(
          name: 'price',
          max: 9999.99,
        );
        
        expect(field.inputFormatters, isNotNull);
        expect(field.inputFormatters!.length, equals(1));
        expect(field.inputFormatters!.first, isA<CurrencyFormatter>());
        expect(field.min, equals(0));
      });
      
      test('VooField.percentage creates field with percentage formatter', () {
        final field = VooField.percentage(
          name: 'completion',
        );
        
        expect(field.inputFormatters, isNotNull);
        expect(field.inputFormatters!.length, equals(1));
        expect(field.inputFormatters!.first, isA<PercentageFormatter>());
        expect(field.min, equals(0));
        expect(field.max, equals(100));
      });
      
      test('VooField.decimal creates field with decimal formatter', () {
        final field = VooField.decimal(
          name: 'weight',
          maxDecimalPlaces: 3,
          min: 0.001,
          max: 999.999,
        );
        
        expect(field.inputFormatters, isNotNull);
        expect(field.inputFormatters!.length, equals(1));
        expect(field.inputFormatters!.first, isA<StrictNumberFormatter>());
        
        final formatter = field.inputFormatters!.first as StrictNumberFormatter;
        expect(formatter.maxDecimalPlaces, equals(3));
        expect(formatter.allowDecimals, isTrue);
      });
    });
  });
}