import 'package:flutter/material.dart';

class PigThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double height;

  PigThemedButton({
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFFF6347),  // Default to Tomato Red
    this.width = 200,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        size: Size(width, height),
        painter: PigButtonPainter(color: color),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class PigButtonPainter extends CustomPainter {
  final Color color;

  PigButtonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw main button shape (rounded rectangle)
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(rrect, paint);

    // Draw pig ear on left side
    final leftEarPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.05, size.height * 0.1,
        size.width * 0.2, size.height * 0.1,
      )
      ..quadraticBezierTo(
        size.width * 0.25, size.height * 0.2,
        size.width * 0.2, size.height * 0.3,
      )
      ..close();
    canvas.drawPath(leftEarPath, paint);

    // Draw pig ear on right side
    final rightEarPath = Path()
      ..moveTo(size.width * 0.9, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.95, size.height * 0.1,
        size.width * 0.8, size.height * 0.1,
      )
      ..quadraticBezierTo(
        size.width * 0.75, size.height * 0.2,
        size.width * 0.8, size.height * 0.3,
      )
      ..close();
    canvas.drawPath(rightEarPath, paint);

    // Add a subtle gradient for depth
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white.withOpacity(0.3), Colors.transparent],
      stops: [0.0, 0.5],
    );
    final gradientPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.srcATop;
    canvas.drawRRect(rrect, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}