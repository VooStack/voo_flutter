import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('VooApiStandard Integration', () {
    test('RemoteDataGridSource should pass sorts to buildRequest', () async {
      // Track the request sent
      Map<String, dynamic>? capturedRequest;
      
      // Create a RemoteDataGridSource with VooApiStandard
      final dataSource = RemoteDataGridSource(
        apiEndpoint: 'https://api.example.com/data',
        apiStandard: ApiFilterStandard.voo,
        fieldPrefix: 'Site',
        httpClient: (url, requestData, headers) async {
          capturedRequest = requestData;
          // Mock response
          return {
            'data': <dynamic>[],
            'total': 0,
            'page': 0,
            'pageSize': 20,
          };
        },
      );

      // Apply a sort
      dataSource.applySort('siteNumber', VooSortDirection.ascending);
      
      // Wait for the data to load
      await dataSource.loadData();
      
      // Verify the request contains sortBy and sortDescending
      expect(capturedRequest, isNotNull);
      // print('Captured request: $capturedRequest');
      expect(capturedRequest!['sortBy'], equals('Site.SiteNumber'));
      expect(capturedRequest!['sortDescending'], equals(false));
      
      // Test descending sort on same field
      dataSource.applySort('siteNumber', VooSortDirection.descending);
      await dataSource.loadData();
      
      expect(capturedRequest!['sortBy'], equals('Site.SiteNumber'));
      expect(capturedRequest!['sortDescending'], equals(true));
      
      // Test sorting a different field
      dataSource.clearSorts();
      dataSource.applySort('siteName', VooSortDirection.ascending);
      await dataSource.loadData();
      
      expect(capturedRequest!['sortBy'], equals('Site.SiteName'));
      expect(capturedRequest!['sortDescending'], equals(false));
      
      // Test clearing sort
      dataSource.applySort('siteName', VooSortDirection.none);
      await dataSource.loadData();
      
      expect(capturedRequest!.containsKey('sortBy'), equals(false));
      expect(capturedRequest!.containsKey('sortDescending'), equals(false));
    });

    test('VooDataGridController sortColumn should trigger API request with sort', () async {
      Map<String, dynamic>? capturedRequest;
      
      final dataSource = RemoteDataGridSource(
        apiEndpoint: 'https://api.example.com/data',
        apiStandard: ApiFilterStandard.voo,
        fieldPrefix: 'Site',
        httpClient: (url, requestData, headers) async {
          capturedRequest = requestData;
          return {
            'data': [
              {'siteNumber': '1001', 'siteName': 'Alpha Site'},
              {'siteNumber': '1002', 'siteName': 'Beta Site'},
            ],
            'total': 2,
            'page': 0,
            'pageSize': 20,
          };
        },
      );

      final controller = VooDataGridController(
        dataSource: dataSource,
        columns: [
          const VooDataColumn<Map<String, dynamic>>(
            field: 'siteNumber',
            label: 'Site Number',
            sortable: true,
          ),
          const VooDataColumn<Map<String, dynamic>>(
            field: 'siteName', 
            label: 'Site Name',
            sortable: true,
          ),
        ],
      );

      // Initial load
      await dataSource.loadData();
      expect(capturedRequest!.containsKey('sortBy'), equals(false));

      // Sort by siteNumber ascending
      controller.sortColumn('siteNumber');
      await Future<void>.delayed(const Duration(milliseconds: 100)); // Wait for async operation
      
      expect(capturedRequest!['sortBy'], equals('Site.SiteNumber'));
      expect(capturedRequest!['sortDescending'], equals(false));

      // Sort by siteNumber descending (second click)
      controller.sortColumn('siteNumber');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      expect(capturedRequest!['sortBy'], equals('Site.SiteNumber'));
      expect(capturedRequest!['sortDescending'], equals(true));

      // Clear sort (third click)
      controller.sortColumn('siteNumber');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      expect(capturedRequest!.containsKey('sortBy'), equals(false));
      expect(capturedRequest!.containsKey('sortDescending'), equals(false));
      
      controller.dispose();
    });
  });
}