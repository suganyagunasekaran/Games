import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final List<String> emojis = [
    '🐶',
    '🐶',
    '🐱',
    '🐱',
    '🦁',
    '🦁',
    '🐼',
    '🐼',
    '🐸',
    '🐸',
    '🐵',
    '🐵',
  ];

  late List<String> cards;

  List<bool> revealed = [];

  int? firstIndex;
  int? secondIndex;

  bool checking = false;

  int moves = 0;
  int matchedPairs = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    cards = List.from(emojis);
    cards.shuffle(Random());

    revealed = List.filled(cards.length, false);

    firstIndex = null;
    secondIndex = null;
    checking = false;

    moves = 0;
    matchedPairs = 0;
  }

  Future<void> selectCard(int index) async {
    if (checking || revealed[index]) {
      return;
    }

    setState(() {
      revealed[index] = true;

      if (firstIndex == null) {
        firstIndex = index;
      } else {
        secondIndex = index;
        checking = true;
        moves++;
      }
    });

    if (secondIndex != null) {
      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      setState(() {
        if (cards[firstIndex!] == cards[secondIndex!]) {
          matchedPairs++;
        } else {
          revealed[firstIndex!] = false;
          revealed[secondIndex!] = false;
        }

        firstIndex = null;
        secondIndex = null;
        checking = false;
      });
    }
  }

  void restartGame() {
    setState(() {
      initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final completed = matchedPairs == cards.length ~/ 2;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Memory Game'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              'Moves: $moves',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Pairs: $matchedPairs / ${cards.length ~/ 2}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            if (completed)
              const Text(
                '🎉 You Won!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: cards.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => selectCard(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          revealed[index] ? cards[index] : '❓',
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: restartGame,
              child: const Text('Restart'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}