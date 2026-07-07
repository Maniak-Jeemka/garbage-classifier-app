import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scan_record.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _historyRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('history');
  }

  Future<List<ScanRecord>> loadHistory(String uid) async {
    try {
      final querySnapshot = await _historyRef(uid)
          .orderBy('timestamp', descending: true)
          .get()
          .timeout(const Duration(seconds: 5));

      return querySnapshot.docs
          .map((doc) => ScanRecord.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Return empty list or propagate the error depending on design
      return [];
    }
  }

  Future<void> addRecord(String uid, ScanRecord record) async {
    try {
      await _historyRef(
        uid,
      ).doc(record.id).set(record.toJson()).timeout(const Duration(seconds: 5));
    } catch (e) {
      throw Exception('Failed to save scan record: $e');
    }
  }

  Future<void> deleteRecord(String uid, String id) async {
    try {
      await _historyRef(
        uid,
      ).doc(id).delete().timeout(const Duration(seconds: 5));
    } catch (e) {
      throw Exception('Failed to delete scan record: $e');
    }
  }

  Future<void> clearHistory(String uid) async {
    try {
      final querySnapshot = await _historyRef(
        uid,
      ).get().timeout(const Duration(seconds: 5));

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit().timeout(const Duration(seconds: 5));
    } catch (e) {
      throw Exception('Failed to clear scan history: $e');
    }
  }
}
