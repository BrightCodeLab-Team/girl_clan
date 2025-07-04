import 'package:girl_clan/core/constants/app_assets.dart';

class EventModel {
  String? id;
  String? eventName;
  String? location;
  String? date;
  String? startTime;
  String? category;
  String? imageUrl;
  String? joiningPeople;
  String? availablePeople;
  String? description;
  String? capacity;

  // 🔥 Chat logic fields
  String? hostUserId;
  String? hostName;
  String? hostImage;

  // 🔥 NEW: List of users who joined
  List<String>? joinedUsers;

  EventModel({
    this.id,
    this.eventName,
    this.location,
    this.date,
    this.startTime,
    this.category,
    this.imageUrl,
    this.joiningPeople,
    this.availablePeople,
    this.description,
    this.capacity,
    this.hostUserId,
    this.hostName,
    this.hostImage,
    this.joinedUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'eventName': eventName ?? '',
      'location': location ?? '',
      'date': date ?? '',
      'startTime': startTime ?? '',
      'category': category ?? '',
      'imageUrl': imageUrl ?? AppAssets().loginImage,
      'joiningPeople': joiningPeople ?? '0',
      'availablePeople': availablePeople ?? '0',
      'description': description ?? '',
      'capacity': capacity ?? '',
      'hostUserId': hostUserId ?? '',
      'hostName': hostName ?? '',
      'hostImage': hostImage ?? '',
      'joinedUsers': joinedUsers ?? [],
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString(),
      eventName: json['eventName']?.toString(),
      location: json['location']?.toString(),
      date: json['date']?.toString(),
      startTime: json['startTime']?.toString(),
      category: json['category']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      joiningPeople: json['joiningPeople']?.toString() ?? '0',
      availablePeople: json['availablePeople']?.toString() ?? '0',
      capacity: json['capacity']?.toString(),
      description: json['description']?.toString(),
      hostUserId: json['hostUserId']?.toString(),
      hostName: json['hostName']?.toString(),
      hostImage: json['hostImage']?.toString(),
      joinedUsers:
          json['joinedUsers'] != null
              ? List<String>.from(json['joinedUsers'])
              : [],
    );
  }
}
