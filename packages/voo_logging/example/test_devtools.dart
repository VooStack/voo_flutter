import 'dart:async';
import 'dart:developer' as developer;
import 'package:voo_logging/voo_logging.dart';

Future<void> main() async {
  // Initialize the logger
  await VooLogger.initialize(appName: 'DevTools Test App', appVersion: '1.0.0');

  // Create a periodic timer to generate logs
  int counter = 0;
  Timer.periodic(const Duration(seconds: 2), (timer) {
    counter++;

    // Generate different types of logs
    switch (counter % 6) {
      case 0:
        VooLogger.verbose('Verbose log #$counter', category: 'Timer', tag: 'Test');
        break;
      case 1:
        VooLogger.debug('Debug log #$counter', category: 'Timer', tag: 'Test');
        break;
      case 2:
        VooLogger.info('Info log #$counter', category: 'Timer', tag: 'Test');
        break;
      case 3:
        VooLogger.warning('Warning log #$counter', category: 'Timer', tag: 'Test');
        break;
      case 4:
        VooLogger.error('Error log #$counter', category: 'Timer', tag: 'Test');
        break;
      case 5:
        VooLogger.fatal('Fatal log #$counter', category: 'Timer', tag: 'Test');
        break;
    }

    // Also test with different categories
    if (counter % 3 == 0) {
      VooLogger.info('Network request to API', category: 'Network', tag: 'HTTP');
    }

    if (counter % 4 == 0) {
      VooLogger.info('User clicked button', category: 'Analytics', tag: 'UserAction');
    }

    if (counter % 5 == 0) {
      VooLogger.performance('Database query', const Duration(milliseconds: 123), metrics: {'rows': 100, 'cache_hit': true});
    }

    // Stop after 20 iterations
    if (counter >= 20) {
      timer.cancel();
      developer.log('Test completed. Check DevTools extension to see the logs.');
    }
  });

  developer.log('Generating test logs... Open DevTools extension to see them.');
}
