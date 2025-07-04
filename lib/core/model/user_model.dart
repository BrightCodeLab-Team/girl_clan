import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:girl_clan/core/constants/app_assets.dart';

class UserModel {
  final String? id;
  final String imageUrl;
  final String name;
  final String message;
  final DateTime? time;

  UserModel({
    this.id,
    required this.imageUrl,
    required this.name,
    required this.message,
    required this.time,
  });
  Map<String, dynamic> toJson() {
    return {
      //'id': currentUser?.uid ?? '',
      'id': id ?? '',
      'name': name ?? '',
      'time': time ?? '',
      'profileImageUrl': imageUrl ?? AppAssets().loginImage,
      'message': message ?? '',
    };
  }

  // Factory constructor to create an Event from a Map (useful for persistence)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '', // Optional: If Firestore stores 'id'

      name: json['name'].toString(),
      imageUrl: json['profileImageUrl'].toString(),
      message: json['message'].toString(),
      time: json['time'] != null ? (json['time'] as Timestamp).toDate() : null,
    );
  }
}
