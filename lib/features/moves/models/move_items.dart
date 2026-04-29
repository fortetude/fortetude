import 'move.dart';

// TEST: data
final Set<AreaOfConcern> ponly = {AreaOfConcern.physical};
final Set<AreaOfConcern> monly = {AreaOfConcern.mental};
final Set<AreaOfConcern> tonly = {AreaOfConcern.technique};
final Set<AreaOfConcern> pm = {AreaOfConcern.physical, AreaOfConcern.mental};
final Set<AreaOfConcern> pt = {AreaOfConcern.physical, AreaOfConcern.technique};
final Set<AreaOfConcern> mt = {AreaOfConcern.mental, AreaOfConcern.technique};
final Set<AreaOfConcern> pmt = {AreaOfConcern.physical, AreaOfConcern.mental, AreaOfConcern.technique};


// initialise the default Move objects

// Vaults
final stepVaultL = Move(moveId: 0, name: "Step (L)", direction: Direction.left, areas: {AreaOfConcern.physical},
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 10);
final stepVaultR = Move(moveId: 1, name: "Step (R)", direction: Direction.right, areas: monly,
                        category: Category.vaults, competency: Competency.conciousIncompetece, control: 2);
final speedVaultL = Move(moveId: 2, name: "Speed (L)", direction: Direction.left, areas: tonly,
                        category: Category.vaults, competency: Competency.conciousCompetence, control: 5);
final speedVaultR = Move(moveId: 3, name: "Speed (R)", direction: Direction.right, areas: pm,
                        category: Category.vaults, competency: Competency.unonciousCompetence, control: 7);
final kongVaultL = Move(moveId: 4, name: "Kong (L)", direction: Direction.left, areas: pt,
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 1);
final kongVaultR = Move(moveId: 5, name: "Kong (R)", direction: Direction.right, areas: mt,
                        category: Category.vaults, competency: Competency.unonciousCompetence, control: 2);
final diveKongVaultL = Move(moveId: 6, name: "Dive Kong", direction: Direction.both, areas: pmt,
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 3);
final doubleKongVaultL = Move(moveId: 7, name: "Double Kong", direction: Direction.both, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 4);
final dashVaultL = Move(moveId: 8, name: "Dash (L)", direction: Direction.left, areas: pm,
                        category: Category.vaults, competency: Competency.conciousIncompetece, control: 5);
final dashVaultR = Move(moveId: 9, name: "Dash (R)", direction: Direction.right, 
                        category: Category.vaults, competency: Competency.conciousCompetence, control: 6);
final lazyVaultL = Move(moveId: 10, name: "Lazy (L)", direction: Direction.left, areas: mt,
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 7);
final lazyVaultR = Move(moveId: 11, name: "Lazy (R)", direction: Direction.right, areas: pt,
                        category: Category.vaults, competency: Competency.unonciousCompetence, control: 8);
final thiefVaultL = Move(moveId: 12, name: "Thief (L)", direction: Direction.left, 
                        category: Category.vaults, competency: Competency.conciousIncompetece, control: 9);
final thiefVaultR = Move(moveId: 13, name: "Thief (R)", direction: Direction.right, areas: pmt,
                        category: Category.vaults, competency: Competency.conciousCompetence, control: 10);
final reverseVaultL = Move(moveId: 14, name: "Reverse (L)", direction: Direction.left, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 0);
final reverseVaultR = Move(moveId: 15, name: "Reverse (R)", direction: Direction.right, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 0);
final turnVaultL = Move(moveId: 16, name: "Turn (L)", direction: Direction.left, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 0);
final turnVaultR = Move(moveId: 17, name: "Turn (R)", direction: Direction.right, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 0);
final gateVaultL = Move(moveId: 18, name: "Gate (L)", direction: Direction.left, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 0);
final gateVaultR = Move(moveId: 19, name: "Gate (R)", direction: Direction.right, 
                        category: Category.vaults, competency: Competency.unconciousIncompetence, control: 0);

// Jumps

final strides = Move(moveId: 20, name: "Stride", direction: Direction.both, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);
final standingPre = Move(moveId: 21, name: "Standing Pre", direction: Direction.both, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);
final runningPreL = Move(moveId: 22, name: "Running Pre (L)", direction: Direction.left, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);
final runningPreR = Move(moveId: 23, name: "Running Pre (R)", direction: Direction.right, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);
final plyo = Move(moveId: 24, name: "Plyo", direction: Direction.both, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);
final craneL = Move(moveId: 25, name: "Crane (L)", direction: Direction.left, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);
final craneR = Move(moveId: 26, name: "Crane (R)", direction: Direction.right, 
                        category: Category.jumps, competency: Competency.unconciousIncompetence, control: 0);

