import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/line.dart';

Future<String?> promptLineName(
  BuildContext context,
  Box<Line> lineBox,
  int? modifyId,
) async {
  final controller = TextEditingController();

  String? errorText;

  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          controller.addListener(() {
            if (errorText != null) {
              setState(() => errorText = null);
            }
          });

          void submit() {
            if (modifyId != null) {
              final currLine = lineBox.get(modifyId);
              if (currLine == null) {
                throw Error;
              }
              if (currLine.name == controller.text) {
                Navigator.pop(context, null);
              }
            }
            final trimmed = controller.text.trim();
            final duplicated = lineBox.values.any(
              (line) => line.name == trimmed,
            );

            if (duplicated || trimmed.isEmpty) {
              // Update the error message and prevent closing
              setState(() {
                errorText = "Name already exists!";
              });
              return;
            }

            // Valid name, close dialog
            Navigator.pop(context, trimmed);
          }

          return AlertDialog(
            title: (modifyId != null)
                ? Text("Edit Line Name")
                : Text("Save Line"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter line name...",
                    border: const OutlineInputBorder(),
                    errorText: errorText, // displays inline error
                  ),
                  onSubmitted: (_) => submit(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Cancel"),
              ),
              FilledButton(onPressed: submit, child: const Text("Save")),
            ],
          );
        },
      );
    },
  );
}
