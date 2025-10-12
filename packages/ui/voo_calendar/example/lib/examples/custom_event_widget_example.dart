import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';

class CustomEventWidgetExample extends StatefulWidget {
  const CustomEventWidgetExample({super.key});

  @override
  State<CustomEventWidgetExample> createState() => _CustomEventWidgetExampleState();
}

class _CustomEventWidgetExampleState extends State<CustomEventWidgetExample> {
  late VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(initialDate: DateTime.now(), initialView: VooCalendarView.day);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _controller.setEvents([
      VooCalendarEvent.custom(
        id: 'log-1',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        child: _buildCustomLogWidget(icon: Icons.bug_report, level: 'ERROR', message: 'Database connection timeout', color: Colors.red),
        metadata: {'type': 'log', 'level': 'error', 'timestamp': DateTime.now()},
      ),
      VooCalendarEvent.custom(
        id: 'log-1',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        child: _buildCustomLogWidget(icon: Icons.bug_report, level: 'ERROR', message: 'Database connection timeout', color: Colors.red),
        metadata: {'type': 'log', 'level': 'error', 'timestamp': DateTime.now()},
      ),
      VooCalendarEvent.custom(
        id: 'log-1',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        child: _buildCustomLogWidget(icon: Icons.bug_report, level: 'ERROR', message: 'Database connection timeout', color: Colors.red),
        metadata: {'type': 'log', 'level': 'error', 'timestamp': DateTime.now()},
      ),

      VooCalendarEvent.custom(
        id: 'product-1',
        startTime: today.add(const Duration(hours: 12)),
        endTime: today.add(const Duration(hours: 12, minutes: 45)),
        child: _buildCustomProductWidget(productName: 'Organic Almonds', brand: 'Trader Joe\'s', servings: 2.0, calories: 340),
        metadata: {'type': 'product', 'productId': 'prod-123'},
      ),
      VooCalendarEvent.custom(
        id: 'product-1',
        startTime: today.add(const Duration(hours: 12)),
        endTime: today.add(const Duration(hours: 12, minutes: 45)),
        child: _buildCustomProductWidget(productName: 'Organic Almonds', brand: 'Trader Joe\'s', servings: 2.0, calories: 340),
        metadata: {'type': 'product', 'productId': 'prod-123'},
      ),
      VooCalendarEvent.custom(
        id: 'product-1',
        startTime: today.add(const Duration(hours: 12)),
        endTime: today.add(const Duration(hours: 12, minutes: 45)),
        child: _buildCustomProductWidget(productName: 'Organic Almonds', brand: 'Trader Joe\'s', servings: 2.0, calories: 340),
        metadata: {'type': 'product', 'productId': 'prod-123'},
      ),

      VooCalendarEvent.custom(
        id: 'workout-1',
        startTime: today.add(const Duration(hours: 15)),
        endTime: today.add(const Duration(hours: 16)),
        child: _buildCustomWorkoutWidget(exercise: 'HIIT Training', duration: 60, caloriesBurned: 450, intensity: 'High'),
        metadata: {'type': 'workout', 'workoutId': 'workout-456'},
      ),

      VooCalendarEvent.custom(
        id: 'notification-1',
        startTime: today.add(const Duration(hours: 17)),
        endTime: today.add(const Duration(hours: 17, minutes: 15)),
        child: _buildCustomNotificationWidget(title: 'Backup Complete', message: 'System backup completed successfully', icon: Icons.backup, color: Colors.green),
        metadata: {'type': 'notification', 'notificationId': 'notif-789'},
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
      appBar: AppBar(title: const Text('Custom Event Widgets')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade100,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade900),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '✨ Just use VooCalendarEvent.custom with a child widget - the calendar handles the rest automatically!',
                    style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: VooCalendar(
              controller: _controller,
              initialView: VooCalendarView.day,
              headerBuilder: (context, date) => const SizedBox(),
              availableViews: const [VooCalendarView.day],
              // ✨ Use eventHeightBuilder to set heights based on event type
              dayViewConfig: VooDayViewConfig(
                initialScrollHour: 8,
                eventHeightBuilder: (event) {
                  // Custom widgets with child get specific heights
                  if (event.child != null) {
                    // Check metadata to determine event type
                    final type = event.metadata?['type'];
                    if (type == 'log') return 100.0; // Error logs
                    if (type == 'product') return 130.0; // Product widgets
                    if (type == 'workout') return 120.0; // Workout widgets
                    if (type == 'notification') return 90.0; // Notifications
                  }
                  // Default events use minimum height
                  return 80.0;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomLogWidget({required IconData icon, required String level, required String message, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  level,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomProductWidget({required String productName, required String brand, required double servings, required int calories}) {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.shade600, Colors.green.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  productName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(brand, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            '$servings servings • $calories cal',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomWorkoutWidget({required String exercise, required int duration, required int caloriesBurned, required String intensity}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade900, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  exercise,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(spacing: 8, children: [_buildWorkoutBadge('$duration min'), _buildWorkoutBadge('$caloriesBurned cal'), _buildWorkoutBadge(intensity)]),
        ],
      ),
    );
  }

  Widget _buildWorkoutBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCustomNotificationWidget({required String title, required String message, required IconData icon, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
