import 'package:flutter/material.dart';
import 'package:voo_circular_progress/voo_circular_progress.dart';

void main() {
  runApp(const VooCircularProgressExampleApp());
}

/// Example app demonstrating various configurations of VooCircularProgress.
class VooCircularProgressExampleApp extends StatelessWidget {
  const VooCircularProgressExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VooCircularProgress Examples',
        theme: ThemeData.dark(useMaterial3: true),
        home: const ExampleScreen(),
      );
}

/// Main screen showing different examples of the circular progress widget.
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  double _stepsValue = 7762;
  double _caloriesValue = 23;
  double _exerciseValue = 45;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('VooCircularProgress Examples'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Example 1: Google Fit Style
              _buildSectionTitle('Google Fit Style'),
              const SizedBox(height: 16),
              Center(
                child: VooCircularProgress(
                  rings: [
                    ProgressRing(
                      current: _stepsValue,
                      goal: 10000,
                      color: Colors.cyan,
                      strokeWidth: 12,
                    ),
                    ProgressRing(
                      current: _caloriesValue,
                      goal: 30,
                      color: Colors.blue,
                      strokeWidth: 12,
                    ),
                  ],
                  size: 220,
                  gapBetweenRings: 8,
                  centerWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _caloriesValue.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      Text(
                        _stepsValue.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSlider(
                'Steps',
                _stepsValue,
                0,
                15000,
                (value) => setState(() => _stepsValue = value),
              ),
              _buildSlider(
                'Calories',
                _caloriesValue,
                0,
                50,
                (value) => setState(() => _caloriesValue = value),
              ),

              const SizedBox(height: 48),

              // Example 2: Multiple Rings
              _buildSectionTitle('Triple Ring Example'),
              const SizedBox(height: 16),
              Center(
                child: VooCircularProgress(
                  rings: [
                    ProgressRing(
                      current: _stepsValue,
                      goal: 10000,
                      color: Colors.green,
                      strokeWidth: 10,
                    ),
                    ProgressRing(
                      current: _caloriesValue,
                      goal: 30,
                      color: Colors.orange,
                      strokeWidth: 10,
                    ),
                    ProgressRing(
                      current: _exerciseValue,
                      goal: 60,
                      color: Colors.red,
                      strokeWidth: 10,
                    ),
                  ],
                  size: 200,
                  gapBetweenRings: 6,
                  centerWidget: const Icon(
                    Icons.favorite,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSlider(
                'Exercise Minutes',
                _exerciseValue,
                0,
                100,
                (value) => setState(() => _exerciseValue = value),
              ),

              const SizedBox(height: 48),

              // Example 3: Different Animation Curves
              _buildSectionTitle('Custom Animation Curves'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildAnimationExample(
                    'Ease In Out',
                    Curves.easeInOut,
                  ),
                  _buildAnimationExample(
                    'Bounce',
                    Curves.bounceOut,
                  ),
                  _buildAnimationExample(
                    'Elastic',
                    Curves.elasticOut,
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Example 4: Different Sizes
              _buildSectionTitle('Different Sizes'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildSizeExample(100),
                  _buildSizeExample(150),
                  _buildSizeExample(200),
                ],
              ),

              const SizedBox(height: 48),

              // Example 5: Different Stroke Widths
              _buildSectionTitle('Different Stroke Widths'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildStrokeExample(4),
                  _buildStrokeExample(8),
                  _buildStrokeExample(16),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      );

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toInt()}',
            style: const TextStyle(fontSize: 16),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      );

  Widget _buildAnimationExample(String label, Curve curve) => Column(
        children: [
          VooCircularProgress(
            rings: [
              ProgressRing(
                current: _stepsValue,
                goal: 10000,
                color: Colors.purple,
                strokeWidth: 8,
              ),
            ],
            size: 120,
            animationCurve: curve,
            centerWidget: Text(
              '${(_stepsValue / 100).toInt()}%',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      );

  Widget _buildSizeExample(double size) => VooCircularProgress(
        rings: [
          ProgressRing(
            current: 75,
            goal: 100,
            color: Colors.teal,
            strokeWidth: size / 15,
          ),
        ],
        size: size,
        centerWidget: Text(
          '${size.toInt()}',
          style: TextStyle(
            fontSize: size / 6,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildStrokeExample(double strokeWidth) => VooCircularProgress(
        rings: [
          ProgressRing(
            current: 60,
            goal: 100,
            color: Colors.amber,
            strokeWidth: strokeWidth,
          ),
        ],
        size: 120,
        centerWidget: Text(
          '${strokeWidth.toInt()}px',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
