import 'package:flutter_test/flutter_test.dart';
import 'package:voo_devtools_extension/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('should call action after delay', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      var callCount = 0;

      debouncer.call(() => callCount++);

      // Should not be called immediately
      expect(callCount, 0);

      // Wait for debounce delay
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);

      debouncer.dispose();
    });

    test('should cancel previous call when called again', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      var callCount = 0;

      debouncer.call(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.call(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.call(() => callCount++);

      // Wait for final debounce
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1); // Only the last call should execute

      debouncer.dispose();
    });

    test('should cancel pending action', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      var callCount = 0;

      debouncer.call(() => callCount++);
      debouncer.cancel();

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 0);

      debouncer.dispose();
    });

    test('isPending should return correct state', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));

      expect(debouncer.isPending, false);

      debouncer.call(() {});
      expect(debouncer.isPending, true);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(debouncer.isPending, false);

      debouncer.dispose();
    });
  });

  group('Throttler', () {
    test('should call action immediately on first call', () async {
      final throttler = Throttler(interval: const Duration(milliseconds: 100));
      var callCount = 0;

      throttler.call(() => callCount++);
      expect(callCount, 1); // Should be called immediately

      throttler.dispose();
    });

    test('should throttle subsequent calls', () async {
      final throttler = Throttler(interval: const Duration(milliseconds: 100));
      var callCount = 0;

      // First call - immediate
      throttler.call(() => callCount++);
      expect(callCount, 1);

      // Second call within interval - should be scheduled
      throttler.call(() => callCount++);
      expect(callCount, 1); // Still 1

      // Wait for throttle interval
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 2); // Now should be 2

      throttler.dispose();
    });

    test('should cancel pending action', () async {
      final throttler = Throttler(interval: const Duration(milliseconds: 100));
      var callCount = 0;

      throttler.call(() => callCount++);
      throttler.call(() => callCount++); // This gets scheduled
      throttler.cancel();

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1); // Only the first immediate call

      throttler.dispose();
    });
  });
}
