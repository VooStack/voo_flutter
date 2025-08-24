import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// VooEmptyState Previews
@Preview(name: 'VooEmptyState - Basic')
Widget vooEmptyStateBasic() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No Messages',
            message: 'You have no messages at this time',
          ),
        ),
      ),
    );

@Preview(name: 'VooEmptyState - With Action')
Widget vooEmptyStateWithAction() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooEmptyState(
            icon: Icons.search_off,
            title: 'No Results Found',
            message: 'Try adjusting your search criteria',
            action: ElevatedButton(
              onPressed: () {},
              child: const Text('Clear Filters'),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooEmptyState - Error State')
Widget vooEmptyStateError() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooEmptyState(
            icon: Icons.error_outline,
            title: 'Something Went Wrong',
            message: 'We encountered an error loading your data',
            action: TextButton(
              onPressed: () {},
              child: const Text('Try Again'),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'VooEmptyState - No Data')
Widget vooEmptyStateNoData() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooEmptyState(
            icon: Icons.folder_open,
            title: 'No Files',
            message: 'This folder is empty',
          ),
        ),
      ),
    );

// VooStatusBadge Previews
@Preview(name: 'VooStatusBadge - Success')
Widget vooStatusBadgeSuccess() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooStatusBadge(
            statusCode: 200,
          ),
        ),
      ),
    );

@Preview(name: 'VooStatusBadge - Client Error')
Widget vooStatusBadgeClientError() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooStatusBadge(
            statusCode: 404,
          ),
        ),
      ),
    );

@Preview(name: 'VooStatusBadge - Server Error')
Widget vooStatusBadgeServerError() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooStatusBadge(
            statusCode: 500,
          ),
        ),
      ),
    );

@Preview(name: 'VooStatusBadge - Redirect')
Widget vooStatusBadgeRedirect() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: VooStatusBadge(
            statusCode: 301,
          ),
        ),
      ),
    );

@Preview(name: 'VooStatusBadge - Compact')
Widget vooStatusBadgeCompact() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VooStatusBadge(
                statusCode: 200,
                compact: true,
              ),
              SizedBox(height: 8),
              VooStatusBadge(
                statusCode: 404,
                compact: true,
              ),
              SizedBox(height: 8),
              VooStatusBadge(
                statusCode: 500,
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );

@Preview(name: 'VooStatusBadge - Various Codes')
Widget vooStatusBadgeVariousCodes() => const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VooStatusBadge(statusCode: 200),
              VooStatusBadge(statusCode: 201),
              VooStatusBadge(statusCode: 204),
              VooStatusBadge(statusCode: 301),
              VooStatusBadge(statusCode: 302),
              VooStatusBadge(statusCode: 400),
              VooStatusBadge(statusCode: 401),
              VooStatusBadge(statusCode: 403),
              VooStatusBadge(statusCode: 404),
              VooStatusBadge(statusCode: 500),
              VooStatusBadge(statusCode: 502),
              VooStatusBadge(statusCode: 503),
            ],
          ),
        ),
      ),
    );