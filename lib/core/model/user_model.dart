import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? imageUrl;
  final String? name;
  final String? message;
  final DateTime? time;
  final int unreadCount;

  UserModel({
    this.id,
    this.imageUrl,
    this.name,
    this.message,
    this.time,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name ?? '',
      'time': time ?? '',
      'imgUrl': imageUrl ?? '',
      'message': message ?? '',
      'unreadCount': unreadCount,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imgUrl']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      time: json['time'] != null ? (json['time'] as Timestamp).toDate() : null,
      unreadCount: _parseUnread(json['unreadCount']),
    );
  }

  static int _parseUnread(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
