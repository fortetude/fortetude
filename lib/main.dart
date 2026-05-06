import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'navbar.dart';
import 'core/utils/string.dart';
import 'features/moves/models/move.dart';
import 'features/lines/models/line.dart';
import 'features/moves/models/move_items.dart';
import 'features/moves/services/move_adapter.dart';
import 'features/moves/screens/moves_screen.dart';
import 'features/lines/screens/lines_screen.dart';
import 'features/sandbox/screens/sandbox_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final dir = await getApplicationDocumentsDirectory();
  //Hive.init(dir.absolute.path);
  await Hive.initFlutter(); // for web

  Hive.registerAdapter(MoveAdapter());

  //init Hive boxes
  Box<Move> moveBox = await Hive.openBox<Move>('moves');

  // TODO: add sandbox Hive
  Box<Line> sandBox = await Hive.openBox<Line>('sandbox');

  //conditionally add fresh data
  if (moveBox.isEmpty) {
    if (kDebugMode) {
      await insertMovesDebug(moveBox);
    } else {
      await insertMovesProd(moveBox);
    }
  }

  // load dummy Lines

  // load dummy sandbox

  runApp(FortetudeApp(moveBox: moveBox));
}

class FortetudeApp extends StatefulWidget {
  final Box<Move> moveBox;

  const FortetudeApp({super.key, required this.moveBox});

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
            _buildAction(Icons.add_rounded),
            _buildAction(Icons.save),
            _buildAction(Icons.folder_open),
            _buildAction(Icons.more_vert),
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

  Widget _buildAction(IconData iconData) {
    switch (iconData) {
      case Icons.add_rounded:
        return IconButton(
          icon: Icon(Icons.add_rounded),
          tooltip: "Add Move",
          onPressed: () {},
        );
      case Icons.save:
        return IconButton(
          icon: Icon(Icons.save),
          tooltip: "Save Line",
          onPressed: () {},
        );
      case Icons.folder_open:
        return IconButton(
          icon: Icon(Icons.folder_open),
          tooltip: "Open Saved Line",
          onPressed: () {},
        );
      case Icons.more_vert:
        return Builder(
          builder:(context) => _popUpMenu(context)
        );
      case _:
        return Placeholder();
    }
  }

  Widget _popUpMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert), // 3 dots
      onSelected: (value) {
        switch (value) {
          case 'shuffle':
            print('Shuffle selected');
            // Call your shuffle function here
            break;
          case 'share':
            print('Share selected');
            // Call your share function here
            break;
          case 'clear_sandbox':
            print('Clear Sandbox selected');
            // Call your clear sandbox function here
            break;
          case 'challenge':
            print('Clear Sandbox selected');
            // Call your clear sandbox function here
            break;
          case 'info':
            Scaffold.of(context).openEndDrawer();
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
            categoryFilters: categoryFilters,
            competencyFilters: competencyFilters,
            areaFilters: areaFilters,
            sortType: sortType,
          ),
          SandboxScreen(),
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
