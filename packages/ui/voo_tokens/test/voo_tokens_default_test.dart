import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_tokens/voo_tokens.dart';

void main() {
  group('VooTokensTheme Default Behavior', () {
    testWidgets('should provide default tokens when not registered in theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            // Intentionally not adding VooTokensTheme to extensions
          ),
          home: Builder(
            builder: (context) {
              // This should not throw an error anymore
              final tokens = context.vooTokens;
              final spacing = context.vooSpacing;
              final typography = context.vooTypography;

              expect(tokens, isNotNull);
              expect(tokens, isA<VooTokensTheme>());
              expect(spacing, isNotNull);
              expect(typography, isNotNull);

              // Verify default values
              expect(tokens.tokens.scaleFactor, 1.0);
              expect(spacing.md, 16.0);

              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('should use custom tokens when registered in theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [VooTokensTheme.standard(scaleFactor: 2.0)]),
          home: Builder(
            builder: (context) {
              final tokens = context.vooTokens;

              expect(tokens, isNotNull);
              expect(tokens.tokens.scaleFactor, 2.0);
              expect(context.vooSpacing.md, 32.0); // 16 * 2

              return const Placeholder();
            },
          ),
        ),
      );
    });
  });
}
