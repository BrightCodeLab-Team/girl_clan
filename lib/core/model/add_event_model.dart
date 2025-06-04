class Event {
  String? id; // Unique ID for each event
  String eventName;
  String location;
  String date; // Storing as String for now, could be DateTime
  String startTime; // Storing as String for now, could be TimeOfDay
  String? category;
  String? imageUrl; // Path to the image
  int joiningPeople; // Number of people joining
  int
  availablePeople; // Number of people available (not quite sure what this means in your context, but including it as requested)

  Event({
    this.id,
    required this.eventName,
    required this.location,
    required this.date,
    required this.startTime,
    this.category,
    this.imageUrl,
    this.joiningPeople = 0, // Default to 0
    this.availablePeople = 0, // Default to 0
  });

  // Factory constructor to create an Event from a Map (useful for persistence)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['eventName'],
      location: json['location'],
      date: json['date'],
      startTime: json['startTime'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      joiningPeople: json['joiningPeople'] ?? 0,
      availablePeople: json['availablePeople'] ?? 0,
    );
  }

  // Method to convert an Event to a Map (useful for persistence)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'location': location,
      'date': date,
      'startTime': startTime,
      'category': category,
      'imageUrl': imageUrl,
      'joiningPeople': joiningPeople,
      'availablePeople': availablePeople,
    };
  }
}
