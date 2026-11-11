/// Tipos de arquivo suportados por uma música no SingerSinc.
enum AssetType {
  pdf('pdf'),
  audio('audio');

  const AssetType(this.value);
  final String value;

  static AssetType fromValue(String raw) {
    return raw == 'audio' ? AssetType.audio : AssetType.pdf;
  }
}

/// Entidade de domínio representando uma revisão de arquivo (PDF ou MP3) vinculada à música.
class SongAssetEntity {
  const SongAssetEntity({
    required this.id,
    required this.songId,
    required this.assetType,
    required this.revision,
    required this.storagePath,
    required this.mimeType,
    required this.fileSize,
    required this.checksum,
    required this.isActive,
    required this.isDownloaded,
    required this.version,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
    this.localPath,
  });

  final String id;
  final String songId;
  final AssetType assetType;
  final int revision;
  final String storagePath;
  final String? localPath;
  final String mimeType;
  final int fileSize;
  final String checksum;
  final bool isActive;
  final bool isDownloaded;
  final int version;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPendingSync => syncStatus != 'synced';
}

