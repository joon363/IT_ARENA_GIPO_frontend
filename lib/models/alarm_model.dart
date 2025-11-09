import 'dart:math';

class Alarm {
  final String id;
  final String name;
  final Duration start;
  final bool resolved;
  final String alarmType;
  final String challenge;
  final bool isEnabled;
  final List<Member> members;
  final String createdAt;
  final String updatedAt;

  Alarm({
    required this.id,
    required this.name,
    required this.start,
    required this.resolved,
    required this.alarmType,
    required this.challenge,
    required this.isEnabled,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      start: _parseDuration(json['start'] ?? ''),
      resolved: json['resolved'] ?? false,
      alarmType: json['alarm_type'] ?? '',
      challenge: json['challenge'] ?? '',
      isEnabled: json['is_enabled'] ?? false,
      members: (json['members'] as List<dynamic>?)
        ?.map((m) => Member.fromJson(m))
        .toList() ??
        [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static Duration _parseDuration(String timeStr) {
    if (timeStr.isEmpty) return Duration.zero;
    try {
      final parts = timeStr.split(':');
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;

      final secondsParts = parts[2].split('.');
      final seconds = int.tryParse(secondsParts[0]) ?? 0;
      final microseconds =
        int.tryParse(secondsParts.length > 1 ? secondsParts[1] : '0') ?? 0;

      return Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        microseconds: microseconds,
      );
    } catch (_) {
      return Duration.zero;
    }
  }
}

class Member {
  final String userId;
  final bool verified;
  final String nickname;
  final String? imageUrl;

  Member({
    required this.userId,
    required this.verified,
    required this.nickname,
    required this.imageUrl,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    final random = Random();
    return Member(
      userId: json['user_id'] ?? '',
      verified: json['verified'] ?? false,
      nickname: json['nickname'] ?? "홍길동",
      imageUrl: json['img_url'] ?? "",
    );
  }
}
