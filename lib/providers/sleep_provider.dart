import 'package:flutter/material.dart';
import 'package:it_arena/constants.dart';

class SleepProvider with ChangeNotifier {
  final List<String> wallpapers = [
    "assets/images/wallpapers/default.png",
    "assets/images/wallpapers/ronaldo.png",
    "assets/images/wallpapers/dwayne.png",
    "assets/images/wallpapers/davinci.png",
  ];

  int _selectedMethodIndex = 0;
  int get selectedMethodIndex => _selectedMethodIndex;
  String get selectedMethodTitle {
    return sleepInfo[_selectedMethodIndex]['title']!;
  }
  List<TimeSegment> get selectedMethodTimeSegments {
    return sleepSegments[_selectedMethodIndex];
  }

  String get selectedMethodWallpaper {
    return wallpapers[_selectedMethodIndex];
  }

  void setSelectedMethod(int index) {
    _selectedMethodIndex = index;
    notifyListeners();
  }
}
