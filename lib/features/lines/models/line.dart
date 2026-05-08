import 'package:hive_flutter/hive_flutter.dart';

class Line extends HiveObject {
  //final int lineId; // no need for this anymore since HiveObject has its key
  String name;
  List<int> moveList;
  DateTime created;
  DateTime? modified;
  bool pinned;

  int get length => moveList.length;

  Line({required this.name, required this.moveList, pinned})
    : created = DateTime.now(),
      modified = DateTime.now(),
      pinned = pinned ?? false;

  Line copyWith({
    String? name,
    List<int>? moveList,
    DateTime? created,
    DateTime? modified,
    bool? pinned,
  }) {
    return Line(
        name: name ?? this.name,
        moveList: moveList ?? List<int>.from(this.moveList),
        pinned: pinned ?? this.pinned,
      )
      ..created = created ?? this.created
      ..modified = modified ?? this.modified;
  }
}
