class Friend {
  final String id;
  final String userId;
  final String friendId;
  final bool isActive;
  final String location;
  final String phone;
  final String friendUsername;
  final String preferRoutine;
  final DateTime createdAt;
  final DateTime updatedAt;

  Friend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.isActive,
    required this.location,
    required this.phone,
    required this.friendUsername,
    required this.preferRoutine,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      friendId: json['friend_id'] ?? '',
      isActive: json['is_active'] ?? false,
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      friendUsername: json['friend_username'] ?? '',
      preferRoutine: json['preferRoutine']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
