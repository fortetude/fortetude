import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/moves/models/move_data.dart';
import '../../../features/lines/models/line.dart';
import '../../../features/moves/models/move.dart';

Future<void> downloadBackup(String filename, String content) async {
  final bytes = utf8.encode(content);

  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );

  final url = web.URL.createObjectURL(blob);

  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;

  anchor.click();
  anchor.remove();

  Future.delayed(
    const Duration(seconds: 1),
    () => web.URL.revokeObjectURL(url),
  );
}

Future<void> performExport(
  Box<Move> moveBox,
  Box<Line> lineBox,
  BuildContext context,
) async {
  final moveData = moveBox.values.map((move) {
    return MoveUserData(
      moveId: move.moveId,
      competency: move.competency,
      control: move.control,
      areas: move.areas,
      notes: move.notes,
    );
  }).toList();

  final dateString = DateTime.now().toIso8601String();
  final version = 1;
  final filename = "fortetude-$version-$dateString.json";

  final backup = {
    'version': version,
    'exportedAt': dateString,
    'moves': moveData.map((e) => e.toJson()).toList(),
    'lines': lineBox.values.map((e) => e.toJson()).toList(),
  };

  const encoder = JsonEncoder.withIndent('  ');
  final jsonString = encoder.convert(backup);

  // trigger file download prompt
  try {
    await downloadBackup(filename, jsonString);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Export initiated!"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Export failed!!!"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<void> uploadBackup(Box<Move> moveBox, Box<Line> lineBox) async {
  const maxImportSizeBytes = 5 * 1024 * 1024; // 5 MB
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowMultiple: false,
    allowedExtensions: ['json'],
    withData: true,
  );

  if (result == null) {
    // User cancelled
    throw Exception("Cancelled file import");
  } else {
    PlatformFile file = result.files.first;

    if (file.extension != "json") {
      throw FormatException("The selected file is not JSON data!");
    }

    if (file.size > maxImportSizeBytes) {
      throw FormatException("File size exceeds 5MB!");
    }

    if (file.bytes == null || file.bytes!.isEmpty) {
      throw Exception('No file data!');
    }

    final jsonString = utf8.decode(file.bytes!);

    // will immediately throw error if the json is invalid
    Map<String, dynamic> jsonMap = {};
    try {
      jsonMap = jsonDecode(jsonString);
    } on FormatException {
      throw FormatException("Invalid JSON data provided!");
    }

    if (jsonMap['moves'] == null || jsonMap['lines'] == null) {
      throw Exception('Invalid data in JSON');
    }

    // import lines into memory
    final List<Line> lines = (jsonMap['lines'] as List)
        .map((e) => Line.fromJson(e))
        .toList();

    // import moves into memory
    final List<MoveUserData> moves = (jsonMap['moves'] as List)
        .map((e) => MoveUserData.fromJson(e, moveBox))
        .toList();

    // iterate through lines to ensure all moves valid
    for (final l in lines) {
      for (int i in l.moveList) {
        Move? updateMove = moveBox.get(i);
        if (updateMove == null) {
          throw Exception('Invalid moveId in JSON');
        }
      }
    }

    // iterate through moves to ensure all moves valid
    for (final m in moves) {
      Move? updateMove = moveBox.get(m.moveId);

      if (updateMove == null) {
        throw Exception('Invalid moveId in JSON');
      }
    }

    // replace lines in Box
    await lineBox.clear();
    await lineBox.addAll(lines);

    // replace moves in Box
    for (final m in moves) {
      Move? updateMove = moveBox.get(m.moveId);
      if (updateMove == null) {
        throw Exception('Invalid moveId in JSON');
      }

      updateMove.competency = m.competency;
      updateMove.control = m.control;
      updateMove.areas = m.areas;
      updateMove.notes = m.notes;
      await updateMove.save();
    }
  }
}


Future<void> performImport(
  Box<Move> moveBox,
  Box<Line> lineBox,
  BuildContext context,
) async {
  String err = "";
  try {
    await uploadBackup(moveBox, lineBox);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Import successful!"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Import failed: ${e.toString()}"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  return;
}
