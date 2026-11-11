import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:singersinc/core/errors/app_exception.dart';

/// Metadados resultantes da cópia e processamento local de um arquivo importado.
class StoredLocalFile {
  const StoredLocalFile({
    required this.relativePath,
    required this.absolutePath,
    required this.fileSize,
    required this.checksumSha256,
  });

  final String relativePath;
  final String absolutePath;
  final int fileSize;
  final String checksumSha256;
}

/// Contrato para armazenamento de arquivos locais (PDF e MP3) no dispositivo.
abstract interface class LocalFileStorage {
  /// Copia um arquivo selecionado (ex.: cache do `file_picker`) para o diretório
  /// persistente do aplicativo e calcula seu checksum SHA-256 em stream.
  Future<StoredLocalFile> importFile({
    required String sourceFilePath,
    required String userId,
    required String songId,
    required String assetId,
    required String extension,
  });

  /// Salva bytes baixados da nuvem diretamente no diretório persistente local.
  Future<StoredLocalFile> saveDownloadedBytes({
    required List<int> bytes,
    required String userId,
    required String songId,
    required String assetId,
    required String extension,
  });

  /// Resolve um caminho relativo salvo no SQLite para o caminho absoluto atual do sistema.
  Future<String> resolveAbsolutePath(String relativePath);

  /// Verifica se o arquivo relativo existe fisicamente no armazenamento local.
  Future<bool> fileExists(String? relativePath);

  /// Remove todos os arquivos locais pertencentes a uma música.
  Future<void> deleteSongDirectory({
    required String userId,
    required String songId,
  });
}

/// Implementação padrão de [LocalFileStorage] utilizando `path_provider` e `crypto`.
class LocalFileStorageImpl implements LocalFileStorage {
  const LocalFileStorageImpl({
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _documentsDirectoryProvider = documentsDirectoryProvider;

  final Future<Directory> Function()? _documentsDirectoryProvider;

  Future<Directory> _getBaseDir() async {
    if (_documentsDirectoryProvider != null) {
      return _documentsDirectoryProvider();
    }
    return getApplicationDocumentsDirectory();
  }

  @override
  Future<StoredLocalFile> importFile({
    required String sourceFilePath,
    required String userId,
    required String songId,
    required String assetId,
    required String extension,
  }) async {
    try {
      final sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        throw const StorageFileException(
          'O arquivo selecionado não foi encontrado no dispositivo.',
        );
      }

      final cleanExt = extension.startsWith('.') ? extension : '.$extension';
      final relativePath = p.join(
        'singersinc_media',
        userId,
        songId,
        '$assetId$cleanExt',
      );

      final baseDir = await _getBaseDir();
      final targetPath = p.join(baseDir.path, relativePath);
      final targetDir = Directory(p.dirname(targetPath));

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final copiedFile = await sourceFile.copy(targetPath);
      final fileSize = await copiedFile.length();
      if (fileSize <= 0) {
        throw const StorageFileException('O arquivo importado está vazio.');
      }

      // Calcula SHA-256 em stream para não estourar a memória com PDFs/MP3s grandes
      final digest = await copiedFile.openRead().transform(sha256).first;

      return StoredLocalFile(
        relativePath: relativePath.replaceAll(r'\', '/'),
        absolutePath: copiedFile.path,
        fileSize: fileSize,
        checksumSha256: digest.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw StorageFileException(
        'Falha ao copiar o arquivo para o armazenamento local.',
        cause: e,
      );
    }
  }

  @override
  Future<StoredLocalFile> saveDownloadedBytes({
    required List<int> bytes,
    required String userId,
    required String songId,
    required String assetId,
    required String extension,
  }) async {
    try {
      if (bytes.isEmpty) {
        throw const StorageFileException('Arquivo baixado está vazio.');
      }

      final cleanExt = extension.startsWith('.') ? extension : '.$extension';
      final relativePath = p.join(
        'singersinc_media',
        userId,
        songId,
        '$assetId$cleanExt',
      );

      final baseDir = await _getBaseDir();
      final targetPath = p.join(baseDir.path, relativePath);
      final targetFile = File(targetPath);

      if (!await targetFile.parent.exists()) {
        await targetFile.parent.create(recursive: true);
      }

      await targetFile.writeAsBytes(bytes, flush: true);
      final digest = sha256.convert(bytes);

      return StoredLocalFile(
        relativePath: relativePath.replaceAll(r'\', '/'),
        absolutePath: targetFile.path,
        fileSize: bytes.length,
        checksumSha256: digest.toString(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw StorageFileException(
        'Falha ao salvar o arquivo baixado no dispositivo.',
        cause: e,
      );
    }
  }

  @override
  Future<String> resolveAbsolutePath(String relativePath) async {
    final baseDir = await _getBaseDir();
    final normalized = relativePath.replaceAll('/', p.separator);
    return p.join(baseDir.path, normalized);
  }

  @override
  Future<bool> fileExists(String? relativePath) async {
    if (relativePath == null || relativePath.trim().isEmpty) {
      return false;
    }
    try {
      final absPath = await resolveAbsolutePath(relativePath);
      return await File(absPath).exists();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> deleteSongDirectory({
    required String userId,
    required String songId,
  }) async {
    try {
      final baseDir = await _getBaseDir();
      final songDir = Directory(
        p.join(baseDir.path, 'singersinc_media', userId, songId),
      );
      if (await songDir.exists()) {
        await songDir.delete(recursive: true);
      }
    } catch (_) {
      // Ignora falha silenciosa de limpeza de diretório residual
    }
  }
}

final localFileStorageProvider = Provider<LocalFileStorage>((ref) {
  return const LocalFileStorageImpl();
});
