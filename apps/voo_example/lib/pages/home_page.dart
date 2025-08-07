import 'package:flutter/material.dart';
import 'package:voo_example/pages/logging_page.dart';
import 'package:voo_example/pages/analytics_page.dart';
import 'package:voo_example/pages/performance_page.dart';
import 'package:voo_example/pages/network_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voo Flutter Examples'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildFeatureCard(
            context,
            title: 'Logging',
            description: 'Demonstrates logging with different levels, filtering, and DevTools integration',
            icon: Icons.bug_report,
            color: Colors.blue,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoggingPage())),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            title: 'Analytics',
            description: 'Shows touch tracking, heat maps, and user interaction analytics',
            icon: Icons.analytics,
            color: Colors.green,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsPage())),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            title: 'Performance',
            description: 'Monitors app performance, frame rendering, and memory usage',
            icon: Icons.speed,
            color: Colors.orange,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformancePage())),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            title: 'Network Interceptors',
            description: 'Demonstrates Dio interceptors for logging and performance monitoring',
            icon: Icons.network_check,
            color: Colors.purple,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NetworkPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.code, size: 32, color: Colors.deepPurple),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VooFlutter Integration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('All packages working together', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'This example app demonstrates how all VooFlutter packages integrate seamlessly to provide comprehensive monitoring and analytics for your Flutter applications.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {required String title, required String description, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha:  0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
