import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');

  String currentPlayer = 'X';
  String winner = '';

  int xScore = 0;
  int oScore = 0;

  void makeMove(int index) {
    if (board[index].isNotEmpty || winner.isNotEmpty) {
      return;
    }

    setState(() {
      board[index] = currentPlayer;

      checkWinner();

      if (winner.isEmpty) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  void checkWinner() {
    const winningPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final pattern in winningPatterns) {
      final a = pattern[0];
      final b = pattern[1];
      final c = pattern[2];

      if (board[a].isNotEmpty &&
          board[a] == board[b] &&
          board[b] == board[c]) {
        winner = board[a];

        if (winner == 'X') {
          xScore++;
        } else {
          oScore++;
        }

        return;
      }
    }

    if (!board.contains('')) {
      winner = 'Draw';
    }
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
    });
  }

  void resetScore() {
    setState(() {
      xScore = 0;
      oScore = 0;
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Tic Tac Toe'),
        ),

        body: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              winner.isEmpty
                  ? 'Player $currentPlayer Turn'
                  : winner == 'Draw'
                  ? '🤝 Match Draw'
                  : '🎉 Player $winner Wins!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'X: $xScore',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'O: $oScore',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 9,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => makeMove(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: resetGame,
              child: const Text('New Game'),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: resetScore,
              child: const Text('Reset Score'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}