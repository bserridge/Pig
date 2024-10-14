import 'package:flutter/material.dart';

class FarmBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FarmBackgroundPainter(),
      child: Container(),
    );
  }
}

class FarmBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw grass
    paint.color = Color(0xFF32CD32);  // Lime Green
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      paint,
    );

    // Draw a simple house
    paint.color = Color(0xFFCD853F);  // Peru (brownish)
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.5, size.width * 0.2, size.height * 0.2),
      paint,
    );
    
    // Draw roof
    final roofPath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.5)
      ..lineTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.35, size.height * 0.5)
      ..close();
    paint.color = Color(0xFF8B4513);  // Saddle Brown
    canvas.drawPath(roofPath, paint);

    // Draw sun
    paint.color = Color(0xFFFFD700);  // Gold
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), size.width * 0.1, paint);

    // Draw clouds
    paint.color = Colors.white.withOpacity(0.7);
    _drawCloud(canvas, size.width * 0.2, size.height * 0.15, size.width * 0.15, paint);
    _drawCloud(canvas, size.width * 0.6, size.height * 0.25, size.width * 0.2, paint);
  }

  void _drawCloud(Canvas canvas, double x, double y, double size, Paint paint) {
    canvas.drawCircle(Offset(x, y), size * 0.5, paint);
    canvas.drawCircle(Offset(x + size * 0.4, y), size * 0.4, paint);
    canvas.drawCircle(Offset(x + size * 0.8, y), size * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}