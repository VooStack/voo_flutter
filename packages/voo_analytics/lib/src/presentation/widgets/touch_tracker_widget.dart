import 'package:flutter/material.dart';
import 'package:voo_analytics/src/domain/entities/touch_event.dart';
import 'package:voo_analytics/src/voo_analytics_plugin.dart';
import 'package:voo_analytics/src/data/repositories/analytics_repository_impl.dart';

class TouchTrackerWidget extends StatefulWidget {
  final Widget child;
  final String screenName;
  final bool enabled;

  const TouchTrackerWidget({
    super.key,
    required this.child,
    required this.screenName,
    this.enabled = true,
  });

  @override
  State<TouchTrackerWidget> createState() => _TouchTrackerWidgetState();
}

class _TouchTrackerWidgetState extends State<TouchTrackerWidget> {
  Offset? _lastPosition;

  void _logTouchEvent(
    Offset position,
    TouchType type, {
    String? widgetType,
    String? widgetKey,
  }) {
    if (!widget.enabled || !VooAnalyticsPlugin.instance.isInitialized) {
      return;
    }

    // Use last known position for end events if position is zero
    final effectivePosition = (position == Offset.zero && _lastPosition != null)
        ? _lastPosition!
        : position;

    // Update last position if not zero
    if (position != Offset.zero) {
      _lastPosition = position;
    }

    final event = TouchEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      position: effectivePosition,
      screenName: widget.screenName,
      type: type,
      widgetType: widgetType,
      widgetKey: widgetKey,
    );

    final repository = VooAnalyticsPlugin.instance.repository;
    if (repository is AnalyticsRepositoryImpl) {
      repository.logTouchEvent(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        _logTouchEvent(details.localPosition, TouchType.tap);
      },
      onDoubleTapDown: (details) {
        _logTouchEvent(details.localPosition, TouchType.doubleTap);
      },
      onLongPressStart: (details) {
        _logTouchEvent(details.localPosition, TouchType.longPress);
      },
      onScaleStart: (details) {
        // Scale gestures handle both pan and scale
        if (details.pointerCount == 1) {
          _logTouchEvent(details.localFocalPoint, TouchType.panStart);
        } else {
          _logTouchEvent(details.localFocalPoint, TouchType.scaleStart);
        }
      },
      onScaleUpdate: (details) {
        // Throttle update events - only log every 10th update to avoid overwhelming
        if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
          if (details.pointerCount == 1) {
            _logTouchEvent(details.localFocalPoint, TouchType.panUpdate);
          } else {
            _logTouchEvent(details.localFocalPoint, TouchType.scaleUpdate);
          }
        }
        // Always update last position
        _lastPosition = details.localFocalPoint;
      },
      onScaleEnd: (details) {
        if (details.pointerCount == 1) {
          _logTouchEvent(Offset.zero, TouchType.panEnd);
        } else {
          _logTouchEvent(Offset.zero, TouchType.scaleEnd);
        }
      },
      child: widget.child,
    );
  }
}

class TouchableWidget extends StatelessWidget {
  final Widget child;
  final String widgetType;
  final String? widgetKey;
  final VoidCallback? onTap;

  const TouchableWidget({
    super.key,
    required this.child,
    required this.widgetType,
    this.widgetKey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (VooAnalyticsPlugin.instance.isInitialized) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;
            final center = Offset(
              position.dx + size.width / 2,
              position.dy + size.height / 2,
            );

            final screenName =
                ModalRoute.of(context)?.settings.name ?? 'unknown';

            final event = TouchEvent(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              timestamp: DateTime.now(),
              position: center,
              screenName: screenName,
              type: TouchType.tap,
              widgetType: widgetType,
              widgetKey: widgetKey,
            );

            final repository = VooAnalyticsPlugin.instance.repository;
            if (repository is AnalyticsRepositoryImpl) {
              repository.logTouchEvent(event);
            }
          }
        }
        onTap?.call();
      },
      child: child,
    );
  }
}
