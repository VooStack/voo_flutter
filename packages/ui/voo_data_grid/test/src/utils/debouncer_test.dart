import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('should execute action after specified duration', () async {
      var counter = 0;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));

      debouncer.run(() {
        counter++;
      });

      expect(counter, 0);

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(counter, 1);

      debouncer.dispose();
    });

    test('should cancel previous action when new one is triggered', () async {
      var counter = 0;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));

      debouncer.run(() {
        counter++;
      });

      await Future<void>.delayed(const Duration(milliseconds: 50));

      debouncer.run(() {
        counter += 10;
      });

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(counter, 10);

      debouncer.dispose();
    });

    test('should handle multiple rapid calls', () async {
      var value = '';
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));

      debouncer.run(() => value = 'first');
      debouncer.run(() => value = 'second');
      debouncer.run(() => value = 'third');
      debouncer.run(() => value = 'final');

      expect(value, '');

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(value, 'final');

      debouncer.dispose();
    });

    test('should properly dispose and cancel pending timers', () async {
      var counter = 0;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));

      debouncer.run(() {
        counter++;
      });

      await Future<void>.delayed(const Duration(milliseconds: 50));
      debouncer.dispose();

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(counter, 0);
    });

    test('should use default duration of 500ms when not specified', () async {
      var counter = 0;
      final debouncer = Debouncer();

      debouncer.run(() {
        counter++;
      });

      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(counter, 0);

      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(counter, 1);

      debouncer.dispose();
    });
  });
}
