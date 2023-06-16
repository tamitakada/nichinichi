import 'package:isar/isar.dart';
import 'daily.dart';

part 'item.g.dart';

@collection
class Item {

  Id id = Isar.autoIncrement;

  String? description;
  int? order;

  final daily = IsarLink<Daily>();
  final archivedDaily = IsarLink<Daily>();

  Item({ this.description, this.order });

  @override
  bool operator ==(dynamic other) => other != null && other is Item && id == other.id;

  @override
  int get hashCode => super.hashCode;

}