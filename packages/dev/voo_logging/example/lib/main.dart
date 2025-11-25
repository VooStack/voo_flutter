import 'package:flutter/material.dart';
import 'package:voo_logging/voo_logging.dart';
import 'package:dio/dio.dart';
import 'package:voo_toast/voo_toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // VooLogger now works with ZERO configuration!
  // Just call logging methods directly - it auto-initializes with smart defaults.
  //
  // For explicit control, use:
  // await VooLogger.ensureInitialized(config: LoggingConfig.production());

  // Optional: Initialize VooToast for toast notifications
  try {
    VooToastController.instance;
  } catch (_) {
    VooToastController.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VooLogging Demo',
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
      home: const VooToastOverlay(child: LoggingDemoScreen()),
    );
  }
}

class LoggingDemoScreen extends StatefulWidget {
  const LoggingDemoScreen({super.key});

  @override
  State<LoggingDemoScreen> createState() => _LoggingDemoScreenState();
}

class _LoggingDemoScreenState extends State<LoggingDemoScreen> {
  late final Dio dio;
  List<LogEntry> recentLogs = [];
  LogStatistics? stats;
  bool toastEnabled = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _setupDio();
    _listenToLogs();
    _loadStats();
  }

  void _setupDio() {
    dio = Dio();
    final interceptor = VooDioInterceptor();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: interceptor.onRequest,
      onResponse: interceptor.onResponse,
      onError: interceptor.onError,
    ));
  }

  void _listenToLogs() {
    VooLogger.instance.stream.listen((log) {
      setState(() {
        recentLogs.insert(0, log);
        if (recentLogs.length > 50) recentLogs.removeLast();
      });
      _loadStats();
    });
  }

  Future<void> _loadStats() async {
    final newStats = await VooLogger.instance.getStatistics();
    setState(() => stats = newStats);
  }

  Future<void> _clearLogs() async {
    await VooLogger.instance.clearLogs();
    setState(() => recentLogs.clear());
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VooLogging Demo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(toastEnabled ? Icons.notifications_active : Icons.notifications_off_outlined),
            onPressed: () => setState(() => toastEnabled = !toastEnabled),
            tooltip: 'Toggle toast notifications',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                _buildTab('Quick Log', 0, Icons.flash_on),
                _buildTab('Categories', 1, Icons.category),
                _buildTab('Network', 2, Icons.wifi),
                _buildTab('Stats', 3, Icons.analytics),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildQuickLogTab(),
                _buildCategoriesTab(),
                _buildNetworkTab(),
                _buildStatsTab(),
              ],
            ),
          ),
          // Log stream
          _buildLogStream(),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Log Levels'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLogButton('Verbose', Colors.grey, () => VooLogger.verbose('Verbose trace message')),
              _buildLogButton('Debug', Colors.blueGrey, () => VooLogger.debug('Debug information')),
              _buildLogButton('Info', Colors.blue, () => VooLogger.info('Info message', shouldNotify: toastEnabled)),
              _buildLogButton('Warning', Colors.orange, () => VooLogger.warning('Warning alert', shouldNotify: toastEnabled)),
              _buildLogButton('Error', Colors.red, () => VooLogger.error('Error occurred', error: Exception('Sample error'), shouldNotify: toastEnabled)),
              _buildLogButton('Fatal', Colors.red.shade900, () => VooLogger.fatal('Fatal crash!', error: Exception('Critical failure'), shouldNotify: toastEnabled)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Quick Actions'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _logWithMetadata,
                icon: const Icon(Icons.data_object, size: 18),
                label: const Text('Log with Metadata'),
              ),
              FilledButton.tonalIcon(
                onPressed: _logMultiple,
                icon: const Icon(Icons.burst_mode, size: 18),
                label: const Text('Log 10 Messages'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCodeExample(
            'Zero-Config Usage',
            '''// Just use it - auto-initializes!
VooLogger.info('Hello world');

// With metadata
VooLogger.info('User action',
  category: 'Analytics',
  tag: 'button_click',
  metadata: {'screen': 'home'},
);''',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Log by Category'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryButton('Auth', Icons.lock, Colors.purple, () {
                VooLogger.info('User logged in', category: 'Auth', tag: 'login', metadata: {'method': 'email'});
              }),
              _buildCategoryButton('Network', Icons.cloud, Colors.blue, () {
                VooLogger.info('API request completed', category: 'Network', tag: 'api', metadata: {'endpoint': '/users'});
              }),
              _buildCategoryButton('Analytics', Icons.analytics, Colors.green, () {
                VooLogger.info('Event tracked', category: 'Analytics', tag: 'event', metadata: {'name': 'page_view'});
              }),
              _buildCategoryButton('Payment', Icons.payment, Colors.orange, () {
                VooLogger.info('Payment processed', category: 'Payment', tag: 'transaction', metadata: {'amount': 99.99});
              }),
              _buildCategoryButton('System', Icons.settings, Colors.grey, () {
                VooLogger.debug('System check', category: 'System', tag: 'health');
              }),
              _buildCategoryButton('Error', Icons.error, Colors.red, () {
                VooLogger.error('Operation failed', category: 'Error', tag: 'failure', error: Exception('Database error'));
              }),
            ],
          ),
          const SizedBox(height: 24),
          _buildCodeExample(
            'Structured Logging',
            '''VooLogger.info(
  'User completed purchase',
  category: 'Payment',
  tag: 'checkout_complete',
  metadata: {
    'orderId': 'ORD-123',
    'amount': 99.99,
    'currency': 'USD',
    'items': 3,
  },
);''',
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Network Logging with Dio'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => _makeRequest('https://jsonplaceholder.typicode.com/posts/1'),
                icon: const Icon(Icons.download, size: 18),
                label: const Text('GET Request'),
              ),
              FilledButton.icon(
                onPressed: () => _makeRequest('https://jsonplaceholder.typicode.com/posts', isPost: true),
                icon: const Icon(Icons.upload, size: 18),
                label: const Text('POST Request'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _makeRequest('https://httpstat.us/404'),
                icon: const Icon(Icons.error_outline, size: 18),
                label: const Text('404 Error'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _makeRequest('https://httpstat.us/500'),
                icon: const Icon(Icons.dangerous, size: 18),
                label: const Text('500 Error'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCodeExample(
            'Dio Integration',
            '''final dio = Dio();
final interceptor = VooDioInterceptor();

dio.interceptors.add(InterceptorsWrapper(
  onRequest: interceptor.onRequest,
  onResponse: interceptor.onResponse,
  onError: interceptor.onError,
));

// All requests are now logged automatically!
await dio.get('https://api.example.com/data');''',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Log Statistics'),
          const SizedBox(height: 8),
          if (stats != null) ...[
            _buildStatCard('Total Logs', stats!.totalLogs.toString(), Icons.list_alt, Colors.blue),
            const SizedBox(height: 12),
            _buildSectionTitle('By Level'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats!.levelCounts.entries.map((e) {
                return _buildStatChip(e.key, e.value, _getLevelColor(e.key));
              }).toList(),
            ),
            if (stats!.categoryCounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('By Category'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: stats!.categoryCounts.entries.map((e) {
                  return _buildStatChip(e.key, e.value, Colors.indigo);
                }).toList(),
              ),
            ],
          ] else
            const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 24),
          _buildSectionTitle('Configuration'),
          const SizedBox(height: 8),
          _buildConfigInfo(),
        ],
      ),
    );
  }

  Widget _buildLogStream() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(Icons.terminal, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('Log Stream', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
                const Spacer(),
                Text('${recentLogs.length} logs', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            child: recentLogs.isEmpty
                ? Center(
                    child: Text('No logs yet', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: recentLogs.length,
                    itemBuilder: (context, index) {
                      final log = recentLogs[index];
                      return _buildLogEntry(log);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(LogEntry log) {
    final color = _getLevelColor(log.level.name);
    final time = '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.grey.shade600)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(4)),
            child: Text(log.level.name.toUpperCase().substring(0, 3), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ),
          const SizedBox(width: 8),
          if (log.category != null) ...[
            Text('[${log.category}]', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(log.message, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _buildLogButton(String label, Color color, VoidCallback onPressed) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(backgroundColor: color),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 10, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white))),
      label: Text(label),
    );
  }

  Widget _buildConfigInfo() {
    final config = VooLogger.config;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfigRow('Min Level', config.minimumLevel.name),
            _buildConfigRow('Pretty Logs', config.enablePrettyLogs.toString()),
            _buildConfigRow('Max Logs', config.maxLogs?.toString() ?? 'Unlimited'),
            _buildConfigRow('Retention Days', config.retentionDays?.toString() ?? 'Forever'),
            _buildConfigRow('Auto Cleanup', config.autoCleanup.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  Widget _buildCodeExample(String title, String code) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(code, style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: colorScheme.onSurfaceVariant)),
        ),
      ],
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'verbose':
        return Colors.grey;
      case 'debug':
        return Colors.blueGrey;
      case 'info':
        return Colors.blue;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'fatal':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  void _logWithMetadata() {
    VooLogger.info(
      'User interaction logged',
      category: 'Analytics',
      tag: 'user_action',
      metadata: {
        'screen': 'demo',
        'action': 'button_click',
        'timestamp': DateTime.now().toIso8601String(),
        'sessionId': 'demo-session-123',
      },
      shouldNotify: toastEnabled,
    );
  }

  Future<void> _logMultiple() async {
    for (var i = 1; i <= 10; i++) {
      await VooLogger.info('Batch log #$i', category: 'Batch', tag: 'test');
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _makeRequest(String url, {bool isPost = false}) async {
    try {
      if (isPost) {
        await dio.post(url, data: {'title': 'Test', 'body': 'Content'});
      } else {
        await dio.get(url);
      }
      VooLogger.info('Request completed: $url', category: 'Network', shouldNotify: toastEnabled);
    } catch (e) {
      VooLogger.error('Request failed: $url', category: 'Network', error: e, shouldNotify: toastEnabled);
    }
  }
}
