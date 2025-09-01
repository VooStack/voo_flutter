import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/sort_indicator.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('SortIndicator', () {
    testWidgets('should display upward arrow for ascending direction', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.ascending,
          ),
        ),
      );
      
      // Assert
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
      expect(find.byIcon(Icons.unfold_more), findsNothing);
    });
    
    testWidgets('should display downward arrow for descending direction', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.descending,
          ),
        ),
      );
      
      // Assert
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsNothing);
      expect(find.byIcon(Icons.unfold_more), findsNothing);
    });
    
    testWidgets('should display unfold_more icon for none direction', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.none,
          ),
        ),
      );
      
      // Assert
      expect(find.byIcon(Icons.unfold_more), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsNothing);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
    });
    
    testWidgets('should use custom active color for ascending', (tester) async {
      // Arrange
      const customColor = Colors.red;
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.ascending,
            activeColor: customColor,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_upward));
      expect(icon.color, equals(customColor));
    });
    
    testWidgets('should use custom active color for descending', (tester) async {
      // Arrange
      const customColor = Colors.green;
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.descending,
            activeColor: customColor,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_downward));
      expect(icon.color, equals(customColor));
    });
    
    testWidgets('should use custom inactive color for none direction', (tester) async {
      // Arrange
      const customColor = Colors.grey;
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.none,
            inactiveColor: customColor,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.unfold_more));
      expect(icon.color, equals(customColor));
    });
    
    testWidgets('should use theme primary color by default for ascending', (tester) async {
      // Arrange
      final theme = ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
      );
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          theme: theme,
          child: const SortIndicator(
            direction: VooSortDirection.ascending,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_upward));
      expect(icon.color, equals(Colors.blue));
    });
    
    testWidgets('should use custom icon size', (tester) async {
      // Arrange
      const customSize = 24.0;
      
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.ascending,
            iconSize: customSize,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_upward));
      expect(icon.size, equals(customSize));
    });
    
    testWidgets('should use default icon size of 16', (tester) async {
      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: const SortIndicator(
            direction: VooSortDirection.ascending,
          ),
        ),
      );
      
      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_upward));
      expect(icon.size, equals(16.0));
    });
    
    testWidgets('should render correctly in different themes', (tester) async {
      // Test with dark theme
      final darkTheme = ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
        ),
      );
      
      await tester.pumpWidget(
        makeTestableWidget(
          theme: darkTheme,
          child: const SortIndicator(
            direction: VooSortDirection.descending,
          ),
        ),
      );
      
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_downward));
      expect(icon.color, equals(Colors.tealAccent));
    });
    
    group('accessibility', () {
      testWidgets('should be findable by type', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const SortIndicator(
              direction: VooSortDirection.ascending,
            ),
          ),
        );
        
        // Assert
        expect(find.byType(SortIndicator), findsOneWidget);
      });
      
      testWidgets('should render Icon widget', (tester) async {
        // Act
        await tester.pumpWidget(
          makeTestableWidget(
            child: const SortIndicator(
              direction: VooSortDirection.ascending,
            ),
          ),
        );
        
        // Assert
        expect(find.byType(Icon), findsOneWidget);
      });
    });
  });
}