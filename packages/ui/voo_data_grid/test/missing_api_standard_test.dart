import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  test('RemoteDataGridSource without apiStandard should default to custom', () async {
    Map<String, dynamic>? capturedRequest;
    
    // Create without specifying apiStandard
    final dataSource = RemoteDataGridSource(
      apiEndpoint: 'https://api.example.com/data',
      httpClient: (url, requestData, headers) async {
        capturedRequest = requestData;
        return {
          'data': [],
          'total': 0,
          'page': 0,
          'pageSize': 20,
        };
      },
    );

    // Apply a sort
    dataSource.applySort('siteNumber', VooSortDirection.ascending);
    await dataSource.loadData();
    
    // Check what format was used
    // print('Request without apiStandard: $capturedRequest');
    
    // With default (custom) format, sorts would be in a different structure
    expect(capturedRequest!.containsKey('sorts'), equals(true));
    expect(capturedRequest!.containsKey('sortBy'), equals(false));
    expect(capturedRequest!.containsKey('sortDescending'), equals(false));
  });

  test('RemoteDataGridSource with VooApiStandard should use Voo format', () async {
    Map<String, dynamic>? capturedRequest;
    
    // Create with VooApiStandard
    final dataSource = RemoteDataGridSource(
      apiEndpoint: 'https://api.example.com/data',
      apiStandard: ApiFilterStandard.voo, // <-- This is required!
      httpClient: (url, requestData, headers) async {
        capturedRequest = requestData;
        return {
          'data': [],
          'total': 0,
          'page': 0,
          'pageSize': 20,
        };
      },
    );

    // Apply a sort
    dataSource.applySort('siteNumber', VooSortDirection.ascending);
    await dataSource.loadData();
    
    // Check what format was used
    // print('Request with VooApiStandard: $capturedRequest');
    
    // With VooApiStandard, should have sortBy and sortDescending
    expect(capturedRequest!.containsKey('sortBy'), equals(true));
    expect(capturedRequest!.containsKey('sortDescending'), equals(true));
    expect(capturedRequest!['sortBy'], equals('siteNumber'));
    expect(capturedRequest!['sortDescending'], equals(false));
  });
}