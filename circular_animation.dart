import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(JarvisApp());

class JarvisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: JarvisWidget(),
          ),
        ),
      ),
    );
  }
}

class JarvisWidget extends StatefulWidget {
  @override
  _JarvisWidgetState createState() => _JarvisWidgetState();
}

class _JarvisWidgetState extends State<JarvisWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat();
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
          painter: JarvisPainter(_controller.value),
        );
      },
    );
  }
}

class JarvisPainter extends CustomPainter {
  final double progress;

  JarvisPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.translate(center.dx, center.dy);

    // Glowing center pulse
    final pulseRadius = radius * 0.1 + sin(progress * 2 * pi) * 4;
    final pulsePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.cyanAccent, Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: pulseRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, pulseRadius, pulsePaint);

    // Static inner rings
    for (int i = 1; i <= 3; i++) {
      paint
        ..color = Colors.cyanAccent.withOpacity(0.2 * i)
        ..strokeWidth = 1;
      canvas.drawCircle(Offset.zero, radius * 0.2 * i, paint);
    }

    // Rotating outer ring segments
    for (int i = 0; i < 12; i++) {
      final angle = progress * 2 * pi + i * pi / 6;
      final start = Offset(cos(angle) * radius * 0.6, sin(angle) * radius * 0.6);
      final end = Offset(cos(angle) * radius * 0.9, sin(angle) * radius * 0.9);

      paint
        ..color = Colors.cyanAccent
        ..strokeWidth = 2;
      canvas.drawLine(start, end, paint);
    }

    // Rotating circular sweep arc
    final arcPaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arcRadius = radius * 0.95;
    final arcRect = Rect.fromCircle(center: Offset.zero, radius: arcRadius);
    final arcAngle = pi / 6;
    final sweepStart = progress * 2 * pi;

    canvas.drawArc(arcRect, sweepStart, arcAngle, false, arcPaint);

    // Radial spikes (like a radar)
    for (int i = 0; i < 60; i += 5) {
      final angle = i * pi / 30 + progress * pi;
      final spikeStart = Offset(cos(angle) * radius * 0.8, sin(angle) * radius * 0.8);
      final spikeEnd = Offset(cos(angle) * radius, sin(angle) * radius);

      paint
        ..color = Colors.cyanAccent.withOpacity(0.3)
        ..strokeWidth = 1;
      canvas.drawLine(spikeStart, spikeEnd, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

