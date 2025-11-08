String SleepTypesString(String sleepType) {
  switch(sleepType) {
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

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));

  return "$hours:$minutes";
}

