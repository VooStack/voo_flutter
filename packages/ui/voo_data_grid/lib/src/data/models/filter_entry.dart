import 'package:voo_data_grid/src/data/models/filter_logic.dart';
import 'package:voo_data_grid/src/domain/entities/filter_field_config.dart';

/// Internal filter entry model
class FilterEntry {
  FilterFieldConfig? field;
  String? operator;
  dynamic value;
  dynamic secondaryValue; // For range operations
  FilterLogic logic;

  FilterEntry({this.field, this.operator, this.value, this.secondaryValue, this.logic = FilterLogic.and});
}
