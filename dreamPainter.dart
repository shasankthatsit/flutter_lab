import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const DreamPainterApp());

class DreamPainterApp extends StatelessWidget {
  const DreamPainterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamPainter 🎨',
      theme: ThemeData.dark(),
      home: const DreamPainterHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DreamPainterHome extends StatefulWidget {
  const DreamPainterHome({super.key});
  @override
  State<DreamPainterHome> createState() => _DreamPainterHomeState();
}

class _DreamPainterHomeState extends State<DreamPainterHome>
    with SingleTickerProviderStateMixin {
  double emotion = 0.5;
  double chaos = 0.3;
  double symmetry = 0.5;
  late AnimationController _controller;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _mix(Color a, Color b, double t) {
    return Color.lerp(a, b, t)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 DreamPainter'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: DreamPainter(
                    time: _controller.value,
                    emotion: emotion,
                    chaos: chaos,
                    symmetry: symmetry,
                  ),
                  child: Container(),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _slider("Emotion", emotion, (v) => setState(() => emotion = v)),
                _slider("Chaos", chaos, (v) => setState(() => chaos = v)),
                _slider("Symmetry", symmetry, (v) => setState(() => symmetry = v)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.purpleAccent,
        ),
      ],
    );
  }
}

class DreamPainter extends CustomPainter {
  final double time;
  final double emotion;
  final double chaos;
  final double symmetry;
  DreamPainter({
    required this.time,
    required this.emotion,
    required this.chaos,
    required this.symmetry,
  });

  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    final bg = Color.lerp(Colors.deepPurple, Colors.black, 1 - emotion)!;
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);

    final shapes = 150 + (chaos * 300).toInt();
    for (int i = 0; i < shapes; i++) {
      final angle = (i / shapes) * 2 * pi * symmetry;
      final radius = size.shortestSide * 0.4 * sin(time * 2 * pi + i * chaos);
      final dx = center.dx + cos(angle) * radius;
      final dy = center.dy + sin(angle) * radius;
      final offset = Offset(dx, dy);
      final color = HSVColor.fromAHSV(
        1.0,
        (360 * (emotion * 0.8 + chaos * 0.2) + i * 2) % 360,
        0.9,
        0.9,
      ).toColor();
      paint.color = color.withOpacity(0.6);
      canvas.drawCircle(offset, 5 + chaos * 20 * (0.5 + 0.5 * sin(time * 6 + i)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant DreamPainter oldDelegate) => true;
}
