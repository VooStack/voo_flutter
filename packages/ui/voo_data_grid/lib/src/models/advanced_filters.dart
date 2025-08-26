/// Advanced filter models for VooDataGrid with secondary filter support

/// Logic operators for combining filters
enum FilterLogic {
  and,
  or,
}

/// Secondary filter for compound filtering
class SecondaryFilter {
  final FilterLogic logic;
  final dynamic value;
  final String operator;

  const SecondaryFilter({
    required this.logic,
    required this.value,
    required this.operator,
  });

  Map<String, dynamic> toJson() => {
        'logic': logic == FilterLogic.and ? 'And' : 'Or',
        'value': value,
        'operator': operator,
      };

  factory SecondaryFilter.fromJson(Map<String, dynamic> json) {
    return SecondaryFilter(
      logic: json['logic'] == 'And' ? FilterLogic.and : FilterLogic.or,
      value: json['value'],
      operator: json['operator'],
    );
  }
}

/// Base class for all filter types
abstract class BaseFilter {
  final String fieldName;
  final dynamic value;
  final String operator;
  final SecondaryFilter? secondaryFilter;

  const BaseFilter({
    required this.fieldName,
    required this.value,
    required this.operator,
    this.secondaryFilter,
  });

  Map<String, dynamic> toJson() => {
        'fieldName': fieldName,
        'value': value,
        'operator': operator,
        if (secondaryFilter != null) 'secondaryFilter': secondaryFilter!.toJson(),
      };
}

/// String filter implementation
class StringFilter extends BaseFilter {
  const StringFilter({
    required String fieldName,
    required String value,
    required String operator,
    SecondaryFilter? secondaryFilter,
  }) : super(
          fieldName: fieldName,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        );

  factory StringFilter.fromJson(Map<String, dynamic> json) {
    return StringFilter(
      fieldName: json['fieldName'],
      value: json['value'],
      operator: json['operator'],
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'])
          : null,
    );
  }
}

/// Integer filter implementation
class IntFilter extends BaseFilter {
  const IntFilter({
    required String fieldName,
    required int value,
    required String operator,
    SecondaryFilter? secondaryFilter,
  }) : super(
          fieldName: fieldName,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        );

  factory IntFilter.fromJson(Map<String, dynamic> json) {
    return IntFilter(
      fieldName: json['fieldName'],
      value: json['value'] is int ? json['value'] : int.parse(json['value'].toString()),
      operator: json['operator'],
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'])
          : null,
    );
  }
}

/// Date filter implementation
class DateFilter extends BaseFilter {
  const DateFilter({
    required String fieldName,
    required String value,
    required String operator,
    SecondaryFilter? secondaryFilter,
  }) : super(
          fieldName: fieldName,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        );

  factory DateFilter.fromJson(Map<String, dynamic> json) {
    return DateFilter(
      fieldName: json['fieldName'],
      value: json['value'],
      operator: json['operator'],
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'])
          : null,
    );
  }
}

/// Decimal filter implementation
class DecimalFilter extends BaseFilter {
  const DecimalFilter({
    required String fieldName,
    required double value,
    required String operator,
    SecondaryFilter? secondaryFilter,
  }) : super(
          fieldName: fieldName,
          value: value,
          operator: operator,
          secondaryFilter: secondaryFilter,
        );

  factory DecimalFilter.fromJson(Map<String, dynamic> json) {
    return DecimalFilter(
      fieldName: json['fieldName'],
      value: json['value'] is double ? json['value'] : double.parse(json['value'].toString()),
      operator: json['operator'],
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'])
          : null,
    );
  }
}

/// Advanced filter request combining all filter types
class AdvancedFilterRequest {
  final List<StringFilter> stringFilters;
  final List<IntFilter> intFilters;
  final List<DateFilter> dateFilters;
  final List<DecimalFilter> decimalFilters;
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
      return {
        ...legacyFilters!,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (sortBy != null) 'sortBy': sortBy,
        'sortDescending': sortDescending,
      };
    }

    // Otherwise use the advanced format
    return {
      if (stringFilters.isNotEmpty)
        'stringFilters': stringFilters.map((f) => f.toJson()).toList(),
      if (intFilters.isNotEmpty)
        'intFilters': intFilters.map((f) => f.toJson()).toList(),
      if (dateFilters.isNotEmpty)
        'dateFilters': dateFilters.map((f) => f.toJson()).toList(),
      if (decimalFilters.isNotEmpty)
        'decimalFilters': decimalFilters.map((f) => f.toJson()).toList(),
      'logic': logic == FilterLogic.and ? 'And' : 'Or',
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDescending': sortDescending,
    };
  }

  factory AdvancedFilterRequest.fromJson(Map<String, dynamic> json) {
    // Check if it's an advanced format or legacy format
    bool isAdvancedFormat = json.containsKey('stringFilters') ||
        json.containsKey('intFilters') ||
        json.containsKey('dateFilters') ||
        json.containsKey('decimalFilters');

    if (!isAdvancedFormat) {
      // Legacy format - extract known fields and put the rest in legacyFilters
      final legacyFields = <String, dynamic>{};
      json.forEach((key, value) {
        if (!['pageNumber', 'pageSize', 'sortBy', 'sortDescending'].contains(key)) {
          legacyFields[key] = value;
        }
      });

      return AdvancedFilterRequest(
        pageNumber: json['pageNumber'] ?? 1,
        pageSize: json['pageSize'] ?? 20,
        sortBy: json['sortBy'],
        sortDescending: json['sortDescending'] ?? false,
        legacyFilters: legacyFields,
      );
    }

    // Advanced format
    return AdvancedFilterRequest(
      stringFilters: (json['stringFilters'] as List<dynamic>?)
              ?.map((f) => StringFilter.fromJson(f))
              .toList() ??
          [],
      intFilters: (json['intFilters'] as List<dynamic>?)
              ?.map((f) => IntFilter.fromJson(f))
              .toList() ??
          [],
      dateFilters: (json['dateFilters'] as List<dynamic>?)
              ?.map((f) => DateFilter.fromJson(f))
              .toList() ??
          [],
      decimalFilters: (json['decimalFilters'] as List<dynamic>?)
              ?.map((f) => DecimalFilter.fromJson(f))
              .toList() ??
          [],
      logic: json['logic'] == 'Or' ? FilterLogic.or : FilterLogic.and,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      sortBy: json['sortBy'],
      sortDescending: json['sortDescending'] ?? false,
    );
  }

  /// Check if this request has any filters
  bool get hasFilters =>
      stringFilters.isNotEmpty ||
      intFilters.isNotEmpty ||
      dateFilters.isNotEmpty ||
      decimalFilters.isNotEmpty ||
      (legacyFilters?.isNotEmpty ?? false);

  /// Create a legacy-compatible filter request
  factory AdvancedFilterRequest.legacy({
    required Map<String, dynamic> filters,
    required int pageNumber,
    required int pageSize,
    String? sortBy,
    bool sortDescending = false,
  }) {
    return AdvancedFilterRequest(
      legacyFilters: filters,
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortBy: sortBy,
      sortDescending: sortDescending,
    );
  }
}