import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/devtools_extension/domain/repositories/devtools_log_repository.dart';
import 'package:voo_logging/features/devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_logging/features/devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging/features/devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

import 'log_bloc_test.mocks.dart';

@GenerateMocks([DevToolsLogRepository])
void main() {
  late MockDevToolsLogRepository mockRepository;

  setUp(() {
    mockRepository = MockDevToolsLogRepository();

    // Set up default behavior
    when(mockRepository.logStream).thenAnswer((_) => const Stream.empty());
    when(mockRepository.getCachedLogs()).thenReturn([]);
  });

  group('LogBloc', () {
    final testLog1 = LogEntryModel('1', DateTime(2023), 'Test log 1', LogLevel.info, 'Test', 'TestTag', null, null, null, null, null);

    final testLog2 = LogEntryModel('2', DateTime(2023, 1, 2), 'Test log 2', LogLevel.error, 'Error', 'ErrorTag', null, null, null, null, null);

    test('initial state should be correct', () {
      final bloc = LogBloc(repository: mockRepository);
      expect(bloc.state, equals(const LogState()));
      bloc.close();
    });

    blocTest<LogBloc, LogState>(
      'emits [loading, loaded] when LoadLogs is added',
      build: () {
        when(mockRepository.getCachedLogs()).thenReturn([testLog1, testLog2]);
        return LogBloc(repository: mockRepository);
      },
      act: (bloc) {}, // LoadLogs is called automatically in constructor
      expect: () => [
        const LogState(isLoading: true),
        LogState(logs: [testLog1, testLog2], filteredLogs: [testLog1, testLog2]),
      ],
    );

    blocTest<LogBloc, LogState>(
      'emits updated state when LogReceived is added',
      build: () => LogBloc(repository: mockRepository),
      act: (bloc) => bloc.add(LogReceived(testLog1)),
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [
        LogState(logs: [testLog1], filteredLogs: [testLog1]),
      ],
    );

    blocTest<LogBloc, LogState>(
      'emits filtered state when FilterLogsChanged is added',
      build: () {
        when(mockRepository.getCachedLogs()).thenReturn([testLog1, testLog2]);
        return LogBloc(repository: mockRepository);
      },
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for LoadLogs
        bloc.add(const FilterLogsChanged(levels: [LogLevel.info]));
      },
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [
        LogState(
          logs: [testLog1, testLog2],
          filteredLogs: [testLog1], // Only info level
          selectedLevels: const [LogLevel.info],
        ),
      ],
    );

    blocTest<LogBloc, LogState>(
      'emits state with selected log when SelectLog is added',
      build: () {
        when(mockRepository.getCachedLogs()).thenReturn([testLog1]);
        return LogBloc(repository: mockRepository);
      },
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for LoadLogs
        bloc.add(SelectLog(testLog1));
      },
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [
        LogState(logs: [testLog1], filteredLogs: [testLog1], selectedLog: testLog1),
      ],
    );

    blocTest<LogBloc, LogState>(
      'clears selected log when SelectLog with null is added',
      build: () {
        when(mockRepository.getCachedLogs()).thenReturn([testLog1]);
        return LogBloc(repository: mockRepository);
      },
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for LoadLogs
        bloc.add(SelectLog(testLog1)); // First select a log
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const SelectLog(null)); // Then clear selection
      },
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [
        LogState(logs: [testLog1], filteredLogs: [testLog1], selectedLog: testLog1),
        LogState(logs: [testLog1], filteredLogs: [testLog1]),
      ],
    );

    blocTest<LogBloc, LogState>(
      'emits empty state when ClearLogs is added',
      build: () {
        when(mockRepository.getCachedLogs()).thenReturn([testLog1, testLog2]);
        return LogBloc(repository: mockRepository);
      },
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for LoadLogs
        bloc.add(ClearLogs());
      },
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [const LogState()],
      verify: (_) {
        verify(mockRepository.clearLogs()).called(1);
      },
    );

    blocTest<LogBloc, LogState>(
      'toggles autoScroll when ToggleAutoScroll is added',
      build: () => LogBloc(repository: mockRepository),
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for LoadLogs
        bloc.add(ToggleAutoScroll());
      },
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [const LogState(autoScroll: false)],
    );

    blocTest<LogBloc, LogState>(
      'emits filtered state when SearchQueryChanged is added',
      build: () {
        when(mockRepository.getCachedLogs()).thenReturn([testLog1, testLog2]);
        return LogBloc(repository: mockRepository);
      },
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for LoadLogs
        bloc.add(const SearchQueryChanged('Test log 1'));
      },
      skip: 2, // Skip initial state and LoadLogs states
      expect: () => [
        LogState(
          logs: [testLog1, testLog2],
          filteredLogs: [testLog1], // Only matching log
          searchQuery: 'Test log 1',
        ),
      ],
    );

    group('filtering logic', () {
      test('filters by level correctly', () async {
        final logBloc = LogBloc(repository: mockRepository);

        // Wait for initial load to complete
        await Future.delayed(const Duration(milliseconds: 10));

        // Add test logs
        logBloc.add(LogReceived(testLog1)); // info
        logBloc.add(LogReceived(testLog2)); // error

        // Wait for logs to be added
        await Future.delayed(const Duration(milliseconds: 10));

        // Filter by error level
        logBloc.add(const FilterLogsChanged(levels: [LogLevel.error]));

        // Wait for filter to apply
        await Future.delayed(const Duration(milliseconds: 10));

        // Check final state
        expect(logBloc.state.filteredLogs.length, 1);
        expect(logBloc.state.filteredLogs.first.level, LogLevel.error);

        await logBloc.close();
      });

      test('filters by category correctly', () async {
        final logBloc = LogBloc(repository: mockRepository);

        // Wait for initial load to complete
        await Future.delayed(const Duration(milliseconds: 10));

        // Add test logs
        logBloc.add(LogReceived(testLog1)); // category: Test
        logBloc.add(LogReceived(testLog2)); // category: Error

        // Wait for logs to be added
        await Future.delayed(const Duration(milliseconds: 10));

        // Filter by Test category
        logBloc.add(const FilterLogsChanged(category: 'Test'));

        // Wait for filter to apply
        await Future.delayed(const Duration(milliseconds: 10));

        // Check final state
        expect(logBloc.state.filteredLogs.length, 1);
        expect(logBloc.state.filteredLogs.first.category, 'Test');

        await logBloc.close();
      });
    });
  });
}
