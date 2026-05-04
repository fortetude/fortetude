import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';
import '../widgets/move_tile.dart';

class MovesScreen extends StatefulWidget {
  final Box<Move> moveBox;
  final Set<Category> filters;
  const MovesScreen({super.key, required this.moveBox, required this.filters});

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
            constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 200.0),
            leading: const Icon(Icons.search),
            trailing: [
              if (query.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      query = '';
                    });
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
                final matchesSearch = move.name.toLowerCase().contains(query);

                final matchesCategory =
                    widget.filters.isEmpty ||
                    widget.filters.contains(move.category);

                return matchesSearch && matchesCategory;
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

class MovesDrawer extends StatelessWidget {
  final Set<Category> filters;
  final ValueChanged<Set<Category>> onChanged;
  const MovesDrawer({
    super.key,
    required this.filters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.blue,
      width: 200,
      child: ListView(
        children: [
          Text("Filter by move category:"),
          Wrap(
            spacing: 5.0,
            children: Category.values.map((Category category) {
              return FilterChip(
                label: Text(category.name),
                selected: filters.contains(category),
                onSelected: (bool selected) {
                  final newFilters = {...filters};
                  if (selected) {
                    newFilters.add(category);
                  } else {
                    newFilters.remove(category);
                  }

                  onChanged(newFilters);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
