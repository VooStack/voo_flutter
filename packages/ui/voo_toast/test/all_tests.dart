import 'package:flutter_test/flutter_test.dart';

// Domain layer tests
import 'domain/entities/toast_test.dart' as toast_entity_test;
import 'domain/entities/toast_config_test.dart' as toast_config_test;
import 'domain/enums/toast_type_test.dart' as toast_type_test;
import 'domain/enums/toast_position_test.dart' as toast_position_test;
import 'domain/enums/toast_animation_test.dart' as toast_animation_test;

// Data layer tests
import 'data/repositories/toast_repository_impl_test.dart' as toast_repository_test;

// Presentation layer tests
import 'presentation/state/voo_toast_controller_test.dart' as toast_controller_test;
import 'presentation/widgets/molecules/voo_toast_card_test.dart' as toast_card_test;
import 'presentation/widgets/organisms/voo_toast_overlay_test.dart' as toast_overlay_test;

// Integration tests
import 'integration/toast_integration_test.dart' as integration_test;

void main() {
  group('VooToast Package Tests', () {
    group('Domain Layer', () {
      group('Entities', () {
        toast_entity_test.main();
        toast_config_test.main();
      });

      group('Enums', () {
        toast_type_test.main();
        toast_position_test.main();
        toast_animation_test.main();
      });
    });

    group('Data Layer', () {
      group('Repositories', () {
        toast_repository_test.main();
      });
    });

    group('Presentation Layer', () {
      group('State Management', () {
        toast_controller_test.main();
      });

      group('Widgets', () {
        toast_card_test.main();
        toast_overlay_test.main();
      });
    });

    group('Integration', () {
      integration_test.main();
    });
  });
}