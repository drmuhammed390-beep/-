import 'package:uuid/uuid.dart';

enum NoteStatus { active, archived, locked, deleted }
enum NoteColor { blue, green, yellow, red, purple, orange }

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NoteStatus status;
  final NoteColor color;
  final bool isPinned;
  final bool isFavorite;
  final List<String> tags;
  final List<String> attachmentPaths;
  final int wordCount;
  final int characterCount;
  final int lineCount;

  Note({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.status = NoteStatus.active,
    this.color = NoteColor.blue,
    this.isPinned = false,
    this.isFavorite = false,
    this.tags = const [],
    this.attachmentPaths = const [],
    this.wordCount = 0,
    this.characterCount = 0,
    this.lineCount = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Copy with method for immutability
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    NoteStatus? status,
    NoteColor? color,
    bool? isPinned,
    bool? isFavorite,
    List<String>? tags,
    List<String>? attachmentPaths,
    int? wordCount,
    int? characterCount,
    int? lineCount,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
      lineCount: lineCount ?? this.lineCount,
    );
  }

  // Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'color': color.toString().split('.').last,
      'isPinned': isPinned ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
      'tags': tags.join(','),
      'attachmentPaths': attachmentPaths.join(','),
      'wordCount': wordCount,
      'characterCount': characterCount,
      'lineCount': lineCount,
    };
  }

  // Create from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: NoteStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => NoteStatus.active,
      ),
      color: NoteColor.values.firstWhere(
        (e) => e.toString().split('.').last == json['color'],
        orElse: () => NoteColor.blue,
      ),
      isPinned: json['isPinned'] == 1,
      isFavorite: json['isFavorite'] == 1,
      tags: (json['tags'] as String).isEmpty
          ? []
          : (json['tags'] as String).split(','),
      attachmentPaths: (json['attachmentPaths'] as String).isEmpty
          ? []
          : (json['attachmentPaths'] as String).split(','),
      wordCount: json['wordCount'] ?? 0,
      characterCount: json['characterCount'] ?? 0,
      lineCount: json['lineCount'] ?? 0,
    );
  }

  // Calculate statistics
  static Map<String, int> calculateStats(String content) {
    final words = content.trim().split(RegExp(r'\s+'));
    final characters = content.length;
    final charactersNoSpaces = content.replaceAll(RegExp(r'\s'), '').length;
    final lines = content.split('\n').length;

    return {
      'words': words.isEmpty || (words.length == 1 && words[0].isEmpty)
          ? 0
          : words.length,
      'characters': characters,
      'charactersNoSpaces': charactersNoSpaces,
      'lines': lines,
    };
  }

  // Calculate reading time (average 200 words per minute)
  int getReadingTimeMinutes() {
    return (wordCount / 200).ceil();
  }
}
