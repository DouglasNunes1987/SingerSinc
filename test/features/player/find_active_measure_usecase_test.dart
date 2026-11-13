import 'package:flutter_test/flutter_test.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/player/domain/usecases/find_active_measure_usecase.dart';

void main() {
  const useCase = FindActiveMeasureUseCase();

  final testMeasures = [
    const MeasureEntity(
      id: 'm-1',
      syncId: 'sync-1',
      measureOrder: 1,
      measureLabel: '1',
      startMs: 2000, // Introdução até 2s
    ),
    const MeasureEntity(
      id: 'm-2',
      syncId: 'sync-1',
      measureOrder: 2,
      measureLabel: '2',
      startMs: 4500,
    ),
    const MeasureEntity(
      id: 'm-3',
      syncId: 'sync-1',
      measureOrder: 3,
      measureLabel: '3',
      startMs: 7000,
    ),
    const MeasureEntity(
      id: 'm-4',
      syncId: 'sync-1',
      measureOrder: 4,
      measureLabel: '4',
      startMs: 10000,
    ),
  ];

  group('FindActiveMeasureUseCase (Busca Binária de Compasso Ativo)', () {
    test('deve retornar null durante a introdução musical (antes do compasso 1)', () {
      final active = useCase(
        measures: testMeasures,
        currentPositionMs: 1500,
      );
      expect(active, isNull);
    });

    test('deve retornar o compasso exato no milissegundo de início', () {
      final active = useCase(
        measures: testMeasures,
        currentPositionMs: 2000,
      );
      expect(active?.id, 'm-1');
    });

    test('deve retornar o compasso 2 quando a reprodução estiver no meio dele', () {
      final active = useCase(
        measures: testMeasures,
        currentPositionMs: 5500, // Entre 4500 e 7000
      );
      expect(active?.id, 'm-2');
    });

    test('deve retornar o último compasso quando o áudio passar do início dele', () {
      final active = useCase(
        measures: testMeasures,
        currentPositionMs: 15000, // Após 10000
      );
      expect(active?.id, 'm-4');
    });

    test('deve ignorar compassos com startMs nulo', () {
      final measuresWithNull = [
        ...testMeasures,
        const MeasureEntity(
          id: 'm-5',
          syncId: 'sync-1',
          measureOrder: 5,
          measureLabel: '5',
          startMs: null,
        ),
      ];

      final active = useCase(
        measures: measuresWithNull,
        currentPositionMs: 12000,
      );
      expect(active?.id, 'm-4');
    });
  });
}

