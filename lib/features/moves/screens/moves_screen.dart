import 'package:flutter/material.dart';
import '../models/move_items.dart';
import '../widgets/move_tile.dart';

class MovesScreen extends StatelessWidget {
  const MovesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final move in allMoves)
          MoveTile(move: move),
      ],
    );
  }
}