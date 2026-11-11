import 'package:drift/drift.dart';

/// Tabela local de músicas (`songs`), espelhando o banco PostgreSQL remoto
/// e incluindo metadados de controle Offline-First.
class Songs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get baseVersion =>
      integer().named('base_version').withDefault(const Constant(0))();
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

