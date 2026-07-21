import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'database_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();

  factory BackupService() {
    return _instance;
  }

  BackupService._internal();

  Future<String> createBackup() async {
    try {
      final db = await DatabaseService().database;
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDocDir.path}/backups');

      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupFile = File('${backupDir.path}/backup_$timestamp.json');

      // Export all data
      final notes = await db.query('notes');
      final images = await db.query('images');
      final audio = await db.query('audio_recordings');
      final settings = await db.query('settings');

      final backupData = {
        'timestamp': timestamp,
        'version': 1,
        'notes': notes,
        'images': images,
        'audio': audio,
        'settings': settings,
      };

      await backupFile.writeAsString(jsonEncode(backupData));
      return backupFile.path;
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  Future<List<String>> getBackupList() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDocDir.path}/backups');

      if (!await backupDir.exists()) {
        return [];
      }

      final files = backupDir.listSync();
      final backupFiles = files
          .where((file) => file.path.endsWith('.json'))
          .map((file) => file.path)
          .toList();

      backupFiles.sort((a, b) => b.compareTo(a)); // Sort descending
      return backupFiles;
    } catch (e) {
      return [];
    }
  }

  Future<bool> restoreBackup(String backupPath) async {
    try {
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file not found');
      }

      final content = await backupFile.readAsString();
      final backupData = jsonDecode(content);

      final db = await DatabaseService().database;

      // Clear existing data
      await db.delete('notes');
      await db.delete('images');
      await db.delete('audio_recordings');
      await db.delete('settings');

      // Restore data
      for (var note in backupData['notes']) {
        await db.insert('notes', note);
      }

      for (var image in backupData['images']) {
        await db.insert('images', image);
      }

      for (var audio in backupData['audio']) {
        await db.insert('audio_recordings', audio);
      }

      for (var setting in backupData['settings']) {
        await db.insert('settings', setting);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }

  Future<void> deleteBackup(String backupPath) async {
    try {
      final file = File(backupPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete backup: $e');
    }
  }

  String formatBackupDate(String backupPath) {
    try {
      final fileName = backupPath.split('/').last;
      final timestamp = int.parse(fileName.replaceAll('backup_', '').replaceAll('.json', ''));
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
