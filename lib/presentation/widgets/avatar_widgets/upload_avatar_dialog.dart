import 'dart:typed_data';

import 'package:audavis_time_management/presentation/blocs/avatar_upload_cubit/avatar_upload_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadAvatarDialog extends StatefulWidget {
  final String colleagueId;
  final String? currentUrl;

  const UploadAvatarDialog({
    super.key,
    required this.colleagueId,
    this.currentUrl,
  });

  @override
  State<UploadAvatarDialog> createState() => _UploadAvatarDialogState();
}

class _UploadAvatarDialogState extends State<UploadAvatarDialog> {
  Uint8List? _bytes;
  String? _fileName;

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // wichtig für Web
    );
    if (res == null || res.files.isEmpty) return;

    final f = res.files.single;
    if (f.bytes == null) return;

    setState(() {
      _bytes = f.bytes!;
      _fileName = f.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AvatarUploadCubit, AvatarUploadState>(
      listener: (context, state) {
        if (state is AvatarUploadSuccess) {
          Navigator.of(context).pop(state.url); // return URL
        }
      },
      builder: (context, state) {
        final loading = state is AvatarUploadLoading;
        final error = state is AvatarUploadError ? state.message : null;

        return AlertDialog(
          title: const Text("Profilfoto hochladen"),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_bytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _bytes!,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (widget.currentUrl != null &&
                    widget.currentUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.currentUrl!,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: const Text("Kein Bild ausgewählt"),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: loading ? null : _pick,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text("Foto auswählen"),
                      ),
                    ),
                  ],
                ),
                if (_fileName != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ausgewählt: $_fileName",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.of(context).pop(),
              child: const Text("Abbrechen"),
            ),
            FilledButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (_bytes == null || _fileName == null) return;

                      await context.read<AvatarUploadCubit>().upload(
                        colleagueId: widget.colleagueId,
                        bytes: _bytes!,
                        fileName: _fileName!,
                      );
                    },
              child: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Hochladen"),
            ),
          ],
        );
      },
    );
  }
}
