import 'package:isar/isar.dart';
import 'daily.dart';

part 'item.g.dart';

@collection
class Item {

  Id id = Isar.autoIncrement;

  String? description;
  int? order;

  final daily = IsarLink<Daily>();

  Item({ this.description, this.order });

}