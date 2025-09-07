import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/config/utils/formatters/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    late CurrencyFormatter formatter;

    setUp(() {
      formatter = CurrencyFormatter();
    });

    test('typing 88 should format as \$0.88', () {
      // First type "8"
      var oldValue = TextEditingValue.empty;
      var newValue = const TextEditingValue(
        text: '8',
        selection: TextSelection.collapsed(offset: 1),
      );
      var result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$0.08');

      // Then type another "8" to make "88"
      oldValue = result;
      newValue = const TextEditingValue(
        text: '\$0.088',
        selection: TextSelection.collapsed(offset: 6),
      );
      result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$0.88');
    });

    test('typing sequence 1, 2, 3 should format correctly', () {
      var oldValue = TextEditingValue.empty;
      
      // Type "1"
      var newValue = const TextEditingValue(
        text: '1',
        selection: TextSelection.collapsed(offset: 1),
      );
      var result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$0.01');
      
      // Type "2" to make "12"
      oldValue = result;
      newValue = TextEditingValue(
        text: oldValue.text + '2',
        selection: TextSelection.collapsed(offset: oldValue.text.length + 1),
      );
      result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$0.12');
      
      // Type "3" to make "123"
      oldValue = result;
      newValue = TextEditingValue(
        text: oldValue.text + '3',
        selection: TextSelection.collapsed(offset: oldValue.text.length + 1),
      );
      result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$1.23');
    });

    test('typing 100 should format as \$1.00', () {
      var oldValue = TextEditingValue.empty;
      
      // Type "1"
      var newValue = const TextEditingValue(
        text: '1',
        selection: TextSelection.collapsed(offset: 1),
      );
      var result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$0.01');
      
      // Type "0" to make "10"
      oldValue = result;
      newValue = TextEditingValue(
        text: oldValue.text + '0',
        selection: TextSelection.collapsed(offset: oldValue.text.length + 1),
      );
      result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$0.10');
      
      // Type "0" to make "100"
      oldValue = result;
      newValue = TextEditingValue(
        text: oldValue.text + '0',
        selection: TextSelection.collapsed(offset: oldValue.text.length + 1),
      );
      result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$1.00');
    });

    test('typing 1234567 should format with thousand separators', () {
      var oldValue = TextEditingValue.empty;
      const input = '1234567';
      
      for (int i = 0; i < input.length; i++) {
        final char = input[i];
        final currentText = i == 0 ? char : oldValue.text + char;
        
        var newValue = TextEditingValue(
          text: currentText,
          selection: TextSelection.collapsed(offset: currentText.length),
        );
        
        var result = formatter.formatEditUpdate(oldValue, newValue);
        oldValue = result;
      }
      
      expect(oldValue.text, '\$12,345.67');
    });

    test('deleting from end should work correctly', () {
      // Start with $12.34
      var oldValue = const TextEditingValue(
        text: '\$12.34',
        selection: TextSelection.collapsed(offset: 6),
      );
      
      // Delete last character (backspace)
      var newValue = const TextEditingValue(
        text: '\$12.3',
        selection: TextSelection.collapsed(offset: 5),
      );
      
      var result = formatter.formatEditUpdate(oldValue, newValue);
      expect(result.text, '\$1.23');
    });
  });
}