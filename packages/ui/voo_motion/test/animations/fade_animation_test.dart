import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_motion/voo_motion.dart';

void main() {
  group('VooFadeAnimation', () {
    testWidgets('should animate opacity from 0 to 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFadeAnimation(
              config: VooAnimationConfig(
                duration: Duration(milliseconds: 300),
              ),
              child: Text('Fade Test'),
            ),
          ),
        ),
      );
      
      // Initially should be at fromOpacity
      final opacity1 = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity1.opacity, 0.0);
      
      // After half the animation duration
      await tester.pump(const Duration(milliseconds: 150));
      final opacity2 = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity2.opacity, greaterThan(0.0));
      expect(opacity2.opacity, lessThan(1.0));
      
      // After full animation
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      
      final opacity3 = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity3.opacity, 1.0);
    });
    
    testWidgets('should respect delay parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFadeAnimation(
              config: VooAnimationConfig(
                duration: Duration(milliseconds: 200),
                delay: Duration(milliseconds: 100),
              ),
              child: Text('Delayed Fade'),
            ),
          ),
        ),
      );
      
      // Should still be at initial opacity after pumping less than delay
      await tester.pump(const Duration(milliseconds: 50));
      final opacity1 = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity1.opacity, 0.0);
      
      // After delay, animation should start
      await tester.pump(const Duration(milliseconds: 100));
      final opacity2 = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity2.opacity, greaterThan(0.0));
    });
    
    testWidgets('should not auto-play when autoPlay is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFadeAnimation(
              config: VooAnimationConfig(
                duration: Duration(milliseconds: 200),
                autoPlay: false,
              ),
              child: Text('No AutoPlay'),
            ),
          ),
        ),
      );
      
      // Should remain at initial opacity
      await tester.pump(const Duration(milliseconds: 300));
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, 0.0);
    });
    
    testWidgets('should handle custom curves', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFadeAnimation(
              config: VooAnimationConfig(
                duration: Duration(milliseconds: 300),
                curve: Curves.bounceOut,
              ),
              child: Text('Custom Curve'),
            ),
          ),
        ),
      );
      
      // Animation should work with custom curve
      await tester.pumpAndSettle();
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(VooFadeAnimation),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, 1.0);
    });
  });
}