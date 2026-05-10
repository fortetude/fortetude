import 'dart:math' as math;

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:fortetude/features/lines/models/line_adapter.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

import 'core/utils/search.dart';
import 'features/lines/widgets/line_name.dart';
import 'navbar.dart';
import 'core/utils/string.dart';

import 'features/moves/models/move.dart';
import 'features/lines/models/line.dart';
import 'features/moves/models/move_items.dart';
import 'features/moves/services/move_adapter.dart';
import 'features/moves/screens/moves_screen.dart';
import 'features/lines/screens/lines_screen.dart';
import 'features/sandbox/screens/sandbox_screen.dart';
import 'features/sandbox/widgets/confirm_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final dir = await getApplicationDocumentsDirectory();
  //Hive.init(dir.absolute.path);
  await Hive.initFlutter(); // for web

  Hive.registerAdapter(MoveAdapter());
  Hive.registerAdapter(LineAdapter());

  //init Hive boxes
  Box<Move> moveBox = await Hive.openBox<Move>('moves');
  Box<Line> lineBox = await Hive.openBox<Line>('lines');
  Box<int> sandBox = await Hive.openBox<int>('sandbox');

  //conditionally add fresh data
  if (moveBox.isEmpty) {
    if (kDebugMode) {
      await insertMovesDebug(moveBox);
    } else {
      await insertMovesProd(moveBox);
    }
  }

  runApp(FortetudeApp(moveBox: moveBox, lineBox: lineBox, sandBox: sandBox));
}

class FortetudeApp extends StatefulWidget {
  final Box<Move> moveBox;
  final Box<Line> lineBox;
  final Box<int> sandBox;

  const FortetudeApp({
    super.key,
    required this.moveBox,
    required this.lineBox,
    required this.sandBox,
  });

  @override
  State<FortetudeApp> createState() => _FortetudeAppState();
}

