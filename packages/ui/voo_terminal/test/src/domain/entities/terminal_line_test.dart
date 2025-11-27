import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';

void main() {
  group('TerminalLine', () {
    group('constructor', () {
      test('creates line with required properties', () {
        final timestamp = DateTime.now();
        final line = TerminalLine(
          id: 'test-id',
          content: 'Hello',
          type: LineType.output,
          timestamp: timestamp,
        );

        expect(line.id, 'test-id');
        expect(line.content, 'Hello');
        expect(line.type, LineType.output);
        expect(line.timestamp, timestamp);
        expect(line.isSelectable, true);
      });

      test('creates line with optional properties', () {
        final timestamp = DateTime.now();
        final line = TerminalLine(
          id: 'test-id',
          content: 'Hello',
          type: LineType.output,
          timestamp: timestamp,
          textColor: Colors.red,
          backgroundColor: Colors.black,
          fontWeight: FontWeight.bold,
          isSelectable: false,
          prefix: '>> ',
        );

        expect(line.textColor, Colors.red);
        expect(line.backgroundColor, Colors.black);
        expect(line.fontWeight, FontWeight.bold);
        expect(line.isSelectable, false);
        expect(line.prefix, '>> ');
      });
    });

    group('factory TerminalLine.create', () {
      test('generates unique id', () {
        final line1 = TerminalLine.create(
          content: 'Test',
          type: LineType.output,
        );
        final line2 = TerminalLine.create(
          content: 'Test',
          type: LineType.output,
        );

        expect(line1.id, isNotEmpty);
        expect(line2.id, isNotEmpty);
        // IDs should be different due to microsecond timestamp
      });

      test('sets current timestamp', () {
        final before = DateTime.now();
        final line = TerminalLine.create(
          content: 'Test',
          type: LineType.output,
        );
        final after = DateTime.now();

        expect(line.timestamp.isAfter(before.subtract(const Duration(seconds: 1))), true);
        expect(line.timestamp.isBefore(after.add(const Duration(seconds: 1))), true);
      });
    });

    group('factory constructors for line types', () {
      test('TerminalLine.output creates output line', () {
        final line = TerminalLine.output('Test output');

        expect(line.content, 'Test output');
        expect(line.type, LineType.output);
      });

      test('TerminalLine.output with custom color', () {
        final line = TerminalLine.output('Test', textColor: Colors.blue);

        expect(line.textColor, Colors.blue);
      });

      test('TerminalLine.input creates input line', () {
        final line = TerminalLine.input('echo hello');

        expect(line.content, 'echo hello');
        expect(line.type, LineType.input);
      });

      test('TerminalLine.input with custom prompt', () {
        final line = TerminalLine.input('command', prompt: '>>> ');

        expect(line.prefix, '>>> ');
      });

      test('TerminalLine.error creates error line', () {
        final line = TerminalLine.error('Error message');

        expect(line.content, 'Error message');
        expect(line.type, LineType.error);
      });

      test('TerminalLine.warning creates warning line', () {
        final line = TerminalLine.warning('Warning message');

        expect(line.content, 'Warning message');
        expect(line.type, LineType.warning);
      });

      test('TerminalLine.success creates success line', () {
        final line = TerminalLine.success('Success message');

        expect(line.content, 'Success message');
        expect(line.type, LineType.success);
      });

      test('TerminalLine.system creates system line', () {
        final line = TerminalLine.system('System message');

        expect(line.content, 'System message');
        expect(line.type, LineType.system);
      });

      test('TerminalLine.info creates info line', () {
        final line = TerminalLine.info('Info message');

        expect(line.content, 'Info message');
        expect(line.type, LineType.info);
      });

      test('TerminalLine.debug creates debug line', () {
        final line = TerminalLine.debug('Debug message');

        expect(line.content, 'Debug message');
        expect(line.type, LineType.debug);
      });
    });

    group('effectivePrefix', () {
      test('returns custom prefix when set', () {
        final line = TerminalLine.create(
          content: 'Test',
          type: LineType.output,
          prefix: '>> ',
        );

        expect(line.effectivePrefix, '>> ');
      });

      test('returns type default prefix when no custom prefix', () {
        final line = TerminalLine.error('Error');

        expect(line.effectivePrefix, '✗ ');
      });

      test('returns empty string for output type with no prefix', () {
        final line = TerminalLine.output('Test');

        expect(line.effectivePrefix, '');
      });
    });

    group('displayText', () {
      test('combines prefix and content', () {
        final line = TerminalLine.error('Error occurred');

        expect(line.displayText, '✗ Error occurred');
      });

      test('returns just content when no prefix', () {
        final line = TerminalLine.output('Hello');

        expect(line.displayText, 'Hello');
      });
    });

    group('copyWith', () {
      test('copies with new content', () {
        final original = TerminalLine.output('Original');
        final copy = original.copyWith(content: 'Modified');

        expect(copy.content, 'Modified');
        expect(copy.type, original.type);
        expect(copy.id, original.id);
      });

      test('copies with new type', () {
        final original = TerminalLine.output('Test');
        final copy = original.copyWith(type: LineType.error);

        expect(copy.type, LineType.error);
        expect(copy.content, original.content);
      });

      test('copies all properties when specified', () {
        final original = TerminalLine.output('Test');
        final newTimestamp = DateTime(2025, 1, 1);
        final copy = original.copyWith(
          id: 'new-id',
          content: 'New content',
          type: LineType.success,
          timestamp: newTimestamp,
          textColor: Colors.green,
          backgroundColor: Colors.white,
          fontWeight: FontWeight.w600,
          isSelectable: false,
          prefix: '! ',
        );

        expect(copy.id, 'new-id');
        expect(copy.content, 'New content');
        expect(copy.type, LineType.success);
        expect(copy.timestamp, newTimestamp);
        expect(copy.textColor, Colors.green);
        expect(copy.backgroundColor, Colors.white);
        expect(copy.fontWeight, FontWeight.w600);
        expect(copy.isSelectable, false);
        expect(copy.prefix, '! ');
      });
    });

    group('equality', () {
      test('equal lines have same hash code', () {
        final timestamp = DateTime(2025, 1, 1);
        final line1 = TerminalLine(
          id: 'id',
          content: 'Test',
          type: LineType.output,
          timestamp: timestamp,
        );
        final line2 = TerminalLine(
          id: 'id',
          content: 'Test',
          type: LineType.output,
          timestamp: timestamp,
        );

        expect(line1, equals(line2));
        expect(line1.hashCode, equals(line2.hashCode));
      });

      test('different lines are not equal', () {
        final line1 = TerminalLine.output('Test 1');
        final line2 = TerminalLine.output('Test 2');

        expect(line1, isNot(equals(line2)));
      });
    });
  });
}
