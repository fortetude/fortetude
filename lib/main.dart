import 'package:flutter/material.dart';
import 'navbar.dart';
import 'features/moves/screens/moves_screen.dart';
import 'features/lines/screens/lines_screen.dart';
import 'features/sandbox/screens/sandbox_screen.dart';

void main() {
  runApp(const FortetudeApp());
}

class FortetudeApp extends StatefulWidget {
  const FortetudeApp({super.key});

  @override
  State<FortetudeApp> createState() => _FortetudeAppState();
}

class _FortetudeAppState extends State<FortetudeApp> {
  int currentIndex = 1;

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
      default: // catch
        return AppBar();
    }
  }

  Widget? _buildDrawer() {
    switch (currentIndex) {
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
          MovesScreen(),
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
