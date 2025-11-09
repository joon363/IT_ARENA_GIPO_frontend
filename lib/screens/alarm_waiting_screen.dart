import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../connections/api_calls.dart';
import '../connections/API_KEYS.dart';
import '../constants.dart';
import '../models/alarm_model.dart';
import '../themes.dart';
export 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'alarm_camera_screen.dart';

// A widget that displays the picture taken by the user.
class AlarmWaitingScreen extends StatefulWidget {
  const AlarmWaitingScreen({super.key});

  @override
  State<AlarmWaitingScreen> createState() => _AlarmWaitingScreenState();
}

class _AlarmWaitingScreenState extends State<AlarmWaitingScreen> {
  late final Future<Alarm?> _initSetAlarm;
  final String? imagePath = null;
  bool isWaitingForCamera = false;
  bool isDone = false;
  bool isUserDone = false;
  bool onInit = true;
  List<Alarm> alarms = [];
  Alarm? alarm;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initSetAlarm = _setAlarm();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {if (!isDone && !isWaitingForCamera) _checkAlarm();
      },
    );
  }
  Future<Alarm?> _setAlarm() async{
    print("Fetching alarms...");
    alarms = await fetchAlarms(junToken);
    for (final a in alarms){
      if (!a.resolved) {
        return a;
      }
    }
    return null;
  }

  Future<void> _showDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // 배경 터치로 닫히지 않도록
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "성공적으로 종료되었습니다",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const SizedBox(height: 8),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/', // 메인으로
                    (route) => false,
                  );
                },
                child: const Text(
                  "메인으로",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Future<void> _checkAlarm() async {
    print("Checking alarms...");
    if (alarm == null) {
      isDone = true;
      _showDialog();
      return;
    }
    final Alarm newAlarm = await fetchAlarm(junToken, alarm!.id);
    if (newAlarm.resolved) {
      isDone = true;
      _showDialog();
      return;
    }
    for (Member member in newAlarm.members){
      if (member.userId == junToken) {
        if (member.verified) isUserDone = true;
      }
    }
    setState(() {
        alarm = newAlarm;
      });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildUserTile(Member user, int index) {
    final isAwake = user.verified;
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: colorsVer2[index],
                  child: (isAwake && user.imageUrl != null && user.imageUrl!.isNotEmpty) ?
                    Image.network(
                      user.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 48, color: Colors.white),
                    )
                    :
                    Image.asset(
                      'assets/images/main logo.png',
                      fit: BoxFit.scaleDown,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 48, color: Colors.white),
                    ),
                ),
              ),
              Container(
                color: colorsVer1[index],
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: Text(
                  user.nickname,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Alarm?>(
            future: _initSetAlarm,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && alarm == null) {
                // 로딩 중일 때
                return const Center(child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: blue,),
                      Text(
                        '로드 중...',
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],

                  ));
              } else if (snapshot.hasError) {
                // 에러 처리
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                // 데이터 없을 때
                isDone = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showDialog();
                  });
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '알람이 없습니다.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                );
              }
              if (onInit) {
                final Alarm result = snapshot.data!;
                alarm = result;
                onInit = false;
              }
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 170,
                      padding: EdgeInsets.only(top: 100),
                      child: RippleAnimation(
                        color: primaryColor,
                        repeat: true,
                        minRadius: 100,
                        maxRadius: 100,
                        ripplesCount: 2,
                        duration: const Duration(milliseconds: 4000),
                        child: Container(),
                      ),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("알람",
                        style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(alarm == null ? "00:00" : formatDuration(alarm!.start),
                        style: const TextStyle(
                          fontSize: 110, fontWeight: FontWeight.bold)),
                      Material(
                        color: isUserDone ? gray3 : primaryColor,
                        borderRadius: BorderRadius.circular(999),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                          onTap: isUserDone ? null : () async {
                              try {
                                // 🔸 카메라 초기화
                                final cameras = await availableCameras();
                                final firstCamera = cameras.first;

                                // 🔸 카메라 화면으로 직접 이동
                                if (context.mounted) {
                                  isWaitingForCamera = true;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      AlarmCameraScreen(camera: firstCamera, alarmId: alarm!.id,),
                                    ),
                                  );

                                  isWaitingForCamera = false;
                                }
                              } catch (e) {
                                debugPrint("Camera initialization failed: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("카메라 초기화에 실패했습니다.")),
                                );
                              }
                            },
                          child: Container(
                            width: 150,
                            height: 55,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: isUserDone ? Text("대기 중", style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),) :
                              Text("알람 끄기", style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // ✅ 2x2 Grid
                      Expanded(
                        child: Padding(padding: EdgeInsetsGeometry.all(12),
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                            children: [
                              if(alarm == null) Container(),
                              if(alarm != null)...alarm!.members
                                .asMap() // index를 얻기 위해 Map으로 변환
                                .entries
                                .map((entry) {
                                    int index = entry.key;
                                    Member u = entry.value;
                                    return _buildUserTile(u, index); // index 전달
                                  })
                              ,
                            ],
                          ),)
                      ),
                    ],
                  ),
                ]
              );
            }
          )
        )
      )
    );
  }
}
