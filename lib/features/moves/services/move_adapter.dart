import 'package:hive_flutter/hive_flutter.dart';
import '../models/move.dart';

class MoveAdapter extends TypeAdapter<Move> {
  @override
  final int typeId = 0;

  @override
  Move read(BinaryReader reader) {
    return Move(
      moveId: reader.readInt(),
      name: reader.readString(),
      direction: Direction.values[reader.readByte()],
      category: Category.values[reader.readByte()],
      competency: Competency.values[reader.readByte()],
      control: reader.readInt(),
      lastModified: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      areas: (reader.readList())
          .cast<int>()
          .map((i) => AreaOfConcern.values[i])
          .toSet(),
      fresh: reader.readBool(),
      notes: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Move obj) {
    writer.writeInt(obj.moveId);
    writer.writeString(obj.name);
    writer.writeByte(obj.direction.index);
    writer.writeByte(obj.category.index);
    writer.writeByte(obj.competency.index);
    writer.writeInt(obj.control);
    writer.writeInt(obj.lastModified.millisecondsSinceEpoch);
    writer.writeList(obj.areas.map((e) => e.index).toList());
    writer.writeBool(obj.fresh);
    writer.writeString(obj.notes ?? '');
  }
}
