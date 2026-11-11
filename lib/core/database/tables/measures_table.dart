import 'package:drift/drift.dart';

/// Tabela local de compassos (`measures`) em ordem linear de reprodução.
/// `startMs` permanece nulo enquanto o compasso está apenas desenhado no PDF (Etapa 4)
/// e é preenchido na sincronização manual (Etapa 5).
class Measures extends Table {
  TextColumn get id => text()();
  TextColumn get syncId => text()
      .named('sync_id')
      .customConstraint(
        'NOT NULL REFERENCES sync_versions(id) ON DELETE CASCADE',
      )();
  IntColumn get measureOrder => integer().named('measure_order')();
  TextColumn get measureLabel =>
      text().named('measure_label').withDefault(const Constant(''))();
  IntColumn get startMs => integer().named('start_ms').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {syncId, measureOrder},
      ];
}
