import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';
import 'move_control_bar.dart';
import 'move_areas_icons.dart';
import 'move_add_sandbox_button.dart';
import '../screens/move_detail_screen.dart';

class MoveTile extends StatelessWidget {
  final Move move;
  final Box<int> sandBox;

  const MoveTile({super.key, required this.move, required this.sandBox});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          title: Text(move.name),
          tileColor: (!kDebugMode && move.fresh) ? Colors.white : move.competency.color(),
          leading: MoveAddToSandboxButton(move: move, sandBox: sandBox),
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
