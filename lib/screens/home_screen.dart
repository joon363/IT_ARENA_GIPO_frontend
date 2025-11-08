import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 나중에 이 값을 변경하여 진행률 표시기를 업데이트할 수 있습니다.
  // 예: double _progress = 0.0;
  // 현재는 0.75 (75%)로 고정하여 디자인을 보여줍니다.
  final double _progress = 0.75; // 0.0 ~ 1.0 사이의 값
  final int _currentTabIndex = 0; // 현재 선택된 탭 인덱스
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 하단 Navbar
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0, // 하단 바 높이
          child: Row(
            // Row의 자식들을 1:1:1 비율로 나누기 위해 Expanded 사용
            children: [
              // 1. 비활성화 버튼 (왼쪽)
              Expanded(
                child: InkWell(
                  onTap: () {},
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

              // 2. /alarm 버튼 (가운데, sleep_mode.png)
              Expanded(
                child: InkWell(
                  onTap: () {
                    // 2번 버튼 기능
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
                    // 3번 버튼 기능
                    // Navigator.pushNamed(context, '/friend'); // TODO: '/friend' 라우트 미정

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
      body: SafeArea(
        child: Column(
          children: [
            // 상단 타이틀
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                '호날두 수면법',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 빨간색 원 (진행률 표시기)
                    CustomPaint(
                      painter: _CircleProgressPainter(progress: _progress),
                      child: Container(
                        width: 250, // 원의 크기
                        height: 250, // 원의 크기
                        alignment: Alignment.center,
                        child: const Text(
                          'O시간 O분 후에\n기상/취침할 시간입니다', // 이 텍스트도 동적으로 변경될 수 있습니다.
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // 원과 버튼 사이 간격
                    
                    // 수면법 변경하기 버튼
                    ElevatedButton(
                      onPressed: () {
                        // 버튼을 눌렀을 때 실행될 로직 (예: 다른 화면으로 이동)
                        print('수면법 변경하기 버튼 클릭됨!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF9F31), // 버튼 배경색
                        foregroundColor: Colors.white, // 버튼 텍스트 색상
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '수면법 변경하기',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter를 사용하여 원형 진행률 표시기를 그립니다.
class _CircleProgressPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0 사이의 진행률

  _CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const strokeWidth = 25.0; // 원의 두께

    // 배경 원 (회색)
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]! // 연한 회색
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // 둥근 끝 모양
    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // 진행률 원 (빨간색)
    final progressPaint = Paint()
      ..color = Color(0xffFFBA6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 아크 그리기 (시작 각도: -pi/2는 12시 방향, sweepAngle: 진행률에 따라)
    final sweepAngle = 2 * math.pi * progress; // 360도 * 진행률
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2, // 시작 각도 (12시 방향)
      sweepAngle, // 그릴 각도
      false, // center를 포함하지 않음
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress; // progress 값이 변경될 때만 다시 그립니다.
  }
}