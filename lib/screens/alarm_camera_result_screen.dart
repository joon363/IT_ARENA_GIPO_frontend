import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../connections/api_calls.dart';
import 'alarm_waiting_screen.dart';
import '../themes.dart';
export 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/userStatus.dart';

// A widget that displays the picture taken by the user.
class AlarmCameraResultScreen extends StatefulWidget {
  final String imagePath;
  final String refImagePath;
  const AlarmCameraResultScreen({super.key, required this.imagePath, required this.refImagePath});

  @override
  State<AlarmCameraResultScreen> createState() => _AlarmCameraResultScreenState();
}

class _AlarmCameraResultScreenState extends State<AlarmCameraResultScreen> {
  late Future<bool> _result;
  List<UserStatus> users = [];
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _result = checkPoseSuccessFromApi(
      imagePath: widget.imagePath,
      refImagePath: widget.refImagePath,
    );
    fetchUserStatuses(); // 최초 1회
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        fetchUserStatuses(); // 5초마다 폴링
      });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = 250;
    return Scaffold(
      appBar: AppBar(title: Text("분석 결과"), automaticallyImplyLeading: false,),
      body: SafeArea(
        child:
        Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            spacing: 2,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: 8,
                children: [
                  Expanded(child: SizedBox(
                      height: imageHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          fit: BoxFit.cover,
                          scale: 0.5,
                          File(widget.imagePath)
                        ),
                      ),)),
                  Expanded(child: SizedBox(
                      height: imageHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.refImagePath,
                          scale: 0.5,
                          fit: BoxFit.cover,
                        ),
                      ),)),
                ],
              ),
              Expanded(
                child: FutureBuilder<bool>(
                  future: _result,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 로딩 중일 때
                      return const Center(child:
                        Column(
                          children: [
                            CircularProgressIndicator(color: blue,),
                            Text(
                              '사진 분석 중 ...',
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
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '에러링',
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      );
                    }
                    final result = snapshot.data!;
                    if (result) {
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AlarmWaitingScreen(
                              imagePath: widget.imagePath,
                            ),
                          ),
                        );
                      });
                    }
                    return result ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 64, color: orange,),
                          Text(
                            '인증 성공',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 16,)
                        ],
                      )
                      : Column(
                        children: [
                          Expanded(child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.xmark, size: 64, color: errorRed,),
                                Text(
                                  '인증 실패',
                                  style: TextStyle(
                                    color: errorRed,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 16,)
                              ],
                            ),
                          ),
                          Expanded(
                            child:
                            Column(
                              children: [
                                Material(
                                  color: gray2,
                                  borderRadius: BorderRadius.circular(999),
                                  elevation: 0,
                                  child: InkWell(
                                    onTap: () {

                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(999),
                                    //highlightColor: primaryColorLight,
                                    child:

                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Icon(CupertinoIcons.restart, size: 32, color: Colors.black),
                                    ),
                                  )
                                ),
                                Text(
                                  '재시도',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                        ],
                      );
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
