import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';
import '../widgets/move_tile.dart';

class MovesScreen extends StatefulWidget {
  final Box<Move> moveBox;
  const MovesScreen({super.key, required this.moveBox});

  @override
  State<MovesScreen> createState() => _MovesScreenState();
}

class _MovesScreenState extends State<MovesScreen> {
  String query = '';
  final TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            controller: _controller,
            constraints: BoxConstraints(maxHeight: 60.0,maxWidth: 200.0),
            leading: const Icon(Icons.search),
            trailing: [
              if (query.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                     _controller.clear(); 
                    setState(() {query = '';});
                  },
                ),
            ],
            onChanged: (value) {
              setState(() {
                query = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.moveBox.listenable(),
            builder: (context, Box<Move> box, _) {

              List<Move> moves = box.values.where((move) {
                return move.name.toLowerCase().contains(query);
              }).toList();

              if (moves.isEmpty) {
                return const Center(child: Text('No results!'));
              }

              return ListView.builder(
                itemCount: moves.length,
                itemBuilder: (context, index) {
                  return MoveTile(move: moves[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
