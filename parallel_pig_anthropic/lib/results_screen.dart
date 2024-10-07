import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int yourScore;
  final int pigScore;
  final bool youWon;

  ResultsScreen({required this.yourScore, required this.pigScore, required this.youWon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E8B57), // Dark Sea Green
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 100,
                color: Color(0xFFFFD700), // Yellow
                child: Center(
                  child: Text(
                    youWon ? 'You Win!' : 'Pig Wins!',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 300,
                padding: EdgeInsets.all(20),
                color: Color(0xFFFFC0CB), // Pink
                child: Column(
                  children: [
                    Text('Final Scores', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Your Score: $yourScore', style: TextStyle(fontSize: 20)),
                    Text('Pig\'s Score: $pigScore', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6347), // Tomato Red
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500), // Orange
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text(
                  'Exit',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  SystemNavigator.pop(); // This will close the app
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}