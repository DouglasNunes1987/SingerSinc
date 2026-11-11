import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:singersinc/core/utils/validators.dart';

/// Dados preenchidos no modal de cadastro de nova música.
class CreateSongFormResult {
  const CreateSongFormResult({
    required this.title,
    required this.pdfPath,
    required this.audioPath,
  });

  final String title;
  final String pdfPath;
  final String audioPath;
}

/// Modal para cadastro de uma nova música com importação obrigatória de PDF e MP3.
class CreateSongDialog extends StatefulWidget {
  const CreateSongDialog({super.key});

  @override
  State<CreateSongDialog> createState() => _CreateSongDialogState();
}

class _CreateSongDialogState extends State<CreateSongDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _pdfPath;
  String? _audioPath;
  String? _fileValidationError;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    final selectedPath = result?.files.single.path;
    if (selectedPath != null) {
      setState(() {
        _pdfPath = selectedPath;
        _fileValidationError = null;
        if (_titleController.text.trim().isEmpty) {
          _titleController.text = p.basenameWithoutExtension(selectedPath);
        }
      });
    }
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp3'],
    );
    final selectedPath = result?.files.single.path;
    if (selectedPath != null) {
      setState(() {
        _audioPath = selectedPath;
        _fileValidationError = null;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_pdfPath == null || _pdfPath!.isEmpty) {
      setState(() {
        _fileValidationError = 'Selecione a partitura em formato PDF.';
      });
      return;
    }

    if (_audioPath == null || _audioPath!.isEmpty) {
      setState(() {
        _fileValidationError = 'Selecione o arquivo de áudio em formato MP3.';
      });
      return;
    }

    Navigator.of(context).pop(
      CreateSongFormResult(
        title: _titleController.text.trim(),
        pdfPath: _pdfPath!,
        audioPath: _audioPath!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Nova Música'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('create_song_title_field'),
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título da música',
                    prefixIcon: Icon(Icons.music_note_outlined),
                  ),
                  validator: Validators.validateSongTitle,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  key: const Key('pick_pdf_button'),
                  onPressed: _pickPdf,
                  icon: Icon(
                    _pdfPath != null
                        ? Icons.check_circle_rounded
                        : Icons.picture_as_pdf_outlined,
                  ),
                  label: Text(
                    _pdfPath != null
                        ? p.basename(_pdfPath!)
                        : 'Importar Partitura (.PDF)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('pick_audio_button'),
                  onPressed: _pickAudio,
                  icon: Icon(
                    _audioPath != null
                        ? Icons.check_circle_rounded
                        : Icons.audio_file_outlined,
                  ),
                  label: Text(
                    _audioPath != null
                        ? p.basename(_audioPath!)
                        : 'Importar Áudio (.MP3)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_fileValidationError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _fileValidationError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirm_create_song_button'),
          onPressed: _submit,
          style: FilledButton.styleFrom(minimumSize: const Size(120, 42)),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

/// Modal para editar o título de uma música existente.
class EditSongTitleDialog extends StatefulWidget {
  const EditSongTitleDialog({
    required this.initialTitle,
    super.key,
  });

  final String initialTitle;

  @override
  State<EditSongTitleDialog> createState() => _EditSongTitleDialogState();
}

class _EditSongTitleDialogState extends State<EditSongTitleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(_titleController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Título'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: const Key('edit_song_title_field'),
          controller: _titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Título da música',
          ),
          validator: Validators.validateSongTitle,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirm_edit_title_button'),
          onPressed: _submit,
          style: FilledButton.styleFrom(minimumSize: const Size(110, 42)),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

