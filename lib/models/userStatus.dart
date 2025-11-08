
class UserStatus {
  final String name;
  bool status; // 갱신 가능해야 하므로 var 대신 String

  UserStatus({required this.name, required this.status});

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      name: json['name'],
      status: json['status'],
    );
  }
}