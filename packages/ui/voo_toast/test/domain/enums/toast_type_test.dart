import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';

void main() {
  group('ToastType Enum', () {
    test('has all expected values', () {
      const expectedValues = [ToastType.success, ToastType.error, ToastType.warning, ToastType.info, ToastType.custom];

      expect(ToastType.values, expectedValues);
    });

    test('values have correct indices', () {
      expect(ToastType.success.index, 0);
      expect(ToastType.error.index, 1);
      expect(ToastType.warning.index, 2);
      expect(ToastType.info.index, 3);
      expect(ToastType.custom.index, 4);
    });

    test('values have correct names', () {
      expect(ToastType.success.name, 'success');
      expect(ToastType.error.name, 'error');
      expect(ToastType.warning.name, 'warning');
      expect(ToastType.info.name, 'info');
      expect(ToastType.custom.name, 'custom');
    });

    test('toString returns correct string representation', () {
      expect(ToastType.success.toString(), 'ToastType.success');
      expect(ToastType.error.toString(), 'ToastType.error');
      expect(ToastType.warning.toString(), 'ToastType.warning');
      expect(ToastType.info.toString(), 'ToastType.info');
      expect(ToastType.custom.toString(), 'ToastType.custom');
    });

    test('can iterate through values', () {
      final types = <ToastType>[];
      for (final type in ToastType.values) {
        types.add(type);
      }
      expect(types.length, 5);
      expect(types, ToastType.values);
    });

    test('can be used in switch statements', () {
      String getLabel(ToastType type) {
        switch (type) {
          case ToastType.success:
            return 'Success';
          case ToastType.error:
            return 'Error';
          case ToastType.warning:
            return 'Warning';
          case ToastType.info:
            return 'Info';
          case ToastType.custom:
            return 'Custom';
        }
      }

      expect(getLabel(ToastType.success), 'Success');
      expect(getLabel(ToastType.error), 'Error');
      expect(getLabel(ToastType.warning), 'Warning');
      expect(getLabel(ToastType.info), 'Info');
      expect(getLabel(ToastType.custom), 'Custom');
    });

    test('equality works correctly', () {
      const type1 = ToastType.success;
      const type2 = ToastType.success;
      const type3 = ToastType.error;

      expect(type1 == type2, true);
      expect(type1 == type3, false);
      expect(type2 == type3, false);
    });

    test('can be stored in collections', () {
      final set = <ToastType>{ToastType.success, ToastType.error};

      expect(set.length, 2);
      expect(set.contains(ToastType.success), true);
      expect(set.contains(ToastType.error), true);
      expect(set.contains(ToastType.warning), false);
    });

    test('can be used as map keys', () {
      final map = <ToastType, String>{
        ToastType.success: 'green',
        ToastType.error: 'red',
        ToastType.warning: 'orange',
        ToastType.info: 'blue',
        ToastType.custom: 'custom',
      };

      expect(map[ToastType.success], 'green');
      expect(map[ToastType.error], 'red');
      expect(map[ToastType.warning], 'orange');
      expect(map[ToastType.info], 'blue');
      expect(map[ToastType.custom], 'custom');
    });
  });
}
