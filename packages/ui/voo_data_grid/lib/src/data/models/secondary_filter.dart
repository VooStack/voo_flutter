import 'package:voo_data_grid/src/data/models/filter_logic.dart';

/// Secondary filter for compound filtering
class SecondaryFilter {
  final FilterLogic logic;
  final dynamic value;
  final String operator;

  const SecondaryFilter({required this.logic, required this.value, required this.operator});

  Map<String, dynamic> toJson() => {'logic': logic == FilterLogic.and ? 'And' : 'Or', 'value': value, 'operator': operator};

  factory SecondaryFilter.fromJson(Map<String, dynamic> json) =>
      SecondaryFilter(logic: json['logic'] == 'And' ? FilterLogic.and : FilterLogic.or, value: json['value'], operator: json['operator']?.toString() ?? '');
}
