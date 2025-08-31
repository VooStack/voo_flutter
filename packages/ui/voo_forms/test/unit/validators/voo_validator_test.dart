import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

/// Unit tests for VooValidator
/// Tests all validation rules following clean architecture
void main() {
  group('VooValidator Tests', () {
    group('Required Validator', () {
      test('Should return error for null value', () {
        final validator = VooValidator.required();
        final result = validator.validate(null);
        expect(result, equals('This field is required'));
      });

      test('Should return error for empty string', () {
        final validator = VooValidator.required();
        final result = validator.validate('');
        expect(result, equals('This field is required'));
      });

      test('Should return null for valid value', () {
        final validator = VooValidator.required();
        final result = validator.validate('valid');
        expect(result, isNull);
      });

      test('Should use custom error message', () {
        final validator = VooValidator.required('Please fill this field');
        final result = validator.validate(null);
        expect(result, equals('Please fill this field'));
      });
    });

    group('Email Validator', () {
      test('Should validate correct email format', () {
        final validator = VooValidator.email();
        
        expect(validator.validate('user@example.com'), isNull);
        expect(validator.validate('test.user@domain.co.uk'), isNull);
        expect(validator.validate('user+tag@example.com'), isNull);
      });

      test('Should reject invalid email format', () {
        final validator = VooValidator.email();
        
        expect(validator.validate('invalid'), isNotNull);
        expect(validator.validate('user@'), isNotNull);
        expect(validator.validate('@domain.com'), isNotNull);
        expect(validator.validate('user@domain'), isNotNull);
        expect(validator.validate('user @domain.com'), isNotNull);
      });

      test('Should allow null/empty for optional fields', () {
        final validator = VooValidator.email();
        expect(validator.validate(null), isNull);
        expect(validator.validate(''), isNull);
      });
    });

    group('MinLength Validator', () {
      test('Should validate minimum length', () {
        final validator = VooValidator.minLength(5);
        
        expect(validator.validate('12345'), isNull);
        expect(validator.validate('123456'), isNull);
        expect(validator.validate('1234'), equals('Minimum 5 characters required'));
      });

      test('Should handle null values', () {
        final validator = VooValidator.minLength(5);
        expect(validator.validate(null), equals('Minimum 5 characters required'));
      });

      test('Should use custom error message', () {
        final validator = VooValidator.minLength(5, 'Too short');
        expect(validator.validate('123'), equals('Too short'));
      });
    });

    group('MaxLength Validator', () {
      test('Should validate maximum length', () {
        final validator = VooValidator.maxLength(10);
        
        expect(validator.validate('1234567890'), isNull);
        expect(validator.validate('123'), isNull);
        expect(validator.validate('12345678901'), equals('Maximum 10 characters allowed'));
      });

      test('Should handle null values', () {
        final validator = VooValidator.maxLength(10);
        expect(validator.validate(null), isNull);
      });
    });

    group('Pattern Validator', () {
      test('Should validate against regex pattern', () {
        // Phone number pattern
        final validator = VooValidator.pattern(
          r'^\d{3}-\d{3}-\d{4}$',
          'Invalid phone format (XXX-XXX-XXXX)',
        );
        
        expect(validator.validate('123-456-7890'), isNull);
        expect(validator.validate('1234567890'), equals('Invalid phone format (XXX-XXX-XXXX)'));
        expect(validator.validate('123-45-6789'), equals('Invalid phone format (XXX-XXX-XXXX)'));
      });

      test('Should validate alphanumeric pattern', () {
        final validator = VooValidator.pattern(
          r'^[a-zA-Z0-9]+$',
          'Only letters and numbers allowed',
        );
        
        expect(validator.validate('Test123'), isNull);
        expect(validator.validate('Test_123'), equals('Only letters and numbers allowed'));
        expect(validator.validate('Test@123'), equals('Only letters and numbers allowed'));
      });
    });

    group('Min Validator', () {
      test('Should validate minimum numeric value', () {
        final validator = VooValidator.min(18);
        
        expect(validator.validate(18), isNull);
        expect(validator.validate(19), isNull);
        expect(validator.validate(17), equals('Must be at least 18'));
      });

      test('Should handle null input', () {
        final validator = VooValidator.min(10);
        expect(validator.validate(null), isNull);
      });
    });

    group('Max Validator', () {
      test('Should validate maximum numeric value', () {
        final validator = VooValidator.max(100);
        
        expect(validator.validate(100), isNull);
        expect(validator.validate(99), isNull);
        expect(validator.validate(101), equals('Must be at most 100'));
      });

      test('Should handle null values', () {
        final validator = VooValidator.max(100);
        expect(validator.validate(null), isNull);
      });
    });

    group('Custom Validator', () {
      test('Should execute custom validation logic', () {
        final validator = VooValidator.custom<String>(
          validator: (value) {
            if (value == 'forbidden') {
              return 'This value is not allowed';
            }
            return null;
          },
        );
        
        expect(validator.validate('allowed'), isNull);
        expect(validator.validate('forbidden'), equals('This value is not allowed'));
      });

      test('Should handle nullable values', () {
        final validator = VooValidator.custom<String>(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cannot be empty';
            }
            return null;
          },
        );
        
        expect(validator.validate(null), equals('Cannot be empty'));
        expect(validator.validate(''), equals('Cannot be empty'));
        expect(validator.validate('valid'), isNull);
      });
    });

    group('Composite Validators', () {
      test('Should chain multiple validators', () {
        final validators = [
          VooValidator.required(),
          VooValidator.minLength(8),
          VooValidator.pattern('[A-Z]', 'Must contain uppercase'),
          VooValidator.pattern('[0-9]', 'Must contain number'),
        ];
        
        // Test each validator
        String? runValidators(String? value) {
          for (final validator in validators) {
            final error = validator.validate(value);
            if (error != null) return error;
          }
          return null;
        }
        
        expect(runValidators(null), equals('This field is required'));
        expect(runValidators(''), equals('This field is required'));
        expect(runValidators('short'), equals('Minimum 8 characters required'));
        expect(runValidators('lowercase'), equals('Must contain uppercase'));
        expect(runValidators('UPPERCASE'), equals('Must contain number'));
        expect(runValidators('Password1'), isNull);
      });
    });

    group('URL Validator', () {
      test('Should validate URL format', () {
        final validator = VooValidator.url();
        
        expect(validator.validate('https://example.com'), isNull);
        expect(validator.validate('http://www.example.com'), isNull);
        expect(validator.validate('https://sub.example.com/path'), isNull);
        expect(validator.validate('example.com'), isNotNull);
        expect(validator.validate('not a url'), isNotNull);
      });
    });

    group('Phone Validator', () {
      test('Should validate phone numbers', () {
        final validator = VooValidator.phone();
        
        // Various phone formats (spaces, hyphens, parentheses are stripped)
        expect(validator.validate('+1234567890'), isNull);
        expect(validator.validate('123-456-7890'), isNull);
        expect(validator.validate('(123) 456-7890'), isNull);
        expect(validator.validate('123 456 7890'), isNull);
        expect(validator.validate('1234567890'), isNull);
        
        // Invalid formats
        expect(validator.validate('123'), isNotNull);
        expect(validator.validate('abc'), isNotNull);
        expect(validator.validate('123.456.7890'), isNotNull); // Dots are not stripped
      });
    });

    group('Numeric Validator', () {
      test('Should validate numeric string values', () {
        final validator = VooValidator.pattern(
          r'^-?\d+(\.\d+)?$',
          'Must be a valid number',
        );
        
        expect(validator.validate('123'), isNull);
        expect(validator.validate('123.45'), isNull);
        expect(validator.validate('-123'), isNull);
        expect(validator.validate('abc'), equals('Must be a valid number'));
        expect(validator.validate('12a'), equals('Must be a valid number'));
      });
    });

    group('Range Validator', () {
      test('Should validate numeric range', () {
        final validator = VooValidator.range(1, 10);
        
        expect(validator.validate(5), isNull);
        expect(validator.validate(1), isNull);
        expect(validator.validate(10), isNull);
        expect(validator.validate(0), equals('Must be between 1 and 10'));
        expect(validator.validate(11), equals('Must be between 1 and 10'));
      });
    });

    group('Password Strength Validator', () {
      test('Should validate password complexity', () {
        final validator = VooValidator.password();
        
        // Strong password
        expect(validator.validate('StrongPass123!'), isNull);
        
        // Weak passwords
        expect(validator.validate('weak'), isNotNull);
        expect(validator.validate('nouppercase123!'), isNotNull);
        expect(validator.validate('NOLOWERCASE123!'), isNotNull);
        expect(validator.validate('NoNumbers!'), isNotNull);
        expect(validator.validate('NoSpecialChars123'), isNotNull);
      });
    });

    group('Matches Validator', () {
      test('Should validate value matches', () {
        final validator = VooValidator.matches('expectedValue', 'Values must match');
        
        expect(validator.validate('expectedValue'), isNull);
        expect(validator.validate('differentValue'), equals('Values must match'));
      });
    });

    group('Compound Validation', () {
      test('Should combine all validators', () {
        final validator = VooValidator.all([
          VooValidator.required(),
          VooValidator.minLength(8),
          VooValidator.maxLength(20),
        ]);
        
        expect(validator.validate(null), isNotNull);
        expect(validator.validate(''), isNotNull);
        expect(validator.validate('short'), isNotNull);
        expect(validator.validate('thisislongerthantwentycharacters'), isNotNull);
        expect(validator.validate('validpass'), isNull);
      });
    });

    group('Any Validation', () {
      test('Should pass if any validator passes', () {
        final validator = VooValidator.any([
          VooValidator.email(),
          VooValidator.phone(),
        ]);
        
        expect(validator.validate('user@example.com'), isNull);
        expect(validator.validate('123-456-7890'), isNull);
        expect(validator.validate('invalid'), isNotNull);
      });
    });
  });
}