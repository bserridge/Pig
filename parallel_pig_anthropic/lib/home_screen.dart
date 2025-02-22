import 'package:flutter/material.dart';
import 'game_screen.dart';  // Make sure to create this file if you haven't already
// import 'parallel_pig_logo.dart';
import 'pig_mascot.dart';
// import 'farm_background.dart';
import 'how_to_play_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E8B57),  // Dark Sea Green
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // FarmBackground(),
              Container(
                width: 300,
                height: 150,
                color: Color(0xFFFFD700),  // Yellow
                child: Center(
                  child: Text(
                    'Parallel Pig',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50), // TO DO - what is this for? just to space things out?
              // TO DO - replace the emoji list in the ParallelPigLogo widget with the PigMascot widget, so that we get a row of three pig mascots
              PigMascot(size: 200, isHappy: true),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6347),  // Tomato Red
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text(
                  'Start Game',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500),  // Orange
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text(
                  'How to Play',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  // TODO: Implement How to Play screen or dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HowToPlayScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}