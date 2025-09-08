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
        
        // Type first '5' - should give $0.05
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$0.05');
        
        // Type second '5' - should give $0.55 (not $50.05!)
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
      
      test('typing 1234 incrementally formats with thousand separator', () {
        final formatter = CurrencyFormatter.usd();
        
        // Type '1'
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
    
    group('Deletion', () {
      test('deleting digits works correctly', () {
        final formatter = CurrencyFormatter.usd();
        formatter.setInitialValue(12.34);
        
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
        expect(result.text, '');
      });
    });
    
    group('Currency variants', () {
      test('EUR formatter works correctly', () {
        final formatter = CurrencyFormatter.eur();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '9');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '0,09 €');  // Note: EUR uses comma as decimal separator with space
        
        oldValue = result;
        newValue = const TextEditingValue(text: '0,099');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '0,99 €');
      });
      
      test('GBP formatter works correctly', () {
        final formatter = CurrencyFormatter.gbp();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '5');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '£0.05');
        
        oldValue = result;
        newValue = const TextEditingValue(text: '£0.050');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '£0.50');
      });
      
      test('JPY formatter works correctly (no decimals)', () {
        final formatter = CurrencyFormatter.jpy();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '1');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '¥1');
        
        oldValue = result;
        newValue = const TextEditingValue(text: '¥12');
        result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '¥12');
      });
    });
    
    group('Min/Max constraints', () {
      test('respects minimum value', () {
        final formatter = CurrencyFormatter(
          minValue: 10.00,
        );
        
        // Try to enter $5.00
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '500');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$10.00');  // Should be constrained to min
      });
      
      test('respects maximum value', () {
        final formatter = CurrencyFormatter(
          maxValue: 100.00,
        );
        
        // Try to enter $150.00
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '15000');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$100.00');  // Should be constrained to max
      });
    });
    
    group('Parsing', () {
      test('parses formatted USD correctly', () {
        expect(CurrencyFormatter.parse('\$1,234.56'), 1234.56);
        expect(CurrencyFormatter.parse('\$0.99'), 0.99);
        expect(CurrencyFormatter.parse('\$10'), 10.0);
      });
      
      test('parses formatted EUR correctly', () {
        expect(CurrencyFormatter.parse('1.234,56€'), 1234.56);
        expect(CurrencyFormatter.parse('0,99€'), 0.99);
      });
      
      test('handles empty and invalid input', () {
        expect(CurrencyFormatter.parse(''), null);
        expect(CurrencyFormatter.parse('abc'), null);
      });
    });
    
    group('Initial value', () {
      test('setInitialValue works correctly', () {
        final formatter = CurrencyFormatter.usd();
        formatter.setInitialValue(25.50);
        
        // Now typing a digit should append to this value
        var oldValue = const TextEditingValue(text: '\$25.50');
        var newValue = const TextEditingValue(text: '\$25.507');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$255.07');
      });
    });
    
    group('Edge cases', () {
      test('handles paste of large numbers', () {
        final formatter = CurrencyFormatter.usd();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: '123456789');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '\$1,234,567.89');
      });
      
      test('handles clearing the field', () {
        final formatter = CurrencyFormatter.usd();
        
        var oldValue = const TextEditingValue(text: '\$12.34');
        var newValue = TextEditingValue.empty;
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '');
      });
      
      test('handles non-numeric input gracefully', () {
        final formatter = CurrencyFormatter.usd();
        
        var oldValue = TextEditingValue.empty;
        var newValue = const TextEditingValue(text: 'abc');
        var result = formatter.formatEditUpdate(oldValue, newValue);
        expect(result.text, '');
      });
    });
  });
}