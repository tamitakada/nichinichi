import 'package:isar/isar.dart';
import 'daily.dart';
import 'item.dart';

part 'todo_list.g.dart';

@collection
class TodoList {

  Id id = Isar.autoIncrement;

  DateTime date;

  final incompleteDailies = IsarLinks<Item>();
  final completeDailies = IsarLinks<Item>();

  final incompleteSingles = IsarLinks<Item>();
  final completeSingles = IsarLinks<Item>();

  TodoList({ required this.date });

}