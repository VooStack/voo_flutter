import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';

void main() {
  group('ToastAnimation Enum', () {
    test('has all expected values', () {
      const expectedValues = [
        ToastAnimation.none,
        ToastAnimation.fade,
        ToastAnimation.slideIn,
        ToastAnimation.slideInFromTop,
        ToastAnimation.slideInFromBottom,
        ToastAnimation.slideInFromLeft,
        ToastAnimation.slideInFromRight,
        ToastAnimation.bounce,
        ToastAnimation.scale,
        ToastAnimation.rotate,
      ];

      expect(ToastAnimation.values, expectedValues);
    });

    test('values have correct indices', () {
      expect(ToastAnimation.none.index, 0);
      expect(ToastAnimation.fade.index, 1);
      expect(ToastAnimation.slideIn.index, 2);
      expect(ToastAnimation.slideInFromTop.index, 3);
      expect(ToastAnimation.slideInFromBottom.index, 4);
      expect(ToastAnimation.slideInFromLeft.index, 5);
      expect(ToastAnimation.slideInFromRight.index, 6);
      expect(ToastAnimation.bounce.index, 7);
      expect(ToastAnimation.scale.index, 8);
      expect(ToastAnimation.rotate.index, 9);
    });

    test('values have correct names', () {
      expect(ToastAnimation.none.name, 'none');
      expect(ToastAnimation.fade.name, 'fade');
      expect(ToastAnimation.slideIn.name, 'slideIn');
      expect(ToastAnimation.slideInFromTop.name, 'slideInFromTop');
      expect(ToastAnimation.slideInFromBottom.name, 'slideInFromBottom');
      expect(ToastAnimation.slideInFromLeft.name, 'slideInFromLeft');
      expect(ToastAnimation.slideInFromRight.name, 'slideInFromRight');
      expect(ToastAnimation.bounce.name, 'bounce');
      expect(ToastAnimation.scale.name, 'scale');
      expect(ToastAnimation.rotate.name, 'rotate');
    });

    test('can identify slide animations', () {
      final slideAnimations = [
        ToastAnimation.slideIn,
        ToastAnimation.slideInFromTop,
        ToastAnimation.slideInFromBottom,
        ToastAnimation.slideInFromLeft,
        ToastAnimation.slideInFromRight,
      ];

      for (final animation in ToastAnimation.values) {
        if (animation.name.contains('slide')) {
          expect(slideAnimations.contains(animation), true);
        } else {
          expect(slideAnimations.contains(animation), false);
        }
      }
    });

    test('can identify directional animations', () {
      final directionalAnimations = [
        ToastAnimation.slideInFromTop,
        ToastAnimation.slideInFromBottom,
        ToastAnimation.slideInFromLeft,
        ToastAnimation.slideInFromRight,
      ];

      for (final animation in directionalAnimations) {
        expect(animation.name.contains('From'), true);
      }
    });

    test('can be used in switch statements', () {
      bool requiresDirection(ToastAnimation animation) {
        switch (animation) {
          case ToastAnimation.slideInFromTop:
          case ToastAnimation.slideInFromBottom:
          case ToastAnimation.slideInFromLeft:
          case ToastAnimation.slideInFromRight:
            return true;
          case ToastAnimation.none:
          case ToastAnimation.fade:
          case ToastAnimation.slideIn:
          case ToastAnimation.bounce:
          case ToastAnimation.scale:
          case ToastAnimation.rotate:
            return false;
        }
      }

      expect(requiresDirection(ToastAnimation.slideInFromTop), true);
      expect(requiresDirection(ToastAnimation.slideInFromBottom), true);
      expect(requiresDirection(ToastAnimation.fade), false);
      expect(requiresDirection(ToastAnimation.scale), false);
    });

    test('none animation is unique', () {
      expect(ToastAnimation.none, isNot(ToastAnimation.fade));
      expect(ToastAnimation.none, isNot(ToastAnimation.slideIn));
      expect(ToastAnimation.none.name, 'none');
    });

    test('can determine animation complexity', () {
      bool isComplexAnimation(ToastAnimation animation) {
        return animation == ToastAnimation.bounce ||
            animation == ToastAnimation.scale ||
            animation == ToastAnimation.rotate;
      }

      expect(isComplexAnimation(ToastAnimation.bounce), true);
      expect(isComplexAnimation(ToastAnimation.scale), true);
      expect(isComplexAnimation(ToastAnimation.rotate), true);
      expect(isComplexAnimation(ToastAnimation.fade), false);
      expect(isComplexAnimation(ToastAnimation.none), false);
    });

    test('can be used as map keys', () {
      final map = <ToastAnimation, Duration>{
        ToastAnimation.none: Duration.zero,
        ToastAnimation.fade: const Duration(milliseconds: 200),
        ToastAnimation.slideIn: const Duration(milliseconds: 300),
        ToastAnimation.bounce: const Duration(milliseconds: 500),
      };

      expect(map[ToastAnimation.none], Duration.zero);
      expect(map[ToastAnimation.fade], const Duration(milliseconds: 200));
      expect(map[ToastAnimation.slideIn], const Duration(milliseconds: 300));
      expect(map[ToastAnimation.bounce], const Duration(milliseconds: 500));
    });

    test('equality works correctly', () {
      const anim1 = ToastAnimation.fade;
      const anim2 = ToastAnimation.fade;
      const anim3 = ToastAnimation.scale;

      expect(anim1 == anim2, true);
      expect(anim1 == anim3, false);
      expect(anim2 == anim3, false);
    });

    test('can iterate through values', () {
      final animations = <ToastAnimation>[];
      for (final animation in ToastAnimation.values) {
        animations.add(animation);
      }
      expect(animations.length, 10);
      expect(animations, ToastAnimation.values);
    });
  });
}