import 'package:flutter/material.dart';

class SleepMethodDwayneScreen extends StatelessWidget {
  const SleepMethodDwayneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                      '드웨인 존슨 수면법', // 이미지에 맞게 텍스트 변경
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
                              '- 매일 새벽 3~4시에 기상하는 극단적인 얼리버\n   드 방식입니다.\n- 하루에 총 4~5시간 정도의 짧은 수면을 취합\n   니다.', // 예시 텍스트
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
                              '- 이른 아침 시간을 확보하여 운동 및 바쁜 스케\n   줄 소화에 집중할 수 있습니다.\n- 철저한 자기 관리와 루틴을 통해 높은 생산성을\n   유지합니다.', // 예시 텍스트
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