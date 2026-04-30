import 'package:flutter/material.dart';
import '../models/move.dart';

class MoveControlBar extends StatelessWidget {
  final Move move;

  const MoveControlBar({super.key, required this.move});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 4,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: IgnorePointer(
          child: FractionallySizedBox(
            widthFactor: move.controlWidth(),
            child: Container(
              color: Color.lerp( // bar color
                move.competency.color(),
                Colors.black,
                0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}