class TopPicksCardModel {
  final String imageUrl;
  final String category; // e.g., "Hiking", "Party"
  final String title;
  final String location;
  final String joined;
  final String date;

  const TopPicksCardModel({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.location,
    required this.joined,
    required this.date,
  });
}
