import 'package:hive/hive.dart';
import 'move.dart';
import '../../../core/utils/random.dart';

// initialise the default Move objects
Map<String, Category> moveEntries = {
  "Step (L)": Category.vaults,
  "Step (R)": Category.vaults,
  "Speed (L)": Category.vaults,
  "Speed (R)": Category.vaults,
  "Kong (L)": Category.vaults,
  "Kong (R)": Category.vaults,
  "Dive Kong": Category.vaults,
  "Double Kong": Category.vaults,
  "Dash (L)": Category.vaults,
  "Dash (R)": Category.vaults,
  "Lazy (L)": Category.vaults,
  "Lazy (R)": Category.vaults,
  "Thief (L)": Category.vaults,
  "Thief (R)": Category.vaults,
  "Reverse (L)": Category.vaults,
  "Reverse (R)": Category.vaults,
  "Turn (L)": Category.vaults,
  "Turn (R)": Category.vaults,
  "Gate (L)": Category.vaults,
  "Gate (R)": Category.vaults,
  "Stride": Category.jumps,
  "Standing Pre": Category.jumps,
  "Running Pre (L)": Category.jumps,
  "Running Pre (R)": Category.jumps,
  "Plyo": Category.jumps,
  "Crane (L)": Category.jumps,
  "Crane (R)": Category.jumps,
  "Safety Tap": Category.drops,
  "Ground Kong": Category.drops,
  "Kong Down (L)": Category.drops,
  "Kong Down (R)": Category.drops,
  "Step Down (L)": Category.drops,
  "Step Down (R)": Category.drops,
  "Lazy Down (L)": Category.drops,
  "Lazy Down (R)": Category.drops,
  "Reverse Down (L)": Category.drops,
  "Reverse Down (R)": Category.drops,
  "Roll (L)": Category.drops,
  "Roll (R)": Category.drops,
  "Dive Roll": Category.drops,
  "Cat Leap (L)": Category.wall,
  "Cat Leap (R)": Category.wall,
  "Pop Vault (L)": Category.wall,
  "Pop Vault (R)": Category.wall,
  "Lache": Category.bar,
  "Underbar": Category.bar,
  "Reverse Underbar": Category.bar,
  "Bar Kip": Category.bar,
  "Bar Muscle Up": Category.bar,
};

// Vaults
List<Move> templateMoves({bool randomise = false}) {
  int moveId = -1;

  // Iterate through the map and create a list of Move objects
  List<Move> moves = moveEntries.entries.map((entry) {
    // Create a new Move object for each key-value pair
    moveId += 1;
    Direction d;
    if(entry.key.contains('(L)')) {
      d = Direction.left;
    } else if(entry.key.contains('(R)')) {
      d = Direction.right;
    } else {
      d = Direction.both;
    }

    return Move(
      moveId: moveId,
      name: entry.key,
      direction: d,
      category: entry.value,
      competency: randomise ? randEnum(Competency.values) : Competency.unconciousIncompetence,
      areas: randomise ? randAreas() : {},
      fresh: true,
      control: randomise ? randControl() : 0,
    );

  }).toList();

  return moves;
}

// insert blank for prod
Future<void> insertMovesProd(Box<Move> moveBox) async {
  // Convert Set<Move> to a Map<int, Move>, using moveId as the key
  List<Move> allMoves = templateMoves();
  var movesMap = {for (var move in allMoves) move.moveId: move};
  moveBox.putAll(movesMap);
}

// insert filled data for debug
Future<void> insertMovesDebug(Box<Move> moveBox) async {
  List<Move> randMoves = templateMoves(randomise: true);
  // add Moves into box, but randomise properties
  var movesMap = {for (var move in randMoves) move.moveId: move};
  moveBox.putAll(movesMap);
}
