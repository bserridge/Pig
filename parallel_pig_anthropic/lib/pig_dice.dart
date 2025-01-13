import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedPigDice extends StatefulWidget {
  final int value;
  final double size;
  final VoidCallback onRollComplete;
  final int rollNumber;

  AnimatedPigDice({
    required this.value,
    this.size = 200,
    required this.onRollComplete,
    required this.rollNumber,
  });

  @override
  _AnimatedPigDiceState createState() => _AnimatedPigDiceState();
}

class _AnimatedPigDiceState extends State<AnimatedPigDice> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ValueNotifier<int> _displayedValue;

  @override
  void initState() {
    super.initState();
    _displayedValue = ValueNotifier(1);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      if (_controller.value < 0.8) {
        _displayedValue.value = Random().nextInt(6) + 1;
      } else {
        _displayedValue.value = widget.value;
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onRollComplete();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedPigDice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rollNumber != oldWidget.rollNumber) {
      print("Starting animation for roll number: ${widget.rollNumber} (value: ${widget.value})");
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * pi,
          child: ValueListenableBuilder<int>(
            valueListenable: _displayedValue,
            builder: (context, value, child) {
              return PigDice(value: value, size: widget.size);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _displayedValue.dispose();
    super.dispose();
  }
}

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
        _drawPigNose(canvas, size, 0.5, 0.5, size.width * 0.2, paint);
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
  }

  void _drawPigNose(Canvas canvas, Size size, double x, double y, double radius, Paint paint) {
    // Main nose circle
    canvas.drawCircle(Offset(size.width * x, size.height * y), radius, paint);
    
    // Nostrils
    paint.color = Color(0xFFFF1493); // Deep pink
    canvas.drawCircle(Offset(size.width * x - radius * 0.4, size.height * y), radius * 0.25, paint);
    canvas.drawCircle(Offset(size.width * x + radius * 0.4, size.height * y), radius * 0.25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}