import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int WIN_SCORE = 100;
  int yourScore = 0;
  int pigScore = 0;
  int currentTurn = 0;
  int diceValue = 1;
  bool isYourTurn = true;
  bool gameOver = false;

  final Random _random = Random();

  void rollDice() {
    if (gameOver) return;

    setState(() {
      diceValue = _random.nextInt(6) + 1;
      if (diceValue != 1) {
        currentTurn += diceValue;
      } else {
        currentTurn = 0;
        switchTurn();
      }
    });

    if (!isYourTurn) {
      aiTurn();
    }
  }

  void hold() {
    if (gameOver) return;

    setState(() {
      if (isYourTurn) {
        yourScore += currentTurn;
      } else {
        pigScore += currentTurn;
      }
      currentTurn = 0;
      checkWinCondition();
      if (!gameOver) {
        switchTurn();
      }
    });

    if (!isYourTurn && !gameOver) {
      aiTurn();
    }
  }

  void switchTurn() {
    isYourTurn = !isYourTurn;
  }

  void checkWinCondition() {
    if (yourScore >= WIN_SCORE) {
      gameOver = true;
      // Show win message
    } else if (pigScore >= WIN_SCORE) {
      gameOver = true;
      // Show lose message
    }
  }

  void aiTurn() {
    // Simple AI: Roll until reaching 20 points or rolling a 1
    while (currentTurn < 20) {
      rollDice();
      if (diceValue == 1 || gameOver) return;
    }
    hold();
  }

  void resetGame() {
    setState(() {
      yourScore = 0;
      pigScore = 0;
      currentTurn = 0;
      diceValue = 1;
      isYourTurn = true;
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E8B57), // Dark Sea Green
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              color: const Color(0xFFFFD700), // Yellow
              height: 70,
              child: const Center(child: Text('Parallel Pig', style: TextStyle(fontSize: 24))),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFFFFC0CB), // Pink
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Your score'),
                        Text('$yourScore', style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFFFC0CB), // Pink
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Pig's score"),
                        Text('$pigScore', style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: const Color(0xFFFFD700), // Yellow
              height: 40,
              child: Center(child: Text('Goal: $WIN_SCORE points | You need: ${WIN_SCORE - yourScore} more to win!')),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.white,
                  child: Center(child: Text('$diceValue', style: const TextStyle(fontSize: 72))),
                ),
              ),
            ),
            Container(
              color: const Color(0xFFFFD700), // Yellow
              height: 50,
              child: Center(child: Text('Current Turn: $currentTurn')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA500)), // Orange
                    onPressed: isYourTurn && !gameOver ? rollDice : null,
                    child: const Text('Roll'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6347)), // Tomato Red
                    onPressed: isYourTurn && !gameOver ? hold : null,
                    child: const Text('Hold'),
                  ),
                ],
              ),
            ),
            if (gameOver)
              ElevatedButton(
                onPressed: resetGame,
                child: Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}