import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../moves/models/move.dart';
import '../models/line.dart';

class LineScreen extends StatefulWidget {
  final Box<Line> lineBox;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(Line) onLineSelected;
  final void Function(Line) onLineTapped;
  final LinesSortType lsortType;

  const LineScreen({
    super.key,
    required this.lineBox,
    required this.scaffoldKey,
    required this.onLineSelected,
    required this.onLineTapped,
    required this.lsortType,
  });

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  late Box<Line> lineBox;
  int? selectedIndex;
  String query = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    lineBox = widget.lineBox;
  }

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
            valueListenable: widget.lineBox.listenable(),
            builder: (context, Box<Line> lineBox, _) {
              //final lines = lineBox.values.toList();

              final lines = lineBox.values.where((line) {
                return line.name.toLowerCase().contains(query);
              }).toList();

              if (lines.isEmpty) {
                return const Center(child: Text('No results!'));
              }

              // sort - accounting for pinned items
              lines.sort(widget.lsortType.compare);

              final firstNonPinnedIndex = lines.indexWhere(
                (line) => line.pinned == false,
              );
              final lastPinnedIndex = firstNonPinnedIndex -1;

              return ListView.builder(
                itemCount: lines.length,
                itemBuilder: (context, index) {
                  final line = lines[index];
                  final key = line.key; // HiveObject key

                  return Dismissible(
                    key: ValueKey(key),
                    // show different icon and bg based on pinned
                    background: Container(
                      color: line.pinned ? Colors.grey : Colors.orange,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: line.pinned
                          ? Icon(Icons.backspace_rounded, color: Colors.white)
                          : Icon(Icons.push_pin_rounded, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),

                    // allow both directions
                    direction: DismissDirection.horizontal,

                    confirmDismiss: (direction) async {
                      // delete line
                      if (direction == DismissDirection.endToStart) {
                        widget.lineBox.delete(key);
                        return true;
                      }

                      // toggle pinned value
                      if (direction == DismissDirection.startToEnd) {
                        line.pinned = !line.pinned;
                        await line.save();
                        return false;
                      }

                      return false;
                    },

                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        line.delete();
                      }
                    },

                    child: Builder(
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            border: (index == lastPinnedIndex)
                                ? Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  )
                                : null,
                          ),
                          child: ListTile(
                            title: Text(line.name, overflow: TextOverflow.fade),
                            subtitle: Text("${line.length} moves"),
                            selected: selectedIndex == index,
                            tileColor: line.pinned ? Colors.amber.shade50 : null,
                            selectedColor: line.pinned? Colors.orange.shade600 : null,
                            selectedTileColor: line.pinned ? Colors.amber.shade100 : Theme.of(context).focusColor,
                            trailing: line.pinned ? Icon(Icons.push_pin) : null,
                            onLongPress: () {
                              widget.onLineSelected(line);
                            },
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                widget.onLineTapped(line);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class LineDrawer extends StatelessWidget {
  final Line? selectedLine;
  final Box<Move> moveBox;
  const LineDrawer({
    super.key,
    required this.selectedLine,
    required this.moveBox,
  });

  @override
  Widget build(BuildContext context) {
    // Map moveIds → move names
    final moveNames = selectedLine!.moveList
        .map((id) => moveBox.get(id)?.name ?? 'Unknown move')
        .toList();

    return Drawer(
      surfaceTintColor: selectedLine!.pinned ? Colors.amberAccent : Colors.blue,
      width: 190,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(moveNames.join("\n"), style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
