import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/classification_result.dart';
import '../../models/scan_record.dart';
import '../../providers/classification_controller.dart';
import '../../providers/history_provider.dart';
import '../home/home_provider.dart';
import '../theme/app_theme.dart';
import '../theme/clay_decoration.dart';
import '../theme/custom_app_bar.dart';

/// Scan screen where users capture/pick a photo and
/// classify waste using Gemini AI.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final classificationState =
        ref.watch(classificationControllerProvider);
    final theme = Theme.of(context);

    // Listen to classification results and save to history
    ref.listen(classificationControllerProvider,
        (previous, next) {
      next.whenOrNull(
        data: (result) {
          if (result != null &&
              state.image != null &&
              previous?.isLoading == true) {
            final record = ScanRecord(
              id: DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(),
              timestamp: DateTime.now(),
              imagePath: state.image!.path,
              result: result,
            );
            ref
                .read(historyProvider.notifier)
                .addRecord(record);

            _showResultPopup(context, result);
          }
        },
        error: (error, stack) {
          _showErrorDialog(context, error);
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Pindai Sampah'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              _buildPhotoArea(context, state, notifier),
              const SizedBox(height: 24),
              _buildContextField(context, notifier),
              const SizedBox(height: 24),
              _buildClassifyButton(context, state, ref),

              // Display loading state only
              classificationState.when(
                data: (_) => const SizedBox.shrink(),
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.neonGreen,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Menganalisis jenis sampah...',
                          style: GoogleFonts.outfit(),
                        ),
                      ],
                    ),
                  ),
                ),
                error: (_, _) =>
                    const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea(
    BuildContext context,
    HomeState state,
    Home notifier,
  ) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    if (state.image != null) {
      return Container(
        height: 280,
        decoration: ClayDecoration.elevated(
          color: theme.colorScheme.surfaceContainerLow,
          brightness: brightness,
        ).copyWith(
          image: DecorationImage(
            image: FileImage(File(state.image!.path)),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: ClayDecoration.pill(
                  color: Colors.black54,
                  brightness: brightness,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: notifier.clearImage,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      decoration: ClayDecoration.card(
        color: theme.colorScheme.surfaceContainerLow,
        brightness: brightness,
        radius: 28,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_rounded,
            size: 64,
            color: AppTheme.neonGreen.withAlpha(180),
          ),
          const SizedBox(height: 12),
          Text(
            'Ambil atau Pilih Foto Sampah',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI akan mengklasifikasikan sampah '
            'ke wadah yang tepat',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              _buildSourceCardButton(
                context,
                icon: Icons.camera_alt_rounded,
                label: 'Kamera',
                onTap: notifier.takePicture,
              ),
              _buildSourceCardButton(
                context,
                icon: Icons.photo_library_rounded,
                label: 'Galeri',
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
    final brightness = theme.brightness;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: ClayDecoration.button(
          color: AppTheme.neonGreen.withAlpha(25),
          brightness: brightness,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.neonGreen,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.neonGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextField(
    BuildContext context,
    Home notifier,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konteks Tambahan (Opsional)',
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: ClayDecoration.input(
            color:
                theme.colorScheme.surfaceContainerLow,
            brightness: theme.brightness,
          ),
          child: TextField(
            onChanged: notifier.setContext,
            maxLines: 2,
            style: GoogleFonts.outfit(fontSize: 14),
            decoration: InputDecoration(
              hintText:
                  'Misalnya: "Saya menemukan plastik '
                  'kemasan ini di pantai"',
              filled: false,
              hintStyle: GoogleFonts.outfit(
                color: theme
                    .colorScheme.onSurfaceVariant
                    .withAlpha(150),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassifyButton(
    BuildContext context,
    HomeState state,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final classificationState =
        ref.watch(classificationControllerProvider);
    final isLoading =
        classificationState.isLoading || state.isLoading;
    final hasImage = state.image != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      decoration: hasImage && !isLoading
          ? ClayDecoration.button(
              color: AppTheme.neonGreen,
              brightness: theme.brightness,
            )
          : ClayDecoration.card(
              color: theme
                  .colorScheme.surfaceContainerHighest,
              brightness: theme.brightness,
              radius: 20,
            ),
      child: ElevatedButton(
        onPressed: (!hasImage || isLoading)
            ? null
            : () => ref
                .read(
                  classificationControllerProvider
                      .notifier,
                )
                .classify(File(state.image!.path)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          isLoading ? 'Menganalisis...' : 'Mulai Klasifikasi',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: (hasImage && !isLoading)
                ? const Color(0xFF0A1F00)
                : theme
                    .colorScheme.onSurfaceVariant
                    .withAlpha(150),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(
    BuildContext context,
    Object error,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color:
                  Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(
          _humanizeError(error),
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _humanizeError(Object error) {
    if (error is SocketException) {
      return 'Koneksi internet bermasalah. '
          'Silakan periksa jaringan Anda.';
    }
    return 'Terjadi kesalahan: ${error.toString()}';
  }

  void _showResultPopup(
    BuildContext context,
    ClassificationResult result,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).padding.bottom + 24,
          left: 16,
          right: 16,
          top: 32,
        ),
        child: InlineResultCard(result: result),
      ),
    );
  }
}

/// Claymorphism-styled classification result card.
class InlineResultCard extends StatelessWidget {
  final ClassificationResult result;

  const InlineResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
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
      return AppTheme.neonGreen;
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

    return Container(
      decoration: ClayDecoration.elevated(
        color: theme.colorScheme.surfaceContainerLow,
        brightness: brightness,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: ClayDecoration.pill(
                    color: catColor.withAlpha(30),
                    brightness: brightness,
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
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
                  decoration: ClayDecoration.pill(
                    color: catColor.withAlpha(20),
                    brightness: brightness,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant
                    .withAlpha(60),
              ),
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
                padding:
                    const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                      ),
                      child: Icon(
                        Icons
                            .check_circle_outline_rounded,
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
                          color: theme
                              .colorScheme.onSurface,
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
