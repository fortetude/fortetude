import 'dart:math';
import '../../features/moves/models/move.dart';

final _random = Random();

int randControl() => _random.nextInt(11);

// final Competency = randEnum(Competency.values);
T randEnum<T>(List<T> values) =>
    values[_random.nextInt(values.length)];

Set<AreaOfConcern> randAreas() {
  final random = Random();

  return AreaOfConcern.values
      .where((_) => random.nextBool())
      .toSet();
}

