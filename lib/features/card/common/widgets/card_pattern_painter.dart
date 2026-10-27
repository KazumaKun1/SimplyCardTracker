import 'package:flutter/material.dart';

class CardPatternPainter extends CustomPainter {
  const CardPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.10);
    // Top-right: center sits just inside the corner, radius 40% of card width
    canvas.drawCircle(
      Offset(size.width * 0.95, 0),
      size.width * 0.45,
      paint,
    );

    // Bottom-left: center sits exactly on the corner, radius 55% of card width
    canvas.drawCircle(Offset(0, size.height * 0.95), size.width * 0.70, paint);
  }

  @override
  bool shouldRepaint(covariant CardPatternPainter oldDelegate) => false;
}
