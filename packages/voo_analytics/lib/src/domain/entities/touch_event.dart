import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TouchEvent extends Equatable {
  final String id;
  final DateTime timestamp;
  final Offset position;
  final String screenName;
  final String? widgetType;
  final String? widgetKey;
  final TouchType type;
  final Map<String, dynamic>? metadata;

  const TouchEvent({
    required this.id,
    required this.timestamp,
    required this.position,
    required this.screenName,
    this.widgetType,
    this.widgetKey,
    required this.type,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'x': position.dx,
      'y': position.dy,
      'screen_name': screenName,
      if (widgetType != null) 'widget_type': widgetType,
      if (widgetKey != null) 'widget_key': widgetKey,
      'type': type.name,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory TouchEvent.fromMap(Map<String, dynamic> map) {
    return TouchEvent(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      position: Offset(
        (map['x'] as num).toDouble(),
        (map['y'] as num).toDouble(),
      ),
      screenName: map['screen_name'] as String,
      widgetType: map['widget_type'] as String?,
      widgetKey: map['widget_key'] as String?,
      type: TouchType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TouchType.tap,
      ),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        timestamp,
        position,
        screenName,
        widgetType,
        widgetKey,
        type,
        metadata,
      ];
}

enum TouchType {
  tap,
  doubleTap,
  longPress,
  panStart,
  panUpdate,
  panEnd,
  scaleStart,
  scaleUpdate,
  scaleEnd,
}