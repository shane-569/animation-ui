import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(PulsatingSpirographApp());

class PulsatingSpirographApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpirographRing(),
        ),
      ),
    );
  }
}

class SpirographRing extends StatefulWidget {
  const SpirographRing({Key? key}) : super(key: key);

  @override
  _SpirographRingState createState() => _SpirographRingState();
}

class _SpirographRingState extends State<SpirographRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: SpirographPainter(progress: _controller.value),
          size: const Size(500, 500), // Increased size
        );
      },
    );
  }
}

class SpirographPainter extends CustomPainter {
  final double progress;
  SpirographPainter({required this.progress});

  final Color startColor = Colors.teal;
  final Color endColor = Colors.blueAccent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final int lines = 90;
    final double baseRadius = size.width * 0.35; // Increased base radius
    final double waveAmplitude = sin(progress * pi) * 70; // More dramatic expansion

    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < lines; i++) {
      final angle = (2 * pi / lines) * i;
      final path = Path();

      for (double t = 0; t < 1; t += 0.02) {
        final r = baseRadius + waveAmplitude * sin(5 * pi * t + angle);
        final x = r * cos(angle + t * 2 * pi);
        final y = r * sin(angle + t * 2 * pi);
        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final color = Color.lerp(startColor, endColor, i / lines)!.withOpacity(0.8);
      final paint = Paint()
        ..color = color
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
