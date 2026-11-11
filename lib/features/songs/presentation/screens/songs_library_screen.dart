import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/config/env_config.dart';
import 'package:singersinc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/presentation/controllers/songs_controller.dart';
import 'package:singersinc/features/songs/presentation/screens/song_form_dialog.dart';
import 'package:singersinc/features/songs/presentation/widgets/song_card_widget.dart';
import 'package:singersinc/shared/widgets/app_error_banner.dart';
import 'package:singersinc/shared/widgets/app_loading_overlay.dart';

/// Tela principal da Biblioteca de Músicas (Etapa 2).
class SongsLibraryScreen extends ConsumerWidget {
  const SongsLibraryScreen({super.key});

  Future<void> _openCreateSongDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final result = await showDialog<CreateSongFormResult>(
      context: context,
      builder: (_) => const CreateSongDialog(),
    );

    if (result != null) {
      await ref.read(songsControllerProvider.notifier).createSong(
            title: result.title,
            pdfSourcePath: result.pdfPath,
            audioSourcePath: result.audioPath,
          );
    }
  }

  Future<void> _openEditTitleDialog(
    BuildContext context,
    WidgetRef ref,
    SongLibraryItem item,
  ) async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) => EditSongTitleDialog(initialTitle: item.title),
    );

    if (newTitle != null && newTitle != item.title) {
      await ref.read(songsControllerProvider.notifier).updateTitle(
            songId: item.id,
            newTitle: newTitle,
          );
    }
  }

  Future<void> _replaceAsset(
    BuildContext context,
    WidgetRef ref,
    SongLibraryItem item,
    AssetType assetType,
  ) async {
    final ext = assetType == AssetType.pdf ? 'pdf' : 'mp3';
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [ext],
    );
    final selectedPath = picked?.files.single.path;
    if (selectedPath == null) return;

    await ref.read(songsControllerProvider.notifier).replaceAsset(
          songId: item.id,
          assetType: assetType,
          newSourceFilePath: selectedPath,
        );
  }

  Future<void> _confirmDeleteSong(
    BuildContext context,
    WidgetRef ref,
    SongLibraryItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir música?'),
        content: Text(
          'Tem certeza que deseja excluir "${item.title}"? Os arquivos locais e sincronizações serão removidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              minimumSize: const Size(110, 42),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(songsControllerProvider.notifier).deleteSong(item.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(userSongsStreamProvider);
    final actionState = ref.watch(songsControllerProvider);
    final theme = Theme.of(context);

    ref.listen<SongsActionState>(songsControllerProvider, (previous, next) {
      if (next.successMessage != null &&
          next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Biblioteca de Músicas'),
            if (EnvConfig.bypassAuth)
              Text(
                'Modo Local (Autenticação Oculta)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('sync_now_button'),
            tooltip: 'Sincronizar com a nuvem agora',
            onPressed: actionState.isSyncing
                ? null
                : () {
                    ref.read(songsControllerProvider.notifier).syncNow();
                  },
            icon: actionState.isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded),
          ),
          if (!EnvConfig.bypassAuth)
            IconButton(
              key: const Key('logout_button'),
              tooltip: 'Sair da conta',
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_song_fab'),
        onPressed: () => _openCreateSongDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova Música'),
      ),
      body: AppLoadingOverlay(
        isLoading: actionState.isBusy,
        message: 'Processando arquivos localmente...',
        child: SafeArea(
          child: Column(
            children: [
              if (actionState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: AppErrorBanner(
                    message: actionState.errorMessage!,
                    onRetry: () {
                      ref
                          .read(songsControllerProvider.notifier)
                          .clearMessages();
                    },
                  ),
                ),
              Expanded(
                child: songsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: AppErrorBanner(
                        message:
                            'Erro ao carregar biblioteca local: $err',
                      ),
                    ),
                  ),
                  data: (songs) {
                    if (songs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_music_outlined,
                                size: 72,
                                color: theme.colorScheme.outline,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma música cadastrada',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toque em "Nova Música" para importar uma partitura em PDF e seu respectivo áudio MP3.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final item = songs[index];
                        return SongCardWidget(
                          item: item,
                          onEditTitle: () =>
                              _openEditTitleDialog(context, ref, item),
                          onReplacePdf: () => _replaceAsset(
                            context,
                            ref,
                            item,
                            AssetType.pdf,
                          ),
                          onReplaceAudio: () => _replaceAsset(
                            context,
                            ref,
                            item,
                            AssetType.audio,
                          ),
                          onDelete: () =>
                              _confirmDeleteSong(context, ref, item),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

