import 'package:firebase_auth/firebase_auth.dart';
import 'package:girl_clan/core/constants/app_assets.dart';

class EventModel {
  final currentUser = FirebaseAuth.instance.currentUser;
  String? id; // Unique ID for each event
  String? eventName;
  String? location;
  String? date; // Storing as String for now, could be DateTime
  String? startTime; // Storing as String for now, could be TimeOfDay
  String? category;
  String? imageUrl; // Path to the image
  String? joiningPeople; // Number of people joining
  String?
  availablePeople; // Number of people available (not quite sure what this means in your context, but including it as requested)
  String? description;
  String? capacity;

  EventModel({
    this.id,
    this.eventName,
    this.location,
    this.date,
    this.startTime,
    this.category,
    this.imageUrl,
    this.joiningPeople, // Default to 0
    this.availablePeople, // Default to 0
    this.description,
    this.capacity,
  });
  // Method to convert an Event to a Map (useful for persistence)
  Map<String, dynamic> toJson() {
    return {
      //'id': currentUser?.uid ?? '',
      'id': id ?? '',
      'eventName': eventName ?? '',
      'location': location ?? '',
      'date': date ?? '',
      'startTime': startTime ?? '',
      'category': category ?? '',
      'imageUrl': imageUrl ?? AppAssets().loginImage,
      'joiningPeople': joiningPeople ?? 0,
      'availablePeople': availablePeople ?? 0,
      'description': description ?? '',
      'capacity': capacity ?? '', // Default to 0
    };
  }

  // Factory constructor to create an Event from a Map (useful for persistence)
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'].toString(),
      eventName: json['eventName'].toString(),
      location: json['location'].toString(),
      date: json['date'].toString(),
      startTime: json['startTime'].toString(),
      category: json['category'].toString(),
      imageUrl: json['imageUrl'].toString(),
      joiningPeople: json['joiningPeople']?.toString() ?? '0',
      availablePeople: json['availablePeople']?.toString() ?? '0',
      capacity: json['capacity'].toString(),
      description: json['description'].toString(),
    );
  }
}
