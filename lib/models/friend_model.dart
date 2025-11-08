import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String nickname;
  final String room;
  final String tel;
  final String sleeptype;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.nickname,
    required this.room,
    required this.tel,
    required this.sleeptype,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      nickname: json['nickname'] ?? '',
      room: json['room'] ?? '',
      tel: json['tel'] ?? '',
      sleeptype: json['sleeptype'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class Friend {
  final String id;
  final String userId;
  final String friendId;
  final bool isActive;
  final String friendUsername;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Friend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.isActive,
    required this.friendUsername,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      friendId: json['friend_id'] ?? '',
      isActive: json['is_active'] ?? false,
      friendUsername: json['friend_username'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      user: json['user'] != null ? User.fromJson(json['user']) : User(
        id: '',
        email: '',
        username: '',
        fullName: '',
        nickname: '',
        room: '',
        tel: '',
        sleeptype: '',
        isActive: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
