import 'package:flutter/material.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';

/// Card que representa uma música na Biblioteca do professor, exibindo:
/// - Título e metadados (duração do áudio, revisão de PDF/MP3)
/// - Badge de Disponibilidade Offline
/// - Badge de Status de Sincronização com a Nuvem (Sincronizado / Pendente / Conflito)
/// - Ações de editar título, substituir PDF/MP3 e excluir
class SongCardWidget extends StatelessWidget {
  const SongCardWidget({
    required this.item,
    required this.onEditTitle,
    required this.onReplacePdf,
    required this.onReplaceAudio,
    required this.onDelete,
    this.onTap,
    super.key,
  });

  final SongLibraryItem item;
  final VoidCallback onEditTitle;
  final VoidCallback onReplacePdf;
  final VoidCallback onReplaceAudio;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  String _formatDuration(int? durationMs) {
    if (durationMs == null || durationMs <= 0) return '--:--';
    final totalSeconds = durationMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 KB';
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(0)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final durationLabel =
        _formatDuration(item.activeSyncVersion?.audioDurationMs);
    final pdfRev = item.activePdfAsset?.revision ?? 1;
    final audioRev = item.activeAudioAsset?.revision ?? 1;
    final totalBytes = (item.activePdfAsset?.fileSize ?? 0) +
        (item.activeAudioAsset?.fileSize ?? 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.music_note_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Duração: $durationLabel • ${_formatFileSize(totalBytes)} • PDF v$pdfRev / MP3 v$audioRev',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    key: Key('song_menu_${item.id}'),
                    tooltip: 'Opções da música',
                    onSelected: (value) {
                      switch (value) {
                        case 'edit_title':
                          onEditTitle();
                        case 'replace_pdf':
                          onReplacePdf();
                        case 'replace_audio':
                          onReplaceAudio();
                        case 'delete':
                          onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit_title',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Editar título'),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'replace_pdf',
                        child: ListTile(
                          leading: Icon(Icons.picture_as_pdf_outlined),
                          title: Text('Substituir partitura PDF'),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'replace_audio',
                        child: ListTile(
                          leading: Icon(Icons.audio_file_outlined),
                          title: Text('Substituir áudio MP3'),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                          ),
                          title: Text(
                            'Excluir música',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // 1. Indicador de disponibilidade offline
                  _StatusBadge(
                    icon: item.isAvailableOffline
                        ? Icons.offline_pin_rounded
                        : Icons.cloud_download_outlined,
                    label: item.isAvailableOffline
                        ? 'Disponível offline'
                        : 'Download pendente',
                    backgroundColor: item.isAvailableOffline
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    foregroundColor: item.isAvailableOffline
                        ? const Color(0xFF166534)
                        : const Color(0xFF991B1B),
                  ),

                  // 2. Indicador de sincronização com a nuvem
                  if (item.hasConflict)
                    const _StatusBadge(
                      icon: Icons.warning_amber_rounded,
                      label: 'Conflito de versão',
                      backgroundColor: Color(0xFFFEE2E2),
                      foregroundColor: Color(0xFF991B1B),
                    )
                  else if (item.hasPendingCloudSync)
                    const _StatusBadge(
                      icon: Icons.cloud_upload_outlined,
                      label: 'Pendente de nuvem',
                      backgroundColor: Color(0xFFFEF3C7),
                      foregroundColor: Color(0xFF92400E),
                    )
                  else
                    const _StatusBadge(
                      icon: Icons.cloud_done_outlined,
                      label: 'Sincronizado na nuvem',
                      backgroundColor: Color(0xFFDBEAFE),
                      foregroundColor: Color(0xFF1E40AF),
                    ),

                  // 3. Indicador de compassos mapeados
                  _StatusBadge(
                    icon: Icons.grid_view_rounded,
                    label:
                        '${item.syncedMeasuresCount}/${item.measuresCount} compassos',
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

