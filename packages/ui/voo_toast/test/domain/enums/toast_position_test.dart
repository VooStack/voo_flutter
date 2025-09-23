import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';

void main() {
  group('ToastPosition Enum', () {
    test('has all expected values', () {
      const expectedValues = [
        ToastPosition.top,
        ToastPosition.topLeft,
        ToastPosition.topCenter,
        ToastPosition.topRight,
        ToastPosition.center,
        ToastPosition.centerLeft,
        ToastPosition.centerRight,
        ToastPosition.bottom,
        ToastPosition.bottomLeft,
        ToastPosition.bottomCenter,
        ToastPosition.bottomRight,
        ToastPosition.auto,
      ];

      expect(ToastPosition.values, expectedValues);
    });

    test('values have correct indices', () {
      expect(ToastPosition.top.index, 0);
      expect(ToastPosition.topLeft.index, 1);
      expect(ToastPosition.topCenter.index, 2);
      expect(ToastPosition.topRight.index, 3);
      expect(ToastPosition.center.index, 4);
      expect(ToastPosition.centerLeft.index, 5);
      expect(ToastPosition.centerRight.index, 6);
      expect(ToastPosition.bottom.index, 7);
      expect(ToastPosition.bottomLeft.index, 8);
      expect(ToastPosition.bottomCenter.index, 9);
      expect(ToastPosition.bottomRight.index, 10);
      expect(ToastPosition.auto.index, 11);
    });

    test('values have correct names', () {
      expect(ToastPosition.top.name, 'top');
      expect(ToastPosition.topLeft.name, 'topLeft');
      expect(ToastPosition.topCenter.name, 'topCenter');
      expect(ToastPosition.topRight.name, 'topRight');
      expect(ToastPosition.center.name, 'center');
      expect(ToastPosition.centerLeft.name, 'centerLeft');
      expect(ToastPosition.centerRight.name, 'centerRight');
      expect(ToastPosition.bottom.name, 'bottom');
      expect(ToastPosition.bottomLeft.name, 'bottomLeft');
      expect(ToastPosition.bottomCenter.name, 'bottomCenter');
      expect(ToastPosition.bottomRight.name, 'bottomRight');
      expect(ToastPosition.auto.name, 'auto');
    });

    test('can identify top positions', () {
      final topPositions = [ToastPosition.top, ToastPosition.topLeft, ToastPosition.topCenter, ToastPosition.topRight];

      for (final position in ToastPosition.values) {
        if (position.name.startsWith('top')) {
          expect(topPositions.contains(position), true);
        } else {
          expect(topPositions.contains(position), false);
        }
      }
    });

    test('can identify bottom positions', () {
      final bottomPositions = [ToastPosition.bottom, ToastPosition.bottomLeft, ToastPosition.bottomCenter, ToastPosition.bottomRight];

      for (final position in ToastPosition.values) {
        if (position.name.startsWith('bottom')) {
          expect(bottomPositions.contains(position), true);
        } else {
          expect(bottomPositions.contains(position), false);
        }
      }
    });

    test('can identify center positions', () {
      final centerPositions = [ToastPosition.center, ToastPosition.centerLeft, ToastPosition.centerRight];

      for (final position in ToastPosition.values) {
        if (position.name.startsWith('center')) {
          expect(centerPositions.contains(position), true);
        }
      }
    });

    test('can be used in switch statements', () {
      String getVerticalAlignment(ToastPosition position) {
        switch (position) {
          case ToastPosition.top:
          case ToastPosition.topLeft:
          case ToastPosition.topCenter:
          case ToastPosition.topRight:
            return 'top';
          case ToastPosition.center:
          case ToastPosition.centerLeft:
          case ToastPosition.centerRight:
            return 'center';
          case ToastPosition.bottom:
          case ToastPosition.bottomLeft:
          case ToastPosition.bottomCenter:
          case ToastPosition.bottomRight:
            return 'bottom';
          case ToastPosition.auto:
            return 'auto';
        }
      }

      expect(getVerticalAlignment(ToastPosition.topLeft), 'top');
      expect(getVerticalAlignment(ToastPosition.center), 'center');
      expect(getVerticalAlignment(ToastPosition.bottomRight), 'bottom');
      expect(getVerticalAlignment(ToastPosition.auto), 'auto');
    });

    test('auto position is unique', () {
      expect(ToastPosition.auto, isNot(ToastPosition.top));
      expect(ToastPosition.auto, isNot(ToastPosition.bottom));
      expect(ToastPosition.auto, isNot(ToastPosition.center));
      expect(ToastPosition.auto.name, 'auto');
    });

    test('can be used as map keys', () {
      final map = <ToastPosition, double>{ToastPosition.top: 0, ToastPosition.center: 50, ToastPosition.bottom: 100};

      expect(map[ToastPosition.top], 0);
      expect(map[ToastPosition.center], 50);
      expect(map[ToastPosition.bottom], 100);
    });

    test('equality works correctly', () {
      const pos1 = ToastPosition.topRight;
      const pos2 = ToastPosition.topRight;
      const pos3 = ToastPosition.bottomLeft;

      expect(pos1 == pos2, true);
      expect(pos1 == pos3, false);
      expect(pos2 == pos3, false);
    });
  });
}
