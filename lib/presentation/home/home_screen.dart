import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/classification_result.dart';
import '../../models/scan_record.dart';
import '../../providers/classification_controller.dart';
import '../../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/camera_capture.dart';
import '../widgets/clay.dart';
import '../widgets/result_ticket.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final isClassifying = ref.watch(classificationControllerProvider).isLoading;
    final image = state.image;

    ref.listen(classificationControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (result) {
          final current = ref.read(homeProvider).image;
          if (result == null || current == null || previous?.isLoading != true) {
            return;
          }
          ref.read(historyProvider.notifier).addRecord(
                ScanRecord(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  timestamp: DateTime.now(),
                  imagePath: current.path,
                  result: result,
                ),
              );
          _showResultSheet(context, result);
        },
        error: (error, _) => _showErrorDialog(context, error),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Pindai sampah')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: image == null
              ? CameraCapture(
                  onCaptured: notifier.setImage,
                  onGallery: notifier.pickFromGallery,
                )
              : _Review(
                  imagePath: image.path,
                  isClassifying: isClassifying,
                  onClear: notifier.clearImage,
                  onContext: notifier.setContext,
                  onClassify: () => ref
                      .read(classificationControllerProvider.notifier)
                      .classify(File(image.path)),
                ),
        ),
      ),
    );
  }

  void _showResultSheet(BuildContext context, ClassificationResult result) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: ResultTicket(result: result),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, Object error) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasifikasi gagal'),
        content: Text(_humanizeError(error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  String _humanizeError(Object error) {
    if (error is SocketException) {
      return 'Koneksi internet bermasalah. Silakan periksa jaringan Anda.';
    }
    final message = error.toString();
    if (message.contains('TimeoutException')) {
      return 'Waktu koneksi habis saat mengunggah foto. '
          'Coba ulangi dengan jaringan yang lebih stabil.';
    }
    if (message.contains('Failed host lookup') ||
        message.contains('Network is unreachable') ||
        message.contains('SocketException')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }
    if (message.contains('ClientException') ||
        message.contains('connection abort') ||
        message.contains('Connection closed') ||
        message.contains('Broken pipe')) {
      return 'Koneksi terputus saat mengirim foto. '
          'Coba lagi dengan jaringan yang lebih stabil.';
    }
    if (message.contains('503') ||
        message.contains('high demand') ||
        message.contains('UNAVAILABLE')) {
      return 'Server AI sedang mengalami lonjakan beban tinggi. '
          'Silakan coba lagi beberapa saat.';
    }
    if (message.contains('401:') ||
        message.contains('403:') ||
        message.contains('invalid_api_key')) {
      return 'Kunci API Groq tidak valid. Silakan periksa file .env Anda.';
    }
    if (message.contains('model_not_found') ||
        message.contains('model_decommissioned')) {
      return 'Model AI yang dikonfigurasi tidak tersedia pada endpoint API.';
    }
    return 'Terjadi kesalahan: $message';
  }
}

class _Review extends StatelessWidget {
  const _Review({
    required this.imagePath,
    required this.isClassifying,
    required this.onClear,
    required this.onContext,
    required this.onClassify,
  });

  final String imagePath;
  final bool isClassifying;
  final VoidCallback onClear;
  final ValueChanged<String> onContext;
  final VoidCallback onClassify;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            ClaySurface(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: ClayCircleButton(
                icon: Icons.close_rounded,
                tooltip: 'Ambil ulang',
                size: 48,
                iconSize: 22,
                onPressed: isClassifying ? null : onClear,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: clayShadows(context, depth: 0.55),
          ),
          child: TextField(
            onChanged: onContext,
            maxLines: 1,
            decoration: const InputDecoration(
              labelText: 'Konteks tambahan',
              hintText: 'Opsional, misalnya: plastik kemasan dari pantai',
              prefixIcon: Icon(Icons.edit_note_rounded),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ClayButton(
          accent: true,
          onPressed: isClassifying ? null : onClassify,
          child: isClassifying
              ? const _AnalyzingLabel()
              : const Text('Mulai klasifikasi'),
        ),
      ],
    );
  }
}

class _AnalyzingLabel extends StatelessWidget {
  const _AnalyzingLabel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        SizedBox(width: 12),
        Text('Menganalisis jenis sampah'),
      ],
    );
  }
}