class _FortetudeAppState extends State<FortetudeApp> {
  int currentIndex = 1;
  Set<Category> categoryFilters = {};
  Set<Competency> competencyFilters = {};
  Set<AreaOfConcern> areaFilters = {};
  MoveSortType sortType = MoveSortType.defaultSort;
  LinesSortType lsortType = LinesSortType.defaultSort;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Line? _selectedLine; // currently selected line via longpress
  Line? _tappedLine; // currently selected line via tap
  var query = '';

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    switch (currentIndex) {
      case 0: // MOVES
        String c = (categoryFilters.length == 1)
            ? ": ${capitalise(categoryFilters.first.name)}"
            : "";
        return AppBar(
          title: Align(alignment: Alignment.center, child: Text('Moves $c')),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.filter_alt),
              tooltip: "Filter & Sort",
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        );
      case 1: // SANDBOX
        return AppBar(
          automaticallyImplyLeading: false,
          automaticallyImplyActions: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.auto_awesome_outlined),
              tooltip: "Autogenerate a Line",
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            _buildAction(
              Icons.add_rounded,
              widget.moveBox,
              widget.lineBox,
              widget.sandBox,
            ),
            _buildAction(
              Icons.save,
              widget.moveBox,
              widget.lineBox,
              widget.sandBox,
            ),
            _buildAction(
              Icons.folder_open,
              widget.moveBox,
              widget.lineBox,
              widget.sandBox,
            ),
            _buildAction(
              Icons.more_vert,
              widget.moveBox,
              widget.lineBox,
              widget.sandBox,
            ),
          ],
          title: Align(alignment: Alignment.center, child: Text('Sandbox')),
        );
      case 2: // LINES
        return AppBar(
          automaticallyImplyLeading: false,
          automaticallyImplyActions: false,
          leading: Builder(
            builder: (context) => PopupMenuButton(
              icon: Icon(Icons.filter_alt),
              tooltip: "Sort lines",
              onSelected: (value) {
                setState(() {
                  lsortType = value;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: LinesSortType.nameAsc,
                  child: Row(
                    children: [
                      Icon(Icons.sort_by_alpha),
                      SizedBox(width: 8),
                      Text("Name: A - Z"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: LinesSortType.nameDesc,
                  child: Row(
                    children: [
                      Icon(Icons.sort_outlined),
                      SizedBox(width: 8),
                      Text("Name: Z - A"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: LinesSortType.lengthAsc,
                  child: Row(
                    children: [
                      Icon(Icons.square_foot_sharp),

                      SizedBox(width: 8),
                      Text("Length ↑"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: LinesSortType.lengthDesc,
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: math.pi,
                        child: Icon(Icons.square_foot_sharp),
                      ),
                      SizedBox(width: 8),
                      Text("Length ↓"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: LinesSortType.created,
                  child: Row(
                    children: [
                      Icon(Icons.history_edu_rounded),
                      SizedBox(width: 8),
                      Text("Date Created"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: LinesSortType.modified,
                  child: Row(
                    children: [
                      Icon(Icons.access_time_outlined),
                      SizedBox(width: 8),
                      Text("Last Modified"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          title: Align(alignment: Alignment.center, child: Text('Lines')),
          actions: [
            _buildAction(
              Icons.drive_file_rename_outline_outlined,
              widget.moveBox,
              widget.lineBox,
              widget.sandBox,
            ),
            _buildAction(
              Icons.add_road_outlined,
              widget.moveBox,
              widget.lineBox,
              widget.sandBox,
            ),
          ],
        );
      default: // catch_
        return AppBar();
    }
  }

  Widget? _buildDrawer() {
    switch (currentIndex) {
      case 0:
        return MovesDrawer(
          categoryFilters: categoryFilters,
          competencyFilters: competencyFilters,
          areaFilters: areaFilters,

          onCategoryChanged: (v) => setState(() => categoryFilters = v),
          onCompetencyChanged: (v) => setState(() => competencyFilters = v),
          onAreaChanged: (v) => setState(() => areaFilters = v),
          sortType: sortType,
          onSortChanged: (v) => setState(() => sortType = v),
        );
      case 1:
        return SandBoxAutoDrawer(moveBox: widget.moveBox, sandBox: widget.sandBox);
      default:
        return LineDrawer(selectedLine: _selectedLine, moveBox: widget.moveBox);
    }
  }

  Widget? _buildEndDrawer() {
    switch (currentIndex) {
      case 0:
        return null;
      case 1:
        return SandboxInfoDrawer();
      default:
        return null; // no drawer for other tabs
    }
  }

  Widget _buildAction(
    IconData iconData,
    Box<Move> moveBox,
    Box<Line> lineBox,
    Box<int> sandBox,
  ) {
    var builder = Builder(
      builder: (context) {
        var action = switch (iconData) {
          Icons.add_rounded => IconButton(
            icon: Icon(Icons.add_rounded),
            tooltip: "Add Move",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              final moveId = await showSearch<int?>(
                context: context,
                delegate: FTSearchDelegate(box: widget.moveBox),
              );

              if (moveId != null) {
                await widget.sandBox.add(moveId);
                final name = widget.moveBox.get(moveId)!.name;

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added $name to Sandbox!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
          Icons.save => IconButton(
            icon: Icon(Icons.save),
            tooltip: "Save Line",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              // prompt for name
              final name = await promptLineName(context, widget.lineBox, null);
              if (name != null) {
                Line newLine = Line(
                  name: name,
                  moveList: sandBox.values.toList(),
                );
                await widget.lineBox.add(newLine);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added "$name" to Saved Lines!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
          Icons.folder_open => IconButton(
            icon: Icon(Icons.folder_open),
            tooltip: "Open Saved Line",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              // showSearch
              final lineKey = await showSearch<int?>(
                context: context,
                delegate: FTSearchDelegate(box: widget.lineBox),
              );

              if (lineKey != null) {
                final line = widget.lineBox.get(lineKey);

                bool? result;
                // overwrite dialog
                if (sandBox.length > 0) {
                  result = await confirmOverwriteSandbox(
                    context: context,
                    length: sandBox.length,
                  );
                }

                if (sandBox.length > 0 && result == null) {
                  return; // nop
                  // overwrite
                } else if (sandBox.length > 0 && result == true) {
                  await sandBox.clear();
                }

                // add moves
                await sandBox.addAll(line!.moveList);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${line?.name} to Sandbox!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
          Icons.more_vert => _popUpMenu(moveBox, lineBox, sandBox, context),
          Icons.drive_file_rename_outline_outlined => IconButton(
            icon: Icon(Icons.drive_file_rename_outline_outlined),
            tooltip: "Edit Line Name",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              if (_tappedLine == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No line selected!"),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                // show confirmation dialog
                String? result = await promptLineName(
                  context,
                  lineBox,
                  _tappedLine!.key,
                );
                // send it
                if (result != null) {
                  _tappedLine!.name = result;
                  _tappedLine!.save();
                }
              }
            },
          ),
          Icons.add_road_outlined => IconButton(
            icon: Icon(Icons.add_road_outlined),
            tooltip: "Import Line to Sandbox",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              if (_tappedLine == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No line selected!"),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                // show confirmation dialog

                bool? result;
                // overwrite dialog
                if (sandBox.length > 0) {
                  result = await confirmOverwriteSandbox(
                    context: context,
                    length: sandBox.length,
                  );
                }

                if (sandBox.length > 0 && result == null) {
                  return; // nop
                  // overwrite
                } else if (sandBox.length > 0 && result == true) {
                  await sandBox.clear();
                }

                // add moves
                await sandBox.addAll(_tappedLine!.moveList);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${_tappedLine?.name} to Sandbox!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                // send it
              }
            },
          ),
          _ => Placeholder(),
        };

        return action;
      },
    );

    return builder;
  }

  Widget _popUpMenu(
    Box<Move> moveBox,
    Box<Line> lineBox,
    Box<int> sandBox,
    BuildContext incomingContext,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert), // 3 dots
      onSelected: (value) async {
        switch (value) {
          case 'shuffle':
            if (sandBox.length > 1) {
              await shuffleSandbox(widget.sandBox);
            }

            ScaffoldMessenger.of(incomingContext).showSnackBar(
              SnackBar(
                content: Text(
                  sandBox.length > 1
                      ? "Sandbox shuffled!"
                      : "Nothing to shuffle!",
                ),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
            break;
          case 'share':
            print('Share selected');
            // Call your share function here
            break;
          case 'clear':
            if (sandBox.length > 0 &&
                await confirmEmptySandbox(
                  context: incomingContext,
                  length: sandBox.length,
                )) {
              await sandBox.clear();
            }
            break;
          case 'challenge':
            showModalBottomSheet(
              context: incomingContext,
              builder: _challengeSheet,
            );
            break;
          case 'info':
            Scaffold.of(incomingContext).openEndDrawer();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'shuffle',
          child: Row(
            children: [
              Icon(Icons.shuffle, color: Colors.black),
              SizedBox(width: 8),
              Text('Shuffle'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.offline_share, color: Colors.black),
              SizedBox(width: 8),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'clear',
          child: Row(
            children: [
              Icon(Icons.delete_rounded, color: Colors.black),
              SizedBox(width: 8),
              Text('Clear'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'challenge',
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.black),
              SizedBox(width: 8),
              Text('Challenge Ideas'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'info',
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.black),
              SizedBox(width: 8),
              Text('About/Credits'),
            ],
          ),
        ),
      ],
    );
  }

  // show challenge tips
  Widget _challengeSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // shrink to fit content
        children: [
          // Header with flag emoji
          Row(
            children: const [
              Text(
                "Challenge Ideas ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.flag),
            ],
          ),
          const SizedBox(height: 12),

          // Bullet points
          _buildBullet("Do the line backwards from finish to start."),
          _buildBullet("Swap the sides of some or all of the moves."),
          _buildBullet("Time yourself and try to beat your previous record."),
          _buildBullet("Take no more than two steps between each move."),
          _buildBullet(
            "Do the line together with a friend leading or following you.",
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Bullet builder
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 20)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Future<void> shuffleSandbox(Box<int> sandbox) async {
    if (sandbox.isEmpty) return;

    // Get current keys and values
    final keys = sandbox.keys.toList();
    final values = sandbox.values.toList();

    // Shuffle the values
    values.shuffle(Random());

    // Map shuffled values back to original keys
    final newMap = {for (int i = 0; i < keys.length; i++) keys[i]: values[i]};

    // Clear and putAll to reorder Hive box
    await sandbox.clear();
    await sandbox.putAll(newMap);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: _buildAppBar(currentIndex),
        drawer: _buildDrawer(),
        endDrawer: _buildEndDrawer(),
        key: _scaffoldKey,
        body: <Widget>[
          MovesScreen(
            moveBox: widget.moveBox,
            sandBox: widget.sandBox,
            categoryFilters: categoryFilters,
            competencyFilters: competencyFilters,
            areaFilters: areaFilters,
            sortType: sortType,
          ),
          SandboxScreen(
            moveBox: widget.moveBox,
            lineBox: widget.lineBox,
            sandBox: widget.sandBox,
          ),
          LineScreen(
            lineBox: widget.lineBox,
            scaffoldKey: _scaffoldKey,
            onLineSelected: (line) {
              setState(() {
                _selectedLine = line;
              });
              _scaffoldKey.currentState?.openDrawer();
            },
            onLineTapped: (line) {
              setState(() {
                _tappedLine = line;
              });
            },
            lsortType: lsortType,
          ),
        ][currentIndex],
        bottomNavigationBar: FTNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
