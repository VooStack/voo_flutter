import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_chip.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('VooFilterChip', () {
    testWidgets('should display label only when value is null', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const VooFilterChip(
            label: 'Status',
          ),
        ),
      );
      
      // Assert
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Status: '), findsNothing);
    });
    
    testWidgets('should display label and value when value is provided', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const VooFilterChip(
            label: 'Status',
            value: 'Active',
          ),
        ),
      );
      
      // Assert
      expect(find.text('Status: Active'), findsOneWidget);
      expect(find.text('Status'), findsNothing);
      expect(find.text('Active'), findsNothing);
    });
    
    testWidgets('should show delete icon when onDeleted is provided', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: VooFilterChip(
            label: 'Category',
            value: 'Electronics',
            onDeleted: () {},
          ),
        ),
      );
      
      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
    
    testWidgets('should not show delete icon when onDeleted is null', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const VooFilterChip(
            label: 'Category',
            value: 'Electronics',
          ),
        ),
      );
      
      // Assert
      expect(find.byIcon(Icons.close), findsNothing);
    });
    
    testWidgets('should call onDeleted callback when delete icon is tapped', (tester) async {
      // Arrange
      bool wasDeleted = false;
      
      await tester.pumpWidget(
        makeTestableWidget(
          child: VooFilterChip(
            label: 'Price',
            value: '> 100',
            onDeleted: () => wasDeleted = true,
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      
      // Assert
      expect(wasDeleted, isTrue);
    });
    
    testWidgets('should use custom label style', (tester) async {
      // Arrange
      const customStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      );
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const VooFilterChip(
            label: 'Custom',
            labelStyle: customStyle,
          ),
        ),
      );
      
      // Assert
      final text = tester.widget<Text>(find.text('Custom'));
      expect(text.style?.fontSize, equals(14));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
      expect(text.style?.color, equals(Colors.blue));
    });
    
    testWidgets('should use default label style with fontSize 12', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const VooFilterChip(
            label: 'Default',
          ),
        ),
      );
      
      // Assert
      final text = tester.widget<Text>(find.text('Default'));
      expect(text.style?.fontSize, equals(12));
    });
    
    testWidgets('should use custom delete icon size', (tester) async {
      // Arrange
      const customSize = 20.0;
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: VooFilterChip(
            label: 'Test',
            onDeleted: () {},
            deleteIconSize: customSize,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(icon.size, equals(customSize));
    });
    
    testWidgets('should use default delete icon size of 16', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: VooFilterChip(
            label: 'Test',
            onDeleted: () {},
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(icon.size, equals(16));
    });
    
    testWidgets('should render InputChip with compact visual density', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const VooFilterChip(
            label: 'Compact',
          ),
        ),
      );
      
      // Assert
      final inputChip = tester.widget<InputChip>(find.byType(InputChip));
      expect(inputChip.visualDensity, equals(VisualDensity.compact));
      expect(inputChip.materialTapTargetSize, equals(MaterialTapTargetSize.shrinkWrap));
    });
    
    group('edge cases', () {
      testWidgets('should handle empty label', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const VooFilterChip(
              label: '',
            ),
          ),
        );
        
        // Assert
        expect(find.text(''), findsOneWidget);
      });
      
      testWidgets('should handle empty value', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const VooFilterChip(
              label: 'Field',
              value: '',
            ),
          ),
        );
        
        // Assert
        expect(find.text('Field: '), findsOneWidget);
      });
      
      testWidgets('should handle very long label and value', (tester) async {
        // Arrange
        const longLabel = 'This is a very long filter label';
        const longValue = 'This is an extremely long filter value that might overflow';
        
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const VooFilterChip(
              label: longLabel,
              value: longValue,
            ),
          ),
        );
        
        // Assert
        expect(find.text('$longLabel: $longValue'), findsOneWidget);
      });
    });
    
    group('accessibility', () {
      testWidgets('should be findable by type', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const VooFilterChip(
              label: 'Test',
            ),
          ),
        );
        
        // Assert
        expect(find.byType(VooFilterChip), findsOneWidget);
      });
      
      testWidgets('should render InputChip widget', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const VooFilterChip(
              label: 'Test',
            ),
          ),
        );
        
        // Assert
        expect(find.byType(InputChip), findsOneWidget);
      });
    });
  });
}