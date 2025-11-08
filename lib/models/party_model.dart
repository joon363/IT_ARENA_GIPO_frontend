class AlarmParty {
  final String time;          // "08:30" 형식
  final List<String> members; // 멤버 이름 목록
  bool isParticipating; // 나의 참여 여부

  AlarmParty({
    required this.time,
    required this.members,
    required this.isParticipating,
  });

  factory AlarmParty.fromJson(Map<String, dynamic> json) {
    return AlarmParty(
      time: json['time'],
      members: List<String>.from(json['members']),
      isParticipating: json['isParticipating'],
    );
  }
}
