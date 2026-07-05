import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/scan_record.dart';

class HistoryService {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/bali_waste_classifier_history.json';
    return File(path);
  }

  Future<List<ScanRecord>> loadHistory() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents) as List<dynamic>;
      return jsonList
          .map((json) => ScanRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // In case of error, default to empty list
      return [];
    }
  }

  Future<void> saveHistory(List<ScanRecord> history) async {
    try {
      final file = await _localFile;
      final jsonList = history.map((record) => record.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      // Fail silently or log
    }
  }
}
