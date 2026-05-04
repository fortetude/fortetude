import 'package:flutter/material.dart';
import '../models/move.dart';
import 'move_control_bar.dart';
import 'move_areas_icons.dart';
import 'move_add_sandbox_button.dart';
import '../screens/move_detail_screen.dart';

class MoveTile extends StatelessWidget {
  final Move move;

  const MoveTile({super.key, required this.move});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          title: Text(move.name),
          tileColor: move.fresh? Colors.white : move.competency.color(),
          leading: MoveAddToSandboxButton(move: move),
          trailing: MoveAreasIcons(move: move),

          // MoveDetails
          onTap: () => _openBottomSheet(context, move),
        ),

        MoveControlBar(move: move),
      ],
    );
  }

  // MoveDetails
   Future<void> _openBottomSheet(BuildContext context, Move move) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) {
        return MoveDetailScreen(move: move);
      },
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Move saved successfully.'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
