import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('Advanced OData DataGridRequestBuilder Tests', () {
    group('Complex Real-World Scenarios', () {
      test('should handle e-commerce product filtering scenario', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          fieldPrefix: 'Product',
        );

        final testDate = DateTime(2024);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 50,
          filters: {
            'name': const VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'laptop',
            ),
            'price': const VooDataFilter(
              operator: VooFilterOperator.between,
              value: 500.00,
              valueTo: 2000.00,
            ),
            'category': const VooDataFilter(
              operator: VooFilterOperator.inList,
              value: ['Electronics', 'Computers', 'Accessories'],
            ),
            'inStock': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: true,
            ),
            'releaseDate': VooDataFilter(
              operator: VooFilterOperator.greaterThanOrEqual,
              value: testDate,
            ),
            'discontinuedDate': const VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
          },
          sorts: [
            const VooColumnSort(field: 'price', direction: VooSortDirection.ascending),
            const VooColumnSort(field: 'rating', direction: VooSortDirection.descending),
            const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
          ],
          additionalParams: {
            'includeCount': true,
            'select': ['id', 'name', 'price', 'category', 'inStock', 'rating'],
            'expand': ['manufacturer', 'reviews'],
            'search': 'gaming laptop',
          },
        );

        final params = result['params'] as Map<String, String>;

        // Verify all parameters are present
        expect(params[r'$skip'], '0');
        expect(params[r'$top'], '50');
        expect(params[r'$count'], 'true');
        expect(params[r'$select'], 'id,name,price,category,inStock,rating');
        expect(params[r'$expand'], 'manufacturer,reviews');
        expect(params[r'$search'], '"gaming laptop"');

        // Verify complex filter expression
        final filter = params[r'$filter']!;
        expect(filter, contains("contains(Product.name, 'laptop')"));
        expect(filter, contains('(Product.price ge 500.0 and Product.price le 2000.0)'));
        expect(filter, contains("Product.category in ('Electronics','Computers','Accessories')"));
        expect(filter, contains('Product.inStock eq true'));
        expect(filter, contains('Product.releaseDate ge ${testDate.toUtc().toIso8601String()}'));
        expect(filter, contains('Product.discontinuedDate eq null'));

        // Verify multi-field sorting
        expect(params[r'$orderby'], 'Product.price asc,Product.rating desc,Product.name asc');
      });

      test('should handle financial transaction filtering', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
        );

        final startDate = DateTime(2024);
        final endDate = DateTime(2024, 3, 31);

        final result = builder.buildRequest(
          page: 2,
          pageSize: 100,
          filters: {
            'transactionDate': VooDataFilter(
              operator: VooFilterOperator.between,
              value: startDate,
              valueTo: endDate,
            ),
            'amount': const VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 1000.00,
            ),
            'status': const VooDataFilter(
              operator: VooFilterOperator.notEquals,
              value: 'cancelled',
            ),
            'accountType': const VooDataFilter(
              operator: VooFilterOperator.inList,
              value: ['checking', 'savings', 'investment'],
            ),
            'flaggedForReview': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: false,
            ),
          },
          sorts: [
            const VooColumnSort(
              field: 'transactionDate',
              direction: VooSortDirection.descending,
            ),
          ],
          additionalParams: {
            'includeCount': true,
            'compute': 'amount * exchangeRate as convertedAmount',
            'apply': 'groupby((accountType), aggregate(amount with sum as totalAmount))',
          },
        );

        final params = result['params'] as Map<String, String>;

        expect(params[r'$skip'], '200'); // page 2 * pageSize 100
        expect(params[r'$top'], '100');
        expect(params[r'$count'], 'true');
        expect(params[r'$compute'], 'amount * exchangeRate as convertedAmount');
        expect(params[r'$apply'], 'groupby((accountType), aggregate(amount with sum as totalAmount))');

        final filter = params[r'$filter']!;
        expect(filter, contains('(transactionDate ge ${startDate.toUtc().toIso8601String()} and transactionDate le ${endDate.toUtc().toIso8601String()})'));
        expect(filter, contains('amount gt 1000.0'));
        expect(filter, contains("status ne 'cancelled'"));
        expect(filter, contains("accountType in ('checking','savings','investment')"));
        expect(filter, contains('flaggedForReview eq false'));
      });

      test('should handle user management scenario with OR logic', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 25,
          filters: {
            'role': const VooDataFilter(
              operator: VooFilterOperator.inList,
              value: ['admin', 'moderator'],
            ),
            'isActive': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: true,
            ),
            'lastLoginDate': const VooDataFilter(
              operator: VooFilterOperator.isNotNull,
              value: null,
            ),
          },
          sorts: [
            const VooColumnSort(field: 'lastLoginDate', direction: VooSortDirection.descending),
          ],
          additionalParams: {
            'logicalOperator': 'or', // Use OR instead of AND
            'select': ['id', 'username', 'email', 'role', 'isActive'],
            'expand': 'permissions',
          },
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // With OR logic
        expect(filter, contains(' or '));
        expect(filter, contains("role in ('admin','moderator')"));
        expect(filter, contains('isActive eq true'));
        expect(filter, contains('lastLoginDate ne null'));
      });
    });

    group('Special Characters and Edge Cases', () {
      test('should handle special characters in string values', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final specialStrings = [
          "O'Reilly's Books & Media",
          'He said "Hello"',
          'Line1\nLine2',
          'Tab\tSeparated',
          'Path\\to\\file',
          '100% discount',
          r'Price: $99.99',
          '#hashtag @mention',
          'Smith, John & Jane',
        ];

        for (final str in specialStrings) {
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'name': VooDataFilter(
                operator: VooFilterOperator.equals,
                value: str,
              ),
            },
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          final filter = params[r'$filter']!;

          // Check that special characters are properly escaped
          final escaped = str.replaceAll("'", "''");
          expect(filter, equals("name eq '$escaped'"));
        }
      });

      test('should handle very long field names and values', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          fieldPrefix: 'VeryLongPrefixForNestedObjectProperties',
        );

        const veryLongFieldName = 'thisIsAVeryLongFieldNameThatMightBeUsedInEnterpriseApplicationsWithComplexDataModels';
        final veryLongValue = 'A' * 1000; // 1000 character string

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            veryLongFieldName: VooDataFilter(
              operator: VooFilterOperator.contains,
              value: veryLongValue,
            ),
          },
          sorts: [
            const VooColumnSort(field: veryLongFieldName, direction: VooSortDirection.ascending),
          ],
        );

        final params = result['params'] as Map<String, String>;
        const expectedField = 'VeryLongPrefixForNestedObjectProperties.$veryLongFieldName';

        expect(params[r'$filter'], contains("contains($expectedField, '$veryLongValue')"));
        expect(params[r'$orderby'], contains('$expectedField asc'));
      });

      test('should handle empty and null values correctly', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'emptyString': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: '',
            ),
            'nullField': const VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
            'notNullField': const VooDataFilter(
              operator: VooFilterOperator.isNotNull,
              value: null,
            ),
          },
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        expect(filter, contains("emptyString eq ''"));
        expect(filter, contains('nullField eq null'));
        expect(filter, contains('notNullField ne null'));
      });

      test('should handle numeric edge cases', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'zero': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 0,
            ),
            'negative': const VooDataFilter(
              operator: VooFilterOperator.lessThan,
              value: -100.5,
            ),
            'veryLarge': const VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 9999999999999.99,
            ),
            'verySmall': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 0.00000001,
            ),
          },
          sorts: [],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        expect(filter, contains('zero eq 0'));
        expect(filter, contains('negative lt -100.5'));
        expect(filter, contains('veryLarge gt 9999999999999.99'));
        // Very small numbers may be formatted in scientific notation
        expect(
          filter,
          anyOf(
            contains('verySmall eq 0.00000001'),
            contains('verySmall eq 1e-8'),
          ),
        );
      });
    });

    group('DataGridRequestBuilder Integration Tests', () {
      test('should switch between different API standards', () {
        final filters = {
          'status': const VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'active',
          ),
          'age': const VooDataFilter(
            operator: VooFilterOperator.greaterThan,
            value: 25,
          ),
        };
        final sorts = [
          const VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
        ];

        // Test each API standard
        for (final standard in ApiFilterStandard.values) {
          final builder = DataGridRequestBuilder(standard: standard);
          final result = builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: filters,
            sorts: sorts,
          );

          expect(result, isNotNull);
          expect(result, isA<Map<String, dynamic>>());

          // Each standard should produce different output format
          switch (standard) {
            case ApiFilterStandard.simple:
              expect(result.containsKey('params'), true);
              final params = result['params'] as Map<String, String>;
              expect(params['status'], 'active');
              expect(params['age_gt'], '25');
              break;
            case ApiFilterStandard.jsonApi:
              expect(result.containsKey('params'), true);
              final params = result['params'] as Map<String, String>;
              expect(params.containsKey('filter[status]'), true);
              expect(params.containsKey('filter[age][gt]'), true);
              break;
            case ApiFilterStandard.odata:
              expect(result.containsKey('params'), true);
              final params = result['params'] as Map<String, String>;
              expect(params[r'$filter'], "status eq 'active' and age gt 25");
              break;
            case ApiFilterStandard.mongodb:
              expect(result.containsKey('body'), true);
              final body = result['body'] as Map<String, dynamic>;
              expect(body['query']['status'], 'active');
              expect(body['query']['age'], {r'$gt': 25});
              break;
            case ApiFilterStandard.graphql:
              expect(result.containsKey('variables'), true);
              final variables = result['variables'] as Map<String, dynamic>;
              expect(variables['where']['status'], {'eq': 'active'});
              expect(variables['where']['age'], {'gt': 25});
              break;
            case ApiFilterStandard.voo:
              expect(result['stringFilters'], isNotNull);
              expect(result['intFilters'], isNotNull);
              break;
            case ApiFilterStandard.custom:
              expect(result.containsKey('filters'), true);
              expect(result.containsKey('sorts'), true);
              break;
          }
        }
      });

      test('should maintain field prefix across all operations', () {
        const builder = DataGridRequestBuilder(
          standard: ApiFilterStandard.odata,
          fieldPrefix: 'Entity.Nested',
        );

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'field1': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'value1',
            ),
            'field2': const VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'search',
            ),
          },
          sorts: [
            const VooColumnSort(field: 'field1', direction: VooSortDirection.ascending),
            const VooColumnSort(field: 'field2', direction: VooSortDirection.descending),
          ],
        );

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;
        final orderby = params[r'$orderby']!;

        // All fields should have the prefix
        expect(filter, contains("Entity.Nested.field1 eq 'value1'"));
        expect(filter, contains("contains(Entity.Nested.field2, 'search')"));
        expect(orderby, equals('Entity.Nested.field1 asc,Entity.Nested.field2 desc'));
      });

      test('should handle RemoteDataGridSource with OData', () {
        final source = RemoteDataGridSource(
          apiEndpoint: 'https://api.example.com/odata/products',
          apiStandard: ApiFilterStandard.odata,
          fieldPrefix: 'Product',
          headers: {
            'Authorization': 'Bearer token123',
            'X-API-Version': '2.0',
          },
        );

        expect(source.apiStandard, ApiFilterStandard.odata);
        expect(source.fieldPrefix, 'Product');
        expect(source.headers!['Authorization'], 'Bearer token123');
        expect(source.requestBuilder.standard, ApiFilterStandard.odata);
        expect(source.requestBuilder.fieldPrefix, 'Product');
      });
    });

    group('OData Response Parsing Tests', () {
      test('should parse complex OData response with all metadata', () {
        final response = {
          '@odata.context': r'$metadata#Products',
          '@odata.count': 500,
          '@odata.nextLink': r'Products?$skip=50&$top=50',
          '@odata.deltaLink': r'Products?$deltatoken=abc123',
          'value': [
            {
              '@odata.id': 'Products(1)',
              '@odata.editLink': 'Products(1)',
              '@odata.etag': 'W/"datetime\'2024-01-01T00:00:00\'"',
              'id': 1,
              'name': 'Product 1',
              'price': 99.99,
              'category': {
                '@odata.id': 'Categories(1)',
                'id': 1,
                'name': 'Electronics',
              },
            },
            {
              '@odata.id': 'Products(2)',
              '@odata.editLink': 'Products(2)',
              'id': 2,
              'name': 'Product 2',
              'price': 149.99,
            },
          ],
        };

        final parsed = DataGridRequestBuilder.parseODataResponse(
          json: response,
          pageSize: 50,
        );

        expect(parsed.rows.length, 2);
        expect(parsed.totalRows, 500);
        expect(parsed.page, 0);
        expect(parsed.pageSize, 50);

        // Check first row data
        final firstRow = parsed.rows[0] as Map<String, dynamic>;
        expect(firstRow['id'], 1);
        expect(firstRow['name'], 'Product 1');
        expect(firstRow['price'], 99.99);
        expect(firstRow['category']['name'], 'Electronics');

        // Extract metadata
        final metadata = DataGridRequestBuilder.extractODataMetadata(response);
        expect(metadata['@odata.context'], r'$metadata#Products');
        expect(metadata['@odata.count'], 500);
        expect(metadata['@odata.nextLink'], r'Products?$skip=50&$top=50');
        expect(metadata['@odata.deltaLink'], r'Products?$deltatoken=abc123');
        expect(metadata['hasNextPage'], true);
        expect(metadata['hasDeltaLink'], true);
      });

      test('should handle nested OData error responses', () {
        final errorResponse = {
          'error': {
            'code': 'ValidationError',
            'message': 'One or more validation errors occurred.',
            'details': [
              {
                'code': 'RangeError',
                'target': 'price',
                'message': 'The field Price must be between 0 and 10000.',
              },
              {
                'code': 'RequiredError',
                'target': 'name',
                'message': 'The Name field is required.',
              },
            ],
            'innererror': {
              'message': 'Inner error details',
              'type': 'System.ArgumentException',
              'stacktrace': 'at ProductController.Post()...',
            },
          },
        };

        final error = DataGridRequestBuilder.parseODataError(errorResponse);

        expect(error, isNotNull);
        expect(error!['code'], 'ValidationError');
        expect(error['message'], 'One or more validation errors occurred.');
        expect(error['details'], isA<List>());
        expect((error['details'] as List).length, 2);

        final firstDetail = (error['details'] as List)[0];
        expect(firstDetail['code'], 'RangeError');
        expect(firstDetail['target'], 'price');
      });

      test('should handle empty OData response', () {
        final emptyResponse = {
          '@odata.context': r'$metadata#Products',
          'value': [],
        };

        final parsed = DataGridRequestBuilder.parseODataResponse(
          json: emptyResponse,
        );

        expect(parsed.rows, isEmpty);
        expect(parsed.totalRows, 0);
        expect(parsed.page, 0);
        expect(parsed.pageSize, 20); // default
      });
    });

    group('Performance and Large Dataset Tests', () {
      test('should handle large number of filters efficiently', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        // Create 100 filters
        final filters = <String, VooDataFilter>{};
        for (int i = 0; i < 100; i++) {
          filters['field$i'] = VooDataFilter(
            operator: VooFilterOperator.equals,
            value: 'value$i',
          );
        }

        final stopwatch = Stopwatch()..start();
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: filters,
          sorts: [],
        );
        stopwatch.stop();

        expect(result, isNotNull);
        expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be fast

        final params = result['params'] as Map<String, String>;
        final filter = params[r'$filter']!;

        // Should contain all 100 filters joined with 'and'
        expect(' and '.allMatches(filter).length, 99); // 100 filters = 99 'and' operators
      });

      test('should handle pagination for large datasets', () {
        const builder = DataGridRequestBuilder(standard: ApiFilterStandard.odata);

        // Test different page sizes and pages
        final testCases = [
          {'page': 0, 'pageSize': 10, 'expectedSkip': '0'},
          {'page': 5, 'pageSize': 10, 'expectedSkip': '50'},
          {'page': 99, 'pageSize': 100, 'expectedSkip': '9900'},
          {'page': 1000, 'pageSize': 50, 'expectedSkip': '50000'},
        ];

        for (final testCase in testCases) {
          final result = builder.buildRequest(
            page: testCase['page']! as int,
            pageSize: testCase['pageSize']! as int,
            filters: {},
            sorts: [],
          );

          final params = result['params'] as Map<String, String>;
          expect(params[r'$skip'], testCase['expectedSkip']);
          expect(params[r'$top'], testCase['pageSize'].toString());
        }
      });
    });

    group('Backward Compatibility Tests', () {
      test('should support legacy static method', () {
        final result = DataGridRequestBuilder.buildRequestBody(
          page: 0,
          pageSize: 20,
          filters: {
            'status': const VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
          },
          sorts: [],
        );

        expect(result, isNotNull);
        expect(result['pagination'], isNotNull);
        expect(result['filters'], isNotNull);
      });

      test('should support legacy parseResponse method', () {
        final json = {
          'data': [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
          ],
          'total': 100,
          'page': 0,
          'pageSize': 20,
        };

        final response = DataGridRequestBuilder.parseResponse(
          json: json,
        );

        expect(response.rows.length, 2);
        expect(response.totalRows, 100);
        expect(response.page, 0);
        expect(response.pageSize, 20);
      });

      test('should handle custom data and total keys', () {
        final json = {
          'items': [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
          ],
          'count': 50,
          'currentPage': 2,
          'size': 10,
        };

        final response = DataGridRequestBuilder.parseResponse(
          json: json,
          dataKey: 'items',
          totalKey: 'count',
          pageKey: 'currentPage',
          pageSizeKey: 'size',
        );

        expect(response.rows.length, 2);
        expect(response.totalRows, 50);
        expect(response.page, 2);
        expect(response.pageSize, 10);
      });
    });
  });
}
