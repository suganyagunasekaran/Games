import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/game_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Game> games = const [
    Game(
      name: 'Tic Tac Toe',
      icon: Icons.close,
      route: '/tic-tac-toe',
    ),
    Game(
      name: 'Memory Game',
      icon: Icons.psychology,
      route: '/memory',
    ),
    Game(
      name: 'Snake',
      icon: Icons.gamepad,
      route: '/snake',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 Game Center'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];

          return ListTile(
            leading: Icon(game.icon),
            title: Text(game.name),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push(game.route);
            },
          );
        },
      ),
    );
  }
}