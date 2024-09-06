import 'dart:math';
import 'package:flutter/material.dart';

class ChartsExample extends StatefulWidget {
  final double diameter;
  final Duration? duration;
  final List<ChartData> data;

  const ChartsExample({super.key, required this.data, required this.diameter, this.duration});

  @override
  State<ChartsExample> createState() => _ChartsExampleState();
}

class _ChartsExampleState extends State<ChartsExample> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ChartData? selectedData; // 탭한 데이터 저장

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 500),
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

  void _onTapUp(TapUpDetails details, Size size) {
    // 탭한 좌표를 가져옴
    final tapPosition = details.localPosition;

    // 도넛의 중심 좌표
    final center = Offset(size.width / 2, size.height / 2);

    // 탭한 위치에서 중심까지의 거리
    final distanceFromCenter = (tapPosition - center).distance;

    final double radius = size.width / 2;

    if (distanceFromCenter < radius && distanceFromCenter > radius - 50) {
      // 탭한 위치가 도넛 차트 내부에 있는지 확인 (도넛 두께가 50이라고 가정)

      // 탭한 위치의 각도를 계산 (중심 기준으로 시계방향 0도부터 시작)
      double angle = atan2(tapPosition.dy - center.dy, tapPosition.dx - center.dx) * (180 / pi);
      if (angle < 0) angle += 360; // 음수 각도는 양수로 변환

      // 각 데이터 섹션에 해당하는 범위를 확인
      double startAngle = -90.0; // 도넛의 시작 각도
      final total = widget.data.map((x) => x.value).reduce((a, b) => a + b);

      for (var item in widget.data) {
        final sweepAngle = (item.value / total) * 360;

        if (angle >= startAngle && angle < startAngle + sweepAngle) {
          setState(() {
            selectedData = item; // 선택한 데이터 저장
          });
          break;
        }

        startAngle += sweepAngle;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapUp: (details) => _onTapUp(details, Size(widget.diameter, widget.diameter)), // 탭 이벤트 처리
          child: SizedBox(
            width: widget.diameter,
            height: widget.diameter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: DonutChartPainter(
                    progress: _animation.value,
                    dataList: widget.data,
                    diameter: widget.diameter,
                    selectedData: selectedData, // 선택된 데이터 전달
                  ),
                );
              },
            ),
          ),
        ),

        Positioned(
          width: widget.diameter,
          height: widget.diameter,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('성별',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (selectedData != null)
                  Text('${selectedData!.title} (${_per(selectedData!.value)}%)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  int _per(int value) {
    int total = widget.data.map((x) => x.value).reduce((a, b) => a + b);
    return (value / total * 100).round();
  }
}

class DonutChartPainter extends CustomPainter {
  final double progress;
  final double diameter;
  final List<ChartData> dataList;
  final ChartData? selectedData; // 선택된 데이터
  final double strokeWidth;

  DonutChartPainter({required this.progress, required this.dataList, this.selectedData, required this.diameter}):
      strokeWidth = diameter / 4;

  @override
  void paint(Canvas canvas, Size size) {
    final int total = dataList.map((x) => x.value).reduce((a, b) => a + b);
    double startAngle = -90.0; // 시작 각도
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth // 기본 도넛 두께
      ..strokeCap = StrokeCap.butt;

    final double radius = size.width / 3;
    double accumulatedProgress = 0.0; // 현재까지의 누적 진행도

    for (ChartData data in dataList) {
      final double sectionProgress = (data.value / total); // 해당 데이터의 백분율

      // 현재 진행도가 이 섹션에 아직 도달하지 않았을 경우 그리지 않음
      if (progress <= accumulatedProgress) break;

      // 현재 섹션의 진행도 중 그릴 부분만 계산
      final double sweepProgress = (progress - accumulatedProgress).clamp(0.0, sectionProgress);
      final double sweepAngle = sweepProgress * 360;

      paint.color = data.color;
      // 선택된 데이터 는 강조 처리
      if (selectedData == data) {
        paint.strokeWidth = strokeWidth + (diameter / 20); // 강조된 두께
      } else {
        paint.strokeWidth = strokeWidth; // 기본 두께
      }

      // 섹션 그리기
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        radians(startAngle),
        radians(sweepAngle),
        false,
        paint,
      );

      // 섹션의 중앙 각도를 계산하여 텍스트 그리기
      final double halfAngle = startAngle + sweepAngle / 2;
      final Offset labelPosition = Offset(
        size.width / 2 + radius * cos(radians(halfAngle)), // 중앙 위치에서 조금 안쪽에 그리기
        size.height / 2 + radius * sin(radians(halfAngle)),
      );

      // 섹션이 로드될 때 텍스트를 그리기
      _drawText(canvas, data.title, labelPosition);

      startAngle += sectionProgress * 360;
      accumulatedProgress += sectionProgress; // 누적 진행도 갱신
    }
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double radians(double degrees) => degrees * (3.141592653589793 / 180);
}

class ChartData {
  final String title;
  final int value;
  final Color color;

  ChartData({required this.title, required this.value, required this.color});
}
