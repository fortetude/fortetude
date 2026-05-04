import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'navbar.dart';
import 'features/moves/models/move.dart';
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
  Set<Category> filters = {};
  var query = '';

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    switch (currentIndex) {
      case 0: // MOVES
        return AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text('Moves Screen'),
          ),
        );
      case 1: // SANDBOX
        return AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text('Sandbox Screen'),
          ),
        );
      case 2: // LINES
        return AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text('Lines Screen'),
          ),
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
          filters: filters,
          onChanged: (updatedFilters) {
            setState(() {
              filters = updatedFilters;
            });
          },
        );
      case 1:
        return const SandboxDrawer();
      default:
        return null; // no drawer for other tabs
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: _buildAppBar(currentIndex),
        drawer: _buildDrawer(),
        body: <Widget>[
          MovesScreen(moveBox: widget.moveBox, filters: filters),
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
