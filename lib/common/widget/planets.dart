import 'dart:ui';

import 'package:flutter/material.dart';

class PlanetsWidget extends StatefulWidget {
  final Color animCircleColor;
  final double animCircleRadius;
  final double value;
  final double pathRadius;
  final Duration duration;

  const PlanetsWidget({
    Key? key,
    this.animCircleColor = Colors.white,
    this.animCircleRadius = 5.0,
    this.value = 0.0,
    this.pathRadius = 10.0,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _PlanetsWidgetState createState() => _PlanetsWidgetState();
}

class _PlanetsWidgetState extends State<PlanetsWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.repeat();
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
      builder: (context, snapshot) {
        return Center(
          child: CustomPaint(
            painter: AtomPaint(
              animCircleColor: widget.animCircleColor,
              animCircleRadius: widget.animCircleRadius,
              value: _controller.value,
              pathRadius: widget.pathRadius,
            ),
          ),
        );
      },
    );
  }
}

class AtomPaint extends CustomPainter {
  final Color animCircleColor;
  final double animCircleRadius;
  final double value;
  final double pathRadius;

  AtomPaint({
    this.animCircleColor = Colors.white,
    this.animCircleRadius = 5.0,
    this.value = 0.0,
    this.pathRadius = 10.0,
  });

  // Paint _axisPaint = Paint()
  //   ..color = Colors.grey.shade200
  //   ..strokeWidth = 2.0
  //   ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawCircle(Offset.zero, 20.0, Paint()..color = Colors.red);
    drawAxis(value, canvas, pathRadius, Paint()..color = animCircleColor);
  }

  drawAxis(double value, Canvas canvas, double radius, Paint paint) {
    var firstAxis = getCirclePath(radius);
    // canvas.drawPath(firstAxis, _axisPaint);
    PathMetrics pathMetrics = firstAxis.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(0.0, pathMetric.length * value);
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)?.position ?? const Offset(0.0, 0.0);
        canvas.drawCircle(offset, animCircleRadius, paint);
      } catch (e) {}
    }
  }

  Path getCirclePath(double radius) => Path()..addOval(Rect.fromCircle(center: const Offset(0, 0), radius: radius));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
