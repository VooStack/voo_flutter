import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/app_wrapper.dart';

Future<void> main() async {
  runApp(const VooLoggerDevToolsExtension());
}

class VooLoggerDevToolsExtension extends StatelessWidget {
  const VooLoggerDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Logger DevTools',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xffa2d399), brightness: Brightness.dark),
      ),
      home: const DevToolsExtension(child: AppWrapper()),
    );
  }
}
