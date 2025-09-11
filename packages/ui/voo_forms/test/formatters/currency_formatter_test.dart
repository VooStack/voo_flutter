import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('CurrencyFormatter', () {
    group('Incremental typing', () {
      test('typing digits incrementally formats correctly', () {
        final formatter = CurrencyFormatter.usd();
        
        // Start with empty
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(
          text: '5',
          selection: TextSelection.collapsed(offset: 1),
        );
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.05');
        
        // Type second '5' to get 55 cents
        oldValue = result;
        newValue = const TextEditingValue(
          text: '\$0.055',  // User typed another 5
          selection: TextSelection.collapsed(offset: 6),
        );
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.55');
        
        // Type third '5' - should give $5.55
        oldValue = result;
        newValue = const TextEditingValue(
          text: '\$0.555',  // User typed another 5
          selection: TextSelection.collapsed(offset: 6),
        );
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$5.55');
      });
      
      test('typing 777 incrementally gives \$7.77', () {
        final formatter = CurrencyFormatter.usd();
        
        // Type '7'
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(
          text: '7',
          selection: TextSelection.collapsed(offset: 1),
        );
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.07');
        
        // Type second '7'
        oldValue = result;
        newValue = const TextEditingValue(
          text: '\$0.077',
          selection: TextSelection.collapsed(offset: 6),
        );
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.77');
        
        // Type third '7'
        oldValue = result;
        newValue = const TextEditingValue(
          text: '\$0.777',
          selection: TextSelection.collapsed(offset: 6),
        );
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$7.77');
      });
      
      test('typing 1234 gives \$12.34', () {
        final formatter = CurrencyFormatter.usd();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '1');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.01');
        
        // Type '2'
        oldValue = result;
        newValue = const TextEditingValue(text: '\$0.012');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.12');
        
        // Type '3'
        oldValue = result;
        newValue = const TextEditingValue(text: '\$0.123');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$1.23');
        
        // Type '4'
        oldValue = result;
        newValue = const TextEditingValue(text: '\$1.234');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$12.34');
      });
    });
    
    group('Backspace handling', () {
      test('handles backspace correctly', () {
        final formatter = CurrencyFormatter.usd();
        
        // Start with $12.34
        var oldValue = const TextEditingValue(text: '\$12.34');
        var newValue = const TextEditingValue(text: '\$12.3');  // Deleted last digit
        
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$1.23');
        
        // Delete another digit
        oldValue = result;
        newValue = const TextEditingValue(text: '\$1.2');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.12');
        
        // Delete another digit
        oldValue = result;
        newValue = const TextEditingValue(text: '\$0.1');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.01');
        
        // Delete last digit
        oldValue = result;
        newValue = const TextEditingValue(text: '\$0.0');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.00');
      });
    });
    
    group('Large amounts', () {
      test('handles thousands correctly', () {
        final formatter = CurrencyFormatter.usd();
        
        // Type 123456 to get $1,234.56
        formatter.setInitialValue(1234.56);
        final result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '123456'),
        );
        expect(result.text, '\$1,234.56');
      });
      
      test('handles millions correctly', () {
        final formatter = CurrencyFormatter.usd();
        
        // Type 12345678 to get $123,456.78
        formatter.setInitialValue(123456.78);
        final result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '12345678'),
        );
        expect(result.text, '\$123,456.78');
      });
    });
    
    group('Currency symbols', () {
      test('EUR formatter works correctly', () {
        final formatter = CurrencyFormatter.eur();
        
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '99'),
        );
        expect(result.text, contains('0,99'));
        expect(result.text, contains('€'));
      });
      
      test('GBP formatter works correctly', () {
        final formatter = CurrencyFormatter.gbp();
        
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '99'),
        );
        expect(result.text, '£0.99');
      });
      
      test('JPY formatter works correctly (no decimal)', () {
        final formatter = CurrencyFormatter.jpy();
        
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '100'),
        );
        expect(result.text, '¥100');
      });
    });
    
    group('Parse function', () {
      test('parses USD correctly', () {
        expect(CurrencyFormatter.parse('\$12.34'), 12.34);
        expect(CurrencyFormatter.parse('\$1,234.56'), 1234.56);
        expect(CurrencyFormatter.parse('\$0.00'), 0.0);
      });
      
      test('parses EUR correctly', () {
        expect(CurrencyFormatter.parse('12,34€'), 12.34);
        expect(CurrencyFormatter.parse('1.234,56€'), 1234.56);
      });
      
      test('handles empty and invalid input', () {
        expect(CurrencyFormatter.parse(''), null);
        expect(CurrencyFormatter.parse('abc'), null);
      });
    });
  });
}