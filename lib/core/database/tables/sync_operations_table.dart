import 'package:drift/drift.dart';

/// Fila local de operações pendentes (Outbox Pattern) para sincronização
/// resiliente entre o SQLite/sistema de arquivos local e o Supabase.
class SyncOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get operationType => text().named('operation_type')();
  TextColumn get payloadJson => text().named('payload_json').nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))(); // pending | in_progress | failed | conflict
  IntColumn get retryCount =>
      integer().named('retry_count').withDefault(const Constant(0))();
  TextColumn get errorMessage => text().named('error_message').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

