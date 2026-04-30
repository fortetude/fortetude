import 'package:flutter/material.dart';

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
  jumps('J'),
  drops('D'),
  wall('W'),
  bar('B');

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
    Competency.unonciousCompetence => Color.fromARGB(200, 59, 167, 255),
    Competency.conciousCompetence => Color.fromARGB(240, 100, 255, 86),
    Competency.conciousIncompetece => Color.fromARGB(230, 255, 255, 114),
    Competency.unconciousIncompetence => Color.fromARGB(209, 253, 80, 80),
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
  final Category category;
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
    required this.category,
    required this.competency,
    required this.control,
    DateTime? lastModified,
    this.areas = const {},
    this.notes = '',
  }) : lastModified = lastModified ?? DateTime.now();

  // string checks
  static String truncateNotes(String value) {
    return value.length > 1000
        ? value.substring(0, 1000)
        : value;
  }

  String getName() {return name;}

  double controlWidth() {
    return (control / 10).clamp(0.0, 1.0);
  }

  bool hasPhysical() {
    return areas?.contains(AreaOfConcern.physical) ?? false;
  }

  bool hasMental() {
    return areas?.contains(AreaOfConcern.mental) ?? false;
  }

  bool hasTechnique() {
    return areas?.contains(AreaOfConcern.technique) ?? false;
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
      category: category,
      competency: competency ?? this.competency,
      control: control ?? this.control,
    );
  }
}