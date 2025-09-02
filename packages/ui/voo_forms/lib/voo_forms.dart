library voo_forms;

// Domain entities
export 'src/domain/entities/field_change.dart';
export 'src/domain/entities/field_type.dart';
export 'src/domain/entities/form.dart' hide VooForm; // Hide domain VooForm, use widget VooForm
export 'src/domain/entities/form_config.dart';
export 'src/domain/entities/form_field.dart';
export 'src/domain/entities/form_header.dart';
export 'src/domain/entities/form_section.dart';
export 'src/domain/entities/validation_rule.dart';

// Domain enums
export 'src/domain/enums/error_display_mode.dart';
export 'src/domain/enums/field_variant.dart';
export 'src/domain/enums/focus_behavior.dart';
export 'src/domain/enums/label_position.dart';
export 'src/domain/enums/label_style.dart';
export 'src/domain/enums/validation_trigger.dart';

// Presentation - State Management
export 'src/presentation/state/voo_form_controller.dart';

// Presentation - Atoms (Base Components)
export 'src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

// Presentation - Config
export 'src/presentation/widgets/config/voo_field_options.dart';

// Presentation - Molecules (Field Components)
export 'src/presentation/widgets/molecules/fields/voo_boolean_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_checkbox_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_currency_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_date_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_decimal_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_dropdown_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_email_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_form_header.dart';
export 'src/presentation/widgets/molecules/fields/voo_form_section_divider.dart';
export 'src/presentation/widgets/molecules/fields/voo_integer_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_list_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_multiline_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_number_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_password_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_percentage_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_phone_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_radio_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_slider_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_switch_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_text_field.dart';
export 'src/presentation/widgets/molecules/fields/voo_time_field.dart';

// Presentation - Molecules (Form Components)

// Presentation - Organisms (Complex Forms)
export 'src/presentation/widgets/organisms/forms/voo_form.dart';

// Utilities
export 'src/utils/form_theme.dart';
export 'src/utils/form_utils.dart';
export 'src/utils/formatters.dart';

// Individual formatters
export 'src/utils/formatters/case_formatter.dart';
export 'src/utils/formatters/credit_card_formatter.dart';
export 'src/utils/formatters/currency_formatter.dart';
export 'src/utils/formatters/date_formatter.dart';
export 'src/utils/formatters/international_phone_formatter.dart';
export 'src/utils/formatters/mask_formatter.dart';
export 'src/utils/formatters/pattern_formatter.dart';
export 'src/utils/formatters/percentage_formatter.dart';
export 'src/utils/formatters/phone_number_formatter.dart';
export 'src/utils/formatters/ssn_formatter.dart';
export 'src/utils/formatters/zip_code_formatter.dart';
export 'src/utils/validators.dart';
