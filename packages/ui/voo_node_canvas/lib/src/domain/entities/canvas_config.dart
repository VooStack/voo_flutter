import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/enums/connection_style.dart';

/// Configuration for the node canvas.
///
/// This class defines the global settings that control the behavior
/// and appearance of the canvas and its elements.
class CanvasConfig extends Equatable {
  /// Creates a canvas configuration.
  const CanvasConfig({
    this.gridSize = 20.0,
    this.showGrid = true,
    this.snapToGrid = false,
    this.minZoom = 0.25,
    this.maxZoom = 2.0,
    this.initialZoom = 1.0,
    this.gridColor,
    this.backgroundColor,
    this.connectionStyle = ConnectionStyle.bezier,
    this.connectionColor,
    this.connectionStrokeWidth = 2.0,
    this.connectionHitTolerance = 10.0,
    this.portRadius = 6.0,
    this.portColor,
    this.selectedColor,
    this.enablePan = true,
    this.enableZoom = true,
    this.enableNodeDrag = true,
    this.enableMarqueeSelection = true,
    this.marqueeColor,
    this.marqueeRequiresContain = false,
    this.portHitTolerance = 20.0,
    this.portHighlightColor,
  }) : assert(minZoom > 0 && minZoom <= maxZoom, 'Invalid zoom range'),
       assert(portHitTolerance > 0, 'Port hit tolerance must be positive'),
       assert(initialZoom >= minZoom && initialZoom <= maxZoom,
           'Initial zoom must be within min/max range'),
       assert(gridSize > 0, 'Grid size must be positive'),
       assert(portRadius > 0, 'Port radius must be positive'),
       assert(connectionStrokeWidth > 0, 'Connection stroke width must be positive');

  /// The size of the grid cells in logical pixels.
  final double gridSize;

  /// Whether to show the background grid.
  final bool showGrid;

  /// Whether to snap nodes to the grid when dragging.
  final bool snapToGrid;

  /// The minimum zoom level allowed.
  final double minZoom;

  /// The maximum zoom level allowed.
  final double maxZoom;

  /// The initial zoom level.
  final double initialZoom;

  /// The color of the grid lines.
  final Color? gridColor;

  /// The background color of the canvas.
  final Color? backgroundColor;

  /// The default style for connections.
  final ConnectionStyle connectionStyle;

  /// The default color for connections.
  final Color? connectionColor;

  /// The default stroke width for connections.
  final double connectionStrokeWidth;

  /// The hit tolerance for detecting clicks on connections.
  ///
  /// Larger values make it easier to click on thin connection lines.
  /// Default is 10.0 pixels.
  final double connectionHitTolerance;

  /// The radius of port indicators.
  final double portRadius;

  /// The default color for ports.
  final Color? portColor;

  /// The color used to indicate selection.
  final Color? selectedColor;

  /// Whether panning the canvas is enabled.
  final bool enablePan;

  /// Whether zooming the canvas is enabled.
  final bool enableZoom;

  /// Whether dragging nodes is enabled.
  final bool enableNodeDrag;

  /// Whether marquee (drag-to-select) selection is enabled.
  ///
  /// When enabled, dragging on empty canvas creates a selection rectangle
  /// that selects all nodes and connections within it.
  final bool enableMarqueeSelection;

  /// The color of the marquee selection rectangle.
  ///
  /// If null, uses the theme's primary color with reduced opacity.
  final Color? marqueeColor;

  /// Whether marquee selection requires nodes to be fully contained.
  ///
  /// If true, nodes must be fully inside the selection rectangle.
  /// If false (default), nodes only need to intersect the rectangle.
  final bool marqueeRequiresContain;

  /// The hit detection tolerance for ports in logical pixels.
  ///
  /// Larger values make it easier to click on ports.
  /// Default is 20.0 pixels.
  final double portHitTolerance;

  /// The color used for port highlight effects (hover, valid connection target).
  ///
  /// If null, uses a lighter version of the port color.
  final Color? portHighlightColor;

  /// Creates a copy of this config with optional new values.
  CanvasConfig copyWith({
    double? gridSize,
    bool? showGrid,
    bool? snapToGrid,
    double? minZoom,
    double? maxZoom,
    double? initialZoom,
    Color? gridColor,
    Color? backgroundColor,
    ConnectionStyle? connectionStyle,
    Color? connectionColor,
    double? connectionStrokeWidth,
    double? connectionHitTolerance,
    double? portRadius,
    Color? portColor,
    Color? selectedColor,
    bool? enablePan,
    bool? enableZoom,
    bool? enableNodeDrag,
    bool? enableMarqueeSelection,
    Color? marqueeColor,
    bool? marqueeRequiresContain,
    double? portHitTolerance,
    Color? portHighlightColor,
  }) =>
      CanvasConfig(
        gridSize: gridSize ?? this.gridSize,
        showGrid: showGrid ?? this.showGrid,
        snapToGrid: snapToGrid ?? this.snapToGrid,
        minZoom: minZoom ?? this.minZoom,
        maxZoom: maxZoom ?? this.maxZoom,
        initialZoom: initialZoom ?? this.initialZoom,
        gridColor: gridColor ?? this.gridColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        connectionStyle: connectionStyle ?? this.connectionStyle,
        connectionColor: connectionColor ?? this.connectionColor,
        connectionStrokeWidth: connectionStrokeWidth ?? this.connectionStrokeWidth,
        connectionHitTolerance:
            connectionHitTolerance ?? this.connectionHitTolerance,
        portRadius: portRadius ?? this.portRadius,
        portColor: portColor ?? this.portColor,
        selectedColor: selectedColor ?? this.selectedColor,
        enablePan: enablePan ?? this.enablePan,
        enableZoom: enableZoom ?? this.enableZoom,
        enableNodeDrag: enableNodeDrag ?? this.enableNodeDrag,
        enableMarqueeSelection:
            enableMarqueeSelection ?? this.enableMarqueeSelection,
        marqueeColor: marqueeColor ?? this.marqueeColor,
        marqueeRequiresContain:
            marqueeRequiresContain ?? this.marqueeRequiresContain,
        portHitTolerance: portHitTolerance ?? this.portHitTolerance,
        portHighlightColor: portHighlightColor ?? this.portHighlightColor,
      );

  @override
  List<Object?> get props => [
        gridSize,
        showGrid,
        snapToGrid,
        minZoom,
        maxZoom,
        initialZoom,
        gridColor,
        backgroundColor,
        connectionStyle,
        connectionColor,
        connectionStrokeWidth,
        connectionHitTolerance,
        portRadius,
        portColor,
        selectedColor,
        enablePan,
        enableZoom,
        enableNodeDrag,
        enableMarqueeSelection,
        marqueeColor,
        marqueeRequiresContain,
        portHitTolerance,
        portHighlightColor,
      ];
}
