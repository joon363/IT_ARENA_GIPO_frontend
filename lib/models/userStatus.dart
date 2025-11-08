
class UserStatus {
  final String name;
  bool status;
  String? imageUrl;

  UserStatus({required this.name, required this.status, this.imageUrl});

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      name: json['name'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }
}