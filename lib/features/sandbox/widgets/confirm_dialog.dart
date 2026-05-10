import 'package:flutter/material.dart';

Future<bool> confirmEmptySandbox({required BuildContext context, required int length}) async {

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(width: 8),
          Expanded(child: const Text("Clearing Sandbox")),
        ]
      ),
      content: Text("This action will remove all contents ($length items) of the sandbox. Proceed?"),
      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No'),
        ),

        FilledButton(
          onPressed: () {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sandbox Cleared!"),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  return result ?? false;
}

Future<bool?> confirmOverwriteSandbox({required BuildContext context, required int length}) async {

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(width: 8),
          Expanded(child: const Text("Overwrite Sandbox?")),
        ]
      ),
      content: Text("Would you like to overwrite the sandbox ($length items) with new moves from the line?"),
      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Append Instead'),
        ),

        FilledButton(
          onPressed: () {
            Navigator.pop(context, true);
            /*
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Imported Line into Sandbox!"),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            */
            },
          child: const Text('Overwrite'),
        ),
      ],
    ),
  );

  return result;
}