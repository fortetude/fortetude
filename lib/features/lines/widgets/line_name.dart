
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/line.dart';

Future<String?> promptLineName(BuildContext context, Box<Line> lineBox) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,

    builder: (context) {
      return AlertDialog(
        title: const Text("Save Line"),

        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter line name...",
            border: OutlineInputBorder(),
          ),

          onSubmitted: (value) {
            final duplicated = lineBox.values.any(
              (line) => line.name == value,
            );

            if(duplicated) {
              value = "${value.trim()} (copy)";
            }
            Navigator.pop(context, value);
          },
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text("Cancel"),
          ),

          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim(),
              );
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}