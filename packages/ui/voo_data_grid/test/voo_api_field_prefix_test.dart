import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooApiStandard Field Prefix PascalCase', () {
    test('should capitalize field names after prefix in VooApiStandard', () {
      const builder = DataGridRequestBuilder(
        standard: ApiFilterStandard.voo,
        fieldPrefix: 'Site',
      );

      // Test with filter
      final request = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {
          'siteNumber': const VooDataFilter(
            value: 100,
            operator: VooFilterOperator.equals,
          ),
          'siteName': const VooDataFilter(
            value: 'Test',
            operator: VooFilterOperator.contains,
          ),
        },
        sorts: [
          const VooColumnSort(
            field: 'siteNumber',
            direction: VooSortDirection.ascending,
          ),
        ],
      );

      // Check that field names are PascalCase after the prefix
      expect(request['intFilters'], isNotNull);
      expect(request['intFilters'][0]['fieldName'], 'Site.SiteNumber'); // Should be PascalCase
      
      expect(request['stringFilters'], isNotNull);
      expect(request['stringFilters'][0]['fieldName'], 'Site.SiteName'); // Should be PascalCase
      
      expect(request['sortBy'], 'Site.SiteNumber'); // Should be PascalCase
    });

    test('should handle number range with PascalCase fields', () {
      const builder = DataGridRequestBuilder(
        standard: ApiFilterStandard.voo,
        fieldPrefix: 'Site',
      );

      final request = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {
          'siteNumber': const VooDataFilter(
            value: 100,
            valueTo: 200,
            operator: VooFilterOperator.between,
          ),
        },
        sorts: [],
      );

      // Should create two separate filters with PascalCase field names
      expect(request['intFilters'], isNotNull);
      expect(request['intFilters'].length, 2);
      
      // Check first filter (GreaterThanOrEqual)
      expect(request['intFilters'][0]['fieldName'], 'Site.SiteNumber');
      expect(request['intFilters'][0]['operator'], 'GreaterThanOrEqual');
      expect(request['intFilters'][0]['value'], 100);
      
      // Check second filter (LessThanOrEqual)
      expect(request['intFilters'][1]['fieldName'], 'Site.SiteNumber');
      expect(request['intFilters'][1]['operator'], 'LessThanOrEqual');
      expect(request['intFilters'][1]['value'], 200);
    });

    test('should not capitalize for other API standards', () {
      const builder = DataGridRequestBuilder(
        standard: ApiFilterStandard.jsonApi,
        fieldPrefix: 'site',
      );

      final params = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {
          'siteNumber': const VooDataFilter(
            value: 100,
            operator: VooFilterOperator.equals,
          ),
        },
        sorts: [],
      );

      // JSON:API standard should NOT capitalize - field should remain as-is
      expect(params['params'], isNotNull);
      expect(params['params']['filter[site.siteNumber]'], '100'); // Should remain camelCase
    });
  });
}