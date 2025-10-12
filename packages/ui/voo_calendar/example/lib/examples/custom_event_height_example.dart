import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';

/// Example demonstrating the RECOMMENDED way to use custom widgets with proper height handling
///
/// THE PROBLEM:
/// When you use custom widgets (like ProductLogListTile), they have their own intrinsic
/// height that might be LARGER than the allocated space. This causes them to overflow
/// into other hour slots, creating visual overlap.
///
/// THE SOLUTION:
/// 1. Extend VooCalendarEventWidget for your custom event widget (RECOMMENDED)
/// 2. Or use eventBuilderWithInfo with ClipRect (alternative)
/// 3. Configure minEventHeight to match your widget's minimum size
/// 4. Enable dynamic height for proper stacking
class CustomEventHeightExample extends StatefulWidget {
  const CustomEventHeightExample({super.key});

  @override
  State<CustomEventHeightExample> createState() => _CustomEventHeightExampleState();
}

class _CustomEventHeightExampleState extends State<CustomEventHeightExample> {
  late VooCalendarController _controller;
  bool _useCorrectImplementation = false;

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(initialDate: DateTime.now(), initialView: VooCalendarView.day);

    // Create events with custom metadata
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _controller.setEvents([
      // Breakfast - 9:00 AM (multiple items at same time)
      VooCalendarEvent(
        id: '1',
        title: 'Creamy Peanut Butter',
        description: '1.5 servings',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        metadata: {'productName': 'Creamy Peanut Butter', 'brand': 'Jif', 'servings': 1.5, 'calories': 285},
      ),
      VooCalendarEvent(
        id: '2',
        title: 'Whole Wheat Bread',
        description: '2 slices',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        metadata: {'productName': 'Whole Wheat Bread', 'brand': 'Nature\'s Own', 'servings': 2.0, 'calories': 140},
      ),
      VooCalendarEvent(
        id: '3',
        title: 'Orange Juice',
        description: '1 cup',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        metadata: {'productName': 'Orange Juice', 'brand': 'Tropicana', 'servings': 1.0, 'calories': 110},
      ),
      // Lunch - 12:00 PM
      VooCalendarEvent(
        id: '4',
        title: 'Classic Potato Chips',
        description: '2.5 servings',
        startTime: today.add(const Duration(hours: 12)),
        endTime: today.add(const Duration(hours: 12, minutes: 30)),
        metadata: {'productName': 'Classic Potato Chips', 'brand': "Lay's", 'servings': 2.5, 'calories': 400},
      ),
      // Snack - 3:00 PM (multiple items at same time)
      VooCalendarEvent(
        id: '5',
        title: 'Greek Yogurt',
        description: '1 container',
        startTime: today.add(const Duration(hours: 15)),
        endTime: today.add(const Duration(hours: 15, minutes: 30)),
        metadata: {'productName': 'Greek Yogurt', 'brand': 'Chobani', 'servings': 1.0, 'calories': 150},
      ),
      VooCalendarEvent(
        id: '6',
        title: 'Mixed Berries',
        description: '0.5 cup',
        startTime: today.add(const Duration(hours: 15)),
        endTime: today.add(const Duration(hours: 15, minutes: 30)),
        metadata: {'productName': 'Mixed Berries', 'brand': 'Dole', 'servings': 0.5, 'calories': 40},
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Event Height Example'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _useCorrectImplementation = !_useCorrectImplementation;
              });
            },
            child: Text(_useCorrectImplementation ? 'Show Problem' : 'Show Solution', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _useCorrectImplementation ? Colors.green.shade100 : Colors.red.shade100,
            child: Row(
              children: [
                Icon(_useCorrectImplementation ? Icons.check_circle : Icons.error, color: _useCorrectImplementation ? Colors.green : Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _useCorrectImplementation ? '✅ CORRECT: Events respect allocated height and don\'t overflow' : '❌ PROBLEM: Events overflow into other hours',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _useCorrectImplementation ? _buildCorrectImplementation() : _buildProblemImplementation()),
        ],
      ),
    );
  }

  /// ❌ WRONG: Using eventBuilder without proper height constraints
  Widget _buildProblemImplementation() {
    return VooCalendar(
      controller: _controller,
      initialView: VooCalendarView.day,
      headerBuilder: (context, date) => const SizedBox(),
      availableViews: const [VooCalendarView.day],

      // ❌ PROBLEM: eventBuilder doesn't provide allocated dimensions
      eventBuilder: (context, event) {
        return _buildProductCard(event);
      },

      dayViewConfig: const VooDayViewConfig(
        hourHeight: 120.0,
        minEventHeight: 50.0,
        eventSpacing: 4.0,
        initialScrollHour: 8, // Scroll to 8 AM to see the 9 AM events
        enableDynamicHeight: true,
        // Even with dynamic height, custom widgets can overflow
        // because they don't know their allocated size
      ),
    );
  }

  /// ✅ CORRECT: Using VooCalendarEventWidget (Recommended approach)
  Widget _buildCorrectImplementation() {
    return VooCalendar(
      controller: _controller,
      initialView: VooCalendarView.day,
      headerBuilder: (context, date) => const SizedBox(),
      availableViews: const [VooCalendarView.day],

      // ✅ SOLUTION: Use VooCalendarEventWidget for automatic dimension handling
      eventBuilderWithInfo: (context, event, renderInfo) {
        return ProductEventWidget(event: event, renderInfo: renderInfo);
      },

      dayViewConfig: const VooDayViewConfig(
        hourHeight: 120.0, // Taller hours to accommodate content
        minEventHeight: 70.0, // Minimum height for each event
        eventSpacing: 8.0,
        initialScrollHour: 8, // Scroll to 8 AM to see the 9 AM events
        enableDynamicHeight: true, // Auto-expand for overlapping events
      ),
    );
  }

  /// Your custom widget (ProductLogListTile equivalent)
  Widget _buildProductCard(VooCalendarEvent event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.metadata?['productName'] ?? event.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              event.metadata?['brand'] ?? '',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${event.metadata?['servings']} servings • ${event.metadata?['calories']} cal',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ RECOMMENDED: Extend VooCalendarEventWidget for custom event rendering
///
/// This is the cleanest and most efficient approach for custom event widgets.
/// VooCalendarEventWidget automatically handles:
/// - Sizing (allocatedHeight, allocatedWidth)
/// - Overflow protection (built-in ClipRect)
/// - Layout constraints
class ProductEventWidget extends VooCalendarEventWidget {
  const ProductEventWidget({super.key, required super.event, required super.renderInfo});

  @override
  Widget buildContent(BuildContext context) {
    // VooCalendarEventWidget automatically wraps this with proper dimensions
    // Just build your content here - no manual sizing needed!
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(8),
        // Add debug border to show the allocated space
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 2),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.metadata?['productName'] ?? event.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              event.metadata?['brand'] ?? '',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${event.metadata?['servings']} servings • ${event.metadata?['calories']} cal',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
