import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

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
          title: Align(alignment: Alignment.center, child: Text('Lines')),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.alarm),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Snackbar!"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
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
        return SandBoxAutoDrawer();
      default:
        return null; // no drawer for other tabs
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
            onPressed: () {},
          ),
          Icons.save => IconButton(
            icon: Icon(Icons.save),
            tooltip: "Save Line",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () {},
          ),
          Icons.folder_open => IconButton(
            icon: Icon(Icons.folder_open),
            tooltip: "Open Saved Line",
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () {},
          ),
          Icons.more_vert => _popUpMenu(moveBox, lineBox, sandBox, context),
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
            if(sandBox.length > 1) {
              await shuffleSandbox(widget.sandBox);
            } 

            ScaffoldMessenger.of(incomingContext).showSnackBar(
              SnackBar(
                content: Text(
                  sandBox.length > 1 ? 
                  "Sandbox shuffled!" : 
                  "Nothing to shuffle!"
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
            if (await confirmEmptySandbox(context: incomingContext)) {
              await sandBox.clear();
            }
            break;
          case 'challenge':
            showModalBottomSheet(context: incomingContext, builder: _challengeSheet);
            break;
          case 'info':
            print("info selected");
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
        _buildBullet("Do the line together with a friend leading or following you."),

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
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
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
          LineScreen(),
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
