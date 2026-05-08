import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/moves/models/move.dart';

class MoveSearchDelegate extends SearchDelegate<int?> {
  final Box<Move> moveBox;

  MoveSearchDelegate({required this.moveBox});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = moveBox.values.where((move) {
      return move.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,

      itemBuilder: (context, index) {
        final move = results[index];

        return ListTile(
          title: Text(move.name),
          onTap: () {
            close(context, move.moveId);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
