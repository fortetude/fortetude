import 'package:flutter/material.dart';

class FTNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FTNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      //indicatorColor: Colors.lightBlue,
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
      onDestinationSelected: onTap,
    );
  }
}
