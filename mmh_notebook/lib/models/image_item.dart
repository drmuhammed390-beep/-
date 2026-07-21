import 'package:uuid/uuid.dart';

enum ImageType { regular, gif, sticker }

class ImageItem {
  final String id;
  final String name;
  final String filePath;
  final ImageType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int fileSize;
  final String? description;

  ImageItem({
    String? id,
    required this.name,
    required this.filePath,
    this.type = ImageType.regular,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.fileSize = 0,
    this.description,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ImageItem copyWith({
    String? id,
    String? name,
    String? filePath,
    ImageType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? fileSize,
    String? description,
  }) {
    return ImageItem(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fileSize: fileSize ?? this.fileSize,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'fileSize': fileSize,
      'description': description,
    };
  }

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'],
      name: json['name'],
      filePath: json['filePath'],
      type: ImageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ImageType.regular,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      fileSize: json['fileSize'] ?? 0,
      description: json['description'],
    );
  }
}
