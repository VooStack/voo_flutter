import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_config.dart';
import 'package:voo_terminal/src/domain/enums/terminal_mode.dart';

void main() {
  group('TerminalConfig', () {
    group('constructor', () {
      test('creates config with default values', () {
        const config = TerminalConfig();

        expect(config.mode, TerminalMode.preview);
        expect(config.maxLines, 1000);
        expect(config.showTimestamps, false);
        expect(config.timestampFormat, 'HH:mm:ss');
        expect(config.enableHistory, true);
        expect(config.historySize, 100);
        expect(config.autoScroll, true);
        expect(config.prompt, r'$ ');
        expect(config.echoInput, true);
        expect(config.enableSelection, true);
        expect(config.enableLineWrap, true);
        expect(config.tabSize, 4);
        expect(config.autofocus, false);
        expect(config.showCursor, true);
      });

      test('creates config with custom values', () {
        const config = TerminalConfig(
          mode: TerminalMode.interactive,
          maxLines: 500,
          showTimestamps: true,
          timestampFormat: 'yyyy-MM-dd HH:mm:ss',
          enableHistory: false,
          historySize: 50,
          autoScroll: false,
          prompt: '>>> ',
          echoInput: false,
          enableSelection: false,
          enableLineWrap: false,
          tabSize: 2,
          autofocus: true,
          showCursor: false,
        );

        expect(config.mode, TerminalMode.interactive);
        expect(config.maxLines, 500);
        expect(config.showTimestamps, true);
        expect(config.timestampFormat, 'yyyy-MM-dd HH:mm:ss');
        expect(config.enableHistory, false);
        expect(config.historySize, 50);
        expect(config.autoScroll, false);
        expect(config.prompt, '>>> ');
        expect(config.echoInput, false);
        expect(config.enableSelection, false);
        expect(config.enableLineWrap, false);
        expect(config.tabSize, 2);
        expect(config.autofocus, true);
        expect(config.showCursor, false);
      });
    });

    group('factory TerminalConfig.preview', () {
      test('creates preview configuration', () {
        final config = TerminalConfig.preview();

        expect(config.mode, TerminalMode.preview);
        expect(config.enableHistory, false);
        expect(config.showCursor, false);
      });

      test('accepts custom parameters', () {
        final config = TerminalConfig.preview(
          maxLines: 200,
          showTimestamps: true,
          autoScroll: false,
          enableSelection: false,
        );

        expect(config.maxLines, 200);
        expect(config.showTimestamps, true);
        expect(config.autoScroll, false);
        expect(config.enableSelection, false);
      });
    });

    group('factory TerminalConfig.interactive', () {
      test('creates interactive configuration', () {
        final config = TerminalConfig.interactive();

        expect(config.mode, TerminalMode.interactive);
        expect(config.enableHistory, true);
        expect(config.showCursor, true);
        expect(config.autofocus, true);
      });

      test('accepts custom parameters', () {
        final config = TerminalConfig.interactive(
          maxLines: 300,
          showTimestamps: true,
          prompt: '> ',
          enableHistory: false,
          historySize: 200,
          autoScroll: false,
          autofocus: false,
        );

        expect(config.maxLines, 300);
        expect(config.showTimestamps, true);
        expect(config.prompt, '> ');
        expect(config.enableHistory, false);
        expect(config.historySize, 200);
        expect(config.autoScroll, false);
        expect(config.autofocus, false);
      });
    });

    group('factory TerminalConfig.hybrid', () {
      test('creates hybrid configuration', () {
        final config = TerminalConfig.hybrid();

        expect(config.mode, TerminalMode.hybrid);
        expect(config.showCursor, true);
      });

      test('accepts custom parameters', () {
        final config = TerminalConfig.hybrid(
          maxLines: 400,
          showTimestamps: true,
          prompt: '# ',
          enableHistory: false,
          autoScroll: false,
        );

        expect(config.maxLines, 400);
        expect(config.showTimestamps, true);
        expect(config.prompt, '# ');
        expect(config.enableHistory, false);
        expect(config.autoScroll, false);
      });
    });

    group('isPreview', () {
      test('returns true for preview mode', () {
        final config = TerminalConfig.preview();

        expect(config.isPreview, true);
      });

      test('returns false for interactive mode', () {
        final config = TerminalConfig.interactive();

        expect(config.isPreview, false);
      });

      test('returns false for hybrid mode', () {
        final config = TerminalConfig.hybrid();

        expect(config.isPreview, false);
      });
    });

    group('acceptsInput', () {
      test('returns false for preview mode', () {
        final config = TerminalConfig.preview();

        expect(config.acceptsInput, false);
      });

      test('returns true for interactive mode', () {
        final config = TerminalConfig.interactive();

        expect(config.acceptsInput, true);
      });

      test('returns true for hybrid mode', () {
        final config = TerminalConfig.hybrid();

        expect(config.acceptsInput, true);
      });
    });

    group('copyWith', () {
      test('copies with new mode', () {
        const original = TerminalConfig();
        final copy = original.copyWith(mode: TerminalMode.interactive);

        expect(copy.mode, TerminalMode.interactive);
        expect(copy.maxLines, original.maxLines);
      });

      test('copies with all properties', () {
        const original = TerminalConfig();
        final copy = original.copyWith(
          mode: TerminalMode.hybrid,
          maxLines: 250,
          showTimestamps: true,
          timestampFormat: 'HH:mm',
          enableHistory: false,
          historySize: 25,
          autoScroll: false,
          prompt: '>> ',
          echoInput: false,
          enableSelection: false,
          enableLineWrap: false,
          tabSize: 8,
          autofocus: true,
          showCursor: false,
        );

        expect(copy.mode, TerminalMode.hybrid);
        expect(copy.maxLines, 250);
        expect(copy.showTimestamps, true);
        expect(copy.timestampFormat, 'HH:mm');
        expect(copy.enableHistory, false);
        expect(copy.historySize, 25);
        expect(copy.autoScroll, false);
        expect(copy.prompt, '>> ');
        expect(copy.echoInput, false);
        expect(copy.enableSelection, false);
        expect(copy.enableLineWrap, false);
        expect(copy.tabSize, 8);
        expect(copy.autofocus, true);
        expect(copy.showCursor, false);
      });
    });

    group('equality', () {
      test('equal configs have same hash code', () {
        const config1 = TerminalConfig();
        const config2 = TerminalConfig();

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('different configs are not equal', () {
        const config1 = TerminalConfig(mode: TerminalMode.preview);
        const config2 = TerminalConfig(mode: TerminalMode.interactive);

        expect(config1, isNot(equals(config2)));
      });
    });
  });
}
