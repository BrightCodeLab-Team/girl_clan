class GroupsModel {
  String? id;
  String? title;
  String? description;
  String? category;
  String? location;
  String? imageUrl;
  String? createdAt;

  // Host details
  String? hostUserId;
  String? hostName;
  String? hostImage;

  // Location coordinates
  double? locationLat;
  double? locationLng;

  // Group members
  List<String>? joinedUsers;
  List<String>? adminIds; // Track multiple admins

  GroupsModel({
    this.id,
    this.title,
    this.description,
    this.category,
    this.location,
    this.imageUrl,
    this.createdAt,
    this.hostUserId,
    this.hostName,
    this.hostImage,
    this.locationLat,
    this.locationLng,
    this.joinedUsers,
    this.adminIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'hostUserId': hostUserId,
      'hostName': hostName,
      'hostImage': hostImage,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'joinedUsers': joinedUsers ?? [],
      'adminIds': adminIds ?? [],
      'memberCount': joinedUsers?.length ?? 0, // Fixed null check
    };
  }

  factory GroupsModel.fromJson(Map<String, dynamic> json) {
    return GroupsModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      location: json['location'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      hostUserId: json['hostUserId'] as String?,
      hostName: json['hostName'] as String?,
      hostImage: json['hostImage'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      joinedUsers:
          (json['joinedUsers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      adminIds:
          (json['adminIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }
}
