import 'package:flutter/material.dart';

class ParallelPigLogo extends StatelessWidget {
  final double size;

  ParallelPigLogo({this.size = 200});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: LogoPainter(),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw two parallel lines
    paint.color = Colors.pink[300]!;
    paint.strokeWidth = size.width * 0.05;
    paint.style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      paint,
    );

    // Draw pig face
    paint.color = Colors.pink[200]!;
    paint.style = PaintingStyle.fill;

    // Face
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      size.width * 0.25,
      paint,
    );

    // Ears
    final earPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.55)
      ..lineTo(size.width * 0.25, size.height * 0.4)
      ..lineTo(size.width * 0.45, size.height * 0.5)
      ..close();
    canvas.drawPath(earPath, paint);

    final earPath2 = Path()
      ..moveTo(size.width * 0.65, size.height * 0.55)
      ..lineTo(size.width * 0.75, size.height * 0.4)
      ..lineTo(size.width * 0.55, size.height * 0.5)
      ..close();
    canvas.drawPath(earPath2, paint);

    // Eyes
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.65),
      size.width * 0.03,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.65),
      size.width * 0.03,
      paint,
    );

    // Nose
    paint.color = Colors.pink[300]!;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.75),
        width: size.width * 0.2,
        height: size.height * 0.1,
      ),
      paint,
    );

    // Nostrils
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.45, size.height * 0.75),
      size.width * 0.015,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.75),
      size.width * 0.015,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}