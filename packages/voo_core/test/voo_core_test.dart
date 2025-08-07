import 'package:flutter_test/flutter_test.dart';
import 'package:voo_core/voo_core.dart';

void main() {
  group('Voo Core Tests', () {
    test('should initialize Voo core', () async {
      await Voo.initializeApp();
      expect(Voo.isInitialized, true);
    });

    test('should register and retrieve plugins', () async {
      await Voo.initializeApp();
      
      final testPlugin = TestPlugin();
      Voo.registerPlugin(testPlugin);
      
      expect(Voo.hasPlugin('test_plugin'), true);
      
      final retrievedPlugin = Voo.getPlugin<TestPlugin>('test_plugin');
      expect(retrievedPlugin, isNotNull);
      expect(retrievedPlugin, equals(testPlugin));
    });

    tearDown(() {
      Voo.dispose();
    });
  });
}

class TestPlugin extends VooPlugin {
  @override
  String get name => 'test_plugin';

  @override
  String get version => '1.0.0';
}