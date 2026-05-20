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

  double? locationLat;
  double? locationLng;

  String? recurrence; // 🔥 new field (None, Weekly, Monthly)

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
    this.locationLat,
    this.locationLng,
    this.recurrence = "None", // default
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'eventName': eventName ?? '',
      'location': location ?? '',
      'date': date ?? '',
      'startTime': startTime ?? '',
      'category': category ?? '',
      'imageUrl': imageUrl ?? '',
      'joiningPeople': joiningPeople ?? '0',
      'availablePeople': availablePeople ?? '0',
      'description': description ?? '',
      'capacity': capacity ?? '',
      'hostUserId': hostUserId ?? '',
      'hostName': hostName ?? '',
      'hostImage': hostImage ?? '',
      'joinedUsers': joinedUsers ?? [],
      'locationLat': locationLat,
      'locationLng': locationLng,
      'recurrence': recurrence,
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
      locationLat:
          json['locationLat'] != null
              ? double.tryParse(json['locationLat'].toString())
              : null,
      locationLng:
          json['locationLng'] != null
              ? double.tryParse(json['locationLng'].toString())
              : null,
      recurrence: json['recurrence'] ?? "None",
    );
  }
}
