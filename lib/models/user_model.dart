class UserModel {
  final String id;
  final String username;
  final String email;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.imageUrl,
  });

  /// Factory constructor to create a UserModel from Firestore JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  /// Convert UserModel to JSON for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  /// Optional: copyWith method to create updated copies
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
