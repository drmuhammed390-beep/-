import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/index.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'mmh_notebook.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Notes table
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        status TEXT NOT NULL,
        color TEXT NOT NULL,
        isPinned INTEGER NOT NULL DEFAULT 0,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        tags TEXT,
        attachmentPaths TEXT,
        wordCount INTEGER DEFAULT 0,
        characterCount INTEGER DEFAULT 0,
        lineCount INTEGER DEFAULT 0
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_notes_status ON notes(status)');
    await db.execute('CREATE INDEX idx_notes_isPinned ON notes(isPinned)');
    await db.execute('CREATE INDEX idx_notes_isFavorite ON notes(isFavorite)');
    await db.execute('CREATE INDEX idx_notes_createdAt ON notes(createdAt)');
    await db.execute('CREATE INDEX idx_notes_updatedAt ON notes(updatedAt)');

    // Images table
    await db.execute('''
      CREATE TABLE images (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        filePath TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        fileSize INTEGER DEFAULT 0,
        description TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_images_type ON images(type)');
    await db.execute('CREATE INDEX idx_images_createdAt ON images(createdAt)');

    // Audio recordings table
    await db.execute('''
      CREATE TABLE audio_recordings (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        filePath TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        duration INTEGER DEFAULT 0,
        fileSize INTEGER DEFAULT 0,
        description TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_audio_createdAt ON audio_recordings(createdAt)');

    // Settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // Notes operations
  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toJson());
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<Note?> getNote(String id) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Note.fromJson(result.first);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'isPinned DESC, updatedAt DESC');
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> getNotesByStatus(NoteStatus status) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'status = ?',
      whereArgs: [status.toString().split('.').last],
      orderBy: 'isPinned DESC, updatedAt DESC',
    );
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> getFavoriteNotes() async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'isFavorite = 1',
      orderBy: 'isPinned DESC, updatedAt DESC',
    );
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'isPinned DESC, updatedAt DESC',
    );
    return result.map((json) => Note.fromJson(json)).toList();
  }

  // Images operations
  Future<void> insertImage(ImageItem image) async {
    final db = await database;
    await db.insert('images', image.toJson());
  }

  Future<void> updateImage(ImageItem image) async {
    final db = await database;
    await db.update(
      'images',
      image.toJson(),
      where: 'id = ?',
      whereArgs: [image.id],
    );
  }

  Future<void> deleteImage(String id) async {
    final db = await database;
    await db.delete('images', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ImageItem>> getAllImages() async {
    final db = await database;
    final result = await db.query('images', orderBy: 'createdAt DESC');
    return result.map((json) => ImageItem.fromJson(json)).toList();
  }

  Future<List<ImageItem>> getImagesByType(ImageType type) async {
    final db = await database;
    final result = await db.query(
      'images',
      where: 'type = ?',
      whereArgs: [type.toString().split('.').last],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => ImageItem.fromJson(json)).toList();
  }

  // Audio operations
  Future<void> insertAudio(AudioRecording audio) async {
    final db = await database;
    await db.insert('audio_recordings', audio.toJson());
  }

  Future<void> updateAudio(AudioRecording audio) async {
    final db = await database;
    await db.update(
      'audio_recordings',
      audio.toJson(),
      where: 'id = ?',
      whereArgs: [audio.id],
    );
  }

  Future<void> deleteAudio(String id) async {
    final db = await database;
    await db.delete('audio_recordings', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<AudioRecording>> getAllAudio() async {
    final db = await database;
    final result = await db.query('audio_recordings', orderBy: 'createdAt DESC');
    return result.map((json) => AudioRecording.fromJson(json)).toList();
  }

  // Settings operations
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
