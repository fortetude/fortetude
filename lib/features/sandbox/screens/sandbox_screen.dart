import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

import '../../lines/models/line.dart';
import '../../moves/models/move.dart';

class SandboxScreen extends StatefulWidget {
  final Box<Move> moveBox;
  final Box<Line> lineBox;
  final Box<int> sandBox;

  @override
  const SandboxScreen({
    super.key,
    required this.moveBox,
    required this.lineBox,
    required this.sandBox,
  });

  @override
  State<SandboxScreen> createState() => _SandboxScreenState();
}

class _SandboxScreenState extends State<SandboxScreen> {
  late Box<int> sandbox;
  late Box<Move> moveBox;

  @override
  void initState() {
    super.initState();
    sandbox = widget.sandBox;
    moveBox = widget.moveBox;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.sandBox.listenable(),
      builder: (context, Box<int> sandbox, _) {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,

          itemCount: sandbox.length,

          onReorder: (oldIndex, newIndex) async {
            await reorderSandbox(sandbox, oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            final itemMoveId = sandbox.getAt(index);
            final moveItem = moveBox.get(itemMoveId);
            final hiveKey = sandbox.keyAt(index);

            if (moveItem == null) {
              return ListTile(
                title: Text("null Move @ ${hiveKey.toString()}"),
                tileColor: Colors.red,
              );
            }

            Alignment align = switch (moveItem.direction) {
              Direction.left => Alignment.centerLeft,
              Direction.right => Alignment.centerRight,
              Direction.both => Alignment.center,
            };

            return Dismissible(
              // force tiles to rebuild on key change in Flutter
              key: ValueKey('$hiveKey-${moveItem.competency.short}'),
              background: Container(
                color: Colors.deepPurple,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.signpost, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ), // spacing between tiles
                decoration: BoxDecoration(
                  color: moveItem.competency.color(), // keeps your tile color
                  border: Border.all(
                    color: Colors.black26, // subtle gray border
                    width: 2, // slim border
                  ),
                ),
                child: ListTile(
                  visualDensity: VisualDensity.comfortable,
                  title: Align(
                    alignment: align,
                    child: Text(moveItem.cleanName),
                  ),
                  /*
                  subtitle: Text(
                    "ListIndex: $index | hiveKey: ${hiveKey.toString()} | moveId: ${itemMoveId.toString()}",
                  ),
                  */
                  tileColor: moveItem.competency.color(),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle),
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                // delete sandbox item
                if (direction == DismissDirection.endToStart) {
                  sandbox.delete(hiveKey);
                  return true;
                }
                // swap sides of sandbox item
                if (direction == DismissDirection.startToEnd) {
                  // nothing to swap
                  if (moveItem.direction.isBoth()) {
                    return false;
                  }

                  // grab opposite direction move
                  final moveBoxIndex = moveBox.values.toList().indexWhere(
                    (m) => m.moveId == itemMoveId,
                  );

                  int oppositeId = moveBoxIndex;

                  switch (moveItem.direction) {
                    case Direction.left:
                      oppositeId = moveBoxIndex + 1;
                      break;
                    case Direction.right:
                      oppositeId = moveBoxIndex - 1;
                      break;
                    case Direction.both:
                      throw Error();
                  }

                  // update current hiveKey item with opposite move ID
                  await sandbox.put(hiveKey, oppositeId);
                  return false;
                } else {
                  // out of bounds of Hive list
                  throw IndexError;
                }
              },
            );
          },
        );
      },
    );
  }
}

Future<void> reorderSandbox(
  Box<int> sandbox,
  int oldIndex,
  int newIndex,
) async {
  if (oldIndex == newIndex) return;

  // Get current keys and values
  final keys = sandbox.keys.toList();
  final values = sandbox.values.toList();

  // Adjust newIndex if moving down
  if (newIndex > oldIndex) newIndex -= 1;

  // Remove item and insert at new index
  final movedValue = values.removeAt(oldIndex);
  values.insert(newIndex, movedValue);

  // Map back to keys
  final newMap = {for (int i = 0; i < keys.length; i++) keys[i]: values[i]};

  // Update Hive box
  await sandbox.clear();
  await sandbox.putAll(newMap);
}

class SandBoxAutoDrawer extends StatelessWidget {
  const SandBoxAutoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.blue,
      width: 240,
      child: Center(child: Text("Work In Progress!")),
    );
  }
}

class SandboxInfoDrawer extends StatelessWidget {
  const SandboxInfoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.blue,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'fortetude.',
                        style: GoogleFonts.alike(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 50,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Transform.translate(
                          offset: const Offset(0, 6),
                          child: Text(
                            ' v0.0.1',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Text('by kawing-ho', style: TextStyle()),
              ],
            ),
          ),
          // Quick Guide Link
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text("User Guide"),
            subtitle: Text("How best to use the app"),
            onTap: () {
              final mode = kIsWeb
                  ? LaunchMode.platformDefault
                  : LaunchMode.externalApplication;

              launchUrl(Uri.parse('https://example.com'), mode: mode);
            },
          ),
          Divider(height: 0),
          // Donate!
          ListTile(
            leading: Icon(Icons.volunteer_activism_outlined),
            title: Text("Donate"),
            subtitle: Text("Enjoyed the app? Show some love!"),
            onTap: () {
              final mode = kIsWeb
                  ? LaunchMode.platformDefault
                  : LaunchMode.externalApplication;

              launchUrl(Uri.parse('https://example.com'), mode: mode);
            },
          ),
          Divider(height: 0),
          // Light/Dark toggle
          ListTile(
            leading: Icon(Icons.light_mode_outlined), // settings_display
            title: Text("Toggle Light/Dark Mode"),
            subtitle: Text(
              "[Work In Progress]",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(
              Icons.dark_mode_outlined,
            ), // settings_display_rounded
            onTap: () {},
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}
