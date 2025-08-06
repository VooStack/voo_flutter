import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/data/datasources/devtools_log_datasource_impl.dart';
import 'package:voo_logging_devtools_extension/data/repositories/devtools_log_repository_impl.dart';
import 'package:voo_logging_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging_devtools_extension/presentation/pages/voo_logger_page.dart';

/// Wrapper widget that initializes dependencies after DevToolsExtension
class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late final DevToolsLogDataSourceImpl dataSource;
  late final DevToolsLogRepository repository;
  late final LogBloc logBloc;

  @override
  void initState() {
    super.initState();
    // Initialize after DevToolsExtension has set up serviceManager
    dataSource = DevToolsLogDataSourceImpl();
    repository = DevToolsLogRepositoryImpl(dataSource: dataSource);
    logBloc = LogBloc(repository: repository)..add(LoadLogs());
  }

  @override
  void dispose() {
    logBloc.close();
    dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: logBloc, child: const VooLoggerPage());
  }
}
