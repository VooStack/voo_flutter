import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';

void main() {
  group('Toast Entity', () {
    test('creates toast with required parameters', () {
      final toast = Toast(
        id: 'test-id',
        message: 'Test message',
        type: ToastType.info,
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      expect(toast.id, 'test-id');
      expect(toast.message, 'Test message');
      expect(toast.type, ToastType.info);
      expect(toast.duration, const Duration(seconds: 3));
      expect(toast.position, ToastPosition.bottom);
      expect(toast.animation, ToastAnimation.fade);
    });

    test('creates toast with all optional parameters', () {
      final action = ToastAction(
        label: 'Action',
        onPressed: () {},
      );

      final toast = Toast(
        id: 'test-id',
        message: 'Test message',
        type: ToastType.success,
        duration: const Duration(seconds: 5),
        position: ToastPosition.topRight,
        animation: ToastAnimation.slideInFromTop,
        title: 'Test Title',
        icon: const Icon(Icons.check),
        showCloseButton: true,
        showProgressBar: true,
        isDismissible: false,
        onTap: () {},
        actions: [action],
        backgroundColor: Colors.green,
        textColor: Colors.white,
        borderRadius: BorderRadius.circular(8),
        elevation: 4.0,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        width: 300,
        maxWidth: 400,
        customContent: const Text('Custom'),
      );

      expect(toast.title, 'Test Title');
      expect(toast.icon, isA<Icon>());
      expect(toast.showCloseButton, true);
      expect(toast.showProgressBar, true);
      expect(toast.isDismissible, false);
      expect(toast.onTap, isNotNull);
      expect(toast.actions, hasLength(1));
      expect(toast.backgroundColor, Colors.green);
      expect(toast.textColor, Colors.white);
      expect(toast.borderRadius, BorderRadius.circular(8));
      expect(toast.elevation, 4.0);
      expect(toast.margin, const EdgeInsets.all(16));
      expect(toast.padding, const EdgeInsets.all(12));
      expect(toast.width, 300);
      expect(toast.maxWidth, 400);
      expect(toast.customContent, isA<Text>());
    });

    test('copyWith creates new instance with updated values', () {
      final original = Toast(
        id: 'original-id',
        message: 'Original message',
        type: ToastType.info,
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      final updated = original.copyWith(
        message: 'Updated message',
        type: ToastType.success,
        title: 'New Title',
      );

      expect(updated.id, 'original-id');
      expect(updated.message, 'Updated message');
      expect(updated.type, ToastType.success);
      expect(updated.title, 'New Title');
      expect(updated.duration, const Duration(seconds: 3));
      expect(updated.position, ToastPosition.bottom);
      expect(updated.animation, ToastAnimation.fade);
    });

    test('copyWith preserves original values when not specified', () {
      final original = Toast(
        id: 'test-id',
        message: 'Test message',
        type: ToastType.error,
        duration: const Duration(seconds: 5),
        position: ToastPosition.topCenter,
        animation: ToastAnimation.bounce,
        title: 'Original Title',
        showCloseButton: false,
        showProgressBar: true,
      );

      final updated = original.copyWith();

      expect(updated.id, original.id);
      expect(updated.message, original.message);
      expect(updated.type, original.type);
      expect(updated.duration, original.duration);
      expect(updated.position, original.position);
      expect(updated.animation, original.animation);
      expect(updated.title, original.title);
      expect(updated.showCloseButton, original.showCloseButton);
      expect(updated.showProgressBar, original.showProgressBar);
    });

    test('equals and hashCode work correctly', () {
      final toast1 = Toast(
        id: 'same-id',
        message: 'Same message',
        type: ToastType.info,
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      final toast2 = Toast(
        id: 'same-id',
        message: 'Same message',
        type: ToastType.info,
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      final toast3 = Toast(
        id: 'different-id',
        message: 'Same message',
        type: ToastType.info,
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom,
        animation: ToastAnimation.fade,
      );

      expect(toast1, equals(toast2));
      expect(toast1.hashCode, equals(toast2.hashCode));
      expect(toast1, isNot(equals(toast3)));
    });
  });

  group('ToastAction Entity', () {
    test('creates toast action with required parameters', () {
      var pressed = false;
      final action = ToastAction(
        label: 'Test Action',
        onPressed: () {
          pressed = true;
        },
      );

      expect(action.label, 'Test Action');
      expect(action.onPressed, isNotNull);
      
      action.onPressed();
      expect(pressed, true);
    });

    test('creates toast action with optional parameters', () {
      final action = ToastAction(
        label: 'Styled Action',
        onPressed: () {},
        textColor: Colors.blue,
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      );

      expect(action.label, 'Styled Action');
      expect(action.textColor, Colors.blue);
      expect(action.backgroundColor, Colors.blue.withValues(alpha: 0.1));
    });

    test('creates action with all parameters', () {
      final action = ToastAction(
        label: 'Full Action',
        onPressed: () {},
        textColor: Colors.red,
        backgroundColor: Colors.grey,
      );

      expect(action.label, 'Full Action');
      expect(action.textColor, Colors.red);
      expect(action.backgroundColor, Colors.grey);
      expect(action.onPressed, isNotNull);
    });

    test('equals and hashCode work correctly', () {
      final callback = () {};
      
      final action1 = ToastAction(
        label: 'Same',
        onPressed: callback,
        textColor: Colors.blue,
      );

      final action2 = ToastAction(
        label: 'Same',
        onPressed: callback,
        textColor: Colors.blue,
      );

      final action3 = ToastAction(
        label: 'Different',
        onPressed: callback,
        textColor: Colors.blue,
      );

      expect(action1, equals(action2));
      expect(action1.hashCode, equals(action2.hashCode));
      expect(action1, isNot(equals(action3)));
    });
  });
}