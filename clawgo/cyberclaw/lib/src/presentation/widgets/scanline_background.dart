import 'package:flutter/material.dart';

class ScanlineBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const ScanlineBackground({
    super.key,
    required this.child,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  const Color(0xFF191919),
                  Theme.of(context).colorScheme.background,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: ScanlinePainter(opacity: opacity)),
          ),
        ),
        child,
      ],
    );
  }
}

class ScanlinePainter extends CustomPainter {
  final double opacity;

  ScanlinePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    const double scanlineHeight = 2.0;
    const double spacing = 4.0;

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, scanlineHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
