import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';
import 'package:voo_terminal/src/domain/enums/terminal_style_preset.dart';

void main() {
  group('VooTerminalTheme', () {
    group('factory VooTerminalTheme.classic', () {
      test('creates classic theme with green colors', () {
        final theme = VooTerminalTheme.classic();

        expect(theme.preset, TerminalStylePreset.classic);
        expect(theme.textColor, const Color(0xFF00FF00));
        expect(theme.enableGlow, true);
      });

      test('accepts custom cursor color', () {
        final theme = VooTerminalTheme.classic(cursorColor: Colors.red);

        expect(theme.cursorColor, Colors.red);
      });
    });

    group('factory VooTerminalTheme.modern', () {
      test('creates dark modern theme by default', () {
        final theme = VooTerminalTheme.modern();

        expect(theme.preset, TerminalStylePreset.modern);
        expect(theme.enableGlow, false);
      });

      test('creates light modern theme', () {
        final theme = VooTerminalTheme.modern(brightness: Brightness.light);

        expect(theme.backgroundColor, const Color(0xFFFAFAFA));
      });

      test('accepts custom accent color', () {
        final theme = VooTerminalTheme.modern(accentColor: Colors.purple);

        expect(theme.inputColor, Colors.purple);
        expect(theme.cursorColor, Colors.purple);
      });
    });

    group('factory VooTerminalTheme.retro', () {
      test('creates retro theme with scanlines', () {
        final theme = VooTerminalTheme.retro();

        expect(theme.preset, TerminalStylePreset.retro);
        expect(theme.enableScanlines, true);
        expect(theme.enableGlow, true);
      });

      test('accepts custom phosphor color', () {
        final theme = VooTerminalTheme.retro(phosphorColor: Colors.amber);

        expect(theme.textColor, Colors.amber);
      });
    });

    group('factory VooTerminalTheme.matrix', () {
      test('creates matrix theme', () {
        final theme = VooTerminalTheme.matrix();

        expect(theme.preset, TerminalStylePreset.matrix);
        expect(theme.textColor, const Color(0xFF00FF41));
        expect(theme.enableGlow, true);
      });
    });

    group('factory VooTerminalTheme.amber', () {
      test('creates amber theme', () {
        final theme = VooTerminalTheme.amber();

        expect(theme.preset, TerminalStylePreset.amber);
        expect(theme.textColor, const Color(0xFFFFB000));
        expect(theme.enableGlow, true);
      });
    });

    group('factory VooTerminalTheme.ubuntu', () {
      test('creates ubuntu theme', () {
        final theme = VooTerminalTheme.ubuntu();

        expect(theme.preset, TerminalStylePreset.ubuntu);
        expect(theme.backgroundColor, const Color(0xFF300A24));
        expect(theme.enableGlow, false);
      });
    });

    group('factory VooTerminalTheme.fromTheme', () {
      test('creates theme from dark ThemeData', () {
        final themeData = ThemeData.dark();
        final theme = VooTerminalTheme.fromTheme(themeData);

        expect(theme.preset, TerminalStylePreset.custom);
        expect(theme.textColor, themeData.colorScheme.onSurface);
      });

      test('creates theme from light ThemeData', () {
        final themeData = ThemeData.light();
        final theme = VooTerminalTheme.fromTheme(themeData);

        expect(theme.preset, TerminalStylePreset.custom);
      });
    });

    group('colorForLineType', () {
      late VooTerminalTheme theme;

      setUp(() {
        theme = VooTerminalTheme.classic();
      });

      test('returns inputColor for input', () {
        expect(theme.colorForLineType('input'), theme.inputColor);
      });

      test('returns errorColor for error', () {
        expect(theme.colorForLineType('error'), theme.errorColor);
      });

      test('returns warningColor for warning', () {
        expect(theme.colorForLineType('warning'), theme.warningColor);
      });

      test('returns successColor for success', () {
        expect(theme.colorForLineType('success'), theme.successColor);
      });

      test('returns systemColor for system', () {
        expect(theme.colorForLineType('system'), theme.systemColor);
      });

      test('returns infoColor for info', () {
        expect(theme.colorForLineType('info'), theme.infoColor);
      });

      test('returns debugColor for debug', () {
        expect(theme.colorForLineType('debug'), theme.debugColor);
      });

      test('returns textColor for unknown type', () {
        expect(theme.colorForLineType('unknown'), theme.textColor);
      });
    });

    group('textStyle', () {
      test('returns TextStyle with theme properties', () {
        final theme = VooTerminalTheme.classic();
        final style = theme.textStyle;

        expect(style.fontFamily, theme.fontFamily);
        expect(style.fontSize, theme.fontSize);
        expect(style.height, theme.lineHeight);
        expect(style.fontWeight, theme.fontWeight);
        expect(style.color, theme.textColor);
      });
    });

    group('textStyleWithColor', () {
      test('returns style with specified color', () {
        final theme = VooTerminalTheme.classic();
        final style = theme.textStyleWithColor(Colors.red);

        expect(style.color, Colors.red);
        expect(style.fontFamily, theme.fontFamily);
      });
    });

    group('prefixForLineType', () {
      test('returns default prefix for line types', () {
        final theme = VooTerminalTheme.classic();

        expect(theme.prefixForLineType(LineType.error), '✗ ');
        expect(theme.prefixForLineType(LineType.success), '✓ ');
        expect(theme.prefixForLineType(LineType.warning), '⚠ ');
      });

      test('returns empty string when showLinePrefixes is false', () {
        final theme = VooTerminalTheme.classic().copyWith(showLinePrefixes: false);

        expect(theme.prefixForLineType(LineType.error), '');
      });
    });

    group('copyWith', () {
      test('copies with new backgroundColor', () {
        final original = VooTerminalTheme.classic();
        final copy = original.copyWith(backgroundColor: Colors.blue);

        expect(copy.backgroundColor, Colors.blue);
        expect(copy.textColor, original.textColor);
      });

      test('copies with all properties', () {
        final original = VooTerminalTheme.classic();
        final copy = original.copyWith(
          preset: TerminalStylePreset.custom,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
          enableGlow: false,
          enableScanlines: true,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(20),
        );

        expect(copy.preset, TerminalStylePreset.custom);
        expect(copy.backgroundColor, Colors.black);
        expect(copy.textColor, Colors.white);
        expect(copy.fontSize, 16.0);
        expect(copy.enableGlow, false);
        expect(copy.enableScanlines, true);
        expect(copy.borderRadius, BorderRadius.circular(20));
        expect(copy.padding, const EdgeInsets.all(20));
      });
    });

    group('equality', () {
      test('equal themes are equal', () {
        final theme1 = VooTerminalTheme.classic();
        final theme2 = VooTerminalTheme.classic();

        expect(theme1, equals(theme2));
      });

      test('different themes are not equal', () {
        final theme1 = VooTerminalTheme.classic();
        final theme2 = VooTerminalTheme.modern();

        expect(theme1, isNot(equals(theme2)));
      });

      test('equal themes have same hash code', () {
        final theme1 = VooTerminalTheme.classic();
        final theme2 = VooTerminalTheme.classic();

        expect(theme1.hashCode, equals(theme2.hashCode));
      });
    });

    group('default values', () {
      test('has sensible defaults', () {
        final theme = VooTerminalTheme.classic();

        expect(theme.fontFamily, 'monospace');
        expect(theme.fontSize, 14.0);
        expect(theme.lineHeight, 1.4);
        expect(theme.cursorWidth, 2.0);
        expect(theme.cursorBlinks, true);
        expect(theme.showBorder, true);
        expect(theme.borderWidth, 1.0);
        expect(theme.scrollbarWidth, 8.0);
        expect(theme.headerHeight, 36.0);
      });
    });
  });
}
