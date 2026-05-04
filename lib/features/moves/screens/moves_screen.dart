import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';
import '../widgets/move_tile.dart';

class MovesScreen extends StatelessWidget {
  final Box<Move> moveBox;
  const MovesScreen({super.key, required this.moveBox});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: moveBox.listenable(),
      builder: (context, Box<Move> box, _) {
        List<Move> moves = box.values.toList();

        return ListView.builder(
          itemCount: moves.length,
          itemBuilder: (context, index) {
            return MoveTile(move: moves[index]);
          }
        );
      }

    );
  }
  
}