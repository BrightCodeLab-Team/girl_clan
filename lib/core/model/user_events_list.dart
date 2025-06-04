class UserEventsModel {
  final String imageUrl;
  final String time;
  final String title;
  final String location;
  final int goingPeople;
  final int availablePeople;

  UserEventsModel({
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.location,
    required this.goingPeople,
    required this.availablePeople,
  });
}
