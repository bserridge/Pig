import 'package:flutter/material.dart';

class PigDice extends StatelessWidget {
  final int value;
  final double size;

  PigDice({required this.value, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DicePainter(value: value),
    );
  }
}

class DicePainter extends CustomPainter {
  final int value;

  DicePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Dice body
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.2),
      ),
      paint,
    );

    // Dice border
    paint.color = Color(0xFFFFC0CB); // Light pink
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.05;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.2),
      ),
      paint,
    );

    paint.color = Color(0xFFFF69B4); // Hot pink
    paint.style = PaintingStyle.fill;

    // Draw pips based on dice value
    switch (value) {
      case 1:
        _drawPip(canvas, size, 0.5, 0.5, size.width * 0.15, paint);
        break;
      case 2:
        _drawPip(canvas, size, 0.3, 0.3, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.7, size.width * 0.1, paint);
        break;
      case 3:
        _drawPip(canvas, size, 0.3, 0.3, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.5, 0.5, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.7, size.width * 0.1, paint);
        break;
      case 4:
        _drawPip(canvas, size, 0.3, 0.3, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.3, 0.7, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.3, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.7, size.width * 0.1, paint);
        break;
      case 5:
        _drawPip(canvas, size, 0.3, 0.3, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.3, 0.7, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.5, 0.5, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.3, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.7, size.width * 0.1, paint);
        break;
      case 6:
        _drawPip(canvas, size, 0.3, 0.25, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.3, 0.5, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.3, 0.75, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.25, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.5, size.width * 0.1, paint);
        _drawPip(canvas, size, 0.7, 0.75, size.width * 0.1, paint);
        break;
    }
  }

  void _drawPip(Canvas canvas, Size size, double x, double y, double radius, Paint paint) {
    canvas.drawCircle(Offset(size.width * x, size.height * y), radius, paint);
    
    // Draw a small snout in each pip
    paint.color = Color(0xFFFF1493); // Deep pink
    canvas.drawCircle(Offset(size.width * x - radius * 0.3, size.height * y), radius * 0.2, paint);
    canvas.drawCircle(Offset(size.width * x + radius * 0.3, size.height * y), radius * 0.2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}