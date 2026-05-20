// serialise function
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';

import '../../../features/moves/models/move.dart';

String serialise(Box<int> sandBox) {
  final values = sandBox.values.toList();
  String valuesString = values.join(",");

  // compute 8 character shorthash for integrity
  final digest = sha256.convert(utf8.encode(valuesString));
  final shortHash = digest.toString().substring(0, 8);

  // append hash to values
  return '$valuesString|$shortHash';
}

// deserialise function
List<int>? deserialise(String data) {
  // invalid string format check
  if (data.isEmpty || !data.contains("|")) return null;

  final parts = data.trim().split('|');
  if (parts.length != 2) return null;

  // extract parts
  final valuesString = parts[0];
  final shortHash = parts[1];

  // check valid string of values
  final validValues = RegExp(r'^\d+(,\d+)*$').hasMatch(valuesString);
  if (!validValues) return null;

  // check valid hash
  final validHash = RegExp(r'^[a-f0-9]{8}$').hasMatch(shortHash);

  if (!validHash) return null;

  // check hash matches
  final computed = sha256
      .convert(utf8.encode(valuesString))
      .toString()
      .substring(0, 8);

  if (computed != shortHash) return null;

  final moveBox = Hive.box<Move>('moves');

  // finally - check consistent moveIds
  List<int> numbers = valuesString
      .split(',')
      .map(int.parse)
      .where((n) => n <= (moveBox.length - 1))
      .toList();

  if (numbers.isEmpty) return null;

  return numbers;
}

