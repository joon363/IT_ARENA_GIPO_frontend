String SleepTypesString(String sleepType) {
  switch (sleepType) {
    case "default":
      return "기본 수면법";
    case "1":
      return "호날두 수면법";
    case "2":
      return "드웨인 수면법";
    case "3":
      return "다빈치 수면법";
    default:
    return "default";
  }
}

List<Map<String, String>> sleepInfo = [
{
  'title': '기본 수면법',
  'summary': '가장 일반적인 단일 수면입니다.',
  'description': '- 가장 일반적인 수면 방식입니다.\n- 하루에 한 번, 밤에 몰아서 잡니다.',
  'benefit': '- 대부분의 사람들에게 적합합니다.\n- 7~8시간의 연속 수면을 권장합니다.',
  'wallpaper': "assets/images/wallpapers/default.png",
},
{
  'title': '수면법 01: 호날두 수면법',
  'summary': '짧은 수면을 여러 번 나누어 잡니다.',
  'description': '- 하루 90분씩 5회 나누어 잡니다.\n- 수면 전분가의 코칭을 받아 신체 리듬을 관리하\n   는 것으로 알려져 있습니다.',
  'benefit': '- 90분 수면 주기에 맞춰 신체 회복의 질을 높이\n   는 것을 목표로 합니다.\n- 훈련 및 경기 일정에 맞춰 유연하게 휴식 시간\n   을 확보할 수 있습니다.',
  'wallpaper': "assets/images/wallpapers/ronaldo.png",
},
{
  'title': '수면법 02: 드웨인 존슨 수면법',
  'summary': '이른 시간에 취침하고 일찍 일어납니다.',
  'description': '- 매일 새벽 3~4시에 기상하는 극단적인 얼리버\n   드 방식입니다.\n- 하루에 총 4~5시간 정도의 짧은 수면을 취합\n   니다.',
  'benefit': '- 이른 아침 시간을 확보하여 운동 및 바쁜 스케\n   줄 소화에 집중할 수 있습니다.\n- 철저한 자기 관리와 루틴을 통해 높은 생산성을\n   유지합니다.',
  'wallpaper': "assets/images/wallpapers/dwayne.png",
},
{
  'title': '수면법 03: 다빈치 수면법',
  'summary': '극단적인 다상 수면의 한 형태입니다.',
  'description': '- \'우베르만 수면\'이라 불리는 다상 수면의 한 형\n   태입니다.\n- 전설에 따르면 4시간마다 15~20분씩 매우 짧\n   은 잠을 잤다고 합니다.',
  'benefit': '- 하루 총 수면 시간을 2시간 내외로 줄여 깨어\n   있는 시간을 극대화합니다.\n- 창의적인 활동이나 연구에 더 많은 시간을 할애\n   할 수 있습니다.',
  'wallpaper': "assets/images/wallpapers/davinci.png",
},
];
class TimeSegment {
  final String state; // "sleep" or "wake"
  final double hours;

  TimeSegment(this.state, this.hours);
}
final List<List<TimeSegment>> sleepSegments = [

  [
    TimeSegment('sleep', 8),
    TimeSegment('wake', 16),
  ],
  [
    TimeSegment('wake', 6),
    TimeSegment('sleep', 1.5),
    TimeSegment('wake', 2),
    TimeSegment('sleep', 1.5),
    TimeSegment('wake', 8),
    TimeSegment('sleep', 1.5),
    TimeSegment('wake', 2),
    TimeSegment('sleep', 1.5),
  ],
  [
    TimeSegment('sleep', 4),
    TimeSegment('wake', 20),
  ],
  [
    TimeSegment('sleep', 0.25),
    TimeSegment('wake', 3.75),
    TimeSegment('sleep', 0.25),
    TimeSegment('wake', 3.75),
    TimeSegment('sleep', 0.25),
    TimeSegment('wake', 3.75),
    TimeSegment('sleep', 0.25),
    TimeSegment('wake', 3.75),
    TimeSegment('sleep', 0.25),
    TimeSegment('wake', 3.75),
    TimeSegment('sleep', 0.25),
    TimeSegment('wake', 3.75),
  ]
];
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));

  return "$hours:$minutes";
}

