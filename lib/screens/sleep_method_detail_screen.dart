import 'package:flutter/material.dart';
import 'package:it_arena/constants.dart';
import 'package:it_arena/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';

class SleepMethodDetailScreen extends StatelessWidget {
  final int index;
  const SleepMethodDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    return Stack(
      children: [
        Image.asset(sleepInfo[index]['wallpaper']!, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),

        Scaffold(
          backgroundColor: Colors.black12,
          // 2. 본문 (sleep_method_list.dart와 동일한 구조)
          body: SafeArea(
            child: Column(
              children: [
                // 1. 상단 영역 (흰색, sleep_method_list.dart와 동일 + 제목만 변경)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, left: 12.0),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/Vector.png',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 65.0, right: 14.0),
                          child: Text(
                            sleepInfo[index]['title']!,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 두 컨테이너 사이 간격 (필요시 조절)
                const SizedBox(height: 0),

                // 2. 중간 영역 (주황색, 스크린샷의 새 내용으로 채우기)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    // 내용이 길어질 수 있으므로 SingleChildScrollView 사용
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0), // 전체적인 여백
                      child: Column(
                        spacing: 40,
                        children: [
                          // 흰색 설명 카드
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 설명
                                Text(
                                  '소개',
                                  style: const TextStyle(
                                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(height: 20),
                                Text(
                                  sleepInfo[index]['description']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                                ),
                                const SizedBox(height: 25),

                                // 특징
                                Text(
                                  '효능',
                                  style: const TextStyle(
                                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(height: 20),
                                Text(
                                  sleepInfo[index]['benefit']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          SleepWakeCircle(segments: sleepSegments[index], progress: 1),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
