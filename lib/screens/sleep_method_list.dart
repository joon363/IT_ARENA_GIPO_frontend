import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';

class SleepMethodListScreen extends StatefulWidget {
  const SleepMethodListScreen({super.key});

  @override
  State<SleepMethodListScreen> createState() => _SleepMethodListScreenState();
}

class _SleepMethodListScreenState extends State<SleepMethodListScreen> {
  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    return Scaffold(

      // 2. 본문 (home_screen.dart와 동일한 구조)
      body: SafeArea(
        child: Column(
          children: [
            // 1. 상단 영역 (흰색)
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
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                    padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 65.0, right: 14.0),
                    child: Text(
                      '수면법 목록', // 이미지에 맞게 텍스트 변경
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ),
                ],
              ),
            ),

            // 두 컨테이너 사이 간격
            const SizedBox(height: 0),

            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xffFFF5EB), // home_screen.dart와 동일한 배경
                // ListView.builder를 사용해 카드 목록을 동적으로 생성
                child: ListView.builder(
                  padding: const EdgeInsets.all(20.0), // 목록 전체에 여백
                  itemCount: sleepProvider.sleepMethods.length, // 카드 개수 (4개)
                  itemBuilder: (context, index) {
                    final method = sleepProvider.sleepMethods[index];
                    return _buildMethodCard(
                      title: method['title']!,
                      description: method['description']!,
                      index: index,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 수면법 카드를 생성하는 헬퍼 위젯
  Widget _buildMethodCard({
    required String title,
    required String description,
    required int index,
  }) {
    // 현재 카드가 선택되었는지 확인
    final int currentIndex = 
    Provider.of<SleepProvider>(context).selectedMethodIndex;
    final bool isSelected = (index == currentIndex);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // 카드 사이의 간격
      child: Material(
        // Card 대신 Material과 InkWell을 사용해 탭 효과와 색상 변경 구현
        color: isSelected ? const Color(0xffFF9F31) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        elevation: 0, // 그림자
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            // 카드 탭 시 선택된 수면법 인덱스 업데이트
            Provider.of<SleepProvider>(context, listen: false)
                .setSelectedMethod(index);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 수면법 이름 + 설명
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 좌측 정렬
                    children: [
                      // 수면법 이름
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black, // 선택 시 글자색 변경
                        ),
                      ),
                      const SizedBox(height: 4), // 제목과 설명 사이 간격
                      // 간략한 설명
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13, // 더 작은 글씨
                          color: isSelected ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // 돋보기 아이콘 버튼
                IconButton(
                  icon: Image.asset(
                    'assets/images/zoom-in.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    if(index == 0) {
                      Navigator.pushNamed(context, '/sleep_method_normal');
                    } else if (index == 1) {
                      Navigator.pushNamed(context, '/sleep_method_Ronaldo');
                    } else if (index == 2) {
                      Navigator.pushNamed(context, '/sleep_method_Dwayne');
                    } else if (index == 3) {
                      Navigator.pushNamed(context, '/sleep_method_Davinci');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}