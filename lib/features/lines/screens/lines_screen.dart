import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/line.dart';

class LineScreen extends StatefulWidget {
  final Box<Line> lineBox;

  const LineScreen({super.key, required this.lineBox});

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  late Box<Line> lineBox;

  @override
  void initState() {
    super.initState();
    lineBox = widget.lineBox;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.lineBox.listenable(),
      builder: (context, Box<Line> lineBox, _) {
        final lines = lineBox.values.toList();

        return ListView.builder(
          itemCount: lines.length,
          itemBuilder: (context, index) {
            final line = lines[index];
            final key = line.key; // HiveObject key

            return Dismissible(
              key: ValueKey(key),
              background: Container(
                color: Colors.orange,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.push_pin_rounded, color: Colors.white),
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
                if (direction == DismissDirection.endToStart) {
                  // RIGHT → LEFT (delete)
                  //return await _confirmDelete(context);
                  return false;
                }

                if (direction == DismissDirection.startToEnd) {
                  // LEFT → RIGHT (pin toggle)
                  //_togglePin(line);
                  return false; // don't remove item from list
                }

                return false;
              },

              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  line.delete();
                }
              },

              child: ListTile(
                title: Text(line.name),
                subtitle: Text("${line.length} moves"),
                trailing: Icon(
                  line.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
