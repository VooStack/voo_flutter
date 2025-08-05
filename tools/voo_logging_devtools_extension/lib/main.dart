import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/data/datasources/simple_devtools_log_datasource.dart';
import 'package:voo_logging_devtools_extension/data/repositories/devtools_log_repository_impl.dart';

Future<void> main() async {
  runApp(const VooLoggerDevToolsExtension());
}

class VooLoggerDevToolsExtension extends StatelessWidget {
  const VooLoggerDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = SimpleDevToolsLogDataSource();
    final repository = DevToolsLogRepositoryImpl(dataSource: dataSource);

    return MaterialApp(
      title: 'Voo Logger DevTools',
      theme: ThemeData.dark(),
      home: DevToolsExtension(
        child: BlocProvider(
          create: (context) => LogBloc(repository: repository)..add(LoadLogs()),
          child: const VooLoggerPage(),
        ),
      ),
    );
  }
}
