import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/scan_record.dart';
import '../../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/clay.dart';
import '../widgets/result_ticket.dart';

const _filters = ['Semua', 'Organik', 'Non-Organik', 'Residu'];

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _query = '';
  String _filter = _filters.first;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClayCircleButton(
              icon: Icons.delete_sweep_outlined,
              tooltip: 'Hapus semua',
              size: 44,
              iconSize: 22,
              onPressed: () => _confirmClear(context),
            ),
          ),
        ],
      ),
      body: history.when(
        data: _buildContent,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Message(
          title: 'Riwayat gagal dimuat',
          body: 'Tutup lalu buka aplikasi lagi. Detail: $error',
        ),
      ),
    );
  }

  Widget _buildContent(List<ScanRecord> records) {
    if (records.isEmpty) {
      return const _Message(
        title: 'Belum ada pemindaian',
        body: 'Buka tab Pindai dan foto satu sampah. '
            'Hasilnya tersimpan di sini.',
      );
    }
    final visible = records.where(_matches).toList();

    return Column(
      children: [
        _FilterStrip(
          records: records,
          selected: _filter,
          onSelected: (value) => setState(() => _filter = value),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: clayShadows(context, depth: 0.55),
            ),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Cari jenis sampah',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const _Message(
                  title: 'Tidak ada yang cocok',
                  body: 'Ubah kata kunci atau pilih kategori Semua.',
                )
              : ListView.separated(
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 18),
                  itemBuilder: (context, index) => _HistoryTile(
                    record: visible[index],
                    onDelete: () => _delete(context, visible[index]),
                    onOpen: () => _openDetail(context, visible[index]),
                  ),
                ),
        ),
      ],
    );
  }

  bool _matches(ScanRecord record) {
    final inFilter = _filter == _filters.first ||
        record.result.category.toLowerCase() == _filter.toLowerCase();
    final inQuery = record.result.subcategory
        .toLowerCase()
        .contains(_query.toLowerCase());
    return inFilter && inQuery;
  }

  void _delete(BuildContext context, ScanRecord record) {
    ref.read(historyProvider.notifier).deleteRecord(record.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Catatan dihapus'),
        action: SnackBarAction(
          label: 'Batalkan',
          onPressed: () => ref.read(historyProvider.notifier).addRecord(record),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, ScanRecord record) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClaySurface(
                child: SizedBox(
                  height: 200,
                  child: _RecordImage(path: record.imagePath),
                ),
              ),
              const SizedBox(height: 24),
              ResultTicket(result: record.result),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus semua riwayat?'),
        content: const Text(
          'Seluruh catatan klasifikasi dihapus permanen dan tidak bisa '
          'dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearHistory();
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(88, 44),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _FilterStrip extends StatelessWidget {
  const _FilterStrip({
    required this.records,
    required this.selected,
    required this.onSelected,
  });

  final List<ScanRecord> records;
  final String selected;
  final ValueChanged<String> onSelected;

  int _count(String filter) {
    if (filter == _filters.first) return records.length;
    return records
        .where((r) => r.result.category.toLowerCase() == filter.toLowerCase())
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 18),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          return _FilterTile(
            label: filter,
            count: _count(filter),
            isSelected: filter == selected,
            onTap: () => onSelected(filter),
          );
        },
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  const _FilterTile({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label, $count catatan',
      child: ExcludeSemantics(
        child: ClaySurface(
          radius: AppRadius.pill,
          depth: isSelected ? 0.4 : 0.8,
          color: isSelected ? scheme.secondary : scheme.surfaceContainerLow,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? scheme.primary
                      : scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$count',
                  style: textTheme.labelMedium?.copyWith(
                    color: isSelected ? scheme.onPrimary : scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: isSelected ? scheme.onSecondary : scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.record,
    required this.onDelete,
    required this.onOpen,
  });

  final ScanRecord record;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent =
        theme.extension<BinColors>()!.forCategory(record.result.category);
    final percent = (record.result.confidence * 100).round();

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Icon(Icons.delete_outline_rounded, color: scheme.onError),
      ),
      child: ClaySurface(
        radius: AppRadius.medium,
        depth: 0.9,
        padding: const EdgeInsets.all(12),
        onTap: onOpen,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.small),
              child: SizedBox(
                width: 64,
                height: 64,
                child: _RecordImage(path: record.imagePath),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.result.category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    record.result.subcategory,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${_formatTimestamp(record.timestamp)} \u00b7 $percent%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${time.day} ${months[time.month - 1]}';
  }
}

class _RecordImage extends StatelessWidget {
  const _RecordImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => ColoredBox(
        color: scheme.surfaceContainerHigh,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
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
}
