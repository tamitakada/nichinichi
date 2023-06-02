// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTodoListCollection on Isar {
  IsarCollection<TodoList> get todoLists => this.collection();
}

const TodoListSchema = CollectionSchema(
  name: r'TodoList',
  id: 7701471819688667286,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    )
  },
  estimateSize: _todoListEstimateSize,
  serialize: _todoListSerialize,
  deserialize: _todoListDeserialize,
  deserializeProp: _todoListDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'incompleteDailies': LinkSchema(
      id: -5539077334483899646,
      name: r'incompleteDailies',
      target: r'Item',
      single: false,
    ),
    r'completeDailies': LinkSchema(
      id: -8228964954231066007,
      name: r'completeDailies',
      target: r'Item',
      single: false,
    ),
    r'incompleteSingles': LinkSchema(
      id: 4327886357373053704,
      name: r'incompleteSingles',
      target: r'Item',
      single: false,
    ),
    r'completeSingles': LinkSchema(
      id: -1869558052899738691,
      name: r'completeSingles',
      target: r'Item',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _todoListGetId,
  getLinks: _todoListGetLinks,
  attach: _todoListAttach,
  version: '3.1.0+1',
);

int _todoListEstimateSize(
  TodoList object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _todoListSerialize(
  TodoList object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.hashCode);
}

TodoList _todoListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodoList(
    date: reader.readDateTime(offsets[0]),
  );
  object.id = id;
  return object;
}

P _todoListDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _todoListGetId(TodoList object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _todoListGetLinks(TodoList object) {
  return [
    object.incompleteDailies,
    object.completeDailies,
    object.incompleteSingles,
    object.completeSingles
  ];
}

void _todoListAttach(IsarCollection<dynamic> col, Id id, TodoList object) {
  object.id = id;
  object.incompleteDailies
      .attach(col, col.isar.collection<Item>(), r'incompleteDailies', id);
  object.completeDailies
      .attach(col, col.isar.collection<Item>(), r'completeDailies', id);
  object.incompleteSingles
      .attach(col, col.isar.collection<Item>(), r'incompleteSingles', id);
  object.completeSingles
      .attach(col, col.isar.collection<Item>(), r'completeSingles', id);
}

extension TodoListQueryWhereSort on QueryBuilder<TodoList, TodoList, QWhere> {
  QueryBuilder<TodoList, TodoList, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TodoListQueryWhere on QueryBuilder<TodoList, TodoList, QWhereClause> {
  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TodoListQueryFilter
    on QueryBuilder<TodoList, TodoList, QFilterCondition> {
  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TodoListQueryObject
    on QueryBuilder<TodoList, TodoList, QFilterCondition> {}

extension TodoListQueryLinks
    on QueryBuilder<TodoList, TodoList, QFilterCondition> {
  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> incompleteDailies(
      FilterQuery<Item> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'incompleteDailies');
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteDailiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteDailies', length, true, length, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteDailiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteDailies', 0, true, 0, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteDailiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteDailies', 0, false, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteDailiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteDailies', 0, true, length, include);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteDailiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incompleteDailies', length, include, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteDailiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incompleteDailies', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> completeDailies(
      FilterQuery<Item> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'completeDailies');
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeDailiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeDailies', length, true, length, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeDailiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeDailies', 0, true, 0, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeDailiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeDailies', 0, false, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeDailiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeDailies', 0, true, length, include);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeDailiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completeDailies', length, include, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeDailiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completeDailies', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> incompleteSingles(
      FilterQuery<Item> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'incompleteSingles');
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteSinglesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteSingles', length, true, length, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteSinglesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteSingles', 0, true, 0, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteSinglesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteSingles', 0, false, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteSinglesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incompleteSingles', 0, true, length, include);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteSinglesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incompleteSingles', length, include, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      incompleteSinglesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incompleteSingles', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> completeSingles(
      FilterQuery<Item> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'completeSingles');
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeSinglesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeSingles', length, true, length, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeSinglesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeSingles', 0, true, 0, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeSinglesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeSingles', 0, false, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeSinglesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completeSingles', 0, true, length, include);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeSinglesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completeSingles', length, include, 999999, true);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      completeSinglesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completeSingles', lower, includeLower, upper, includeUpper);
    });
  }
}

extension TodoListQuerySortBy on QueryBuilder<TodoList, TodoList, QSortBy> {
  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }
}

extension TodoListQuerySortThenBy
    on QueryBuilder<TodoList, TodoList, QSortThenBy> {
  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension TodoListQueryWhereDistinct
    on QueryBuilder<TodoList, TodoList, QDistinct> {
  QueryBuilder<TodoList, TodoList, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }
}

extension TodoListQueryProperty
    on QueryBuilder<TodoList, TodoList, QQueryProperty> {
  QueryBuilder<TodoList, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TodoList, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<TodoList, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }
}
