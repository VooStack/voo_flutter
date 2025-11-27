import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';

void main() {
  group('LineType', () {
    test('has all expected values', () {
      expect(LineType.values, containsAll([
        LineType.output,
        LineType.input,
        LineType.error,
        LineType.warning,
        LineType.success,
        LineType.system,
        LineType.info,
        LineType.debug,
      ]));
    });
  });

  group('LineTypeExtension', () {
    group('isInput', () {
      test('returns true for input type', () {
        expect(LineType.input.isInput, true);
      });

      test('returns false for other types', () {
        expect(LineType.output.isInput, false);
        expect(LineType.error.isInput, false);
        expect(LineType.success.isInput, false);
      });
    });

    group('isError', () {
      test('returns true for error type', () {
        expect(LineType.error.isError, true);
      });

      test('returns false for other types', () {
        expect(LineType.output.isError, false);
        expect(LineType.input.isError, false);
        expect(LineType.success.isError, false);
      });
    });

    group('isSuccess', () {
      test('returns true for success type', () {
        expect(LineType.success.isSuccess, true);
      });

      test('returns false for other types', () {
        expect(LineType.output.isSuccess, false);
        expect(LineType.error.isSuccess, false);
        expect(LineType.warning.isSuccess, false);
      });
    });

    group('isWarning', () {
      test('returns true for warning type', () {
        expect(LineType.warning.isWarning, true);
      });

      test('returns false for other types', () {
        expect(LineType.output.isWarning, false);
        expect(LineType.error.isWarning, false);
        expect(LineType.success.isWarning, false);
      });
    });

    group('defaultPrefix', () {
      test('output has empty prefix', () {
        expect(LineType.output.defaultPrefix, '');
      });

      test('input has > prefix', () {
        expect(LineType.input.defaultPrefix, '> ');
      });

      test('error has ✗ prefix', () {
        expect(LineType.error.defaultPrefix, '✗ ');
      });

      test('warning has ⚠ prefix', () {
        expect(LineType.warning.defaultPrefix, '⚠ ');
      });

      test('success has ✓ prefix', () {
        expect(LineType.success.defaultPrefix, '✓ ');
      });

      test('system has • prefix', () {
        expect(LineType.system.defaultPrefix, '• ');
      });

      test('info has ℹ prefix', () {
        expect(LineType.info.defaultPrefix, 'ℹ ');
      });

      test('debug has 🔍 prefix', () {
        expect(LineType.debug.defaultPrefix, '🔍 ');
      });
    });
  });
}
