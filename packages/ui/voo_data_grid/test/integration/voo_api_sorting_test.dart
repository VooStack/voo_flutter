import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooApiStandard Sorting', () {
    test('should include sortBy and sortDescending in request', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.voo, fieldPrefix: 'Site');

      // Test ascending sort
      var request = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {},
        sorts: [const VooColumnSort(field: 'siteNumber', direction: VooSortDirection.ascending)],
      );

      // print('Request with ascending sort: $request');
      expect(request['sortBy'], 'Site.SiteNumber'); // Should be PascalCase
      expect(request['sortDescending'], false);

      // Test descending sort
      request = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {},
        sorts: [const VooColumnSort(field: 'siteName', direction: VooSortDirection.descending)],
      );

      // print('Request with descending sort: $request');
      expect(request['sortBy'], 'Site.SiteName');
      expect(request['sortDescending'], true);

      // Test no sort
      request = builder.buildRequest(page: 0, pageSize: 20, filters: {}, sorts: []);

      // print('Request with no sort: $request');
      expect(request.containsKey('sortBy'), false);
      expect(request.containsKey('sortDescending'), false);
    });

    test('should handle multiple sorts but only use first one', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.voo);

      final request = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {},
        sorts: [
          const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          const VooColumnSort(field: 'date', direction: VooSortDirection.descending),
        ],
      );

      // VooApiStandard only supports single sort
      expect(request['sortBy'], 'name');
      expect(request['sortDescending'], false);
    });

    test('should not filter out none direction before sending', () {
      const builder = DataGridRequestBuilder(standard: ApiFilterStandard.voo);

      // None direction should be filtered out before reaching buildRequest
      final request = builder.buildRequest(
        page: 0,
        pageSize: 20,
        filters: {},
        sorts: [
          const VooColumnSort(
            field: 'name',
            direction: VooSortDirection.none, // This should not happen in practice
          ),
        ],
      );

      // If a none sort somehow makes it here, it should still process it
      expect(request['sortBy'], 'name');
      expect(request['sortDescending'], false); // none defaults to ascending
    });
  });
}
