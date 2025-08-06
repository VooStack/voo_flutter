import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/data/datasources/devtools_log_datasource.dart';
import 'package:voo_logging_devtools_extension/data/repositories/devtools_log_repository_impl.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/voo_logger_page.dart';

Future<void> main() async {
  runApp(const VooLoggerDevToolsExtension());
}

class VooLoggerDevToolsExtension extends StatelessWidget {
  const VooLoggerDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = DevToolsLogDataSourceImpl();
    final repository = DevToolsLogRepositoryImpl(dataSource: dataSource);

    return MaterialApp(
      title: 'Voo Logger DevTools',
      theme: ThemeData.dark(),
      home: DevToolsExtension(
        child: BlocProvider(
          create: (context) => LogBloc(repository: repository as DevToolsLogRepository)..add(LoadLogs()),
          child: const VooLoggerPage(),
        ),
      ),
    );
  }
}
