import 'package:flutter/material.dart';
import '../models/move_items.dart';
import '../models/move.dart';


class MovesScreen extends StatelessWidget {

  const MovesScreen({super.key});

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(title: Align(alignment: Alignment.center, child: Text('Moves Screen'))),
      body: ListView(
        children: [
          for (Move move in allMoves)
            ListTile(
              title: Text(move.name),
              subtitle: Text(move.control.toString()),
              onTap: () { showModalBottomSheet<void>(
                context: build,
                builder: (BuildContext context) {
                  return Container();
                },
              );
              }
            ),
        ]

          
      ),
    );
  }
}