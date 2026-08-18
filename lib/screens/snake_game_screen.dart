import 'dart:async';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int gridSize = 20;

  List<Point<int>> snake = [];

  late Point<int> food;

  Direction direction = Direction.right;

  Timer? timer;

  int score = 0;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer?.cancel();

    snake = [
      const Point(5, 10),
      const Point(4, 10),
      const Point(3, 10),
    ];

    direction = Direction.right;

    score = 0;
    gameOver = false;

    generateFood();

    timer = Timer.periodic(
      const Duration(milliseconds: 200),
          (_) => moveSnake(),
    );
  }

  void generateFood() {
    final random = Random();

    do {
      food = Point(
        random.nextInt(gridSize),
        random.nextInt(gridSize),
      );
    } while (snake.contains(food));
  }

  void moveSnake() {
    if (gameOver) return;

    final head = snake.first;

    Point<int> newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;

      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;

      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;

      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    if (newHead.x < 0 ||
        newHead.x >= gridSize ||
        newHead.y < 0 ||
        newHead.y >= gridSize ||
        snake.contains(newHead)) {
      endGame();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      if (newHead == food) {
        score++;
        generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void endGame() {
    timer?.cancel();

    setState(() {
      gameOver = true;
    });
  }

  void changeDirection(Direction newDirection) {
    if (direction == Direction.up &&
        newDirection == Direction.down) {
      return;
    }

    if (direction == Direction.down &&
        newDirection == Direction.up) {
      return;
    }

    if (direction == Direction.left &&
        newDirection == Direction.right) {
      return;
    }

    if (direction == Direction.right &&
        newDirection == Direction.left) {
      return;
    }

    setState(() {
      direction = newDirection;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          title: Text('Snake - Score: $score'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gridSize * gridSize,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                    ),
                    itemBuilder: (context, index) {
                      final x = index % gridSize;
                      final y = index ~/ gridSize;

                      final point = Point(x, y);

                      final isSnake = snake.contains(point);
                      final isFood = point == food;

                      return Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: isFood
                              ? const Text('🍎')
                              : isSnake
                              ? const Text('🟢')
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            if (gameOver)
              Column(
                children: [
                  const Text(
                    'Game Over!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: const TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        startGame();
                      });
                    },
                    child: const Text('Restart'),
                  ),
                ],
              ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    changeDirection(Direction.left);
                  },
                  icon: const Icon(Icons.arrow_left),
                ),
                Container(
                  color:Colors.green,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          changeDirection(Direction.up);
                        },
                        icon: const Icon(Icons.arrow_upward),
                      ),
                      IconButton(
                        onPressed: () {
                          changeDirection(Direction.down);
                        },
                        icon: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    changeDirection(Direction.right);
                  },
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}