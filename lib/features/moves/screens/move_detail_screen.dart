import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/move.dart';
import 'dart:math' as math;

class MoveDetailScreen extends StatefulWidget {
  final Move move;

  const MoveDetailScreen({super.key, required this.move});

  @override
  State<MoveDetailScreen> createState() => _MoveDetailScreenState();
}

class _MoveDetailScreenState extends State<MoveDetailScreen> {
  Competency? competency;
  Set<AreaOfConcern> area = {};
  int controlRating = 0;

  @override
  void initState() {
    super.initState();
    competency = widget.move.competency;
    controlRating = widget.move.control;
    area = widget.move.areas;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              SizedBox(height: 16),
              _buildCompetency(),
              SizedBox(height: 16),
              _buildConcern(),
              SizedBox(height: 16),
              _buildControlRating(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        // Title (Left Corner)
        Expanded(
          child: Text(
            widget.move.name,
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Save button (Right Corner)
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: "Save changes to this move",
          onPressed: () {
            
            // save changes to item 
            final moveBox = Hive.box<Move>('moves');
            Move updatedMove = widget.move.copyWith(
              areas: area,
              control: controlRating,
              competency: competency,
              );
            moveBox.put(widget.move.moveId, updatedMove);

            // Close bottom sheet
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  Widget _buildCompetency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.tornado, "Self-Assessed Competency"),
        DropdownButton<Competency>(
          value: competency,
          hint: Text("Select competency..."),
          isExpanded: false,
          items: [
            DropdownMenuItem(
              value: Competency.unconciousCompetence,
              child: Text(
                Competency.unconciousCompetence.toString(),
                style: TextStyle(color: Competency.unconciousCompetence.color()),
              ),
            ),
            DropdownMenuItem(
              value: Competency.conciousCompetence,
              child: Text(
                Competency.conciousCompetence.toString(),
                style: TextStyle(
                  color: Color.lerp(
                    Competency.conciousCompetence.color(),
                    Colors.black,
                    0.2,
                  ),
                ),
              ),
            ),
            DropdownMenuItem(
              value: Competency.conciousIncompetence,
              child: Text(
                Competency.conciousIncompetence.toString(),
                style: TextStyle(
                  color: Color.lerp(
                    Competency.conciousIncompetence.color(),
                    Colors.black,
                    0.2,
                  ),
                ),
              ),
            ),
            DropdownMenuItem(
              value: Competency.unconciousIncompetence,
              child: Text(
                Competency.unconciousIncompetence.toString(),
                style: TextStyle(
                  color: Competency.unconciousIncompetence.color(),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              competency = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildConcern() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.troubleshoot_rounded, "Area(s) of Concern"),
        SizedBox(height: 8),
        SegmentedButton<AreaOfConcern>(
          selectedIcon: Icon(Icons.warning_rounded),
          segments: const [
            ButtonSegment(
              value: AreaOfConcern.physical,
              icon: Icon(Icons.fitness_center_rounded),

              label: Text(
                'Physical',
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
            ButtonSegment(
              value: AreaOfConcern.mental,
              icon: Icon(Icons.self_improvement_rounded),
              label: Text(
                'Mental',
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
            ButtonSegment(
              value: AreaOfConcern.technique,
              icon: Icon(Icons.psychology_rounded),
              label: Text('Tech', softWrap: false, overflow: TextOverflow.fade),
            ),
          ],
          selected: area,
          multiSelectionEnabled: true,
          emptySelectionAllowed: true,
          onSelectionChanged: (newSelection) {
            setState(() {
              area = newSelection;
            });
          },
        ),
      ],
    );
  }

  Widget _buildControlRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.tune, "Overall Control: ${controlRating.toInt()}"),
        Slider(
          value: controlRating.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: controlRating.toInt().toString(),
          onChanged: (value) {
            setState(() {
              controlRating = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    final style = Theme.of(context).textTheme.titleMedium!;

    if (icon == Icons.tornado) {
      return Row(
        children: [
          Transform.rotate(
            angle: math.pi,
            child: Icon(Icons.tornado, size: style.fontSize! * 1.1),
          ),
          const SizedBox(width: 8),
          Text(title, style: style),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          icon,
          size: style.fontSize! * 1.2, // scales with text
        ),
        const SizedBox(width: 8),
        Text(title, style: style),
      ],
    );
  }
}
