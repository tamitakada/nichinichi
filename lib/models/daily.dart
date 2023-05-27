import 'package:isar/isar.dart';
import 'item.dart';

part 'daily.g.dart';

@collection
class Daily {

  Id id = Isar.autoIncrement;

  String title;
  DateTime startDate;
  DateTime? endDate;

  String color;

  @Backlink(to: "daily")
  final items = IsarLinks<Item>();

  Daily({ required this.title, required this.startDate, this.endDate, this.color = "33CCD6" });

}