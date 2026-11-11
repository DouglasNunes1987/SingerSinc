import 'package:drift/drift.dart';

/// Tabela local de regiões visuais dos compassos (`measure_regions`).
/// Todas as coordenadas (`x`, `y`, `w`, `h`) são normalizadas no intervalo `[0..1]`
/// em relação às dimensões originais da página do PDF.
class MeasureRegions extends Table {
  TextColumn get id => text()();
  TextColumn get measureId => text()
      .named('measure_id')
      .customConstraint('NOT NULL REFERENCES measures(id) ON DELETE CASCADE')();
  IntColumn get regionOrder =>
      integer().named('region_order').withDefault(const Constant(1))();
  IntColumn get pageNumber => integer().named('page_number')();
  RealColumn get x => real()();
  RealColumn get y => real()();
  RealColumn get w => real()();
  RealColumn get h => real()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {measureId, regionOrder},
      ];
}
