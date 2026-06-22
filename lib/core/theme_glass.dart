import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsets? padding;
  final BorderRadius radius;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.15,
    this.padding,
    this.radius = const BorderRadius.all(Radius.circular(20)), required int height, required Future<Null> Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: radius,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: child,
      ),
    );
  }
}
