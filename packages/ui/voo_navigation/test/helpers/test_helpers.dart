import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Creates a MaterialApp with VooTokensTheme configured for testing
Widget createTestApp({required Widget child, ThemeData? theme}) {
  return MaterialApp(
    theme: (theme ?? ThemeData()).copyWith(
      extensions: [VooTokensTheme.standard()],
    ),
    home: child,
  );
}

/// Creates a MaterialApp.router with VooTokensTheme configured for testing
Widget createTestRouterApp({required GoRouter routerConfig, ThemeData? theme}) {
  return MaterialApp.router(
    theme: (theme ?? ThemeData()).copyWith(
      extensions: [VooTokensTheme.standard()],
    ),
    routerConfig: routerConfig,
  );
}

/// Creates a Material widget with VooTokensTheme configured for testing
Widget wrapWithMaterialAndTheme(Widget child) {
  return MaterialApp(
    theme: ThemeData(extensions: [VooTokensTheme.standard()]),
    home: Material(child: child),
  );
}
