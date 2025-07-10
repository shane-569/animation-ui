import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: JarvisVisualizer(),
        ),
      ),
    ));

class JarvisVisualizer extends StatefulWidget {
  const JarvisVisualizer({Key? key}) : super(key: key);

  @override
  State<JarvisVisualizer> createState() => _JarvisVisualizerState();
}

class _JarvisVisualizerState extends State<JarvisVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Spirograph
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return CustomPaint(
              painter: SpirographPainter(progress: _controller.value),
              size: const Size(200, 400),
            );
          },
        ),

        // Glowing Pulsating Center
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double scale = 1.0 + sin(_controller.value * 2 * pi) * 0.3;
            final double opacity = 0.5 + sin(_controller.value * 2 * pi) * 0.5;
            final double radius = 10 * scale;

            return Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withOpacity(opacity),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(opacity),
                    blurRadius: 20 * scale,
                    spreadRadius: 4 * scale,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class SpirographPainter extends CustomPainter {
  final double progress;
  SpirographPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    const int lines = 80;
    final double radius = size.width * 0.45;
    final double wave = sin(progress * pi) * 40;

    final Paint paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < lines; i++) {
      final double angle = (2 * pi / lines) * i;
      final Path path = Path();

      for (double t = 0; t < 1; t += 0.02) {
        final double r = radius + wave * sin(5 * pi * t + angle);
        final double x = r * cos(angle + t * 2 * pi);
        final double y = r * sin(angle + t * 2 * pi);
        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final LinearGradient gradient = LinearGradient(
        colors: <Color>[Colors.tealAccent, Colors.blueAccent],
      );

      final Shader shader = gradient.createShader(Rect.fromCircle(
        center: Offset.zero, // Changed to Offset.zero as it's relative to canvas.translate
        radius: radius,
      ));

      paint.shader = shader;
      // Ensure opacity is clamped between 0.0 and 1.0
      paint.color = Colors.white.withOpacity(max(0.0, 0.6 - i / lines));

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SpirographPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
