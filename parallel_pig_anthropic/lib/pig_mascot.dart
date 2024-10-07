import 'package:flutter/material.dart';

class PigMascot extends StatelessWidget {
  final double size;
  final bool isHappy;

  PigMascot({this.size = 200, this.isHappy = true});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PigPainter(isHappy: isHappy),
    );
  }
}

class PigPainter extends CustomPainter {
  final bool isHappy;

  PigPainter({required this.isHappy});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Body
    paint.color = Color(0xFFFFC0CB); // Light pink
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), 
                      width: size.width * 0.8, height: size.height * 0.7),
      paint,
    );

    // Ears
    paint.color = Color(0xFFFFB6C1); // Lighter pink
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.3, size.height * 0.3), 
                      width: size.width * 0.2, height: size.height * 0.2),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.7, size.height * 0.3), 
                      width: size.width * 0.2, height: size.height * 0.2),
      paint,
    );

    // Eyes
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.4), size.width * 0.08, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.4), size.width * 0.08, paint);

    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.4), size.width * 0.04, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.4), size.width * 0.04, paint);

    // Nose
    paint.color = Color(0xFFFF69B4); // Hot pink
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.55), 
                      width: size.width * 0.3, height: size.height * 0.2),
      paint,
    );

    // Nostrils
    paint.color = Color(0xFFFF1493); // Deep pink
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.55), size.width * 0.02, paint);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.55), size.width * 0.02, paint);

    // Mouth
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.02;
    if (isHappy) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.65), 
                        width: size.width * 0.4, height: size.height * 0.2),
        0.2, 
        2.7, 
        false, 
        paint
      );
    } else {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.7), 
                        width: size.width * 0.4, height: size.height * 0.2),
        3.4, 
        2.7, 
        false, 
        paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}