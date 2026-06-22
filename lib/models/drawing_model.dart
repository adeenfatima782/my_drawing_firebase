import 'package:cloud_firestore/cloud_firestore.dart';

class DrawingModel {
  final String id;
  final String ownerId;
  final String imageUrl;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  DrawingModel({
    required this.id,
    required this.ownerId,
    required this.imageUrl,
    required this.createdAt,
    this.metadata,
  });

  factory DrawingModel.fromJson(String id, Map<String, dynamic> json) {
    return DrawingModel(
      id: id,
      ownerId: json['ownerId'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'ownerId': ownerId,
    'imageUrl': imageUrl,
    'createdAt': createdAt,
    'metadata': metadata ?? {},
  };

  DrawingModel copyWith({
    String? id,
    String? ownerId,
    String? imageUrl,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return DrawingModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
