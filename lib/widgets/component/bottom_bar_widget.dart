
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {

  final double height;
  final Widget child;
  final EdgeInsets? padding;

  const CustomBottomBar({super.key, required this.height, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      height: height + paddingBottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        left: padding?.left ?? 0,
        right: padding?.right ?? 0,
        top: padding?.top ?? 0,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, -10), blurRadius: 10)
          ]
      ),
      child: child
    );
  }
}
