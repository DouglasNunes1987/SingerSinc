import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/features/player/presentation/controllers/audio_playback_controller.dart';

/// Barra de controle de áudio (Play/Pause, Seekbar, Retroceder/Avançar e Velocidade).
class AudioControlBar extends ConsumerStatefulWidget {
  const AudioControlBar({super.key});

  @override
  ConsumerState<AudioControlBar> createState() => _AudioControlBarState();
}

class _AudioControlBarState extends ConsumerState<AudioControlBar> {
  double? _dragValue;

  String _formatDuration(int ms) {
    if (ms <= 0) return '00:00';
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static const List<double> _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioPlaybackControllerProvider);
    final controller = ref.read(audioPlaybackControllerProvider.notifier);
    final theme = Theme.of(context);

    final currentMs = _dragValue?.toInt() ?? state.positionMs;
    final totalMs = state.durationMs;
    final sliderMax = totalMs > 0 ? totalMs.toDouble() : 1.0;
    final sliderValue = currentMs.toDouble().clamp(0.0, sliderMax);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Linha com Slider de Tempo e Marcadores MM:SS
            Row(
              children: [
                Text(
                  _formatDuration(currentMs),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Expanded(
                  child: Slider(
                    key: const Key('audio_progress_slider'),
                    value: sliderValue,
                    min: 0.0,
                    max: sliderMax,
                    onChanged: (val) {
                      setState(() {
                        _dragValue = val;
                      });
                    },
                    onChangeEnd: (val) {
                      controller.seekTo(val.toInt());
                      setState(() {
                        _dragValue = null;
                      });
                    },
                  ),
                ),
                Text(
                  _formatDuration(totalMs),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),

            // Linha com os Controles de Reprodução e Velocidade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Seletor de Velocidade (0.5x .. 2.0x)
                PopupMenuButton<double>(
                  key: const Key('audio_speed_button'),
                  tooltip: 'Velocidade de reprodução',
                  initialValue: state.speed,
                  onSelected: controller.setSpeed,
                  itemBuilder: (context) => _speeds
                      .map(
                        (s) => PopupMenuItem(
                          value: s,
                          child: Text('${s}x'),
                        ),
                      )
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${state.speed}x',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                // Controles Centrais (Voltar 5s, Play/Pause, Avançar 5s)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('seek_backward_button'),
                      tooltip: 'Voltar 5 segundos',
                      icon: const Icon(Icons.replay_5_rounded),
                      iconSize: 28,
                      onPressed: state.isLoading
                          ? null
                          : () => controller.seekRelative(-5000),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      key: const Key('play_pause_button'),
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: state.isLoading ? null : controller.togglePlayPause,
                      child: state.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              state.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 28,
                            ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      key: const Key('seek_forward_button'),
                      tooltip: 'Avançar 5 segundos',
                      icon: const Icon(Icons.forward_5_rounded),
                      iconSize: 28,
                      onPressed: state.isLoading
                          ? null
                          : () => controller.seekRelative(5000),
                    ),
                  ],
                ),

                // Espaçador para balancear a linha
                const SizedBox(width: 48),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

