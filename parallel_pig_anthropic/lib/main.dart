import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() => runApp(ParallelPigGame());

class ParallelPigGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallel Pig',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}