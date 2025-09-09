import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/data/repositories/toast_repository_impl.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';

void main() {
  group('ToastRepositoryImpl', () {
    late ToastRepositoryImpl repository;

    setUp(() {
      repository = ToastRepositoryImpl();
    });

    test('initial state has no toasts', () async {
      final toasts = repository.currentToasts;
      expect(toasts, isEmpty);
    });

    test('show adds a toast to the repository', () async {
      const toast = Toast(
        id: 'test-1',
        message: 'Test message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      repository.show(toast);

      final toasts = repository.currentToasts;
      expect(toasts.length, 1);
      expect(toasts.first, toast);
    });

    test('show adds multiple toasts', () async {
      const toast1 = Toast(
        id: 'test-1',
        message: 'First message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      const toast2 = Toast(
        id: 'test-2',
        message: 'Second message',
        type: ToastType.success,
        position: ToastPosition.top,
      );

      repository.show(toast1);
      repository.show(toast2);

      final toasts = repository.currentToasts;
      expect(toasts.length, 2);
      expect(toasts, contains(toast1));
      expect(toasts, contains(toast2));
    });

    test('dismiss removes a specific toast', () async {
      const toast1 = Toast(
        id: 'test-1',
        message: 'First message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      const toast2 = Toast(
        id: 'test-2',
        message: 'Second message',
        type: ToastType.success,
        position: ToastPosition.top,
      );

      repository.show(toast1);
      repository.show(toast2);

      repository.dismiss('test-1');

      final toasts = repository.currentToasts;
      expect(toasts.length, 1);
      expect(toasts.first, toast2);
    });

    test('dismiss with non-existent id throws exception', () async {
      const toast = Toast(
        id: 'test-1',
        message: 'Test message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      repository.show(toast);

      expect(
        () => repository.dismiss('non-existent'),
        throwsException,
      );
    });

    test('dismissAll removes all toasts', () async {
      const toast1 = Toast(
        id: 'test-1',
        message: 'First message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      const toast2 = Toast(
        id: 'test-2',
        message: 'Second message',
        type: ToastType.success,
        position: ToastPosition.top,
      );

      const toast3 = Toast(
        id: 'test-3',
        message: 'Third message',
        type: ToastType.error,
        position: ToastPosition.center,
        animation: ToastAnimation.bounce,
      );

      repository.show(toast1);
      repository.show(toast2);
      repository.show(toast3);

      final beforeClear = repository.currentToasts;
      expect(beforeClear.length, 3);

      repository.dismissAll();

      final afterClear = repository.currentToasts;
      expect(afterClear, isEmpty);
    });

    test('toastsStream emits changes', () async {
      const toast1 = Toast(
        id: 'test-1',
        message: 'First message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      const toast2 = Toast(
        id: 'test-2',
        message: 'Second message',
        type: ToastType.success,
        position: ToastPosition.top,
      );

      final stream = repository.toastsStream;

      await expectLater(
        stream,
        emitsInOrder([
          <Toast>[],
          <Toast>[toast1],
          <Toast>[toast1, toast2],
          <Toast>[toast2],
          <Toast>[],
        ]),
      );

      repository.show(toast1);
      repository.show(toast2);
      repository.dismiss('test-1');
      repository.dismissAll();
    });

    test('maintains order of toasts', () async {
      final toasts = List.generate(
        5,
        (index) => Toast(
          id: 'test-$index',
          message: 'Message $index',
          position: ToastPosition.bottom,
          animation: ToastAnimation.fade,
        ),
      );

      for (final toast in toasts) {
        repository.show(toast);
      }

      final activeToasts = repository.currentToasts;
      expect(activeToasts.length, 5);

      for (int i = 0; i < toasts.length; i++) {
        expect(activeToasts[i].id, 'test-$i');
      }
    });

    test('handles toasts with different priorities', () async {
      const toast1 = Toast(
        id: 'low-priority',
        message: 'Low priority',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      const toast2 = Toast(
        id: 'high-priority',
        message: 'High priority',
        type: ToastType.error,
        position: ToastPosition.top,
        priority: 10,
      );

      repository.show(toast1);
      repository.show(toast2);

      final toasts = repository.currentToasts;
      expect(toasts.length, 2);
      // Higher priority should be first
      expect(toasts.first.id, 'high-priority');
      expect(toasts.last.id, 'low-priority');
    });

    test('stream updates when toasts change', () async {
      final states = <List<Toast>>[];

      final subscription = repository.toastsStream.listen((toasts) {
        states.add(List.from(toasts));
      });

      const toast1 = Toast(
        id: 'test-1',
        message: 'First message',
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      const toast2 = Toast(
        id: 'test-2',
        message: 'Second message',
        type: ToastType.success,
        position: ToastPosition.top,
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));
      repository.show(toast1);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repository.show(toast2);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repository.dismiss('test-1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repository.dismissAll();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(states.length, greaterThanOrEqualTo(5));
      expect(states[0], isEmpty);
      expect(states[1], [toast1]);
      expect(states[2], [toast1, toast2]);
      expect(states[3], [toast2]);
      expect(states[4], isEmpty);

      await subscription.cancel();
    });

    test('clearQueue clears the queue', () {
      // clearQueue should clear the internal queue
      repository.clearQueue();
      // No way to directly test the queue without exposing it
      // This just ensures the method exists and doesn't throw
      expect(() => repository.clearQueue(), returnsNormally);
    });

    test('dispose cleans up resources', () {
      repository.dispose();
      // After dispose, the stream should be closed
      expect(
        repository.toastsStream.listen((_) {}),
        throwsA(isA<StateError>()),
      );
    });
  });
}
