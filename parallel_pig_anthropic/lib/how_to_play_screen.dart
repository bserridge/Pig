import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E8B57), // Dark Sea Green
      appBar: AppBar(
        title: const Text('How to Play'),
        backgroundColor: const Color(0xFFFFD700), // Yellow
        foregroundColor: Colors.black, // Makes the back arrow and text black
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Objective', [
                'Reach 100 or more points before Pig does!',
              ]),
              const SizedBox(height: 20),
              _buildSection('How to Play', [
                '1. Roll the die on your turn',
                '2. After each roll, you have two choices:',
                '   • Roll again to accumulate more points on this turn',
                '   • End your turn, adding the points to your score',
                '3. If you roll a 1, you lose all points for this turn',
                '4. After you hold or roll a 1, it becomes Pig\'s turn',
              ]),
              const SizedBox(height: 20),
              _buildSection('Strategy Tips', [
                '• Each roll is a risk vs. reward decision',
                '• The more you roll, the more you might gain... or lose!',
                '• Watch out for the pig nose - it means you rolled a 1!',
              ]),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6347), // Tomato Red
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Got it!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC0CB), // Pink
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              point,
              style: const TextStyle(fontSize: 16),
            ),
          )).toList(),
        ],
      ),
    );
  }
}