import 'package:flutter/material.dart';
import '../models/move.dart';


class MoveAddToSandboxButton extends StatelessWidget {
  final Move move;

  const MoveAddToSandboxButton({super.key, required this.move});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.playlist_add_circle_rounded, size: 30),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${move.name} added to Sandbox!"),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Action undone!"),
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