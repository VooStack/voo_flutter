import 'package:flutter/material.dart';

import 'package:voo_terminal_example/pages/home_page.dart';

void main() {
  runApp(const VooTerminalExampleApp());
}

/// Example app demonstrating VooTerminal features.
class VooTerminalExampleApp extends StatelessWidget {
  const VooTerminalExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooTerminal Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
