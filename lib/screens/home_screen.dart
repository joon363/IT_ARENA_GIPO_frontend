import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';
import '../constants.dart';
import '../themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 나중에 이 값을 변경하여 진행률 표시기를 업데이트할 수 있습니다.
  // 예: double _progress = 0.0;
  // 현재는 0.75 (75%)로 고정하여 디자인을 보여줍니다.
  final double _progress = 0.5; // 0.0 ~ 1.0 사이의 값
  final int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    return Stack(
      children: [
        //Image.asset(sleepProvider.selectedMethodWallpaper, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
        SafeArea(
          top: true,
          child: Scaffold(
            backgroundColor: backGround,
            body: Stack(children: [
                Column(
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
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100),
                            // 빨간색 원 (진행률 표시기)
                            SleepWakeCircle(segments: sleepProvider.selectedMethodTimeSegments, progress: _progress),
                            const SizedBox(height: 100), // 원과 버튼 사이 간격

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
                Align(alignment: Alignment.topRight, child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/alarm');
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
                      'Dev) Trigger Alarm',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),)
              ],
            ),
          )
        ),
      ],
    );
  }
}

/// CustomPainter를 사용하여 원형 진행률 표시기를 그립니다.
class MultiSegmentCirclePainter extends CustomPainter {
  final List<TimeSegment> segments;
  final double progress; // 전체 진행률 (0.0~1.0)

  MultiSegmentCirclePainter({required this.segments, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const strokeWidth = 25.0;
    const gapAngle = 3 * math.pi / 180; // 틈 (약 3도)

    final totalHours = segments.fold<double>(0, (sum, s) => sum + s.hours);

    double startAngle = -math.pi / 2;
    double drawnHours = 0;

    for (final segment in segments) {
      final sweepRatio = segment.hours / totalHours;
      final sweepAngle = 2 * math.pi * sweepRatio - gapAngle; // 틈 고려

      // 각 상태별 색상
      final color = (segment.state == "sleep")
        ? gray
        : primaryColor;

      // 옅은 백그라운드 색상 (상태별)
      final bgColor = (segment.state == "sleep")
        ? gray2
        : backGroundDark;

      // 백그라운드(옅은색)
      final backgroundPaint = Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        backgroundPaint,
      );

      // 진행률에 따라 일부만 채우기
      final endRatio = (drawnHours + segment.hours) / totalHours;
      if (progress > drawnHours / totalHours) {
        double visibleRatio =
          (progress - drawnHours / totalHours).clamp(0, sweepRatio);
        final visibleSweep = 2 * math.pi * visibleRatio - gapAngle;

        final progressPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 1.5
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
          startAngle,
          visibleSweep,
          false,
          progressPaint,
        );
      }

      // 다음 섹션 시작 각도로 이동
      startAngle += sweepAngle + gapAngle; // 틈 추가
      drawnHours += segment.hours;
    }
  }

  @override
  bool shouldRepaint(covariant MultiSegmentCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
      oldDelegate.segments != segments;
  }
}

class SleepWakeCircle extends StatelessWidget {
  final List<TimeSegment> segments;
  final double progress; // 0.0~1.0 (전체 시간 중 진행된 비율)

  const SleepWakeCircle({super.key, required this.segments, required this.progress});

  @override
  Widget build(BuildContext context) {
    final totalHours = segments.fold<double>(0, (s, seg) => s + seg.hours);
    final elapsedHours = totalHours * progress;

    // 현재 progress가 어느 세그먼트에 속하는지 계산
    double accumulated = 0;
    String currentState = '';
    double remaining = 0;

    for (final seg in segments) {
      if (elapsedHours < accumulated + seg.hours) {
        currentState = seg.state;
        remaining = (accumulated + seg.hours) - elapsedHours;
        break;
      }
      accumulated += seg.hours;
    }

    final hours = remaining.floor();
    final minutes = ((remaining - hours) * 60).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CustomPaint(
            painter: MultiSegmentCirclePainter(
              segments: segments,
              progress: progress,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '$hours시간 $minutes분 후에\n${currentState == "sleep" ? "취침" : "기상"}할 시간입니다',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
