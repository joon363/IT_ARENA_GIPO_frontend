import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../connections/api_calls.dart';
import '../themes.dart';
export 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

// A widget that displays the picture taken by the user.
class AlarmCameraDoneWaitingScreen extends StatefulWidget {
  final String imagePath;
  final String refImagePath;
  const AlarmCameraDoneWaitingScreen({super.key, required this.imagePath, required this.refImagePath});

  @override
  State<AlarmCameraDoneWaitingScreen> createState() => _AlarmCameraDoneWaitingScreenState();
}

class _AlarmCameraDoneWaitingScreenState extends State<AlarmCameraDoneWaitingScreen> {
  late Future<bool> _result;
  @override
  void initState() {
    super.initState();
    _result = checkPoseSuccessFromApi(
      imagePath: widget.imagePath,
      refImagePath: widget.refImagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("분석 결과")),
        body: SafeArea(
          child:
          Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                              width: double.maxFinite,
                              height: 280,
                              fit: BoxFit.cover,
                              File(widget.imagePath)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Text(
                          '획득한 카드',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FutureBuilder<bool>(
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
                          return Column(
                            spacing: 10,
                            children: [
                              result?Icon(Icons.check_box, size: 50,):
                                  Icon(CupertinoIcons.xmark_circle, size: 50,)
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ],
              )
          ),
        )
    );
  }
}
