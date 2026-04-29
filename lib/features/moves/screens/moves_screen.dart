import 'package:flutter/material.dart';
import '../models/move_items.dart';
import '../models/move.dart';

class MovesScreen extends StatelessWidget {
  const MovesScreen({super.key});

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.center, child: Text('Moves Screen')),
      ),
      body: ListView(
        children: [
          for (Move move in allMoves)
            Stack(
              children: [
                ListTile(
                  title: Text(move.name),
                  subtitle: Text(move.control.toString()),
                  tileColor: move.competency.color(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // icons list
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Visibility(
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              visible: move.hasPhysical(),
                              child: Icon(Icons.fitness_center_rounded),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Visibility(
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              visible: move.hasMental(),
                              child: Icon(Icons.self_improvement_rounded),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Visibility(
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              visible: move.hasTechnique(),
                              child: Icon(Icons.psychology_rounded),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: build,
                      builder: (BuildContext context) {
                        return Container();
                      },
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 4,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: IgnorePointer(
                      child: FractionallySizedBox(
                        widthFactor: move.controlWidth(),
                        child: Container(color: Color.lerp(move.competency.color(), Colors.black, 0.2)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          /*
            ListTile(
              title: Text(move.name),
              subtitle: Text(move.control.toString()),
              tileColor: move.competency.color(),
              trailing: Row (
                mainAxisSize: MainAxisSize.min,
                children: [ // icons list
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: 
                          Visibility(
                            maintainSize: true,
                            maintainState: true,
                            maintainAnimation: true,
                            visible: move.hasPhysical(),
                            child: Icon(Icons.fitness_center_rounded)
                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: 
                          Visibility(
                            maintainSize: true,
                            maintainState: true,
                            maintainAnimation: true,
                            visible: move.hasMental(),
                            child: Icon(Icons.self_improvement_rounded)
                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: 
                          Visibility(
                            maintainSize: true,
                            maintainState: true,
                            maintainAnimation: true,
                            visible: move.hasTechnique(),
                            child: Icon(Icons.psychology_rounded)
                          ),
                      ),
                    ),
                  ),
                ]
              ),
              onTap: () { showModalBottomSheet<void>(
                context: build,
                builder: (BuildContext context) {
                  return Container();
                },
              );
              }
            ), 
          */
        ],
      ),
    );
  }
}

Widget buildTile(double rating) {
  final fraction = (rating / 10).clamp(0.0, 1.0);

  return LayoutBuilder(
    builder: (context, constraints) {
      return Stack(
        children: [
          // Background fill
          FractionallySizedBox(
            widthFactor: fraction,
            child: Container(
              height: constraints.maxHeight,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),

          // The actual ListTile
          ListTile(
            title: Text('Item ($rating)'),
            tileColor: Colors.transparent, // important!
          ),
        ],
      );
    },
  );
}
