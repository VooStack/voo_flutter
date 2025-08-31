import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_motion/voo_motion.dart';

void main() {
  group('VooMotionCurve', () {
    test('should have all predefined curves', () {
      expect(VooMotionCurve.smooth, Curves.easeInOut);
      expect(VooMotionCurve.sharp, Curves.fastOutSlowIn);
      expect(VooMotionCurve.spring, Curves.elasticOut);
      expect(VooMotionCurve.bounce, Curves.bounceOut);
      expect(VooMotionCurve.linear, Curves.linear);
      expect(VooMotionCurve.decelerate, Curves.decelerate);
      expect(VooMotionCurve.accelerate, Curves.easeIn);
      expect(VooMotionCurve.anticipate, Curves.elasticIn);
      expect(VooMotionCurve.overshoot, Curves.elasticInOut);
    });
    
    test('springCurve should create elastic curve with custom tension', () {
      final curve1 = VooMotionCurve.springCurve();
      final curve2 = VooMotionCurve.springCurve(tension: 2.0);
      
      expect(curve1, isA<ElasticOutCurve>());
      expect(curve2, isA<ElasticOutCurve>());
      
      // Different tensions should produce different curves
      expect(curve1, isNot(equals(curve2)));
    });
    
    test('bounceCurve should create custom bounce curve', () {
      final curve1 = VooMotionCurve.bounceCurve();
      final curve2 = VooMotionCurve.bounceCurve(bounces: 5);
      
      expect(curve1, isA<Curve>());
      expect(curve2, isA<Curve>());
      
      // Test that curves transform values correctly
      expect(curve1.transform(0.0), 0.0);
      expect(curve1.transform(1.0), 1.0);
      expect(curve2.transform(0.0), 0.0);
      expect(curve2.transform(1.0), 1.0);
      
      // Mid-point values should differ based on bounce count
      final mid1 = curve1.transform(0.5);
      final mid2 = curve2.transform(0.5);
      expect(mid1, isNot(equals(mid2)));
    });
    
    test('custom bounce curve should produce valid values', () {
      final curve = VooMotionCurve.bounceCurve();
      
      // Test various points along the curve
      for (double t = 0.0; t <= 1.0; t += 0.1) {
        final value = curve.transform(t);
        // Value should be between -1 and 2 for bounce effect
        expect(value, greaterThanOrEqualTo(-0.5));
        expect(value, lessThanOrEqualTo(1.5));
      }
    });
  });
}