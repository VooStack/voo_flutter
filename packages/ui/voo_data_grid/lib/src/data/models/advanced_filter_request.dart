import 'package:voo_data_grid/src/data/models/bool_filter.dart';
import 'package:voo_data_grid/src/data/models/date_filter.dart';
import 'package:voo_data_grid/src/data/models/decimal_filter.dart';
import 'package:voo_data_grid/src/data/models/filter_logic.dart';
import 'package:voo_data_grid/src/data/models/int_filter.dart';
import 'package:voo_data_grid/src/data/models/string_filter.dart';

/// Advanced filter request combining all filter types
class AdvancedFilterRequest {
  final List<StringFilter> stringFilters;
  final List<IntFilter> intFilters;
  final List<DateFilter> dateFilters;
  final List<DecimalFilter> decimalFilters;
  final List<BoolFilter> boolFilters;
  final FilterLogic logic;
  final int pageNumber;
  final int pageSize;
  final String? sortBy;
  final bool sortDescending;

  /// Legacy simple filters for backward compatibility
  final Map<String, dynamic>? legacyFilters;

  const AdvancedFilterRequest({
    this.stringFilters = const [],
    this.intFilters = const [],
    this.dateFilters = const [],
    this.decimalFilters = const [],
    this.boolFilters = const [],
    this.logic = FilterLogic.and,
    this.pageNumber = 1,
    this.pageSize = 20,
    this.sortBy,
    this.sortDescending = false,
    this.legacyFilters,
  });

  Map<String, dynamic> toJson() {
    // If we have legacy filters, use the simple format
    if (legacyFilters != null && legacyFilters!.isNotEmpty) {
      return {...legacyFilters!, 'pageNumber': pageNumber, 'pageSize': pageSize, if (sortBy != null) 'sortBy': sortBy, 'sortDescending': sortDescending};
    }

    // Otherwise use the advanced format
    return {
      if (stringFilters.isNotEmpty) 'stringFilters': stringFilters.map((f) => f.toJson()).toList(),
      if (intFilters.isNotEmpty) 'intFilters': intFilters.map((f) => f.toJson()).toList(),
      if (dateFilters.isNotEmpty) 'dateFilters': dateFilters.map((f) => f.toJson()).toList(),
      if (decimalFilters.isNotEmpty) 'decimalFilters': decimalFilters.map((f) => f.toJson()).toList(),
      if (boolFilters.isNotEmpty) 'boolFilters': boolFilters.map((f) => f.toJson()).toList(),
      'logic': logic == FilterLogic.and ? 'And' : 'Or',
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDescending': sortDescending,
    };
  }

  factory AdvancedFilterRequest.fromJson(Map<String, dynamic> json) {
    // Check if it's an advanced format or legacy format
    final bool isAdvancedFormat =
        json.containsKey('stringFilters') ||
        json.containsKey('intFilters') ||
        json.containsKey('dateFilters') ||
        json.containsKey('decimalFilters') ||
        json.containsKey('boolFilters');

    if (!isAdvancedFormat) {
      // Legacy format - extract known fields and put the rest in legacyFilters
      final legacyFields = <String, dynamic>{};
      json.forEach((key, value) {
        if (!['pageNumber', 'pageSize', 'sortBy', 'sortDescending'].contains(key)) {
          legacyFields[key] = value;
        }
      });

      return AdvancedFilterRequest(
        pageNumber: (json['pageNumber'] as int?) ?? 1,
        pageSize: (json['pageSize'] as int?) ?? 20,
        sortBy: json['sortBy'] as String?,
        sortDescending: (json['sortDescending'] as bool?) ?? false,
        legacyFilters: legacyFields,
      );
    }

    // Advanced format
    return AdvancedFilterRequest(
      stringFilters: (json['stringFilters'] as List<dynamic>?)?.map((f) => StringFilter.fromJson(f as Map<String, dynamic>)).toList() ?? [],
      intFilters: (json['intFilters'] as List<dynamic>?)?.map((f) => IntFilter.fromJson(f as Map<String, dynamic>)).toList() ?? [],
      dateFilters: (json['dateFilters'] as List<dynamic>?)?.map((f) => DateFilter.fromJson(f as Map<String, dynamic>)).toList() ?? [],
      decimalFilters: (json['decimalFilters'] as List<dynamic>?)?.map((f) => DecimalFilter.fromJson(f as Map<String, dynamic>)).toList() ?? [],
      boolFilters: (json['boolFilters'] as List<dynamic>?)?.map((f) => BoolFilter.fromJson(f as Map<String, dynamic>)).toList() ?? [],
      logic: json['logic'] == 'Or' ? FilterLogic.or : FilterLogic.and,
      pageNumber: (json['pageNumber'] as int?) ?? 1,
      pageSize: (json['pageSize'] as int?) ?? 20,
      sortBy: json['sortBy'] as String?,
      sortDescending: (json['sortDescending'] as bool?) ?? false,
    );
  }

  /// Check if this request has any filters
  bool get hasFilters =>
      stringFilters.isNotEmpty ||
      intFilters.isNotEmpty ||
      dateFilters.isNotEmpty ||
      decimalFilters.isNotEmpty ||
      boolFilters.isNotEmpty ||
      (legacyFilters?.isNotEmpty ?? false);

  /// Create a legacy-compatible filter request
  factory AdvancedFilterRequest.legacy({
    required Map<String, dynamic> filters,
    required int pageNumber,
    required int pageSize,
    String? sortBy,
    bool sortDescending = false,
  }) => AdvancedFilterRequest(legacyFilters: filters, pageNumber: pageNumber, pageSize: pageSize, sortBy: sortBy, sortDescending: sortDescending);
}
