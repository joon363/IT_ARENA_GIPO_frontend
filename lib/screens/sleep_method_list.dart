import 'package:flutter/material.dart';

class SleepMethodListScreen extends StatefulWidget {
  const SleepMethodListScreen({super.key});

  @override
  State<SleepMethodListScreen> createState() => _SleepMethodListScreenState();
}

class _SleepMethodListScreenState extends State<SleepMethodListScreen> {
  // 현재 선택된 카드의 인덱스를 저장. -1은 아무것도 선택되지 않음을 의미.
  int _selectedMethodIndex = -1;

  // 카드에 표시될 수면법 목록
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 하단 Navbar (home_screen.dart와 동일)
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              // 1. 버튼 (왼쪽)
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/alarm-clock_active.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ),
              // 2. /alarm 버튼 (가운데)
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/alarm');
                  },
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/bell.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ),
              // 3. /friend 버튼 (오른쪽)
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/friend');
                  },
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/users.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

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
                  itemCount: sleepMethods.length, // 카드 개수 (4개)
                  itemBuilder: (context, index) {
                    final method = sleepMethods[index];
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
    final bool isSelected = (_selectedMethodIndex == index);

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
            // 카드를 탭하면 setState를 호출하여 선택 상태를 업데이트
            setState(() {
              _selectedMethodIndex = index;
            });
            print('$title 선택됨');
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