import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  group('VooUICore exports', () {
    test('design system exports are available', () {
      // Test that main classes are exported and can be referenced
      expect(VooDesignSystemData, isNotNull);
      expect(VooDesignSystem, isNotNull);
      expect(VooColors, isNotNull);
      expect(VooSpacing, isNotNull);
      expect(VooTypography, isNotNull);
    });

    test('VooDesignSystemData has expected properties', () {
      const design = VooDesignSystemData.defaultSystem;
      expect(design.spacingUnit, 8.0);
      expect(design.radiusUnit, 4.0);
      expect(design.borderWidth, 1.0);
      expect(design.inputHeight, 48.0);
      expect(design.buttonHeight, 44.0);
    });

    test('VooColors has expected color maps', () {
      expect(VooColors.logLevels, isA<Map<String, Color>>());
      expect(VooColors.httpMethods, isA<Map<String, Color>>());
      expect(VooColors.getLogLevelColor('info'), isA<Color>());
      expect(VooColors.getHttpStatusColor(200), isA<Color>());
      expect(VooColors.getPerformanceColor(100), isA<Color>());
      expect(VooColors.getHttpMethodColor('GET'), isA<Color>());
    });
  });
}
