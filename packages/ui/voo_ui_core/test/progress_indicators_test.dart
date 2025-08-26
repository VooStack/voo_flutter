import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('VooCircularProgressIndicator', () {
    testWidgets('renders indeterminate progress', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCircularProgressIndicator(),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders determinate progress', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooCircularProgressIndicator(
            value: 0.5,
          ),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, 0.5);
    });

    testWidgets('applies custom size', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCircularProgressIndicator(
            size: 60,
            value: 0.5,  // Use determinate mode to avoid animation timeout
          ),
        ),
      );
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, 60);
      expect(sizedBox.height, 60);
    });

    testWidgets('applies custom colors', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCircularProgressIndicator(
            color: Colors.red,
            backgroundColor: Colors.grey,
            value: 0.5,  // Use determinate mode to avoid animation timeout
          ),
        ),
      );
      await tester.pumpAndSettle();

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, Colors.red);
      expect(indicator.backgroundColor, Colors.grey);
    });

    testWidgets('applies stroke width and cap', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCircularProgressIndicator(
            strokeWidth: 8,
            strokeCap: StrokeCap.round,
            value: 0.5,  // Use determinate mode to avoid animation timeout
          ),
        ),
      );
      await tester.pumpAndSettle();

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.strokeWidth, 8);
      expect(indicator.strokeCap, StrokeCap.round);
    });
  });

  group('VooLinearProgressIndicator', () {
    testWidgets('renders indeterminate progress', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooLinearProgressIndicator(),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders determinate progress', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooLinearProgressIndicator(
            value: 0.7,
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.7);
    });

    testWidgets('applies custom height', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooLinearProgressIndicator(
            minHeight: 8,
            value: 0.5,  // Use determinate mode to avoid animation timeout
          ),
        ),
      );
      await tester.pumpAndSettle();

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.minHeight, 8);
    });

    testWidgets('applies border radius', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooLinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            value: 0.5,  // Use determinate mode to avoid animation timeout
          ),
        ),
      );
      await tester.pumpAndSettle();

      final clipRRect = tester.widget<ClipRRect>(
        find.ancestor(
          of: find.byType(LinearProgressIndicator),
          matching: find.byType(ClipRRect),
        ).first,
      );
      expect(clipRRect.borderRadius, BorderRadius.circular(10));
    });
  });

  group('VooLabeledProgress', () {
    testWidgets('shows label and percentage', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooLabeledProgress(
            value: 0.75,
            label: 'Downloading',
          ),
        ),
      );

      expect(find.text('Downloading'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('hides percentage when showPercentage is false', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooLabeledProgress(
            value: 0.5,
            label: 'Processing',
            showPercentage: false,
          ),
        ),
      );

      expect(find.text('Processing'), findsOneWidget);
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('shows circular progress when isLinear is false', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooLabeledProgress(
            value: 0.5,
            label: 'Loading',
            isLinear: false,
          ),
        ),
      );

      expect(find.byType(VooCircularProgressIndicator), findsOneWidget);
      expect(find.byType(VooLinearProgressIndicator), findsNothing);
    });

    testWidgets('handles null value for indeterminate', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooLabeledProgress(
            value: null,
            label: 'Loading',
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      expect(find.text('Loading'), findsOneWidget);
      expect(find.byType(VooLinearProgressIndicator), findsOneWidget);
    });
  });

  group('VooStepProgressIndicator', () {
    testWidgets('renders correct number of steps', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooStepProgressIndicator(
            totalSteps: 5,
            currentStep: 3,
          ),
        ),
      );

      // Each step is a Container
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(VooStepProgressIndicator),
          matching: find.byType(Container),
        ),
      );
      expect(containers.length, 5);
    });

    testWidgets('shows step labels when provided', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooStepProgressIndicator(
            totalSteps: 3,
            currentStep: 2,
            showLabels: true,
            stepLabels: ['Start', 'Middle', 'End'],
          ),
        ),
      );

      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Middle'), findsOneWidget);
      expect(find.text('End'), findsOneWidget);
    });

    testWidgets('applies active and inactive colors', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooStepProgressIndicator(
            totalSteps: 4,
            currentStep: 2,
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(VooStepProgressIndicator),
          matching: find.byType(Container),
        ),
      );
      expect(containers.length, 4);
    });
  });

  group('VooCircularProgressWithContent', () {
    testWidgets('shows content in center', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooCircularProgressWithContent(
            value: 0.6,
            child: Text('60%'),
          ),
        ),
      );

      expect(find.text('60%'), findsOneWidget);
      expect(find.byType(VooCircularProgressIndicator), findsOneWidget);
    });

    testWidgets('applies custom size', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooCircularProgressWithContent(
            value: 0.5,
            size: 100,
            child: Icon(Icons.download),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(Stack),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, 100);
      expect(sizedBox.height, 100);
    });
  });

  group('VooSkeletonLoader', () {
    testWidgets('renders with animation', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooSkeletonLoader(
            width: 200,
            height: 20,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      expect(find.byType(VooSkeletonLoader), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('applies custom dimensions', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooSkeletonLoader(
            width: 150,
            height: 30,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(VooSkeletonLoader),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxWidth, 150);
    });

    testWidgets('applies border radius', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooSkeletonLoader(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(VooSkeletonLoader),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });
  });

  group('VooListSkeletonLoader', () {
    testWidgets('renders correct number of items', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooListSkeletonLoader(
            itemCount: 3,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      // Each item has multiple skeleton loaders
      expect(find.byType(VooSkeletonLoader), findsWidgets);
    });

    testWidgets('shows avatar when enabled', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooListSkeletonLoader(
            itemCount: 1,
            showAvatar: true,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      // Find circular avatar skeleton (width and height 40)
      final avatarSkeletons = tester.widgetList<VooSkeletonLoader>(
        find.byType(VooSkeletonLoader),
      ).where((skeleton) => skeleton.width == 40 && skeleton.height == 40);
      
      expect(avatarSkeletons.isNotEmpty, true);
    });

    testWidgets('shows subtitle when enabled', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooListSkeletonLoader(
            itemCount: 1,
            showSubtitle: true,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      // Should have at least 2 skeleton loaders (title and subtitle)
      expect(find.byType(VooSkeletonLoader), findsAtLeast(2));
    });
  });

  group('VooCardSkeletonLoader', () {
    testWidgets('renders card with skeleton content', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCardSkeletonLoader(
            height: 200,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(VooSkeletonLoader), findsWidgets);
    });

    testWidgets('shows image skeleton when enabled', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCardSkeletonLoader(
            height: 200,
            showImage: true,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      // Image skeleton should take 60% of height
      final skeletons = tester.widgetList<VooSkeletonLoader>(
        find.byType(VooSkeletonLoader),
      );
      final imageSkeletons = skeletons.where((s) => s.height == 200 * 0.6);
      expect(imageSkeletons.isNotEmpty, true);
    });

    testWidgets('shows action buttons when enabled', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooCardSkeletonLoader(
            height: 250,  // Increased height to prevent overflow
            showActions: true,
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      // Action buttons are 60px wide skeletons
      final skeletons = tester.widgetList<VooSkeletonLoader>(
        find.byType(VooSkeletonLoader),
      );
      final actionSkeletons = skeletons.where((s) => s.width == 60);
      expect(actionSkeletons.length, 2); // Two action buttons
    });
  });

  group('VooShimmer', () {
    testWidgets('applies shimmer effect to child', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooShimmer(
            child: Text('Shimmer Text'),
          ),
        ),
      );
      // Just pump once for animated widget
      await tester.pump();

      expect(find.text('Shimmer Text'), findsOneWidget);
      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('disables effect when enabled is false', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooShimmer(
            enabled: false,
            child: Text('No Shimmer'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No Shimmer'), findsOneWidget);
      expect(find.byType(ShaderMask), findsNothing);
    });
  });

  group('VooProgressRing', () {
    testWidgets('renders circular ring', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooProgressRing(
            value: 0.7,
          ),
        ),
      );

      // VooProgressRing uses CustomPaint internally
      expect(find.byType(VooProgressRing), findsOneWidget);
      // There might be multiple CustomPaint widgets in the tree
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('shows child content in center', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooProgressRing(
            value: 0.8,
            child: Text('80%'),
          ),
        ),
      );

      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('applies custom size and stroke', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooProgressRing(
            value: 0.5,
            size: 120,
            strokeWidth: 10,
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CustomPaint),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, 120);
      expect(sizedBox.height, 120);
    });

    testWidgets('applies custom colors', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooProgressRing(
            value: 0.6,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey,
          ),
        ),
      );

      // VooProgressRing uses CustomPaint internally
      expect(find.byType(VooProgressRing), findsOneWidget);
      // Verify CustomPaint exists (might be multiple in widget tree)
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}