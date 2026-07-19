import 'package:isar/isar.dart';

part 'player.g.dart';

@collection
class Player {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  String name;

  int colorValue;

  bool? isMe;
  
  Player({
    required this.name,
    required this.colorValue,
    this.isMe,
  });
}