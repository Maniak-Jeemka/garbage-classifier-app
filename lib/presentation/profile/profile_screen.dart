import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../theme/clay_decoration.dart';
import '../theme/custom_app_bar.dart';

/// Displays user profile information, scan statistics,
/// and app preferences.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profil Saya'),
      body: SafeArea(
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
                data: (records) =>
                    _StatsGrid(records: records),
                loading: () => SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.neonGreen,
                    ),
                  ),
                ),
                error: (_, _) =>
                    const SizedBox.shrink(),
              ),
              const SizedBox(height: 28),
              const _PreferencesSection(),
              const SizedBox(height: 28),
              const _AppInfoSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: ClayDecoration.elevated(
        color: AppTheme.neonGreen,
        brightness: brightness,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: ClayDecoration.circle(
              color: const Color(0xFF0A1F00)
                  .withAlpha(30),
              brightness: brightness,
              border: Border.all(
                color: const Color(0xFF0A1F00)
                    .withAlpha(50),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFF0A1F00),
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Warga Bali Hijau',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A1F00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bersama menjaga Pulau Dewata 🌿',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: const Color(0xFF0A1F00)
                        .withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Color(0xFF0A1F00)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur edit profil belum tersedia')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<dynamic> records;

  const _StatsGrid({required this.records});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final binColors = theme.extension<BinColors>();

    final total = records.length;
    int organik = 0;
    int nonOrganik = 0;
    int residu = 0;

    for (final record in records) {
      final cat = record.result.category
          .toString()
          .toLowerCase();
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
          'Statistik Pemilahan',
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
                label: 'Total Scan',
                value: total.toString(),
                icon: Icons.qr_code_scanner_rounded,
                color: AppTheme.neonGreen,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Organik',
                value: organik.toString(),
                icon: Icons.eco_rounded,
                color: binColors?.organik ??
                    Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Non-Organik',
                value: nonOrganik.toString(),
                icon: Icons.recycling_rounded,
                color: binColors?.nonOrganik ??
                    Colors.amber,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Residu',
                value: residu.toString(),
                icon: Icons.delete_rounded,
                color:
                    binColors?.residu ?? Colors.red,
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
    final brightness = theme.brightness;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ClayDecoration.card(
        color: theme.colorScheme.surfaceContainerLow,
        brightness: brightness,
        radius: 22,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: ClayDecoration.pill(
              color: color.withAlpha(25),
              brightness: brightness,
            ).copyWith(
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child:
                Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                    color: theme
                        .colorScheme.onSurfaceVariant,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferensi',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: ClayDecoration.card(
            color:
                theme.colorScheme.surfaceContainerLow,
            brightness: brightness,
            radius: 22,
          ),
          child: Column(
            children: [
              _PreferenceItem(
                icon: Icons.language_rounded,
                title: 'Bahasa',
                subtitle: 'Indonesia',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: theme
                      .colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengaturan bahasa belum tersedia')),
                  );
                },
              ),
              const Divider(height: 1, indent: 54),
              _PreferenceItem(
                icon: Icons.delete_sweep_rounded,
                title: 'Hapus Riwayat',
                subtitle: 'Hapus semua data pindaian',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: theme
                      .colorScheme.error,
                  size: 20,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Riwayat'),
                      content: const Text('Anda yakin ingin menghapus semua riwayat klasifikasi?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(historyProvider.notifier).clearHistory();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Riwayat berhasil dihapus')),
                            );
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
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
  final VoidCallback onTap;

  const _PreferenceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
          Icon(
            icon,
            color: AppTheme.neonGreen,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: theme
                        .colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
      ),
    );
  }
}

class _AppInfoSection extends StatelessWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Aplikasi',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: ClayDecoration.card(
            color:
                theme.colorScheme.surfaceContainerLow,
            brightness: brightness,
            radius: 22,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        ClayDecoration.button(
                      color: AppTheme.neonGreen,
                      brightness: brightness,
                    ).copyWith(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Color(0xFF0A1F00),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Re Resik',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Versi 1.0.0',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: theme.colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Aplikasi klasifikasi sampah berbasis '
                'AI untuk membantu warga Bali memilah '
                'sampah ke dalam tiga wadah: Organik, '
                'Non-Organik, dan Residu sesuai Pergub '
                'Bali No. 47/2019.',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  height: 1.5,
                  color: theme
                      .colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
