import 'package:flutter/material.dart';

class ParallelPigLogo extends StatelessWidget {
  final double size;

  ParallelPigLogo({this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (_) => Text('🐷', style: TextStyle(fontSize: size * 0.2))),
          ),
          SizedBox(height: size * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (_) => Text('🐷', style: TextStyle(fontSize: size * 0.2))),
          ),
        ],
      ),
    );
  }
}