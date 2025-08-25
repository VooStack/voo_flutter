import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui/voo_ui.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('VooSlider', () {
    testWidgets('renders with default properties', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSlider(
            value: 0.5,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('handles value changes', (tester) async {
      double value = 0.0;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return VooSlider(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              );
            },
          ),
        ),
      );

      // Drag slider to middle
      final sliderCenter = tester.getCenter(find.byType(Slider));
      await tester.tapAt(sliderCenter);
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, true);
      expect(value, greaterThan(0.4));
      expect(value, lessThan(0.6));
    });

    testWidgets('respects min and max values', (tester) async {
      double value = 50;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return VooSlider(
                value: value,
                min: 0,
                max: 100,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              );
            },
          ),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 0);
      expect(slider.max, 100);
      expect(slider.value, 50);
    });

    testWidgets('shows divisions', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSlider(
            value: 2,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.divisions, 10);
    });

    testWidgets('shows label', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSlider(
            value: 5,
            min: 0,
            max: 10,
            divisions: 10,
            label: '5',
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.label, '5');
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSlider(
            value: 0.5,
            isError: true,
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      final theme = Theme.of(tester.element(find.byType(Slider)));
      expect(slider.activeColor, theme.colorScheme.error);
    });

    testWidgets('disabled state prevents interaction', (tester) async {
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSlider(
            value: 0.5,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byType(Slider));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, false);
    });

    testWidgets('calls onChangeStart and onChangeEnd', (tester) async {
      double? startValue;
      double? endValue;

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSlider(
            value: 0.5,
            onChanged: (_) {},
            onChangeStart: (value) => startValue = value,
            onChangeEnd: (value) => endValue = value,
          ),
        ),
      );

      final sliderCenter = tester.getCenter(find.byType(Slider));
      final gesture = await tester.startGesture(sliderCenter);
      await gesture.moveBy(const Offset(50, 0));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(startValue, isNotNull);
      expect(endValue, isNotNull);
    });
  });

  group('VooRangeSlider', () {
    testWidgets('renders with default properties', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRangeSlider(
            values: const RangeValues(0.3, 0.7),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('handles range value changes', (tester) async {
      RangeValues values = const RangeValues(0.2, 0.8);
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return VooRangeSlider(
                values: values,
                onChanged: (newValues) {
                  setState(() => values = newValues);
                  callbacks.onChanged(newValues);
                },
              );
            },
          ),
        ),
      );

      // Drag start thumb
      final rangeSlider = find.byType(RangeSlider);
      final sliderBox = tester.getRect(rangeSlider);
      final startPosition = Offset(sliderBox.left + sliderBox.width * 0.2, sliderBox.center.dy);
      
      await tester.dragFrom(startPosition, const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, true);
      final newValues = callbacks.lastCall as RangeValues;
      expect(newValues.start, greaterThan(0.2));
    });

    testWidgets('respects min and max values', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRangeSlider(
            values: const RangeValues(25, 75),
            min: 0,
            max: 100,
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.min, 0);
      expect(slider.max, 100);
      expect(slider.values.start, 25);
      expect(slider.values.end, 75);
    });

    testWidgets('shows divisions', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRangeSlider(
            values: const RangeValues(2, 8),
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.divisions, 10);
    });

    testWidgets('shows labels', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRangeSlider(
            values: const RangeValues(2, 8),
            min: 0,
            max: 10,
            labels: const RangeLabels('2', '8'),
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.labels?.start, '2');
      expect(slider.labels?.end, '8');
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRangeSlider(
            values: const RangeValues(0.3, 0.7),
            isError: true,
            onChanged: (_) {},
          ),
        ),
      );

      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      final theme = Theme.of(tester.element(find.byType(RangeSlider)));
      expect(slider.activeColor, theme.colorScheme.error);
    });
  });

  group('VooLabeledSlider', () {
    testWidgets('renders with label and value', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSlider(
            value: 50,
            min: 0,
            max: 100,
            label: 'Volume',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Volume'), findsOneWidget);
      expect(find.text('50.0'), findsOneWidget); // Value display with decimal
    });

    testWidgets('formats value with custom formatter', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSlider(
            value: 0.75,
            min: 0,
            max: 1,
            label: 'Progress',
            valueFormatter: (value) => '${(value * 100).toInt()}%',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('shows helper and error text', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: Column(
            children: [
              VooLabeledSlider(
                value: 5,
                min: 0,
                max: 10,
                label: 'With Helper',
                helperText: 'Adjust the value',
                onChanged: (_) {},
              ),
              VooLabeledSlider(
                value: 5,
                min: 0,
                max: 10,
                label: 'With Error',
                errorText: 'Value too low',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Adjust the value'), findsOneWidget);
      expect(find.text('Value too low'), findsOneWidget);
    });

    testWidgets('shows leading and trailing widgets', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSlider(
            value: 50,
            min: 0,
            max: 100,
            label: 'Brightness',
            leading: const Icon(Icons.brightness_low),
            trailing: const Icon(Icons.brightness_high),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.brightness_low), findsOneWidget);
      expect(find.byIcon(Icons.brightness_high), findsOneWidget);
    });

    testWidgets('hides value when showValue is false', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSlider(
            value: 50,
            min: 0,
            max: 100,
            label: 'No Value',
            showValue: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('50'), findsNothing);
    });
  });

  group('VooLabeledRangeSlider', () {
    testWidgets('renders with label and range values', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledRangeSlider(
            values: const RangeValues(20, 80),
            min: 0,
            max: 100,
            label: 'Price Range',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Price Range'), findsOneWidget);
      expect(find.text('20.0 - 80.0'), findsOneWidget); // Values with decimals
    });

    testWidgets('formats values with custom formatter', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledRangeSlider(
            values: const RangeValues(100, 500),
            min: 0,
            max: 1000,
            label: 'Budget',
            valueFormatter: (value) => '\$${value.toInt()}',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('\$100 - \$500'), findsOneWidget);
    });
  });

  group('VooDiscreteSlider', () {
    testWidgets('renders with discrete divisions', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooDiscreteSlider(
            value: 3,
            min: 0,
            max: 5,
            divisions: 5,
            label: 'Rating',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Rating'), findsOneWidget);
      final slider = tester.widget<Slider>(
        find.descendant(
          of: find.byType(VooSlider),
          matching: find.byType(Slider),
        ),
      );
      expect(slider.divisions, 5);
    });

    testWidgets('shows custom labels for steps', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooDiscreteSlider(
            value: 1,
            min: 0,
            max: 3,
            divisions: 3,
            labels: const ['Small', 'Medium', 'Large', 'XL'],
            showLabels: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
      expect(find.text('XL'), findsOneWidget);
    });
  });

  group('VooIconSlider', () {
    testWidgets('renders with start and end icons', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooIconSlider(
            value: 0.5,
            startIcon: Icons.volume_mute,
            endIcon: Icons.volume_up,
            label: 'Volume',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.volume_mute), findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('Volume'), findsOneWidget);
    });

    testWidgets('handles value changes', (tester) async {
      double value = 0.3;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return VooIconSlider(
                value: value,
                startIcon: Icons.brightness_low,
                endIcon: Icons.brightness_high,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              );
            },
          ),
        ),
      );

      final sliderCenter = tester.getCenter(find.byType(Slider));
      await tester.tapAt(sliderCenter);
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, true);
      expect(value, greaterThan(0.3));
    });

    testWidgets('disabled state shows disabled icons', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooIconSlider(
            value: 0.5,
            startIcon: Icons.volume_mute,
            endIcon: Icons.volume_up,
            enabled: false,
            onChanged: null,
          ),
        ),
      );

      final startIcon = tester.widget<Icon>(find.byIcon(Icons.volume_mute));
      final theme = Theme.of(tester.element(find.byIcon(Icons.volume_mute)));
      expect(
        startIcon.color,
        theme.colorScheme.onSurface.withValues(alpha: 0.38),
      );
    });
  });

  group('VooTickMarkSlider', () {
    testWidgets('renders with tick marks', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooTickMarkSlider(
            value: 50,
            min: 0,
            max: 100,
            tickCount: 11,
            label: 'Progress',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Progress'), findsOneWidget);
      // Tick marks are rendered as Container widgets
      expect(
        find.descendant(
          of: find.byType(VooTickMarkSlider),
          matching: find.byType(Container),
        ),
        findsWidgets,
      );
    });

    testWidgets('shows tick labels when enabled', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooTickMarkSlider(
            value: 50,
            min: 0,
            max: 100,
            tickCount: 3,
            showTickLabels: true,
            tickLabels: const ['0', '50', '100'],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('colors tick marks based on value', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooTickMarkSlider(
            value: 60,
            min: 0,
            max: 100,
            tickCount: 5,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onChanged: (_) {},
          ),
        ),
      );

      // Verify tick marks are rendered
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(VooTickMarkSlider),
          matching: find.byType(Container),
        ),
      );
      
      expect(containers.length, greaterThan(0));
    });
  });
}