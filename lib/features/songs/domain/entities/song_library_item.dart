import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/sync_version_entity.dart';

/// Agregado de domínio representando uma música na Biblioteca do professor,
/// incluindo seus arquivos ativos (PDF e MP3), versão de sincronização ativa
/// e indicadores de disponibilidade offline e estado de sincronização com a nuvem.
class SongLibraryItem {
  const SongLibraryItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.version,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
    this.activePdfAsset,
    this.activeAudioAsset,
    this.activeSyncVersion,
    this.measuresCount = 0,
    this.syncedMeasuresCount = 0,
  });

  final String id;
  final String userId;
  final String title;
  final int version;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SongAssetEntity? activePdfAsset;
  final SongAssetEntity? activeAudioAsset;
  final SyncVersionEntity? activeSyncVersion;
  final int measuresCount;
  final int syncedMeasuresCount;

  /// Verdadeiro quando o PDF ativo e o MP3 ativo estão baixados e disponíveis localmente.
  bool get isAvailableOffline =>
      (activePdfAsset?.isDownloaded ?? false) &&
      (activePdfAsset?.localPath?.isNotEmpty ?? false) &&
      (activeAudioAsset?.isDownloaded ?? false) &&
      (activeAudioAsset?.localPath?.isNotEmpty ?? false);

  /// Verdadeiro quando a música, seus arquivos ativos ou sua versão de sincronização
  /// possuem alterações pendentes de envio para o Supabase.
  bool get hasPendingCloudSync =>
      syncStatus != 'synced' ||
      (activePdfAsset?.isPendingSync ?? false) ||
      (activeAudioAsset?.isPendingSync ?? false) ||
      (activeSyncVersion?.isPendingSync ?? false);

  /// Verdadeiro caso algum registro tenha sido sinalizado com conflito de versão.
  bool get hasConflict =>
      syncStatus == 'conflict' ||
      activePdfAsset?.syncStatus == 'conflict' ||
      activeAudioAsset?.syncStatus == 'conflict' ||
      activeSyncVersion?.syncStatus == 'conflict';
}

