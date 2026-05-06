import 'package:flutter/material.dart';
import '../models/move.dart';

class MoveAreasIcons extends StatelessWidget {
  final Move move;

  const MoveAreasIcons({super.key, required this.move});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconBox(Icons.fitness_center_rounded, move.hasPhysical()),
        SizedBox(width: 4),
        _iconBox(Icons.self_improvement_rounded, move.hasMental()),
        SizedBox(width: 4),
        _iconBox(Icons.psychology_rounded, move.hasTechnique()),
      ],
    );
  }

  Widget _iconBox(IconData icon, bool visible) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: visible ? Colors.black : Colors.white),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Visibility(
            //visible: visible,
            visible: true,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: visible? Icon(icon) : Icon(Icons.check_sharp, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
