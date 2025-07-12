import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? imageUrl;
  final String? name;
  final String? message;
  final DateTime? time;

  UserModel({this.id, this.imageUrl, this.name, this.message, this.time});
  Map<String, dynamic> toJson() {
    return {
      //'id': currentUser?.uid ?? '',
      'id': id ?? '',
      'name': name ?? '',
      'time': time ?? '',
      'profileImageUrl': imageUrl ?? '',
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
