import 'package:flutter/material.dart';
import 'dart:math';
import 'results_screen.dart';
import 'pig_dice.dart';
// import 'pig_themed_button.dart';

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
  bool isRolling = false;
  bool isYourTurn = true;
  bool gameOver = false;

  final Random _random = Random();

  void rollDice() {
    
    assert(!gameOver); // we check this before calling rollDice
    assert(!isRolling); // we check this before calling rollDice

    // prior code returned if !isYourTurn but I think we should use this function for when it's the pig's turn too

    setState(() {
      isRolling = true;
      diceValue = _random.nextInt(6) + 1;
    });
  }

  void hold() {
    
    assert (!gameOver); // we check this before calling hold
    assert (!isRolling); // we check this before calling hold

    endTurn();

    checkWinCondition();

    if (!isYourTurn) {
      // Trigger AI turn after a short delay
      aiTurn();
    }

  }

  void endTurn() {
    setState(() {
      isRolling = false;
    
      if (isYourTurn) {
        yourScore += currentTurn;
      } else {
        pigScore += currentTurn;
      }
      currentTurn = 0;
      isYourTurn = !isYourTurn;
    });
  }
  
  /* this function is not used???
  void switchTurn() {
    isYourTurn = !isYourTurn;
  }
*/

  void checkWinCondition() {
    if (yourScore >= WIN_SCORE || pigScore >= WIN_SCORE) {
      setState(() {
        gameOver = true;
      });
    
      bool youWon = yourScore >= WIN_SCORE;
      
      // Navigate to ResultsScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              yourScore: yourScore,
              pigScore: pigScore,
              youWon: youWon,
            ),
          ),
        );
      });
    }
  }

  void aiTurn() {
    // Simple AI: Roll until reaching 20 points or rolling a 1

    assert(!gameOver); // we check this before calling aiTurn

    if (currentTurn < 20) {
      Future.delayed(Duration(milliseconds: 1000), rollDice);
    } else {
      hold();
    }
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

  void onRollComplete() {
    
    assert(diceValue > 0);

    setState(() {
      isRolling = false;
      
      if (diceValue != 1) {
        currentTurn += diceValue;
      } else {
        currentTurn = 0;
        endTurn();
      }
    });

    checkWinCondition();

    if (!isYourTurn && !gameOver) {
     // Trigger AI turn
      aiTurn();
    }
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
            
            // removing the old dice display
            // PigDice(value: diceValue, size: 200),

            // here's the new code
            AnimatedPigDice(
              value: diceValue,
              size: 200,
              onRollComplete: onRollComplete,
            ),

            /*
            // removing the old dice display
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
            */
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
                  /* commenting out the PigThemedButtons for now
                  PigThemedButton(
                    text: 'Roll',
                    onPressed: isYourTurn && !gameOver ? rollDice : () {},
                    color: Color(0xFFFFA500), // Orange
                    width: 140,
                    height: 60,
                  ),
                  PigThemedButton(
                    text: 'Hold',
                    onPressed: isYourTurn && !gameOver ? hold : () {},
                    color: Color(0xFFFF6347), // Tomato Red
                    width: 140,
                    height: 60,
                  ),
                  */
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA500)), // Orange
                    onPressed: isYourTurn && !gameOver && !isRolling ? rollDice : null,
                    child: const Text('Roll'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(11, 212, 188, 1)), // Teal (Rebeca's idea)
                    onPressed: isYourTurn && !gameOver && !isRolling ? hold : null,
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