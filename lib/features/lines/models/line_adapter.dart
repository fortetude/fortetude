import 'package:hive_flutter/hive_flutter.dart';

import 'line.dart';

class LineAdapter extends TypeAdapter<Line> {

  @override
  final int typeId = 1;

  @override
  Line read(BinaryReader reader) {

    final name = reader.readString();
    final moveList = (reader.readList()).cast<int>();
    final created = reader.read() as DateTime;
    final modified = reader.read();
    final pinned = reader.readBool();

    final line = Line(
      name: name,
      moveList: moveList,
      pinned: pinned,
    );

    line.created = created;
    line.modified = modified;

    return line;
  }

  @override
  void write(BinaryWriter writer, Line obj) {

    writer.writeString(obj.name);
    writer.writeList(obj.moveList);
    writer.write(obj.created);
    writer.write(obj.modified);
    writer.writeBool(obj.pinned);
  }
}