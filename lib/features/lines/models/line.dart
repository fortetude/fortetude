
import 'package:hive_flutter/hive_flutter.dart';

class Line extends HiveObject {
  final int lineId;
  String name;
  List<int> moveList;
  DateTime created;
  DateTime? modified;
  int length;
  bool pinned;

  Line({
    required this.lineId,
    required this.name,
    required this.moveList,
    pinned,
  }) : 
  created = DateTime.now(),
  modified = DateTime.now(),
  pinned = pinned ?? false,
  length = moveList.length;

}