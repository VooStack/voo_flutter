import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:voo_terminal/src/domain/entities/terminal_command.dart';
import 'package:voo_terminal/src/domain/entities/terminal_config.dart';
import 'package:voo_terminal/src/domain/entities/terminal_line.dart';
import 'package:voo_terminal/src/domain/enums/line_type.dart';
import 'package:voo_terminal/src/presentation/controllers/terminal_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TerminalController', () {
    late TerminalController controller;

    setUp(() {
      controller = TerminalController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('constructor', () {
      test('creates controller with default config', () {
        expect(controller.config, isA<TerminalConfig>());
        expect(controller.lines, isEmpty);
        expect(controller.isEmpty, true);
      });

      test('creates controller with custom config', () {
        final config = TerminalConfig.interactive(prompt: '>>> ');
        final customController = TerminalController(config: config);

        expect(customController.config.prompt, '>>> ');
        customController.dispose();
      });

      test('registers commands on creation', () {
        final command = TerminalCommand(
          name: 'test',
          description: 'Test command',
          handler: (_) => const CommandResult.success('OK'),
        );
        final customController = TerminalController(commands: [command]);

        expect(customController.commands.any((c) => c.name == 'test'), true);
        customController.dispose();
      });

      test('registers built-in commands', () {
        final commandNames = controller.commands.map((c) => c.name).toList();

        expect(commandNames, contains('clear'));
        expect(commandNames, contains('help'));
        expect(commandNames, contains('history'));
        expect(commandNames, contains('echo'));
      });
    });

    group('line management', () {
      test('addLine adds line to buffer', () {
        final line = TerminalLine.output('Test');
        controller.addLine(line);

        expect(controller.lines.length, 1);
        expect(controller.lines.first.content, 'Test');
        expect(controller.isNotEmpty, true);
      });

      test('addLines adds multiple lines', () {
        final lines = [
          TerminalLine.output('Line 1'),
          TerminalLine.output('Line 2'),
          TerminalLine.output('Line 3'),
        ];
        controller.addLines(lines);

        expect(controller.lineCount, 3);
      });

      test('write adds output line', () {
        controller.write('Hello');

        expect(controller.lines.last.content, 'Hello');
        expect(controller.lines.last.type, LineType.output);
      });

      test('writeLine adds output line', () {
        controller.writeLine('World');

        expect(controller.lines.last.content, 'World');
      });

      test('writeLines adds multiple output lines', () {
        controller.writeLines(['A', 'B', 'C']);

        expect(controller.lineCount, 3);
      });

      test('writeError adds error line', () {
        controller.writeError('Error occurred');

        expect(controller.lines.last.content, 'Error occurred');
        expect(controller.lines.last.type, LineType.error);
      });

      test('writeWarning adds warning line', () {
        controller.writeWarning('Warning message');

        expect(controller.lines.last.content, 'Warning message');
        expect(controller.lines.last.type, LineType.warning);
      });

      test('writeSuccess adds success line', () {
        controller.writeSuccess('Success!');

        expect(controller.lines.last.content, 'Success!');
        expect(controller.lines.last.type, LineType.success);
      });

      test('writeSystem adds system line', () {
        controller.writeSystem('System message');

        expect(controller.lines.last.content, 'System message');
        expect(controller.lines.last.type, LineType.system);
      });

      test('writeInfo adds info line', () {
        controller.writeInfo('Info message');

        expect(controller.lines.last.content, 'Info message');
        expect(controller.lines.last.type, LineType.info);
      });

      test('writeDebug adds debug line', () {
        controller.writeDebug('Debug message');

        expect(controller.lines.last.content, 'Debug message');
        expect(controller.lines.last.type, LineType.debug);
      });

      test('clear removes all lines', () {
        controller.writeLine('Line 1');
        controller.writeLine('Line 2');
        controller.clear();

        expect(controller.isEmpty, true);
      });

      test('removeWhere removes matching lines', () {
        controller.writeLine('Keep');
        controller.writeError('Remove');
        controller.writeLine('Keep too');

        controller.removeWhere((line) => line.type == LineType.error);

        expect(controller.lineCount, 2);
        expect(controller.lines.every((l) => l.type != LineType.error), true);
      });

      test('trims buffer when exceeding maxLines', () {
        final config = TerminalConfig.preview(maxLines: 3);
        final trimController = TerminalController(config: config);

        trimController.writeLine('1');
        trimController.writeLine('2');
        trimController.writeLine('3');
        trimController.writeLine('4');
        trimController.writeLine('5');

        expect(trimController.lineCount, 3);
        expect(trimController.lines.first.content, '3');
        expect(trimController.lines.last.content, '5');

        trimController.dispose();
      });
    });

    group('config management', () {
      test('updateConfig changes configuration', () {
        final newConfig = TerminalConfig.interactive(prompt: '> ');
        controller.updateConfig(newConfig);

        expect(controller.config.prompt, '> ');
      });
    });

    group('input handling', () {
      test('setInput updates text controller', () {
        controller.setInput('hello');

        expect(controller.currentInput, 'hello');
        expect(controller.textController.text, 'hello');
      });
    });

    group('history navigation', () {
      setUp(() {
        final config = TerminalConfig.interactive(
          enableHistory: true,
          historySize: 10,
        );
        controller = TerminalController(config: config);
      });

      test('navigateHistoryUp does nothing with empty history', () {
        controller.navigateHistoryUp();

        expect(controller.currentInput, '');
      });

      test('navigateHistoryDown does nothing with empty history', () {
        controller.navigateHistoryDown();

        expect(controller.currentInput, '');
      });

      test('clearHistory clears command history', () {
        controller.clearHistory();

        expect(controller.commandHistory, isEmpty);
      });
    });

    group('command system', () {
      test('registerCommand adds command', () {
        final command = TerminalCommand(
          name: 'custom',
          description: 'Custom command',
          handler: (_) => const CommandResult.success('Done'),
        );

        controller.registerCommand(command);

        expect(controller.commands.any((c) => c.name == 'custom'), true);
      });

      test('registerCommands adds multiple commands', () {
        final commands = [
          TerminalCommand(
            name: 'cmd1',
            description: 'Command 1',
            handler: (_) => const CommandResult.success('1'),
          ),
          TerminalCommand(
            name: 'cmd2',
            description: 'Command 2',
            handler: (_) => const CommandResult.success('2'),
          ),
        ];

        controller.registerCommands(commands);

        expect(controller.commands.any((c) => c.name == 'cmd1'), true);
        expect(controller.commands.any((c) => c.name == 'cmd2'), true);
      });

      test('unregisterCommand removes command', () {
        final command = TerminalCommand(
          name: 'removable',
          description: 'Will be removed',
          handler: (_) => const CommandResult.success(''),
        );

        controller.registerCommand(command);
        expect(controller.commands.any((c) => c.name == 'removable'), true);

        controller.unregisterCommand('removable');
        expect(controller.commands.any((c) => c.name == 'removable'), false);
      });

      test('getSuggestions returns matching commands', () {
        final command = TerminalCommand(
          name: 'testcmd',
          description: 'Test',
          handler: (_) => const CommandResult.success(''),
        );
        controller.registerCommand(command);

        final suggestions = controller.getSuggestions('test');

        expect(suggestions, contains('testcmd'));
      });

      test('getSuggestions returns empty for no matches', () {
        final suggestions = controller.getSuggestions('xyz');

        expect(suggestions.where((s) => s.startsWith('xyz')), isEmpty);
      });

      test('getSuggestions returns empty for empty prefix', () {
        final suggestions = controller.getSuggestions('');

        expect(suggestions, isEmpty);
      });
    });

    group('stream support', () {
      test('attachStream adds lines from stream', () async {
        final streamController = StreamController<String>();
        controller.attachStream(streamController.stream);

        streamController.add('Line from stream');
        await Future.delayed(Duration.zero);

        expect(controller.lines.any((l) => l.content == 'Line from stream'), true);

        await streamController.close();
      });

      test('attachStream with custom type', () async {
        final streamController = StreamController<String>();
        controller.attachStream(streamController.stream, type: LineType.error);

        streamController.add('Error from stream');
        await Future.delayed(Duration.zero);

        expect(controller.lines.last.type, LineType.error);

        await streamController.close();
      });

      test('detachStream stops listening', () async {
        final streamController = StreamController<String>();
        controller.attachStream(streamController.stream);

        streamController.add('Before');
        await Future.delayed(Duration.zero);

        controller.detachStream();

        streamController.add('After');
        await Future.delayed(Duration.zero);

        expect(controller.lines.any((l) => l.content == 'Before'), true);
        expect(controller.lines.any((l) => l.content == 'After'), false);

        await streamController.close();
      });

      test('attachStream detaches previous stream', () async {
        final stream1 = StreamController<String>();
        final stream2 = StreamController<String>();

        controller.attachStream(stream1.stream);
        controller.attachStream(stream2.stream);

        stream1.add('From stream 1');
        stream2.add('From stream 2');
        await Future.delayed(Duration.zero);

        expect(controller.lines.any((l) => l.content == 'From stream 1'), false);
        expect(controller.lines.any((l) => l.content == 'From stream 2'), true);

        await stream1.close();
        await stream2.close();
      });
    });

    group('change notification', () {
      test('notifies listeners when line added', () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.writeLine('Test');

        expect(notified, true);
      });

      test('notifies listeners when cleared', () {
        controller.writeLine('Test');

        var notified = false;
        controller.addListener(() => notified = true);

        controller.clear();

        expect(notified, true);
      });

      test('notifies listeners when config updated', () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.updateConfig(TerminalConfig.interactive());

        expect(notified, true);
      });
    });

    group('dispose', () {
      test('disposes internal controllers', () {
        final testController = TerminalController();

        testController.dispose();

        expect(() => testController.scrollController.position, throwsA(anything));
      });
    });
  });
}
