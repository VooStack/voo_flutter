import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/core/services/package_detection_service.dart';
import 'package:voo_devtools_extension/data/datasources/devtools_log_datasource_impl.dart';
import 'package:voo_devtools_extension/data/repositories/devtools_log_repository_impl.dart';
import 'package:voo_devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_devtools_extension/presentation/pages/adaptive_voo_page.dart';

/// Wrapper widget that initializes dependencies after DevToolsExtension
class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late final PackageDetectionService packageDetectionService;
  late final DevToolsLogDataSourceImpl dataSource;
  late final DevToolsLogRepository repository;
  late final LogBloc logBloc;
  late final NetworkBloc networkBloc;
  late final PerformanceBloc performanceBloc;
  late final AnalyticsBloc analyticsBloc;

  @override
  void initState() {
    super.initState();
    // Initialize package detection service
    packageDetectionService = PackageDetectionService();
    packageDetectionService.startMonitoring();

    // Initialize after DevToolsExtension has set up serviceManager
    dataSource = DevToolsLogDataSourceImpl();
    repository = DevToolsLogRepositoryImpl(dataSource: dataSource);

    // Initialize BLoCs (they will be used conditionally based on available plugins)
    logBloc = LogBloc(repository: repository);
    networkBloc = NetworkBloc(repository: repository);
    performanceBloc = PerformanceBloc(repository: repository);
    analyticsBloc = AnalyticsBloc(repository: repository);
  }

  @override
  void dispose() {
    packageDetectionService.stopMonitoring();
    packageDetectionService.dispose();
    logBloc.close();
    networkBloc.close();
    performanceBloc.close();
    analyticsBloc.close();
    dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: logBloc),
        BlocProvider.value(value: networkBloc),
        BlocProvider.value(value: performanceBloc),
        BlocProvider.value(value: analyticsBloc),
      ],
      child: StreamBuilder<Map<String, bool>>(
        stream: packageDetectionService.packageStatusStream,
        initialData: packageDetectionService.packageStatus,
        builder: (context, snapshot) {
          final packageStatus = snapshot.data ?? {};

          // Load data for available packages
          if (packageStatus['voo_logging'] == true) {
            logBloc.add(LoadLogs());
          }
          if (packageStatus['voo_analytics'] == true) {
            analyticsBloc.add(LoadAnalyticsEvents());
          }
          if (packageStatus['voo_performance'] == true) {
            networkBloc.add(LoadNetworkLogs());
            performanceBloc.add(LoadPerformanceLogs());
          }

          return AdaptiveVooPage(pluginStatus: packageStatus);
        },
      ),
    );
  }
}
