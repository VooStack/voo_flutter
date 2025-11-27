library voo_toast;

import 'package:voo_toast/src/presentation/state/voo_toast_controller.dart' show VooToastController;

// Domain - Entities
export 'src/domain/entities/toast.dart';
export 'src/domain/entities/toast_config.dart';
export 'src/domain/entities/toast_style_data.dart';

// Domain - Enums
export 'src/domain/enums/toast_animation.dart';
export 'src/domain/enums/toast_position.dart';
export 'src/domain/enums/toast_style.dart';
export 'src/domain/enums/toast_type.dart';

// Presentation - Previews
export 'src/presentation/previews/toast_preview.dart';
export 'src/presentation/previews/toast_test_page.dart';

// Presentation - State
export 'src/presentation/state/voo_toast_controller.dart';

// Presentation - Styles (for advanced customization)
export 'src/presentation/styles/base_toast_style.dart';

// Presentation - Widgets
export 'src/presentation/widgets/organisms/voo_toast_overlay.dart';

// Convenience global accessor
VooToastController get VooToast => VooToastController.instance;
