import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/login.dart';
import '../screens/memory_game_screen.dart';
import '../screens/snake_game_screen.dart';
import '../screens/tic_tac_toe_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/tic-tac-toe',
      builder: (context, state) => const TicTacToeScreen(),
    ),

    GoRoute(
      path: '/memory',
      builder: (context, state) => const MemoryGameScreen(),
    ),

    GoRoute(
      path: '/snake',
      builder: (context, state) => const SnakeGameScreen(),
    ),
  ],
);