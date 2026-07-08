import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime? createdAt;
  final String? photoUrl;
  final String? wilayah;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.createdAt,
    this.photoUrl,
    this.wilayah,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      photoUrl: json['photoUrl'] as String?,
      wilayah: json['wilayah'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (wilayah != null) 'wilayah': wilayah,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? createdAt,
    String? photoUrl,
    String? wilayah,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      wilayah: wilayah ?? this.wilayah,
    );
  }
}
