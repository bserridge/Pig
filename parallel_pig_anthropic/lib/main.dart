import 'package:flutter/material.dart';

void main() => runApp(ParallelPigGame());

class ParallelPigGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallel Pig',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int yourScore = 0;
  int pigScore = 0;
  int currentTurn = 0;
  int diceValue = 1;

  void rollDice() {
    setState(() {
      diceValue = 1 + (DateTime.now().millisecondsSinceEpoch % 6);
      if (diceValue != 1) {
        currentTurn += diceValue;
      } else {
        currentTurn = 0;
        // Switch to AI turn (to be implemented)
      }
    });
  }

  void hold() {
    setState(() {
      yourScore += currentTurn;
      currentTurn = 0;
      // Switch to AI turn (to be implemented)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E8B57), // Dark Sea Green
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xFFFFD700), // Yellow
              height: 70,
              child: Center(child: Text('Parallel Pig', style: TextStyle(fontSize: 24))),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Color(0xFFFFC0CB), // Pink
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Your score'),
                        Text('$yourScore', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color(0xFFFFC0CB), // Pink
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pig's score"),
                        Text('$pigScore', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Color(0xFFFFD700), // Yellow
              height: 40,
              child: Center(child: Text('Goal: 100 points | You need: ${100 - yourScore} more to win!')),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.white,
                  child: Center(child: Text('$diceValue', style: TextStyle(fontSize: 72))),
                ),
              ),
            ),
            Container(
              color: Color(0xFFFFD700), // Yellow
              height: 50,
              child: Center(child: Text('Current Turn: $currentTurn')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFA500)), // Orange
                    onPressed: rollDice,
                    child: Text('Roll'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6347)), // Tomato Red
                    onPressed: hold,
                    child: Text('Hold'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}