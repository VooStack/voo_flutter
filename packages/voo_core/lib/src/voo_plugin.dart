import 'dart:async';

abstract class VooPlugin {
  String get name;
  String get version;
  
  FutureOr<void> onCoreInitialized() {}
  
  void dispose() {}
  
  Map<String, dynamic> getInfo() {
    return {
      'name': name,
      'version': version,
    };
  }
}