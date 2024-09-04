
import 'package:flutter/material.dart';

class ChartsExample extends StatefulWidget {
  const ChartsExample({super.key});

  @override
  State<ChartsExample> createState() => _ChartsExampleState();
}

class _ChartsExampleState extends State<ChartsExample>
  with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  final int _repeatCount = 4; // 반복 횟수 설정
  int _currentRepeat = 0; // 현재 반복 횟수

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: DonutChartPainter(_animation.value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {

  final double progress;
  final List<double> values = [30, 40, 20, 10];
  final List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow];
  int _index = 0;

  DonutChartPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    print('progress : $progress}');

    final double total = values.reduce((a, b) => a + b);
    double startAngle = -90.0;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50.0;


    final double radius = size.width / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 360 * progress;

      paint.color = colors[i];

      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        radians(startAngle),
        radians(sweepAngle),
        false,
        paint,
      );

      startAngle += (values[i] / total) * 360;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double radians(double degrees) => degrees * (3.141592653589793 / 180);
}

