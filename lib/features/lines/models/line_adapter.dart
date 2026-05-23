import 'package:hive_flutter/hive_flutter.dart';
import 'line.dart';

class LineAdapter extends TypeAdapter<Line> {
  @override
  final int typeId = 1;

  @override
  Line read(BinaryReader reader) {

    final name = reader.readString();
    final moveList = (reader.readList()).cast<int>();
    final created = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final modified = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
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
    writer.writeInt(obj.created.millisecondsSinceEpoch);
    writer.writeInt(obj.modified!.millisecondsSinceEpoch);
    writer.writeBool(obj.pinned);
  }
}