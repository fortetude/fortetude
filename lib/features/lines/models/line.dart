import 'package:hive_flutter/hive_flutter.dart';

enum LinesSortType {
  defaultSort,
  nameAsc,
  nameDesc,
  lengthAsc,
  lengthDesc,
  created,
  modified,
}

extension LinesSorting on LinesSortType {
  int compare(Line a, Line b) {
    if (a.pinned && !b.pinned) return -1;
    if (!a.pinned && b.pinned) return 1;

    switch (this) {
      case LinesSortType.defaultSort:
        return 0; // nop
      case LinesSortType.nameAsc:
        return a.name.compareTo(b.name);
      case LinesSortType.nameDesc:
        return b.name.compareTo(a.name);
      case LinesSortType.lengthAsc:
        return a.length.compareTo(b.length);
      case LinesSortType.lengthDesc:
        return b.length.compareTo(a.length);
      case LinesSortType.created:
        return a.created.compareTo(b.created);
      case LinesSortType.modified:
        return a.modified!.compareTo(b.modified!);
    }
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'moveList': moveList,
      'created': created.toIso8601String(),
      'modified': modified?.toIso8601String(),
      'pinned': pinned,
    };
  }

  factory Line.fromJson(Map<String, dynamic> json) {
    if (json['name'] is! String) {
      throw FormatException('Line.name must be a String');
    }

    if (json['moveList'] is! List) {
      throw FormatException('Line.moveList must be a List');
    }

    if (json['created'] is! String) {
      throw FormatException('Line.created must be a String');
    }

    if (json['modified'] is! String) {
      throw FormatException('Line.modified must be a String');
    }

    if (json['pinned'] is! bool) {
      throw FormatException('Line.pinned must be a bool');
    }

    final moveList = (json['moveList'] as List).map((e) {

      if (e is! int || e < 0) {
        throw FormatException('Line.moveList contains non-int value');
      }

      return e;
    }).toList();

    final line = Line(
      name: json['name'] as String,
      moveList: moveList,
      pinned: json['pinned'] as bool,
    );

    line.created = DateTime.parse(json['created'] as String);

    line.modified = DateTime.parse(json['modified'] as String);

    return line;
  }
}
