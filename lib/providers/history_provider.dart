import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/scan_record.dart';
import '../services/history_service.dart';
import 'auth_provider.dart';

part 'history_provider.g.dart';

@riverpod
class History extends _$History {
  final _service = HistoryService();

  @override
  FutureOr<List<ScanRecord>> build() async {
    final user = await ref.watch(authStateChangesProvider.future);
    if (user == null) {
      return [];
    }
    return await _service.loadHistory(user.uid);
  }

  Future<void> addRecord(ScanRecord record) async {
    final user = await ref.read(authStateChangesProvider.future);
    if (user == null) {
      throw Exception('User must be logged in to save scan record');
    }

    final currentList = state.value ?? [];
    final updatedList = [record, ...currentList];
    state = AsyncData(updatedList);

    try {
      await _service.addRecord(user.uid, record);
    } catch (e) {
      if (ref.mounted) {
        state = AsyncData(currentList);
      }
      rethrow;
    }
  }

  Future<void> deleteRecord(String id) async {
    final user = await ref.read(authStateChangesProvider.future);
    if (user == null) {
      throw Exception('User must be logged in to delete scan record');
    }

    final currentList = state.value ?? [];
    final updatedList = currentList.where((rec) => rec.id != id).toList();
    state = AsyncData(updatedList);

    try {
      await _service.deleteRecord(user.uid, id);
    } catch (e) {
      if (ref.mounted) {
        state = AsyncData(currentList);
      }
      rethrow;
    }
  }

  Future<void> clearHistory() async {
    final user = await ref.read(authStateChangesProvider.future);
    if (user == null) {
      throw Exception('User must be logged in to clear scan history');
    }

    final currentList = state.value ?? [];
    state = const AsyncData([]);

    try {
      await _service.clearHistory(user.uid);
    } catch (e) {
      if (ref.mounted) {
        state = AsyncData(currentList);
      }
      rethrow;
    }
  }
}
