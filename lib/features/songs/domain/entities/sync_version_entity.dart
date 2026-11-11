/// Entidade de domínio representando uma versão de sincronização entre uma
/// revisão de PDF e uma revisão de áudio MP3.
class SyncVersionEntity {
  const SyncVersionEntity({
    required this.id,
    required this.songId,
    required this.pdfAssetId,
    required this.audioAssetId,
    required this.audioDurationMs,
    required this.isActive,
    required this.version,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String songId;
  final String pdfAssetId;
  final String audioAssetId;
  final int audioDurationMs;
  final bool isActive;
  final int version;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPendingSync => syncStatus != 'synced';
}

