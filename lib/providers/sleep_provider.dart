import 'package:flutter/material.dart';

class SleepProvider with ChangeNotifier {
  final List<Map<String, String>> sleepMethods = [
    {
      'title': '기본 수면법',
      'description': '가장 일반적인 단일 수면입니다.',
    },
    {
      'title': '수면법 01: 호날두 수면법',
      'description': '짧은 수면을 여러 번 나누어 잡니다.',
    },
    {
      'title': '수면법 02: 드웨인 존슨 수면법',
      'description': '이른 시간에 취침하고 일찍 일어납니다.',
    },
    {
      'title': '수면법 03: 다빈치 수면법',
      'description': '극단적인 다상 수면의 한 형태입니다.',
    },
  ];

  int _selectedMethodIndex = 0;
  int get selectedMethodIndex => _selectedMethodIndex;
  String get selectedMethodTitle {
    return sleepMethods[_selectedMethodIndex]['title']!;
  }

  void setSelectedMethod(int index) {
    _selectedMethodIndex = index;
    notifyListeners();
  }
}