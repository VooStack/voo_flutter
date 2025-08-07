import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:voo_analytics/src/presentation/widgets/touch_tracker_widget.dart';
import 'package:voo_analytics/src/voo_analytics_plugin.dart';
import 'package:voo_logging/voo_logging.dart';

/// A widget that tracks touches and captures screenshots for each route
class RouteAwareTouchTracker extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final bool captureScreenshots;
  
  const RouteAwareTouchTracker({
    super.key,
    required this.child,
    this.enabled = true,
    this.captureScreenshots = true,
  });

  @override
  State<RouteAwareTouchTracker> createState() => _RouteAwareTouchTrackerState();
}

class _RouteAwareTouchTrackerState extends State<RouteAwareTouchTracker> with RouteAware {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  RouteObserver<ModalRoute>? _routeObserver;
  String _currentRoute = '/';
  bool _hasCaptureedScreenForRoute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = VooAnalyticsPlugin.instance.routeObserver;
    final route = ModalRoute.of(context);
    if (route != null && _routeObserver != null) {
      _routeObserver!.subscribe(this, route);
      _updateCurrentRoute();
    }
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateCurrentRoute();
    _captureScreenshot();
  }

  @override
  void didPopNext() {
    _updateCurrentRoute();
    _captureScreenshot();
  }

  void _updateCurrentRoute() {
    final route = ModalRoute.of(context);
    if (route?.settings.name != null) {
      setState(() {
        _currentRoute = route!.settings.name!;
        _hasCaptureedScreenForRoute = false;
      });
    }
  }

  Future<void> _captureScreenshot() async {
    if (!widget.captureScreenshots || _hasCaptureedScreenForRoute) return;
    
    // Wait for the frame to render
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    try {
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        _sendScreenshotToDevTools(bytes, image.width, image.height);
        _hasCaptureedScreenForRoute = true;
      }
    } catch (e) {
      // Ignore errors in screenshot capture
      debugPrint('Failed to capture screenshot: $e');
    }
  }

  void _sendScreenshotToDevTools(Uint8List imageBytes, int width, int height) {
    // Convert to base64 for transmission
    final base64Image = Uri.dataFromBytes(imageBytes, mimeType: 'image/png').toString();
    
    VooLogger.info(
      'Route Screenshot: $_currentRoute',
      category: 'analytics',
      metadata: {
        'type': 'route_screenshot',
        'route': _currentRoute,
        'screenshot': base64Image,
        'width': width,
        'height': height,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: TouchTrackerWidget(
        screenName: _currentRoute,
        enabled: widget.enabled,
        child: widget.child,
      ),
    );
  }
}

/// Route observer for analytics
class AnalyticsRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteChange(route, 'push');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRouteChange(previousRoute, 'pop');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logRouteChange(newRoute, 'replace');
    }
  }

  void _logRouteChange(Route<dynamic>? route, String action) {
    final routeName = route?.settings.name ?? 'unknown';
    
    VooLogger.info(
      'Route Change: $action -> $routeName',
      category: 'analytics',
      metadata: {
        'type': 'route_change',
        'route': routeName,
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    VooAnalyticsPlugin.instance.logEvent(
      'route_$action',
      parameters: {
        'route': routeName,
      },
    );
  }
}