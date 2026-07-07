import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../providers/history_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/localization.dart';
import '../theme/app_theme.dart';
import '../widgets/clay_container.dart';
import '../widgets/clay_button.dart';

/// Displays user profile information, scan statistics,
/// and app preferences.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final language = settingsAsync.value?.language ?? AppLanguage.id;
    final localizations = AppLocalizations(language);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.get('profil_saya'),
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
              children: [
                const _ProfileHeader(),
                const SizedBox(height: 24),
                historyAsync.when(
                  data: (records) => _StatsGrid(records: records),
                  loading: () => const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 28),
                const _PreferencesSection(),
                const SizedBox(height: 28),
                const _AppInfoSection(),
                const SizedBox(height: 32),
                ClayButton(
                  color: theme.colorScheme.errorContainer,
                  textColor: theme.colorScheme.onErrorContainer,
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        localizations.get('keluar'),
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader();

  Future<void> _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final nameController = TextEditingController(text: user.name);
    final wilayahController = TextEditingController(text: user.wilayah ?? '');
    String? selectedPhotoPath = user.photoUrl;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Edit Profil',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          setState(() {
                            selectedPhotoPath = image.path;
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                              image:
                                  selectedPhotoPath != null &&
                                      selectedPhotoPath!.isNotEmpty
                                  ? DecorationImage(
                                      image:
                                          selectedPhotoPath!.startsWith('http')
                                          ? NetworkImage(selectedPhotoPath!)
                                                as ImageProvider
                                          : FileImage(File(selectedPhotoPath!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child:
                                selectedPhotoPath == null ||
                                    selectedPhotoPath!.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 40,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: GoogleFonts.outfit(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: wilayahController,
                      decoration: InputDecoration(
                        labelText: 'Wilayah (Kecamatan/Kabupaten)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: GoogleFonts.outfit(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.outfit(color: theme.colorScheme.error),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    final newWilayah = wilayahController.text.trim();

                    if (newName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama tidak boleh kosong'),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);

                    try {
                      await ref
                          .read(authProvider.notifier)
                          .updateProfile(
                            name: newName,
                            photoUrl: selectedPhotoPath,
                            wilayah: newWilayah.isEmpty ? null : newWilayah,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profil berhasil diperbarui'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal memperbarui profil: $e'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Simpan', style: GoogleFonts.outfit()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(authProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        final photoUrl = user.photoUrl;

        final onPrimary = theme.colorScheme.onPrimary;
        return ClayContainer(
          borderRadius: 24,
          color: theme.colorScheme.primary.withAlpha(220),
          onTap: () => _showEditProfileDialog(context, ref, user),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha(100),
                      width: 2,
                    ),
                    image: photoUrl != null && photoUrl.isNotEmpty
                        ? DecorationImage(
                            image: photoUrl.startsWith('http')
                                ? NetworkImage(photoUrl) as ImageProvider
                                : FileImage(File(photoUrl)),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          )
                        : null,
                  ),
                  child: photoUrl == null || photoUrl.isEmpty
                      ? Icon(Icons.person_rounded, color: onPrimary, size: 36)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.name.isNotEmpty
                                  ? user.name
                                  : 'Warga Bali Hijau',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: onPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.edit_outlined,
                            color: onPrimary.withAlpha(200),
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.wilayah != null && user.wilayah!.isNotEmpty
                            ? 'Wilayah: ${user.wilayah}'
                            : 'Bersama menjaga Pulau Dewata 🌿',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: onPrimary.withAlpha(180),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 112,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            'Gagal memuat profil: $e',
            style: GoogleFonts.outfit(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends ConsumerWidget {
  final List<dynamic> records;

  const _StatsGrid({required this.records});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final binColors = theme.extension<BinColors>();
    final settingsAsync = ref.watch(settingsProvider);
    final language = settingsAsync.value?.language ?? AppLanguage.id;
    final localizations = AppLocalizations(language);

    final total = records.length;
    int organik = 0;
    int nonOrganik = 0;
    int residu = 0;

    for (final record in records) {
      final cat = record.result.category.toString().toLowerCase();
      if (cat == 'organik') {
        organik++;
      } else if (cat == 'non-organik') {
        nonOrganik++;
      } else {
        residu++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.get('statistik_pemilahan'),
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: localizations.get('total_scan'),
                value: total.toString(),
                icon: Icons.qr_code_scanner_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: localizations.get('organik'),
                value: organik.toString(),
                icon: Icons.eco_rounded,
                color: binColors?.organik ?? Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: localizations.get('non_organik'),
                value: nonOrganik.toString(),
                icon: Icons.recycling_rounded,
                color: binColors?.nonOrganik ?? Colors.amber,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: localizations.get('residu'),
                value: residu.toString(),
                icon: Icons.delete_rounded,
                color: binColors?.residu ?? Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClayContainer(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesSection extends ConsumerWidget {
  const _PreferencesSection();

  String _getThemeModeSubtitle(ThemeMode mode, AppLocalizations localizations) {
    switch (mode) {
      case ThemeMode.system:
        return localizations.get('mengikuti_sistem');
      case ThemeMode.light:
        return localizations.get('mode_terang');
      case ThemeMode.dark:
        return localizations.get('mode_gelap');
    }
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.settings_system_daydream_rounded;
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
  }

  void _showThemeSelector(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            localizations.get('mode_gelap'),
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: currentMode,
                title: Text(
                  localizations.get('mengikuti_sistem'),
                  style: GoogleFonts.outfit(),
                ),
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(settingsProvider.notifier).updateThemeMode(mode);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: currentMode,
                title: Text(
                  localizations.get('mode_terang'),
                  style: GoogleFonts.outfit(),
                ),
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(settingsProvider.notifier).updateThemeMode(mode);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: currentMode,
                title: Text(
                  localizations.get('mode_gelap'),
                  style: GoogleFonts.outfit(),
                ),
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(settingsProvider.notifier).updateThemeMode(mode);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    AppLanguage currentLang,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            localizations.get('bahasa'),
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((lang) {
              return RadioListTile<AppLanguage>(
                value: lang,
                groupValue: currentLang,
                title: Text(lang.name, style: GoogleFonts.outfit()),
                onChanged: (newLang) {
                  if (newLang != null) {
                    ref.read(settingsProvider.notifier).updateLanguage(newLang);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.value;
    final language = settings?.language ?? AppLanguage.id;
    final localizations = AppLocalizations(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.get('preferensi'),
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ClayContainer(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: 20,
          child: Column(
            children: [
              _PreferenceItem(
                icon: _getThemeModeIcon(
                  settings?.themeMode ?? ThemeMode.system,
                ),
                title: localizations.get('mode_gelap'),
                subtitle: _getThemeModeSubtitle(
                  settings?.themeMode ?? ThemeMode.system,
                  localizations,
                ),
                trailing: Icon(
                  Icons.settings_system_daydream_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showThemeSelector(
                  context,
                  ref,
                  settings?.themeMode ?? ThemeMode.system,
                  localizations,
                ),
              ),
              Divider(
                height: 1,
                indent: 56,
                color: theme.colorScheme.outlineVariant.withAlpha(50),
              ),
              _PreferenceItem(
                icon: Icons.language_rounded,
                title: localizations.get('bahasa'),
                subtitle: settings?.language.name ?? 'Indonesia',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () => _showLanguageSelector(
                  context,
                  ref,
                  settings?.language ?? AppLanguage.id,
                  localizations,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _PreferenceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _AppInfoSection extends ConsumerWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final language = settingsAsync.value?.language ?? AppLanguage.id;
    final localizations = AppLocalizations(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.get('tentang_aplikasi'),
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ClayContainer(
          padding: const EdgeInsets.all(20),
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: 20,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bali Waste Classifier',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${localizations.get('versi')} 1.0.0',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Aplikasi klasifikasi sampah berbasis AI '
                'untuk membantu warga Bali memilah sampah '
                'ke dalam tiga wadah: Organik, Non-Organik, '
                'dan Residu sesuai Pergub Bali No. 47/2019.',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
