import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/config/utils/formatters/phone_number_formatter.dart';
import 'package:voo_forms/src/presentation/config/utils/formatters/simple_currency_formatter.dart';

void main() {
  group('Formatter Behavior Tests', () {
    group('SimpleCurrencyFormatter', () {
      late SimpleCurrencyFormatter formatter;

      setUp(() {
        formatter = SimpleCurrencyFormatter();
      });

      test('formats currency naturally as user types', () {
        // Type "4" -> "$4"
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '4'),
        );
        expect(result.text, contains('4'));
        expect(result.text, contains('\$'));

        // Type "45" -> "$45"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '45'),
        );
        expect(result.text, contains('45'));

        // Type "456" -> "$456"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '456'),
        );
        expect(result.text, contains('456'));

        // Type "4567" -> "$4,567"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '4567'),
        );
        expect(result.text, contains('4,567'));

        // Type decimal "4567.89" -> "$4,567.89"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '4567.89'),
        );
        expect(result.text, '\$4,567.89');
      });

      test('handles decimals while typing', () {
        // Type "45." -> "$45."
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '45.'),
        );
        expect(result.text, contains('45.'));

        // Type "45.5" -> "$45.5"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '45.5'),
        );
        expect(result.text, contains('45.5'));

        // Type "45.50" -> "$45.50"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '45.50'),
        );
        expect(result.text, '\$45.50');
      });

      test('EUR formatter works with European locale', () {
        final eurFormatter = SimpleCurrencyFormatter.eur();

        final result = eurFormatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '1234'),
        );
        expect(result.text, contains('€'));
        expect(result.text, contains('1.234')); // European thousand separator
      });
    });

    group('PhoneNumberFormatter', () {
      late PhoneNumberFormatter formatter;

      setUp(() {
        formatter = PhoneNumberFormatter();
      });

      test('formats US phone numbers as user types', () {
        // Type "5" -> "(5"
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '5'),
        );
        expect(result.text, '(5');

        // Type "55" -> "(55"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '55'),
        );
        expect(result.text, '(55');

        // Type "555" -> "(555"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '555'),
        );
        expect(result.text, '(555');

        // Type "5551" -> "(555) 1"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '5551'),
        );
        expect(result.text, '(555) 1');

        // Type "55512" -> "(555) 12"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '55512'),
        );
        expect(result.text, '(555) 12');

        // Type "555123" -> "(555) 123"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '555123'),
        );
        expect(result.text, '(555) 123');

        // Type "5551234" -> "(555) 123-4"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '5551234'),
        );
        expect(result.text, '(555) 123-4');

        // Full number: "5551234567" -> "(555) 123-4567"
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '5551234567'),
        );
        expect(result.text, '(555) 123-4567');
      });

      test('handles deletion properly', () {
        // Start with full number
        var result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '5551234567'),
        );
        expect(result.text, '(555) 123-4567');

        // Delete last digit
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '555123456'),
        );
        expect(result.text, '(555) 123-456');

        // Delete more
        result = formatter.formatEditUpdate(
          result,
          const TextEditingValue(text: '55512'),
        );
        expect(result.text, '(555) 12');
      });
    });
  });
}
