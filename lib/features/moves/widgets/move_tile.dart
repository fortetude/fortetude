import 'package:flutter/material.dart';
import '../models/move.dart';
import 'move_control_bar.dart';
import 'move_areas_icons.dart';
import 'move_add_sandbox_button.dart';

class MoveTile extends StatelessWidget {
  final Move move;

  const MoveTile({super.key, required this.move});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          title: Text(move.name),
          tileColor: move.competency.color(),
          leading: MoveAddToSandboxButton(move: move),
          trailing: MoveAreasIcons(move: move),

          // MoveDetails
          onTap: () => _openBottomSheet(context),
        ),

        MoveControlBar(move: move),
      ],
    );
  }

// MoveDetails
  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Container(),
    );
  }
}