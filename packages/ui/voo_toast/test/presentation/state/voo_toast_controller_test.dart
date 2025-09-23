import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/entities/toast_config.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';
import 'package:voo_toast/src/presentation/state/voo_toast_controller.dart';

void main() {
  group('VooToastController', () {
    // Reset the singleton instance before each test
    setUp(VooToastController.init);

    test('singleton instance returns same controller', () {
      final instance1 = VooToastController.instance;
      final instance2 = VooToastController.instance;

      expect(instance1, same(instance2));
    });

    test('initial state has no toasts', () async {
      final controller = VooToastController.instance;
      final toasts = await controller.toastsStream.first;
      expect(toasts, isEmpty);
    });

    test('showSuccess creates success toast', () async {
      final controller = VooToastController.instance;
      controller.showSuccess(message: 'Success message');

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.type, ToastType.success);
      expect(toasts.first.message, 'Success message');
    });

    test('showError creates error toast', () async {
      final controller = VooToastController.instance;
      controller.showError(message: 'Error message', title: 'Error');

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.type, ToastType.error);
      expect(toasts.first.message, 'Error message');
      expect(toasts.first.title, 'Error');
    });

    test('showWarning creates warning toast', () async {
      final controller = VooToastController.instance;
      controller.showWarning(message: 'Warning message');

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.type, ToastType.warning);
      expect(toasts.first.message, 'Warning message');
    });

    test('showInfo creates info toast', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'Info message');

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.type, ToastType.info);
      expect(toasts.first.message, 'Info message');
    });

    test('showCustom creates custom toast', () async {
      final controller = VooToastController.instance;
      controller.showCustom(content: const Text('Custom content'), backgroundColor: Colors.purple);

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.type, ToastType.custom);
      expect(toasts.first.customContent, isA<Text>());
      expect(toasts.first.backgroundColor, Colors.purple);
    });

    test('dismiss removes specific toast', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'First');
      controller.showInfo(message: 'Second');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final toasts = await controller.toastsStream.first;
      final firstToastId = toasts.first.id;

      controller.dismiss(firstToastId);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final updatedToasts = await controller.toastsStream.first;
      expect(updatedToasts.length, 1);
      expect(updatedToasts.first.message, 'Second');
    });

    test('dismissAll removes all toasts', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'First');
      controller.showError(message: 'Second');
      controller.showSuccess(message: 'Third');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      controller.dismissAll();

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final toasts = await controller.toastsStream.first;
      expect(toasts, isEmpty);
    });

    test('respects max toasts configuration', () async {
      VooToastController.init(config: const ToastConfig(maxToasts: 2, queueMode: false));
      final controller = VooToastController.instance;

      controller.showInfo(message: 'First');
      controller.showInfo(message: 'Second');
      controller.showInfo(message: 'Third');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 2);
    });

    test('queue mode queues toasts when max reached', () async {
      VooToastController.init(config: const ToastConfig(maxToasts: 1));
      final controller = VooToastController.instance;

      controller.showInfo(message: 'First');
      controller.showInfo(message: 'Second');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      var toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.message, 'First');

      final firstToastId = toasts.first.id;
      controller.dismiss(firstToastId);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.message, 'Second');
    });

    test('clearQueue removes queued toasts', () async {
      VooToastController.init(config: const ToastConfig(maxToasts: 1));
      final controller = VooToastController.instance;

      controller.showInfo(message: 'First');
      controller.showInfo(message: 'Second');
      controller.showInfo(message: 'Third');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      controller.clearQueue();

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
      expect(toasts.first.message, 'First');
    });

    test('auto-dismisses toasts after duration', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'Auto dismiss', duration: const Duration(milliseconds: 100));

      await Future<void>.delayed(const Duration(milliseconds: 10));
      var toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);

      await Future<void>.delayed(const Duration(milliseconds: 120));
      toasts = await controller.toastsStream.first;
      expect(toasts, isEmpty);
    });

    test('does not auto-dismiss with zero duration', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'Persistent', duration: Duration.zero);

      await Future<void>.delayed(const Duration(milliseconds: 200));

      final toasts = await controller.toastsStream.first;
      expect(toasts.length, 1);
    });

    test('uses default config values', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'Test');

      final toasts = await controller.toastsStream.first;
      expect(toasts.first.duration, controller.config.defaultDuration);
      expect(toasts.first.position, controller.config.defaultPosition);
      expect(toasts.first.animation, controller.config.defaultAnimation);
    });

    test('overrides default config values', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'Test', duration: const Duration(seconds: 5), position: ToastPosition.topCenter);

      final toasts = await controller.toastsStream.first;
      expect(toasts.first.duration, const Duration(seconds: 5));
      expect(toasts.first.position, ToastPosition.topCenter);
      // Animation is set by default config
    });

    test('generates unique IDs for toasts', () async {
      final controller = VooToastController.instance;
      controller.showInfo(message: 'First');
      controller.showInfo(message: 'Second');
      controller.showInfo(message: 'Third');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final toasts = await controller.toastsStream.first;
      final ids = toasts.map((t) => t.id).toList();

      expect(ids[0], isNot(equals(ids[1])));
      expect(ids[1], isNot(equals(ids[2])));
      expect(ids[0], isNot(equals(ids[2])));
    });

    test('handles context for responsive positioning', () async {
      final controller = VooToastController.instance;
      // Context handling is done internally
      controller.showInfo(message: 'Mobile toast');

      final toasts = await controller.toastsStream.first;
      expect(toasts.first.position, ToastPosition.auto);
    });

    test('handles actions on toasts', () async {
      final controller = VooToastController.instance;
      var actionPressed = false;

      controller.showInfo(
        message: 'With action',
        actions: [
          ToastAction(
            label: 'Test',
            onPressed: () {
              actionPressed = true;
            },
          ),
        ],
      );

      final toasts = await controller.toastsStream.first;
      expect(toasts.first.actions, hasLength(1));

      toasts.first.actions!.first.onPressed();
      expect(actionPressed, true);
    });

    test('stream emits updates when toasts change', () async {
      final controller = VooToastController.instance;
      final states = <int>[];

      final subscription = controller.toastsStream.listen((toasts) {
        states.add(toasts.length);
      });

      await Future<void>.delayed(const Duration(milliseconds: 10));
      controller.showInfo(message: 'First');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      controller.showInfo(message: 'Second');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      controller.dismissAll();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(states, [0, 1, 2, 0]);

      await subscription.cancel();
    });

    test('singleton maintains state', () async {
      final controller1 = VooToastController.instance;
      controller1.showInfo(message: 'Test');

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final controller2 = VooToastController.instance;
      final toasts = await controller2.toastsStream.first;

      expect(controller1, same(controller2));
      expect(toasts.length, 1);
    });
  });
}
