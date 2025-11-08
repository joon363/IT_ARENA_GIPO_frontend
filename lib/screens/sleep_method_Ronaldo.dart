import 'package:flutter/material.dart';

class SleepMethodRonaldoScreen extends StatelessWidget {
  const SleepMethodRonaldoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 하단 Navbar (sleep_method_list.dart와 동일)
      // TODO: 현재 페이지에 맞게 활성화된 아이콘 변경 로직 필요
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
                          Navigator.pushNamed(context, '/sleep_method_list');
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                    padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 65.0, right: 14.0),
                    child: Text(
                      '호날두 수면법', // 이미지에 맞게 텍스트 변경
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
              child: Container(
                width: double.infinity,
                color: const Color(0xffFFF5EB), // 동일한 배경색
                // 내용이 길어질 수 있으므로 SingleChildScrollView 사용
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0), // 전체적인 여백
                  child: Column(
                    children: [
                      // 흰색 설명 카드
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 설명
                            Text(
                              '소개',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 20),
                            Text(
                              '- 가장 일반적인 수면 방식입니다.\n- 하루에 한 번, 밤에 몰아서 잡니다.', // 예시 텍스트
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 25),

                            // 특징
                            Text(
                              '효능',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 20),
                            Text(
                              '- 대부분의 사람들에게 적합합니다.\n- 7~8시간의 연속 수면을 권장합니다.', // 예시 텍스트
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}