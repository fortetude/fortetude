import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/lines/models/line.dart';
import '../../features/moves/models/move.dart';

class FTSearchDelegate extends SearchDelegate<int?> {
  final Box<dynamic> box;

  FTSearchDelegate({required this.box});

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
    final results = box.values.where((move) {
      return move.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,

      itemBuilder: (context, index) {
        final item = results[index];

        return ListTile(
          title: Text(item.name),
          trailing: (item.runtimeType == Line && item.pinned) ?
            Icon(Icons.push_pin_sharp, color: Colors.grey.shade400): null
          ,
          onTap: () {
            if (item.runtimeType == Move) {
              close(context, item.moveId);
            } else {
              close(context, item.key);
            }
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
