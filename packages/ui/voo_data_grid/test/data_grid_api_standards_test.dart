import 'package:flutter_test/flutter_test.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

void main() {
  group('StandardApiRequestBuilder', () {
    late Map<String, VooDataFilter> testFilters;
    late List<VooColumnSort> testSorts;

    setUp(() {
      testFilters = {
        'status': VooDataFilter(
          operator: VooFilterOperator.equals,
          value: 'active',
        ),
        'age': VooDataFilter(
          operator: VooFilterOperator.greaterThan,
          value: 25,
        ),
        'price': VooDataFilter(
          operator: VooFilterOperator.between,
          value: 100,
          valueTo: 500,
        ),
      };

      testSorts = [
        VooColumnSort(field: 'name', direction: VooSortDirection.ascending),
        VooColumnSort(field: 'date', direction: VooSortDirection.descending),
        VooColumnSort(field: 'price', direction: VooSortDirection.ascending),
      ];
    });

    group('Simple REST Standard', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.simple);
      });

      test('should build simple request with basic pagination', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
        ) as Map<String, String>;

        expect(result['page'], '0');
        expect(result['limit'], '20');
      });

      test('should handle equals filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['status'], 'active');
      });

      test('should handle comparison operators', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'age': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 25,
            ),
            'price': VooDataFilter(
              operator: VooFilterOperator.lessThanOrEqual,
              value: 100,
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['age_gt'], '25');
        expect(result['price_lte'], '100');
      });

      test('should handle between operator', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': VooDataFilter(
              operator: VooFilterOperator.between,
              value: 100,
              valueTo: 500,
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['price_from'], '100');
        expect(result['price_to'], '500');
      });

      test('should handle contains operator', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'john',
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['name_like'], 'john');
      });

      test('should handle sorts with comma separation', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: testSorts,
        ) as Map<String, String>;

        expect(result['sort'], 'name,-date,price');
      });
    });

    group('JSON:API Standard', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.jsonApi);
      });

      test('should use 1-based pagination', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
        ) as Map<String, String>;

        expect(result['page[number]'], '1');
        expect(result['page[size]'], '20');
      });

      test('should handle simple filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['filter[status]'], 'active');
      });

      test('should handle complex filters with operators', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'age': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 25,
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['filter[age][gt]'], '25');
      });

      test('should handle between filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': VooDataFilter(
              operator: VooFilterOperator.between,
              value: 100,
              valueTo: 500,
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['filter[price][between]'], '100');
        expect(result['filter[price][to]'], '500');
      });

      test('should handle sorts with comma separation', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: testSorts,
        ) as Map<String, String>;

        expect(result['sort'], 'name,-date,price');
      });
    });

    group('OData Standard', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.odata);
      });

      test('should build OData query string', () {
        final result = builder.buildRequest(
          page: 1,
          pageSize: 20,
          filters: {},
          sorts: [],
        ) as String;

        expect(result.contains('\$top=20'), isTrue);
        expect(result.contains('\$skip=20'), isTrue);
      });

      test('should handle filters with OData syntax', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
            'age': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 25,
            ),
          },
          sorts: [],
        ) as String;

        expect(result.contains("\$filter=status eq 'active' and age gt 25"), isTrue);
      });

      test('should handle between filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': VooDataFilter(
              operator: VooFilterOperator.between,
              value: 100,
              valueTo: 500,
            ),
          },
          sorts: [],
        ) as String;

        expect(result.contains('(price ge 100 and price le 500)'), isTrue);
      });

      test('should handle contains filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'john',
            ),
          },
          sorts: [],
        ) as String;

        expect(result.contains("contains(name, 'john')"), isTrue);
      });

      test('should handle null filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'deletedAt': VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
            'createdAt': VooDataFilter(
              operator: VooFilterOperator.isNotNull,
              value: null,
            ),
          },
          sorts: [],
        ) as String;

        expect(result.contains('deletedAt eq null'), isTrue);
        expect(result.contains('createdAt ne null'), isTrue);
      });

      test('should handle sorts with OData syntax', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: testSorts,
        ) as String;

        expect(result.contains('\$orderby=name asc,date desc,price asc'), isTrue);
      });
    });

    group('MongoDB/Elasticsearch Standard', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.mongodb);
      });

      test('should build MongoDB request body', () {
        final result = builder.buildRequest(
          page: 1,
          pageSize: 20,
          filters: {},
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['from'], 20);
        expect(result['size'], 20);
      });

      test('should handle filters with MongoDB query syntax', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['query'], isNotNull);
        expect(result['query']['bool']['must'], isA<List>());
        
        final must = result['query']['bool']['must'] as List;
        expect(must.length, 1);
        expect(must[0], {'term': {'status': 'active'}});
      });

      test('should handle range filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'age': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 25,
            ),
            'price': VooDataFilter(
              operator: VooFilterOperator.lessThanOrEqual,
              value: 100,
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        final must = result['query']['bool']['must'] as List;
        expect(must.any((m) => m['range'] != null && m['range']['age'] != null), isTrue);
        expect(must.any((m) => m['range'] != null && m['range']['price'] != null), isTrue);
      });

      test('should handle between filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': VooDataFilter(
              operator: VooFilterOperator.between,
              value: 100,
              valueTo: 500,
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        final must = result['query']['bool']['must'] as List;
        expect(must[0]['range']['price'], {'gte': 100, 'lte': 500});
      });

      test('should handle contains filter', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'john',
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        final must = result['query']['bool']['must'] as List;
        expect(must[0], {'match': {'name': 'john'}});
      });

      test('should handle null filters', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'deletedAt': VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
            'createdAt': VooDataFilter(
              operator: VooFilterOperator.isNotNull,
              value: null,
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        final must = result['query']['bool']['must'] as List;
        expect(must.any((m) => m['bool'] != null && m['bool']['must_not'] != null), isTrue);
        expect(must.any((m) => m['exists'] != null), isTrue);
      });

      test('should handle sorts with MongoDB syntax', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: testSorts,
        ) as Map<String, dynamic>;

        expect(result['sort'], isA<List>());
        final sortList = result['sort'] as List;
        expect(sortList.length, 3);
        expect(sortList[0], {'name': {'order': 'asc'}});
        expect(sortList[1], {'date': {'order': 'desc'}});
        expect(sortList[2], {'price': {'order': 'asc'}});
      });
    });

    group('GraphQL Standard', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.graphql);
      });

      test('should build GraphQL variables with pagination', () {
        final result = builder.buildRequest(
          page: 1,
          pageSize: 20,
          filters: {},
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['first'], 20);
        expect(result['offset'], 20);
      });

      test('should handle filters with GraphQL where clause', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'status': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'active',
            ),
            'age': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 25,
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['where'], isNotNull);
        expect(result['where']['status'], {'_eq': 'active'});
        expect(result['where']['age'], {'_gt': 25});
      });

      test('should handle complex operators', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'john',
            ),
            'email': VooDataFilter(
              operator: VooFilterOperator.startsWith,
              value: 'admin',
            ),
            'role': VooDataFilter(
              operator: VooFilterOperator.endsWith,
              value: 'manager',
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['where']['name'], {'_ilike': '%john%'});
        expect(result['where']['email'], {'_ilike': 'admin%'});
        expect(result['where']['role'], {'_ilike': '%manager'});
      });

      test('should handle between operator', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'price': VooDataFilter(
              operator: VooFilterOperator.between,
              value: 100,
              valueTo: 500,
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['where']['price'], {'_gte': 100, '_lte': 500});
      });

      test('should handle list operators', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'category': VooDataFilter(
              operator: VooFilterOperator.inList,
              value: ['electronics', 'books', 'toys'],
            ),
            'status': VooDataFilter(
              operator: VooFilterOperator.notInList,
              value: ['deleted', 'archived'],
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['where']['category'], {'_in': ['electronics', 'books', 'toys']});
        expect(result['where']['status'], {'_nin': ['deleted', 'archived']});
      });

      test('should handle null operators', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'deletedAt': VooDataFilter(
              operator: VooFilterOperator.isNull,
              value: null,
            ),
            'createdAt': VooDataFilter(
              operator: VooFilterOperator.isNotNull,
              value: null,
            ),
          },
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['where']['deletedAt'], {'_is_null': true});
        expect(result['where']['createdAt'], {'_is_null': false});
      });

      test('should handle sorts with GraphQL orderBy', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: testSorts,
        ) as Map<String, dynamic>;

        expect(result['orderBy'], isA<List>());
        final orderBy = result['orderBy'] as List;
        expect(orderBy.length, 3);
        expect(orderBy[0], {'field': 'NAME', 'direction': 'ASC'});
        expect(orderBy[1], {'field': 'DATE', 'direction': 'DESC'});
        expect(orderBy[2], {'field': 'PRICE', 'direction': 'ASC'});
      });
    });

    group('Custom Standard', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.custom);
      });

      test('should build custom request body', () {
        final result = builder.buildRequest(
          page: 1,
          pageSize: 20,
          filters: {},
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['pagination'], {
          'page': 1,
          'pageSize': 20,
          'offset': 20,
          'limit': 20,
        });
      });

      test('should handle filters in custom format', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: testFilters,
          sorts: [],
        ) as Map<String, dynamic>;

        expect(result['filters'], isA<List>());
        final filters = result['filters'] as List;
        expect(filters.length, 3);
        
        expect(filters.any((f) => 
          f['field'] == 'status' && 
          f['operator'] == 'eq' && 
          f['value'] == 'active'
        ), isTrue);
        
        expect(filters.any((f) => 
          f['field'] == 'age' && 
          f['operator'] == 'gt' && 
          f['value'] == 25
        ), isTrue);
        
        expect(filters.any((f) => 
          f['field'] == 'price' && 
          f['operator'] == 'between' && 
          f['value'] == 100 && 
          f['valueTo'] == 500
        ), isTrue);
      });

      test('should handle sorts in custom format', () {
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: testSorts,
        ) as Map<String, dynamic>;

        expect(result['sorts'], isA<List>());
        final sorts = result['sorts'] as List;
        expect(sorts.length, 3);
        expect(sorts[0], {'field': 'name', 'direction': 'asc'});
        expect(sorts[1], {'field': 'date', 'direction': 'desc'});
        expect(sorts[2], {'field': 'price', 'direction': 'asc'});
      });

      test('should include additional params as metadata', () {
        final additionalParams = {
          'userId': '123',
          'context': 'admin',
        };

        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {},
          sorts: [],
          additionalParams: additionalParams,
        ) as Map<String, dynamic>;

        expect(result['metadata'], additionalParams);
      });
    });

    group('URL Encoding', () {
      test('should URL encode values in simple format', () {
        final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.simple);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'search': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'hello world & special chars',
            ),
            'name': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'John & Jane',
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['search_like'], 'hello+world+%26+special+chars');
        expect(result['name'], 'John+%26+Jane');
      });

      test('should URL encode values in JSON:API format', () {
        final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.jsonApi);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'search': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: 'hello world & special chars',
            ),
            'name': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 'John & Jane',
            ),
          },
          sorts: [],
        ) as Map<String, String>;

        expect(result['filter[search][like]'], 'hello+world+%26+special+chars');
        expect(result['filter[name]'], 'John+%26+Jane');
      });

      test('should escape single quotes in OData format', () {
        final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.odata);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'name': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: "O'Reilly's",
            ),
            'description': VooDataFilter(
              operator: VooFilterOperator.contains,
              value: "It's a 'special' value",
            ),
          },
          sorts: [],
        ) as String;

        expect(result.contains("name eq 'O''Reilly''s'"), isTrue);
        expect(result.contains("contains(description, 'It''s a ''special'' value')"), isTrue);
      });

      test('should handle numeric values without quotes in OData', () {
        final builder = StandardApiRequestBuilder(standard: ApiFilterStandard.odata);
        final result = builder.buildRequest(
          page: 0,
          pageSize: 20,
          filters: {
            'age': VooDataFilter(
              operator: VooFilterOperator.equals,
              value: 25,
            ),
            'price': VooDataFilter(
              operator: VooFilterOperator.greaterThan,
              value: 100.50,
            ),
          },
          sorts: [],
        ) as String;

        expect(result.contains('age eq 25'), isTrue);
        expect(result.contains('price gt 100.5'), isTrue);
      });
    });

    group('Filter Validation', () {
      late StandardApiRequestBuilder builder;

      setUp(() {
        builder = StandardApiRequestBuilder(standard: ApiFilterStandard.custom);
      });

      test('should throw error for numeric operators with non-numeric values', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'age': VooDataFilter(
                operator: VooFilterOperator.greaterThan,
                value: 'not a number',
              ),
            },
            sorts: [],
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('requires numeric value'),
          )),
        );
      });

      test('should accept numeric operators with numeric values', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'age': VooDataFilter(
                operator: VooFilterOperator.greaterThan,
                value: 25,
              ),
              'price': VooDataFilter(
                operator: VooFilterOperator.lessThanOrEqual,
                value: '100.50',
              ),
            },
            sorts: [],
          ),
          returnsNormally,
        );
      });

      test('should throw error for list operators with non-list values', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'categories': VooDataFilter(
                operator: VooFilterOperator.inList,
                value: 'not a list',
              ),
            },
            sorts: [],
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('requires List value'),
          )),
        );
      });

      test('should accept list operators with list values', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'categories': VooDataFilter(
                operator: VooFilterOperator.inList,
                value: ['electronics', 'books'],
              ),
              'tags': VooDataFilter(
                operator: VooFilterOperator.notInList,
                value: ['archived', 'deleted'],
              ),
            },
            sorts: [],
          ),
          returnsNormally,
        );
      });

      test('should throw error for between operator without valueTo', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'price': VooDataFilter(
                operator: VooFilterOperator.between,
                value: 100,
                valueTo: null,
              ),
            },
            sorts: [],
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('requires both value and valueTo'),
          )),
        );
      });

      test('should throw error for between operator with non-numeric valueTo', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'price': VooDataFilter(
                operator: VooFilterOperator.between,
                value: 100,
                valueTo: 'not a number',
              ),
            },
            sorts: [],
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('requires numeric valueTo'),
          )),
        );
      });

      test('should accept between operator with numeric values', () {
        expect(
          () => builder.buildRequest(
            page: 0,
            pageSize: 20,
            filters: {
              'price': VooDataFilter(
                operator: VooFilterOperator.between,
                value: 100,
                valueTo: 500,
              ),
            },
            sorts: [],
          ),
          returnsNormally,
        );
      });

      test('should validate all standards without throwing errors', () {
        for (final standard in ApiFilterStandard.values) {
          final builder = StandardApiRequestBuilder(standard: standard);
          
          // Test with valid filters
          expect(
            () => builder.buildRequest(
              page: 0,
              pageSize: 20,
              filters: {
                'status': VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: 'active',
                ),
                'age': VooDataFilter(
                  operator: VooFilterOperator.greaterThan,
                  value: 25,
                ),
              },
              sorts: [],
            ),
            returnsNormally,
            reason: 'Failed for standard: $standard',
          );
        }
      });
    });

    group('Operator conversions', () {
      test('should handle all filter operators correctly', () {
        final allOperators = [
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
          VooFilterOperator.contains,
          VooFilterOperator.notContains,
          VooFilterOperator.startsWith,
          VooFilterOperator.endsWith,
          VooFilterOperator.greaterThan,
          VooFilterOperator.greaterThanOrEqual,
          VooFilterOperator.lessThan,
          VooFilterOperator.lessThanOrEqual,
          VooFilterOperator.between,
          VooFilterOperator.inList,
          VooFilterOperator.notInList,
          VooFilterOperator.isNull,
          VooFilterOperator.isNotNull,
        ];

        for (final operator in allOperators) {
          // Use appropriate values based on operator type
          dynamic value;
          if (operator == VooFilterOperator.between) {
            value = 1;
          } else if (operator == VooFilterOperator.inList || operator == VooFilterOperator.notInList) {
            value = [1, 2, 3];
          } else if (operator == VooFilterOperator.isNull || operator == VooFilterOperator.isNotNull) {
            value = null;
          } else if (operator == VooFilterOperator.greaterThan || 
                     operator == VooFilterOperator.greaterThanOrEqual ||
                     operator == VooFilterOperator.lessThan ||
                     operator == VooFilterOperator.lessThanOrEqual) {
            value = 10; // Numeric value for numeric operators
          } else {
            value = 'test'; // String value for string operators
          }
          
          final filters = {
            'field': VooDataFilter(
              operator: operator,
              value: value,
              valueTo: operator == VooFilterOperator.between ? 10 : null,
            ),
          };

          // Test with each standard
          for (final standard in ApiFilterStandard.values) {
            final builder = StandardApiRequestBuilder(standard: standard);
            final result = builder.buildRequest(
              page: 0,
              pageSize: 20,
              filters: filters,
              sorts: [],
            );

            // Just ensure no exceptions are thrown
            expect(result, isNotNull);
          }
        }
      });
    });
  });
}