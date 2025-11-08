import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';

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
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. 상단 영역 (SizedBox + Text)을 하얀색 Container로 감쌉니다.
            Container(
              width: double.infinity, // 가로 폭 전체
              color: Colors.white,      // 배경색을 하얀색으로 지정
              child: Column(
                // 공백과 텍스트를 담기 위해 Column 사용
                children: [
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      sleepProvider.selectedMethodTitle,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Color(0xffFFF5EB),
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height : 100),
                    // 빨간색 원 (진행률 표시기)
                    CustomPaint(
                      painter: _CircleProgressPainter(progress: _progress),
                      child: Container(
                        width: 250, // 원의 크기
                        height: 250, // 원의 크기
                        alignment: Alignment.center,
                        child: const Text(
                          'OO시간 OO분 후에\n기상/취침할 시간입니다', // 이 텍스트도 동적으로 변경될 수 있습니다.
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150), // 원과 버튼 사이 간격
                    
                    // 수면법 변경하기 버튼
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sleep_method_list');
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
      ..color = Color(0xffFF9F31)
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