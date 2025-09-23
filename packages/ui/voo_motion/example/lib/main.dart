import 'package:flutter/material.dart';
import 'package:voo_motion/voo_motion.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: VooResponsiveBuilder(
        builder: (context, screenInfo) => MaterialApp(
          title: 'VooMotion Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const VooMotionDemo(),
        ),
      ),
    );
  }
}

class VooMotionDemo extends StatefulWidget {
  const VooMotionDemo({super.key});

  @override
  State<VooMotionDemo> createState() => _VooMotionDemoState();
}

class _VooMotionDemoState extends State<VooMotionDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('VooMotion Examples').fadeIn(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Drop In Animation', [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Drop In Button'),
            ).dropIn(delay: const Duration(milliseconds: 200)),
            
            const SizedBox(height: 16),
            
            Card(
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('This card drops in with a bounce'),
              ),
            ).dropIn(
              delay: const Duration(milliseconds: 400),
              fromHeight: 100,
            ),
          ]),
          
          _buildSection('Fade Animations', [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Fade In Text'),
            ).fadeIn(delay: const Duration(milliseconds: 600)),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.star, size: 40, color: Colors.amber)
                    .fadeIn(delay: const Duration(milliseconds: 800)),
                const Icon(Icons.favorite, size: 40, color: Colors.red)
                    .fadeIn(delay: const Duration(milliseconds: 1000)),
                const Icon(Icons.thumb_up, size: 40, color: Colors.green)
                    .fadeIn(delay: const Duration(milliseconds: 1200)),
              ],
            ),
          ]),
          
          _buildSection('Slide Animations', [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade100,
              child: const Text('Slide from Left'),
            ).slideInLeft(delay: const Duration(milliseconds: 1400)),
            
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade100,
              child: const Text('Slide from Right', textAlign: TextAlign.right),
            ).slideInRight(delay: const Duration(milliseconds: 1600)),
            
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.purple.shade100,
              child: const Text('Slide from Top', textAlign: TextAlign.center),
            ).slideInTop(delay: const Duration(milliseconds: 1800)),
            
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: const Text('Slide from Bottom', textAlign: TextAlign.center),
            ).slideInBottom(delay: const Duration(milliseconds: 2000)),
          ]),
          
          _buildSection('Scale Animations', [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 40),
            ).scaleIn(
              delay: const Duration(milliseconds: 2200),
              curve: Curves.elasticOut,
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorBox(Colors.red).scaleIn(
                  delay: const Duration(milliseconds: 2400),
                  from: 0.5,
                ),
                _buildColorBox(Colors.green).scaleIn(
                  delay: const Duration(milliseconds: 2600),
                  from: 0.5,
                ),
                _buildColorBox(Colors.blue).scaleIn(
                  delay: const Duration(milliseconds: 2800),
                  from: 0.5,
                ),
              ],
            ),
          ]),
          
          _buildSection('Rotation Animation', [
            const Icon(
              Icons.refresh,
              size: 60,
              color: Colors.blue,
            ).rotate(
              delay: const Duration(milliseconds: 3000),
              duration: const Duration(seconds: 2),
              repeat: true,
            ),
          ]),
          
          _buildSection('Bounce Animation', [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Bouncing Widget',
                style: TextStyle(color: Colors.white),
              ),
            ).bounce(
              delay: const Duration(milliseconds: 3200),
              repeat: true,
            ),
          ]),
          
          _buildSection('Shake Animation', [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Shake Me!'),
            ).shake(
              delay: const Duration(milliseconds: 3400),
              intensity: 5,
            ),
          ]),
          
          _buildSection('Flip Animation', [
            Card(
              color: Colors.purple,
              child: const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Flip X',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ).flipX(delay: const Duration(milliseconds: 3600)),
            
            const SizedBox(height: 16),
            
            Card(
              color: Colors.teal,
              child: const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Flip Y',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ).flipY(delay: const Duration(milliseconds: 3800)),
          ]),
          
          _buildSection('Stagger List', [
            VooStaggerList(
              animationType: StaggerAnimationType.slideLeft,
              staggerDelay: const Duration(milliseconds: 100),
              config: const VooAnimationConfig(
                delay: Duration(milliseconds: 4000),
              ),
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length].shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Staggered Item ${index + 1}'),
                );
              }),
            ),
          ]),
          
          _buildSection('Chained Animations', [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Multiple Animations',
                style: TextStyle(color: Colors.white),
              ),
            ).fadeIn(
              delay: const Duration(milliseconds: 5000),
            ).scaleIn(
              delay: const Duration(milliseconds: 5500),
            ),
          ]),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ).slideInLeft(),
        ),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }
  
  Widget _buildColorBox(Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}