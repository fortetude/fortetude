import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';
import '../widgets/move_tile.dart';

class MovesScreen extends StatefulWidget {
  final Box<Move> moveBox;
  final Set<Category> categoryFilters;
  final Set<Competency> competencyFilters;
  final Set<AreaOfConcern> areaFilters;

  const MovesScreen({
    super.key,
    required this.moveBox,
    required this.categoryFilters,
    required this.competencyFilters,
    required this.areaFilters,
  });

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
                    widget.categoryFilters.isEmpty ||
                    widget.categoryFilters.contains(move.category);

                final matchesCompetency =
                    widget.competencyFilters.isEmpty ||
                    widget.competencyFilters.contains(move.competency);

                final matchesArea =
                    widget.areaFilters.isEmpty ||
                    widget.areaFilters.any((a) => move.areas.contains(a));

                return matchesSearch &&
                    matchesCategory &&
                    matchesCompetency &&
                    matchesArea;
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
  final Set<Category> categoryFilters;
  final Set<Competency> competencyFilters;
  final Set<AreaOfConcern> areaFilters;

  final ValueChanged<Set<Category>> onCategoryChanged;
  final ValueChanged<Set<Competency>> onCompetencyChanged;
  final ValueChanged<Set<AreaOfConcern>> onAreaChanged;

  const MovesDrawer({
    super.key,
    required this.categoryFilters,
    required this.competencyFilters,
    required this.areaFilters,
    required this.onCategoryChanged,
    required this.onCompetencyChanged,
    required this.onAreaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.blue,
      width: 200,
      child: ListView(
        children: [
          //Category Filter + Label
          Text("Filter by Category:"),
          Wrap(
            spacing: 5.0,
            children: Category.values.map((Category category) {
              return FilterChip(
                label: Text(category.name),
                selected: categoryFilters.contains(category),
                onSelected: (bool selected) {
                  final newFilters = {...categoryFilters};
                  if (selected) {
                    newFilters.add(category);
                  } else {
                    newFilters.remove(category);
                  }

                  onCategoryChanged(newFilters);
                },
              );
            }).toList(),
          ),
          // Competency Filter + label
          Text("Filter by Competency:"),
          Wrap(
            spacing: 5.0,
            children: Competency.values.map((c) {
              return FilterChip(
                label: Text(c.name),
                selected: competencyFilters.contains(c),
                onSelected: (selected) {
                  final newSet = {...competencyFilters};
                  selected ? newSet.add(c) : newSet.remove(c);
                  onCompetencyChanged(newSet);
                },
              );
            }).toList(),
          ),

          // Area of Concern Filter + label
          Text("Filter by Area of Concern:"),
          Wrap(
            spacing: 5.0,
            children: AreaOfConcern.values.map((a) {
              return FilterChip(
                label: Text(a.name),
                selected: areaFilters.contains(a),
                onSelected: (selected) {
                  final newSet = {...areaFilters};
                  selected ? newSet.add(a) : newSet.remove(a);
                  onAreaChanged(newSet);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