// Dismounts & Landings

final safetyTap = Move(moveId: 27, name: "Safety Tap", direction: Direction.both, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final groundKong = Move(moveId: 28, name: "Ground Kong", direction: Direction.both, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final kongDownL = Move(moveId: 29, name: "Kong Down (L)", direction: Direction.left, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final kongDownR = Move(moveId: 30, name: "Kong Down (R)", direction: Direction.right, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final stepDownL = Move(moveId: 31, name: "Step Down (L)", direction: Direction.left, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final stepDownR = Move(moveId: 32, name: "Step Down (R)", direction: Direction.right, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final lazyDownL = Move(moveId: 33, name: "Lazy Down (L)", direction: Direction.left, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final lazyDownR = Move(moveId: 34, name: "Lazy Down (R)", direction: Direction.right, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final reverseDownL = Move(moveId: 35, name: "Reverse Down (L)", direction: Direction.left, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final reverseDownR = Move(moveId: 36, name: "Reverse Down (R)", direction: Direction.right, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final rollL = Move(moveId: 37, name: "Roll (L)", direction: Direction.left, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final rollR = Move(moveId: 38, name: "Roll (R)", direction: Direction.right, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);
final diveRoll = Move(moveId: 39, name: "Dive Roll", direction: Direction.both, 
                        category: Category.drops, competency: Competency.unconciousIncompetence, control: 0);

// Wall Movement

final catLeapL = Move(moveId: 40, name: "Cat Leap (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final catLeapR = Move(moveId: 41, name: "Cat Leap (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final wallrunL = Move(moveId: 42, name: "Step Down (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final wallrunR = Move(moveId: 43, name: "Step Down (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final climbupL = Move(moveId: 44, name: "Lazy Down (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final climbupR = Move(moveId: 45, name: "Lazy Down (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final topoutL = Move(moveId: 46, name: "Reverse Down (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final topoutR = Move(moveId: 47, name: "Reverse Down (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final tictacL = Move(moveId: 48, name: "Roll (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final tictacR = Move(moveId: 49, name: "Roll (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final a180L = Move(moveId: 50, name: "Reverse Down (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final a180R = Move(moveId: 51, name: "Reverse Down (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final popupL = Move(moveId: 52, name: "Pop Vault (L)", direction: Direction.left, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);
final popupR = Move(moveId: 53, name: "Pop Vault (R)", direction: Direction.right, 
                        category: Category.wall, competency: Competency.unconciousIncompetence, control: 0);


// Bar Movement
final lache = Move(moveId: 54, name: "Lache", direction: Direction.both, 
                        category: Category.bar, competency: Competency.unconciousIncompetence, control: 0);
final underbar = Move(moveId: 55, name: "Underbar", direction: Direction.both, 
                        category: Category.bar, competency: Competency.unconciousIncompetence, control: 0);
final reverseUnderbar = Move(moveId: 56, name: "Reverse Underbar", direction: Direction.both, 
                        category: Category.bar, competency: Competency.unconciousIncompetence, control: 0);
final barKip = Move(moveId: 57, name: "Bar Kip", direction: Direction.both, 
                        category: Category.bar, competency: Competency.unconciousIncompetence, control: 0);
final barMuscleUp = Move(moveId: 58, name: "Bar Muscle Up", direction: Direction.both, 
                        category: Category.bar, competency: Competency.unconciousIncompetence, control: 0);

final Set<Move> allMoves = {
  stepVaultL,
  stepVaultR,
  speedVaultL,
  speedVaultR,
  kongVaultL,
  kongVaultR,
  diveKongVaultL,
  doubleKongVaultL,
  dashVaultL,
  dashVaultR,
  lazyVaultL,
  lazyVaultR,
  thiefVaultL,
  thiefVaultR,
  /*
  reverseVaultL,
  reverseVaultR,
  turnVaultL,
  turnVaultR,
  gateVaultL,
  gateVaultR,
  strides,
  standingPre,
  runningPreL,
  runningPreR,
  plyo,
  craneL,
  craneR,
  safetyTap,
  groundKong,
  kongDownL,
  kongDownR,
  stepDownL,
  stepDownR,
  lazyDownL,
  lazyDownR,
  reverseDownL,
  reverseDownR,
  rollL,
  rollR,
  diveRoll,
  catLeapL,
  catLeapR,
  wallrunL,
  wallrunR,
  climbupL,
  climbupR,
  topoutL,
  topoutR,
  tictacL,
  tictacR,
  a180L,
  a180R,
  popupL,
  popupR,
  lache,
  underbar,
  reverseUnderbar,
  barKip,
  barMuscleUp,
  */
};