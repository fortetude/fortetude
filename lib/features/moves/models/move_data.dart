// DTO class for user data within Move (for backups)
import 'package:hive_flutter/hive_flutter.dart';

import 'move.dart';

class MoveUserData {
  final int moveId;
  final Competency competency;
  final int control;
  final Set<AreaOfConcern> areas;
  final String? notes;

  MoveUserData({
    required this.moveId,
    required this.competency,
    required this.control,
    required this.areas,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'moveId': moveId,
      'competency': competency.short,
      'control': control,
      'areas': areas.map((e) => e.short).toList(),
      'notes': notes,
    };
  }

  factory MoveUserData.fromJson(Map<String, dynamic> json, Box<Move> moveBox) {
    if (json['moveId'] is! int) {
      throw FormatException('moveId must be int');
    }

    // validate moveId valid
    final length = moveBox.length;
    if (json['moveId'] < 0 || json['moveId'] > (length - 1)) {
      throw FormatException('moveId out of range');
    }

    if (json['competency'] is! String) {
      throw FormatException('competency must be String');
    }

    if (json['control'] is! int) {
      throw FormatException('control must be int');
    }

    if (json['control'] < 0 || json['control'] > 10) {
      throw FormatException('control out of range 0-10');
    }

    if (json['areas'] is! List) {
      throw FormatException('areas must be List');
    }

    if (json['notes'] == null || json['notes'] is! String) {
      json['notes'] = ''; // silently fix error
    }

    if (json['notes'].length > 5000) {
      throw FormatException('notes are too long! (5000 char limit)');
    }

    final competency = Competency.values.firstWhere(
      (e) => e.short == json['competency'],
      orElse: () {
        throw FormatException('Invalid competency value');
      },
    );

    final areas = (json['areas'] as List).map((e) {
      if (e is! String) {
        throw FormatException('areas contains non-string value');
      }

      return AreaOfConcern.values.firstWhere(
        (a) => a.short == e,
        orElse: () {
          throw FormatException('Invalid AreaOfConcern value: $e');
        },
      );
    }).toSet(); // to set will deduplicate values, thus making it re-valid

    return MoveUserData(
      moveId: json['moveId'] as int,
      competency: competency,
      control: json['control'] as int,
      areas: areas,
      notes: json['notes'] as String,
    );
  }
}
