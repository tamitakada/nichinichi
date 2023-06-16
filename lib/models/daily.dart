import 'package:isar/isar.dart';
import 'item.dart';

part 'daily.g.dart';

@collection
class Daily {

  Id id = Isar.autoIncrement;

  String title;
  String color;
  bool archived;

  @Backlink(to: 'daily')
  final items = IsarLinks<Item>();

  @Backlink(to: 'archivedDaily')
  final archivedItems = IsarLinks<Item>();

  Daily({ required this.title, required this.color, this.archived = false });

  @override
  bool operator ==(dynamic other) => other != null && other is Daily && id == other.id;

  @override
  int get hashCode => super.hashCode;

}