import 'package:flutter/material.dart';

/// Controller for managing VooMotion animations
class VooMotionController extends ChangeNotifier {
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation> _animations = {};

  /// Get an animation controller by key
  AnimationController? getController(String key) => _controllers[key];

  /// Get an animation by key
  Animation? getAnimation(String key) => _animations[key];

  /// Register an animation controller
  void registerController(String key, AnimationController controller) {
    _controllers[key] = controller;
    notifyListeners();
  }

  /// Register an animation
  void registerAnimation(String key, Animation animation) {
    _animations[key] = animation;
    notifyListeners();
  }

  /// Play an animation
  void play(String key) {
    _controllers[key]?.forward();
  }

  /// Play animation in reverse
  void reverse(String key) {
    _controllers[key]?.reverse();
  }

  /// Reset an animation
  void reset(String key) {
    _controllers[key]?.reset();
  }

  /// Stop an animation
  void stop(String key) {
    _controllers[key]?.stop();
  }

  /// Play all animations
  void playAll() {
    for (final controller in _controllers.values) {
      controller.forward();
    }
  }

  /// Reset all animations
  void resetAll() {
    for (final controller in _controllers.values) {
      controller.reset();
    }
  }

  /// Dispose a specific controller
  void disposeController(String key) {
    _controllers[key]?.dispose();
    _controllers.remove(key);
    _animations.remove(key);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
    super.dispose();
  }
}

/// Provider widget for VooMotionController
class VooMotionProvider extends InheritedWidget {
  final VooMotionController controller;

  const VooMotionProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static VooMotionProvider? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<VooMotionProvider>();

  static VooMotionProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'VooMotionProvider not found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(VooMotionProvider oldWidget) => controller != oldWidget.controller;
}
