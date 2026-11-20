import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/scan_record.dart';
import '../../providers/history_provider.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _searchQuery = '';
  String _activeFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Klasifikasi',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Hapus Semua',
            onPressed: () => _confirmClearHistory(context),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (records) {
          final filteredRecords = _filterRecords(records);
          
          return Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImpactStatsCard(records),
                _buildSearchAndFilters(theme),
                Expanded(
                  child: filteredRecords.isEmpty
                      ? _buildEmptyState(theme, records.isEmpty)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: filteredRecords.length,
                          itemBuilder: (context, index) {
                            return _buildHistoryItem(context, filteredRecords[index]);
                          },
                        ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Terjadi kesalahan memuat riwayat: $error'),
        ),
      ),
    );
  }

  List<ScanRecord> _filterRecords(List<ScanRecord> records) {
    return records.where((record) {
      final matchesSearch = record.result.subcategory
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _activeFilter == 'Semua' ||
          record.result.category.toLowerCase() == _activeFilter.toLowerCase();
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildImpactStatsCard(List<ScanRecord> records) {
    final theme = Theme.of(context);
    final totalScans = records.length;
    
    // Simple calculations for gamified ecological impact stats
    final organicCount = records.where((r) => r.result.category.toLowerCase() == 'organik').length;
    final nonOrganicCount = records.where((r) => r.result.category.toLowerCase() == 'non-organik').length;
    
    // Estimate: organic average weight 0.15kg, recyclables average count
    final estCompostKg = (organicCount * 0.15).toStringAsFixed(1);
    
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withAlpha(200),
            theme.colorScheme.secondary.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Dampak Lingkungan Anda',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatDetail(totalScans.toString(), 'Sampah Dipilah'),
              Container(width: 1, height: 32, color: Colors.white24),
              _buildStatDetail('${estCompostKg}kg', 'Potensi Kompos'),
              Container(width: 1, height: 32, color: Colors.white24),
              _buildStatDetail(nonOrganicCount.toString(), 'Didaur Ulang'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatDetail(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: GoogleFonts.outfit(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Cari sampah...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: ['Semua', 'Organik', 'Non-Organik', 'Residu'].map((filter) {
              final isSelected = _activeFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(
                    filter,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _activeFilter = filter;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isHistoryFullyEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isHistoryFullyEmpty
                    ? Icons.center_focus_weak_rounded
                    : Icons.search_off_rounded,
                size: 64,
                color: theme.colorScheme.primary.withAlpha(150),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isHistoryFullyEmpty
                  ? 'Belum Ada Pemindaian'
                  : 'Hasil Tidak Ditemukan',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isHistoryFullyEmpty
                  ? 'Mulai pindai foto sampah Anda di tab Pindai untuk melihat catatan riwayat di sini.'
                  : 'Cobalah mengubah kata kunci pencarian Anda atau ganti filter kategori.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, ScanRecord record) {
    final theme = Theme.of(context);
    final binColors = theme.extension<BinColors>();

    Color getCategoryColor() {
      if (binColors != null) {
        switch (record.result.category.toLowerCase()) {
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

    final catColor = getCategoryColor();
    final timeStr = _formatTimestamp(record.timestamp);

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24.0),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        ref.read(historyProvider.notifier).deleteRecord(record.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Catatan dihapus'),
            action: SnackBarAction(
              label: 'Batal',
              onPressed: () {
                ref.read(historyProvider.notifier).addRecord(record);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(40)),
          ),
          child: InkWell(
            onTap: () => _showRecordDetails(context, record),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(record.imagePath),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, _) {
                        return Container(
                          width: 64,
                          height: 64,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.image_not_supported_rounded, color: theme.colorScheme.onSurfaceVariant),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: catColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                record.result.category.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: catColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              timeStr,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          record.result.subcategory,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.thumb_up_alt_outlined, color: theme.colorScheme.onSurfaceVariant.withAlpha(120), size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Akurasi: ${(record.result.confidence * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      return '${dt.day} ${months[dt.month - 1]}';
    }
  }

  void _showRecordDetails(BuildContext context, ScanRecord record) {
    final theme = Theme.of(context);
    final binColors = theme.extension<BinColors>();

    Color getCategoryColor() {
      if (binColors != null) {
        switch (record.result.category.toLowerCase()) {
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

    final catColor = getCategoryColor();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(record.imagePath),
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, _) {
                          return Container(
                            height: 180,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.image_not_supported_rounded, color: theme.colorScheme.onSurfaceVariant, size: 48),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: catColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            record.result.category.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: catColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(record.result.confidence * 100).toStringAsFixed(0)}% Akurasi',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            color: catColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      record.result.subcategory,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(),
                    ),
                    Text(
                      'Langkah Pengelolaan:',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...record.result.instructions.map((step) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Icon(Icons.check_circle_outline, color: catColor, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  step,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.5,
                                    height: 1.4,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Semua Riwayat?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tindakan ini akan menghapus seluruh catatan klasifikasi sampah Anda secara permanen.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.outfit()),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearHistory();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Hapus', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
