
import 'package:flutter/material.dart';


class ToggleButton extends StatefulWidget {

  final ToggleDecoration decoration;
  final bool Function() callback;
  final void Function(bool) onChanged;

  ToggleButton({super.key, required this.callback, required this.onChanged, ToggleDecoration? decoration}):
      decoration = decoration ?? ToggleDecoration();


  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {

  late bool isToggled;

  _onChanged() {
    setState(() {
      isToggled = !isToggled;
    });
    widget.onChanged(isToggled);
  }

  @override
  void initState() {
    isToggled = widget.callback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Padding top, bottom 각각 3씩
    double ballSize = widget.decoration.height - 6;

    return GestureDetector(
      onTap: _onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.decoration.width,
        height: widget.decoration.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isToggled ? widget.decoration.color : const Color(0xFFD9D9D9),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              top: 3,
              left: isToggled ? ballSize : 0.0,
              right: isToggled ? 0.0 : ballSize,
              child: Container(
                width: ballSize,
                height: ballSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InnerShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 10.0);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class ToggleDecoration {

  final double width;
  final double height;
  final Color color;

  ToggleDecoration({this.width = 40, this.height = 24, Color? color}):
    color = color ?? const Color(0xFF74A9F8);
}