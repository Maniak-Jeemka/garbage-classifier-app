import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/classification_result.dart';
import '../../models/scan_record.dart';
import '../../providers/classification_controller.dart';
import '../../providers/history_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/localization.dart';
import '../home/home_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/clay_container.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_feedback_dialog.dart';
import '../widgets/clay_text_field.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final classificationState = ref.watch(classificationControllerProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final language = settingsAsync.value?.language ?? AppLanguage.id;
    final localizations = AppLocalizations(language);
    final theme = Theme.of(context);

    // Listen to classification results and save to history
    ref.listen(classificationControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (result) {
          if (result != null &&
              state.image != null &&
              previous?.isLoading == true) {
            final record = ScanRecord(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              timestamp: DateTime.now(),
              imagePath: state.image!.path,
              result: result,
            );
            ref.read(historyProvider.notifier).addRecord(record);

            // Show a quick success popup, then the detailed result.
            ClayFeedbackDialog.showSuccess(
              context,
              title: 'Klasifikasi Berhasil! ✨',
              message:
                  '${result.subcategory} terdeteksi sebagai ${result.category}.',
              autoDismiss: const Duration(milliseconds: 1500),
            ).then((_) {
              if (context.mounted) {
                _showResultPopup(context, result);
              }
            });
          }
        },
        error: (error, stack) {
          ClayFeedbackDialog.showError(
            context,
            title: 'Klasifikasi Gagal',
            message: _humanizeError(error),
          );
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          localizations.get('pindai_sampah'),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withAlpha(100),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPhotoArea(context, state, notifier, localizations),
                const SizedBox(height: 24),
                _buildContextField(context, notifier, localizations),
                const SizedBox(height: 24),
                _buildClassifyButton(context, state, ref, localizations),

                // Display loading state only
                classificationState.when(
                  data: (_) => const SizedBox.shrink(),
                  loading: () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(localizations.get('menganalisis_sampah')),
                        ],
                      ),
                    ),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea(
    BuildContext context,
    HomeState state,
    Home notifier,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);

    if (state.image != null) {
      return ClayContainer(
        height: 280,
        borderRadius: 28,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(state.image!.path), fit: BoxFit.cover),
            Positioned(
              top: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      notifier.clearImage();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ClayContainer(
      height: 280,
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_rounded,
            size: 64,
            color: theme.colorScheme.primary.withAlpha(180),
          ),
          const SizedBox(height: 12),
          Text(
            localizations.get('ambil_atau_pilih_foto_sampah'),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.get('ai_klasifikasi_deskripsi'),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSourceCardButton(
                context,
                icon: Icons.camera_alt_rounded,
                label: localizations.get('kamera'),
                onTap: notifier.takePicture,
              ),
              _buildSourceCardButton(
                context,
                icon: Icons.photo_library_rounded,
                label: localizations.get('galeri'),
                onTap: notifier.pickFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCardButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ClayButton(
      width: 110,
      height: 75,
      borderRadius: 16,
      color: theme.colorScheme.primary.withAlpha(30),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextField(
    BuildContext context,
    Home notifier,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.get('konteks_tambahan'),
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ClayTextField(
          onChanged: notifier.setContext,
          maxLines: 2,
          hintText: localizations.get('konteks_hint'),
        ),
      ],
    );
  }

  Widget _buildClassifyButton(
    BuildContext context,
    HomeState state,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);
    final classificationState = ref.watch(classificationControllerProvider);
    final isLoading = classificationState.isLoading || state.isLoading;
    final hasImage = state.image != null;

    return ClayButton(
      isEnabled: hasImage,
      isLoading: isLoading,
      color: theme.colorScheme.primary,
      borderRadius: 18,
      onPressed: () => ref
          .read(classificationControllerProvider.notifier)
          .classify(File(state.image!.path)),
      child: Text(
        localizations.get('mulai_klasifikasi'),
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: hasImage
              ? (theme.brightness == Brightness.dark
                    ? Colors.black87
                    : Colors.white)
              : theme.colorScheme.onSurfaceVariant.withAlpha(150),
        ),
      ),
    );
  }


  String _humanizeError(Object error) {
    if (error is SocketException) {
      return "Koneksi internet bermasalah. Silakan periksa jaringan Anda.";
    }
    return "Terjadi kesalahan: ${error.toString()}";
  }

  void _showResultPopup(BuildContext context, ClassificationResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 24,
          left: 16,
          right: 16,
          top: 32,
        ),
        child: InlineResultCard(result: result),
      ),
    );
  }
}

class InlineResultCard extends StatelessWidget {
  final ClassificationResult result;

  const InlineResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final binColors = theme.extension<BinColors>();

    Color getCategoryColor() {
      if (binColors != null) {
        switch (result.category.toLowerCase()) {
          case 'organik':
            return binColors.organik;
          case 'non-organik':
            return binColors.nonOrganik;
          case 'residu':
            return binColors.residu;
        }
      }
      return theme.colorScheme.primary;
    }

    String getCategoryTitle() {
      switch (result.category.toLowerCase()) {
        case 'organik':
          return 'WADAH HIJAU (ORGANIK)';
        case 'non-organik':
          return 'WADAH KUNING (NON-ORGANIK)';
        case 'residu':
          return 'WADAH MERAH/ABU-ABU (RESIDU)';
        default:
          return result.category.toUpperCase();
      }
    }

    final catColor = getCategoryColor();

    return ClayContainer(
      borderRadius: 24,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: catColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: catColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getCategoryTitle(),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: catColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.subcategory,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(result.confidence * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: catColor,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Text(
              'Instruksi Pembuangan:',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            ...result.instructions.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: catColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        step,
                        style: GoogleFonts.outfit(
                          fontSize: 13.5,
                          height: 1.4,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
