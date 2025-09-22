import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  group('VooNavigationRoute', () {
    test('creates basic route with required fields', () {
      final route = VooNavigationRoute(
        id: 'test',
        path: '/test',
        builder: (context, state) => const Text('Test'),
      );

      expect(route.id, 'test');
      expect(route.path, '/test');
      expect(route.transitionDuration, const Duration(milliseconds: 300));
      expect(route.fullScreenDialog, false);
      expect(route.maintainState, true);
    });

    test('creates material route with factory', () {
      final route = VooNavigationRoute.material(
        id: 'material',
        path: '/material',
        builder: (context, state) => const Text('Material'),
        fullScreenDialog: true,
      );

      expect(route.id, 'material');
      expect(route.path, '/material');
      expect(route.fullScreenDialog, true);
      expect(route.pageBuilder, isNotNull);
    });

    test('creates fade route with custom duration', () {
      final route = VooNavigationRoute.fade(
        id: 'fade',
        path: '/fade',
        builder: (context, state) => const Text('Fade'),
        transitionDuration: const Duration(milliseconds: 500),
      );

      expect(route.id, 'fade');
      expect(route.transitionDuration, const Duration(milliseconds: 500));
      expect(route.transitionBuilder, isNotNull);
    });

    test('creates slide route with custom offset', () {
      final route = VooNavigationRoute.slide(
        id: 'slide',
        path: '/slide',
        builder: (context, state) => const Text('Slide'),
        beginOffset: const Offset(0, 1),
        curve: Curves.easeOut,
      );

      expect(route.id, 'slide');
      expect(route.transitionBuilder, isNotNull);
    });

    test('creates scale route with custom scale values', () {
      final route = VooNavigationRoute.scale(
        id: 'scale',
        path: '/scale',
        builder: (context, state) => const Text('Scale'),
        beginScale: 0.5,
        alignment: Alignment.topCenter,
      );

      expect(route.id, 'scale');
      expect(route.transitionBuilder, isNotNull);
    });

    test('supports nested routes', () {
      final childRoute = VooNavigationRoute.material(
        id: 'child',
        path: 'child',
        builder: (context, state) => const Text('Child'),
      );

      final parentRoute = VooNavigationRoute.material(
        id: 'parent',
        path: '/parent',
        builder: (context, state) => const Text('Parent'),
        routes: [childRoute],
      );

      expect(parentRoute.routes.length, 1);
      expect(parentRoute.routes.first.id, 'child');
    });

    test('supports route metadata', () {
      final route = VooNavigationRoute.material(
        id: 'metadata',
        path: '/metadata',
        builder: (context, state) => const Text('Metadata'),
        metadata: {'key': 'value', 'number': 42},
      );

      expect(route.metadata, isNotNull);
      expect(route.metadata!['key'], 'value');
      expect(route.metadata!['number'], 42);
    });

    test('converts to GoRoute correctly', () {
      final route = VooNavigationRoute.material(
        id: 'goroute',
        path: '/goroute',
        name: 'goRouteName',
        builder: (context, state) => const Text('GoRoute'),
      );

      final goRoute = route.toGoRoute();

      expect(goRoute, isA<GoRoute>());
      expect(goRoute.path, '/goroute');
      expect(goRoute.name, 'goRouteName');
    });

    test('handles redirect function', () {
      String? redirectPath;

      final route = VooNavigationRoute.material(
        id: 'redirect',
        path: '/redirect',
        builder: (context, state) => const Text('Redirect'),
        redirect: (context, state) {
          redirectPath = '/redirected';
          return redirectPath;
        },
      );

      expect(route.redirect, isNotNull);
    });

    test('supports route guard', () {
      final route = VooNavigationRoute.material(
        id: 'guarded',
        path: '/guarded',
        builder: (context, state) => const Text('Guarded'),
        guard: (context, state) async {
          // Simulate async check
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return true;
        },
      );

      expect(route.guard, isNotNull);
    });

    group('nested routes', () {
      test('creates deeply nested route structure', () {
        final grandchildRoute = VooNavigationRoute.material(
          id: 'grandchild',
          path: 'grandchild',
          builder: (context, state) => const Text('Grandchild'),
        );

        final childRoute = VooNavigationRoute.material(
          id: 'child',
          path: 'child',
          builder: (context, state) => const Text('Child'),
          routes: [grandchildRoute],
        );

        final parentRoute = VooNavigationRoute.material(
          id: 'parent',
          path: '/parent',
          builder: (context, state) => const Text('Parent'),
          routes: [childRoute],
        );

        expect(parentRoute.routes.length, 1);
        expect(parentRoute.routes.first.routes.length, 1);
        expect(parentRoute.routes.first.routes.first.id, 'grandchild');
      });

      test('converts nested routes to GoRoute hierarchy', () {
        final childRoute = VooNavigationRoute.material(
          id: 'child',
          path: 'child',
          builder: (context, state) => const Text('Child'),
        );

        final parentRoute = VooNavigationRoute.material(
          id: 'parent',
          path: '/parent',
          builder: (context, state) => const Text('Parent'),
          routes: [childRoute],
        );

        final goRoute = parentRoute.toGoRoute();

        expect(goRoute.routes.length, 1);
        expect(goRoute.routes.first, isA<GoRoute>());
        expect((goRoute.routes.first as GoRoute).path, 'child');
      });
    });
  });
}
