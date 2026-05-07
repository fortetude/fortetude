import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';

class MoveAddToSandboxButton extends StatelessWidget {
  final Move move;
  final Box<int> sandBox;

  const MoveAddToSandboxButton({
    super.key,
    required this.move,
    required this.sandBox,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.playlist_add_circle_rounded, size: 30),
      tooltip: "Add move to Sandbox",
      onPressed: () async {
        // add to sandbox
        final moveId = move.moveId;
        final key = await sandBox.add(moveId);

        // update last used timestamp
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text("${move.name} added to Sandbox!"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                // take it back out
                final undoId = sandBox.get(key);
                final String snackbarText;
                if (undoId == null || undoId != moveId) {
                  snackbarText = "Key expired - Undo failed!";
                } else {
                  sandBox.delete(key);
                  snackbarText = "Undo successful!";
                }
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(snackbarText),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
