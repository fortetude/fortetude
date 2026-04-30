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
        _iconBox(Icons.self_improvement_rounded, move.hasMental()),
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
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Visibility(
            visible: visible,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}