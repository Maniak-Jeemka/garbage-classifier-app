import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/scan_record.dart';
import '../services/history_service.dart';

part 'history_provider.g.dart';

@Riverpod(keepAlive: true)
class History extends _$History {
  final _service = HistoryService();

  @override
  FutureOr<List<ScanRecord>> build() async {
    return await _service.loadHistory();
  }

  Future<void> addRecord(ScanRecord record) async {
    final currentList = await future;
    final updatedList = [record, ...currentList];
    state = AsyncData(updatedList);
    await _service.saveHistory(updatedList);
  }

  Future<void> deleteRecord(String id) async {
    final currentList = await future;
    final updatedList = currentList.where((rec) => rec.id != id).toList();
    state = AsyncData(updatedList);
    await _service.saveHistory(updatedList);
  }

  Future<void> clearHistory() async {
    state = const AsyncData([]);
    await _service.saveHistory([]);
  }
}
