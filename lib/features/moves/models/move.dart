import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  bool notLeft() => this != Direction.left;
  bool notRight() => this != Direction.right;
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
  unconciousCompetence('UC'),
  conciousCompetence('CC'),
  conciousIncompetence('CI'),
  unconciousIncompetence('UI');

  final String short;
  const Competency(this.short);

  // switch color based on competency level
  Color color() => switch (this) {
    Competency.unconciousCompetence => Color.fromARGB(200, 59, 167, 255),
    Competency.conciousCompetence => Color.fromARGB(240, 100, 255, 86),
    Competency.conciousIncompetence => Color.fromRGBO(255, 255, 24, 0.902),
    Competency.unconciousIncompetence => Color.fromARGB(209, 253, 80, 80),
  };

  @override
  String toString() => switch (this) {
    Competency.unconciousCompetence => "Unconcious Competence",
    Competency.conciousCompetence => "Concious Competence",
    Competency.conciousIncompetence => "Concious Incompetence",
    Competency.unconciousIncompetence => "Unconcious Incompetence",
  };
}

enum AreaOfConcern {
  physical('P'),
  mental('M'),
  technique('T');

  final String short;
  const AreaOfConcern(this.short);

  IconData getIcon() => switch (this) {
    AreaOfConcern.physical => Icons.fitness_center_rounded,
    AreaOfConcern.mental => Icons.self_improvement_rounded,
    AreaOfConcern.technique => Icons.psychology_rounded,
  };
}

extension AreasIcon on AreaOfConcern {
  IconData get icon {
    switch (this) {
      case AreaOfConcern.physical:
        return Icons.fitness_center_rounded;
      case AreaOfConcern.mental:
        return Icons.self_improvement_rounded;
      case AreaOfConcern.technique:
        return Icons.psychology_rounded;
    }
  }
}

enum MoveSortType {
  defaultSort,
  nameAsc,
  nameDesc,
  overallRatingAsc,
  overallRatingDesc,
}

extension MoveSorting on MoveSortType {
  int compare(Move a, Move b) {
    switch (this) {
      case MoveSortType.nameAsc:
        return a.name.compareTo(b.name);

      case MoveSortType.nameDesc:
        return b.name.compareTo(a.name);

      case MoveSortType.defaultSort:
        return a.category.index.compareTo(b.category.index);
      case MoveSortType.overallRatingAsc:
        return a.overallRating.compareTo(b.overallRating);
      case MoveSortType.overallRatingDesc:
        return b.overallRating.compareTo(a.overallRating);
    }
  }
}

// JSON representation of a "move"
class Move extends HiveObject {
  final int moveId;
  final String name;
  final Direction direction;
  final Category category;
  bool fresh;
  Competency competency;
  int control;
  DateTime lastModified;
  Set<AreaOfConcern> areas; // can be null if none currently match
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
    //DateTime? lastUsed, // DateTime.utc(1, 1, 1);
    required this.areas,
    this.fresh = false,
    this.notes = '',
    // ignore: prefer_initializing_formals
  }) : lastModified = lastModified ?? DateTime.now();

  // string checks
  static String truncateNotes(String value) {
    return value.length > 1000 ? value.substring(0, 1000) : value;
  }

  String get cleanName =>
      name.replaceFirst(" (L)", "").replaceFirst(" (R)", "");

  double controlWidth() {
    return (control / 10).clamp(0.0, 1.0);
  }

  bool hasPhysical() {
    return areas.contains(AreaOfConcern.physical);
  }

  bool hasMental() {
    return areas.contains(AreaOfConcern.mental);
  }

  bool hasTechnique() {
    return areas.contains(AreaOfConcern.technique);
  }

  Move copyWith({
    Competency? competency,
    int? control,
    DateTime? lastModified,
    required Set<AreaOfConcern> areas, // can be null if none currently match
    String? notes, // can be null if user doesn't require notes
  }) {
    return Move(
      moveId: moveId,
      name: name,
      direction: direction,
      category: category,
      competency: competency ?? this.competency,
      control: control ?? this.control,
      fresh: false,
      areas: areas,
      lastModified: DateTime.now(), // update modified date
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moveId': moveId,
      'name': name,

      // Store enums as strings for stability
      'direction': direction.name,
      'category': category.name,
      'competency': competency.name,

      'control': control,

      // ISO8601 is portable and human-readable
      'lastModified': lastModified.toIso8601String(),

      // Store enum sets as string arrays
      'areas': areas.map((e) => e.name).toList(),

      'fresh': fresh,

      'notes': notes,
    };
  }

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      moveId: json['moveId'] as int,

      name: json['name'] as String,

      direction: Direction.values.firstWhere(
        (e) => e.name == json['direction'],
      ),

      category: Category.values.firstWhere((e) => e.name == json['category']),

      competency: Competency.values.firstWhere(
        (e) => e.name == json['competency'],
      ),

      control: json['control'] as int,

      lastModified: DateTime.parse(json['lastModified'] as String),

      areas: (json['areas'] as List)
          .map((e) => AreaOfConcern.values.firstWhere((a) => a.name == e))
          .toSet(),

      fresh: json['fresh'] as bool,

      notes: json['notes'] as String?,
    );
  }
}

extension MoveRating on Move {
  int get overallRating {
    // Competency points
    int competencyPoints = switch (competency) {
      Competency.unconciousCompetence => 70,
      Competency.conciousCompetence => 50,
      Competency.conciousIncompetence => 30,
      Competency.unconciousIncompetence => 10,
    };

    // Area of Concern points
    int areaPoints = switch (areas.length) {
      0 => 0,
      1 => -3,
      2 => -5,
      _ => -7,
    };

    // Control points (just add control directly)
    int controlPoints = control;

    return competencyPoints + areaPoints + controlPoints;
  }
}
