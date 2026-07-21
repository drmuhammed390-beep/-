import 'package:uuid/uuid.dart';

class AudioRecording {
  final String id;
  final String name;
  final String filePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Duration duration;
  final int fileSize;
  final String? description;

  AudioRecording({
    String? id,
    required this.name,
    required this.filePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.duration = Duration.zero,
    this.fileSize = 0,
    this.description,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  AudioRecording copyWith({
    String? id,
    String? name,
    String? filePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    Duration? duration,
    int? fileSize,
    String? description,
  }) {
    return AudioRecording(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      duration: duration ?? this.duration,
      fileSize: fileSize ?? this.fileSize,
      description: description ?? this.description,
    );
  }

  String getDurationString() {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getFileSizeString() {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'duration': duration.inMilliseconds,
      'fileSize': fileSize,
      'description': description,
    };
  }

  factory AudioRecording.fromJson(Map<String, dynamic> json) {
    return AudioRecording(
      id: json['id'],
      name: json['name'],
      filePath: json['filePath'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      duration: Duration(milliseconds: json['duration'] ?? 0),
      fileSize: json['fileSize'] ?? 0,
      description: json['description'],
    );
  }
}
