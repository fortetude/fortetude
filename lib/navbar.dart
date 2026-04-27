import 'package:flutter/material.dart';
import 'package:fortetude/features/lines/screens/lines_screen.dart';
import 'package:fortetude/features/moves/screens/moves_screen.dart';
import 'package:fortetude/features/sandbox/screens/sandbox_screen.dart';

class FTNavigationBar extends StatefulWidget {
  const FTNavigationBar({super.key});

  @override
  State<FTNavigationBar> createState() => _FTNavigationBarState();
}

class _FTNavigationBarState extends State<FTNavigationBar> {
  int currentIndex = 1; // choose middle screen by default

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        indicatorColor: Colors.lightBlue,
        destinations: const <Widget>[
          //Moves
          NavigationDestination(
            icon: Icon(Icons.run_circle_outlined),
            selectedIcon: Icon(Icons.run_circle),
            label: 'Moves',
          ),
          //Sandbox
          NavigationDestination(
            icon: Icon(Icons.build_circle_outlined),
            selectedIcon: Icon(Icons.build_circle),
            label: 'Sandbox',
          ),
          //Lines
                    NavigationDestination(
            icon: Icon(Icons.moving),
            selectedIcon: Icon(Icons.moving_sharp),
            label: 'Lines',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      // select Widget based on currentIndex of the list of Screens
      body: <Widget> [  
        MovesScreen(),
        SandboxScreen(),
        LineScreen(),
      ][currentIndex],
    );
  }
}

