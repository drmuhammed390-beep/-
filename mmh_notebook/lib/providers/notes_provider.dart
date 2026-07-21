import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/database_service.dart';

class NotesProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  Note? _currentNote;
  String _searchQuery = '';

  List<Note> get allNotes => _filteredNotes.isEmpty && _searchQuery.isEmpty
      ? _allNotes
      : _filteredNotes;
  Note? get currentNote => _currentNote;
  String get searchQuery => _searchQuery;

  Future<void> loadNotes() async {
    _allNotes = await _dbService.getAllNotes();
    notifyListeners();
  }

  Future<void> createNote(String title, String content) async {
    final stats = Note.calculateStats(content);
    final note = Note(
      title: title,
      content: content,
      wordCount: stats['words'] ?? 0,
      characterCount: stats['characters'] ?? 0,
      lineCount: stats['lines'] ?? 0,
    );

    await _dbService.insertNote(note);
    _allNotes.add(note);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    final stats = Note.calculateStats(note.content);
    final updatedNote = note.copyWith(
      updatedAt: DateTime.now(),
      wordCount: stats['words'] ?? 0,
      characterCount: stats['characters'] ?? 0,
      lineCount: stats['lines'] ?? 0,
    );

    await _dbService.updateNote(updatedNote);
    final index = _allNotes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _allNotes[index] = updatedNote;
    }
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _dbService.deleteNote(id);
    _allNotes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final note = _allNotes.firstWhere((n) => n.id == id);
    final updated = note.copyWith(isFavorite: !note.isFavorite);
    await updateNote(updated);
  }

  Future<void> togglePin(String id) async {
    final note = _allNotes.firstWhere((n) => n.id == id);
    final updated = note.copyWith(isPinned: !note.isPinned);
    await updateNote(updated);
  }

  Future<void> archiveNote(String id) async {
    final note = _allNotes.firstWhere((n) => n.id == id);
    final updated = note.copyWith(status: NoteStatus.archived);
    await updateNote(updated);
  }

  Future<void> lockNote(String id) async {
    final note = _allNotes.firstWhere((n) => n.id == id);
    final updated = note.copyWith(status: NoteStatus.locked);
    await updateNote(updated);
  }

  Future<void> restoreNote(String id) async {
    final note = _allNotes.firstWhere((n) => n.id == id);
    final updated = note.copyWith(status: NoteStatus.active);
    await updateNote(updated);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = await _dbService.searchNotes(query);
    }
    notifyListeners();
  }

  Future<List<Note>> getNotesByStatus(NoteStatus status) async {
    return await _dbService.getNotesByStatus(status);
  }

  Future<List<Note>> getFavoriteNotes() async {
    return await _dbService.getFavoriteNotes();
  }

  void setCurrentNote(Note? note) {
    _currentNote = note;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredNotes = [];
    notifyListeners();
  }
}
