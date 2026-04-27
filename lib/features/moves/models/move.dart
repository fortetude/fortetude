import 'dart:ui';

// Direction of the move
enum Direction {
  left('L'),
  right('R'),
  both('B');

  final String short;
  const Direction(this.short);

  bool isLeft() => this == Direction.left;
  bool isRight() => this == Direction.right;
  bool isBoth() => this == Direction.both;
}

enum Category {
  vaults('V'),
  conciousCompetence('CC'),
  conciousIncompetece('CI'),
  unconciousIncompetence('UI');

  final String short;
  const Category(this.short);
}


enum Competency {
  unonciousCompetence('UC'),
  conciousCompetence('CC'),
  conciousIncompetece('CI'),
  unconciousIncompetence('UI');

  final String short;
  const Competency(this.short);

  // switch color based on competency level
  Color color() => switch(this) {
    Competency.unonciousCompetence => Color.fromARGB(255, 0, 0, 255),
    Competency.conciousCompetence => Color.fromARGB(255, 0, 255, 0),
    Competency.conciousIncompetece => Color.fromARGB(255, 255, 255, 0),
    Competency.unconciousIncompetence => Color.fromARGB(255, 255, 0, 0),
  };
}

enum AreaOfConcern {
  physical('P'),
  mental('M'),
  technique('T');

  final String short;
  const AreaOfConcern(this.short);
}

// JSON representation of a "move"
class Move {

  final int moveId;
  final String name;
  final Direction direction;
  Competency competency;
  int control;
  DateTime lastModified;
  Set<AreaOfConcern>? areas; // can be null if none currently match
  String? notes; // can be null if user doesn't require notes
  

  // Constructor for returning a new Move
  Move({
    required this.moveId,
    required this.name,
    required this.direction,
    required this.competency,
    required this.control,
    DateTime? lastModified,
    Set<AreaOfConcern>? areas,
    String? notes = '',
  }) : lastModified = lastModified ?? DateTime.now();

  // string checks
  static String truncateNotes(String value) {
    return value.length > 1000
        ? value.substring(0, 1000)
        : value;
  }

  Move copyWith({
    Competency? competency,
    int? control,
    DateTime? lastModified,
    Set<AreaOfConcern>? areas, // can be null if none currently match
    String? notes // can be null if user doesn't require notes
  }) {
    return Move(
      moveId: moveId,
      name: name,
      direction: direction,
      competency: competency ?? this.competency,
      control: control ?? this.control,
    );
  }
}